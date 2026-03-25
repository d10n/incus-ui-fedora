Name:           incus-ui
Version:        0.19.9
Release:        1%{?dist}
Summary:        Incus web interface
License:        GPL-3.0-only
URL:            https://github.com/zabbly/incus-ui-canonical
Source0:        https://github.com/zabbly/incus-ui-canonical/archive/refs/tags/incus-%{version}.tar.gz
Source1:        incus.service.d/incus-ui.conf
BuildRequires:  systemd-rpm-macros
BuildRequires:  git
BuildRequires:  npm
BuildRequires:  yarnpkg
BuildArch:      noarch

%description
Incus web interface.

%prep
%autosetup -n incus-ui-canonical-incus-%{version}

# See https://github.com/zabbly/incus/blob/2efccf9de6d2245b8c4f2b3203e94613b973cf24/.github/workflows/builds.yml#L366C11-L366C79
find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.scss" \) -exec sed -i '
  s,devlxd,guestapi,g;
  s,dev/lxd,dev/incus,g;
  s,LXD,Incus,g;
  s,Lxd,Incus,g;
  s,lxd,incus,g;
  ' {} \;

yarn install --ignore-scripts --frozen-lockfile

%build
yarn build

%install
rm -rf %{buildroot}
install -dm755 %{buildroot}%{_datadir}/%{name}
cp -dR --preserve=timestamps build/ui/* %{buildroot}%{_datadir}/%{name}/
install -D -m0644 %{_sourcedir}/incus.service.d/incus-ui.conf %{buildroot}%{_unitdir}/incus.service.d/incus-ui.conf

%files
#/usr/share/incus-ui
%{_datadir}/%{name}
#/usr/lib/systemd/system/incus.service.d/incus-ui.conf
%{_unitdir}/incus.service.d/incus-ui.conf

%changelog
* Wed Mar 25 2026 localhost <root@localhost> - 0.19.9-1
- Initial RPM packaging
