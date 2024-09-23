Received: from mail-4319.protonmail.ch (mail-4319.protonmail.ch [185.70.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D9219F138;
	Mon, 23 Sep 2024 16:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727110139; cv=none; b=Vic8pEL15LiEaGA01iV+uHB9irVWd2QrCZYiJ6S3fKgTTdpCy87UuOGn8oWXbEnZc2Xi+Wyzg2ehU5viJp0CT0hoaJbiFlIbQOpVYoC884/aaL8B1WqZeDaWjC6mjRKbU3avNW4FQ6DXNoWGDndzedfsIunVy7cFdDOlotQm7VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727110139; c=relaxed/simple;
	bh=bAiicrpcuvXIdu+PFpVoDZJII26yW/Y2dVSZSXvEyTI=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=uAMzpXwVXWFZK0XnyAK8aHBgO6u7uHuqgEjtyH4AGBnixHwvNCLWF2p1imDZd1E6kcMstiB+ygjHjhA8I2iwZoCz4oUVxj2DptLK9TZFnsvIT8GjJOJfcl3Imk2/2jfX7hLIQII9eB0xPR9vc4qVixwOp831MicIRyQ64sd9g+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=SVixMpVy; arc=none smtp.client-ip=185.70.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="SVixMpVy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1727110135; x=1727369335;
	bh=1gfs9NK8z4Sb3ZQ/sTw/C1jG/iVcYvCWzQ5pw5kIq/g=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=SVixMpVy8aWtWzXbBA3jH3Kn+767c+QVO4GHbPaL4jqFbt3ri7FqbykMdxfsg006h
	 bkGP5/bej2BRyqK1Guc4BzUlXdi3bRWRIThFLzGlDZPBhKpWsHEkhPUKzyZsiNHrAT
	 j1J14vHdpMIbNmjlP4RYe55kNxqrs/b7fpE6pto6WZhEywTie/L4Lk1RjrQh5p2Y2j
	 lsJF7I+YKGRciZaw61ovKT3Q3iaFD1frjpHThr7NtugKLfkRDfLWqZUyGtLjbLJC+Z
	 aWEPLmzwjymYZyNAhcUFiM6Sb8zh3sEsnknBWCuXJwKoW63c5r4ra45BidwUI0kbTb
	 YHfnGMLp1qhwg==
Date: Mon, 23 Sep 2024 16:48:51 +0000
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Jari Ruusu <jariruusu@protonmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Announce loop-AES-v3.8e file/swap crypto package
Message-ID: <Y0PDGsSUEFUwuPwSuIyYJ-TtAEwpiWlsyftpLvGNNBd4XpRc_MzU0Up6dVZwCxqB0Ux1z5zVd-lOwYGpnvBBAKOSv-CkfeMDqBmYiD7jsHQ=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: d1c6e9522a85c82d3becc236238d5bc0e4c56067
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

loop-AES changes since previous release:
- Worked around kernel interface changes on 6.11 kernels.

bzip2 compressed tarball is here:

    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8e.tar.bz2
    md5sum 92f962b8ab46ff6b3035f5dc03563dec

    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8e.tar.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

