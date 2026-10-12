class TeamMember {
  const TeamMember({required this.name, required this.githubUsername});

  final String name;
  final String githubUsername;

  String get githubUrl => 'https://github.com/$githubUsername';
}

const List<TeamMember> teamMembers = [
  TeamMember(name: 'Eric Silva Patricio', githubUsername: 'ericSilvaP'),
  TeamMember(name: 'Kauã Neres Moura', githubUsername: 'Kaua-cel'),
  TeamMember(
    name: 'Alan Rodrigues de Castro',
    githubUsername: 'alanrcastro100',
  ),
  TeamMember(
    name: 'José Maranhão da Silva Neto',
    githubUsername: 'maranhaojose',
  ),
];
