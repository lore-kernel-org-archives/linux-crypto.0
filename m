Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF9D27E7C8
	for <linux-crypto@vger.kernel.org>; Tue, 27 May 2025 17:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368037; cv=none; b=FX7Dy1xdgOGI3Lpi2MQq7xKkVDLYzIHiLREgJEsKp9ibEfIsvE67rtShrfAC5PNZdZh7iImIPbeop+xonT6yE5aCo3271d1pSDCeMSn9YX5gKuR+mvk6EmilBHTDMRDRyvjk7FIcYhbmfsIRA4JNksslO16NZk6KwwvFSgDgSNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368037; c=relaxed/simple;
	bh=JYIstnxhz6tTJudJXraLsJSMoXf8z5L6KnymvRoqCJw=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=cMZabFu71GraxpMniaKDG7l4yN9MTqlfUzBEYf5F7BfQp0U78tWUhqJkxdW1Wl0Iwt+fe1GMNhxbV4EHC3Lxy+sDaXNyLU8//JEn6hGSefIpmJyr+Nd+bIECRFSf4F2QDiZIzdfKJZ1kPPHY1+rfNj0b6yxo/JS8ccaDjQbJCgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=QQNaCbHO; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="QQNaCbHO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1748368019; x=1748627219;
	bh=TnsuEeUNZd4fOSbK32mnlJ8dMhf6J4wN5qJo8aYgypM=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=QQNaCbHO/bJ8H1gcWMPwQBXQNHZoALFNokYeOgq3JzqE3FmNs1+TU7SZWNCrQkdsn
	 0pZP5NZfJXBumvkNSE5y/wT8kDMhlaUOL1cIPLE+ZWbIYbmomSstFVt6/54M8ygDZ6
	 IZh0YywsQgtawYUjNohEV4FL5Mj9X9RT7ZTakL2CmMFc4Ad41AXcul4oaUUAdQD4go
	 jYfZWEGIoIyxqSxvGbKrLhyOrb+Jj505xyU3hRR9nuXWi1A9H9hrjWeC5eEJ5BBkVv
	 mBaUan3vfX0wQKMVsvfZYuE80Bq8RPhvLBEnQuDa6dsZzQM0TrarcLn8PCC0zxSfeK
	 LVS+v0TBh7iVA==
Date: Tue, 27 May 2025 17:46:55 +0000
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Jari Ruusu <jariruusu@protonmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Announce loop-AES-v3.8f file/swap crypto package
Message-ID: <g9x8NCRWnSXUc7OpuZSioaPr-MOy3ETTj31mYng_Oq4i6HGwkTDC8xtPPN8c8dk0CTOq4t__8K0G5tnaEu6mji95tHWKSqQAr3h6xzaAtB0=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: a95dbd1b6339706ad70bd284dd2b15d00d4f9709
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

loop-AES changes since previous release:
- build-initrd.sh can now be configured to use devtmpfs names.
  This makes it work with drivers that use dynamically
  allocated major-numbers (/dev/nvme0n1p1 and such).
- Gentoo specific improvements for build-initrd.sh, patches
  from Hank Leininger.
- Worked around kernel interface changes on 6.15 kernels.

bzip2 compressed tarball is here:

    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8f.tar.bz2
    md5sum 05fdf443d826c56e3756825eae55f711

    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8f.tar.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

