Received: from mail-4325.protonmail.ch (mail-4325.protonmail.ch [185.70.43.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5B858AA5
	for <linux-crypto@vger.kernel.org>; Sat, 20 Jul 2024 08:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721462465; cv=none; b=evjT1Ukym2/Zq6KQ8PFgqFb9tTpG2UrmT69q2GXNPA70YhId5TWtwj1MyXsZUr9bI/giEC4V8HCy5UPi/8SsF0dHQ5cWL433vKdYqYKzspmgNhrOUbd0DqKZbdVXZB54GKDzyunACLJ3F5CbXgOEY4Y0rVEwPLKPRFN/BiWEvcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721462465; c=relaxed/simple;
	bh=DPHT+BfOa0vagYpe7nlw5q4gExak7dRfzS6eOSek5Us=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=WKJoCCtX09WmCAoBQEJtdl+185slPQQ0wv6HQgGDKSknVEasRYweY1QDo/84Y1Gsbt4mFYnGnqK0Q6ncLagI8H/3MvDou0bW8ZazoLWvALhW3uNsXACltXNww28sBd+HACx/yVvY7bH99yvKNPdWiLnR5qBXihZIm3pKnOEzI8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=NQ4Ebzg0; arc=none smtp.client-ip=185.70.43.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="NQ4Ebzg0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1721462447; x=1721721647;
	bh=zAyD8N1jd8wn9zgkPHwTpcBdJue2QBdmN1NS7myffk0=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=NQ4Ebzg0R9kxkThvFmF8ezo+gubrz6NW+abasAj2v6ZOwaLu1tOeDTPN78aLE7gIx
	 81pymRfZfPTLaKdDggi5HnvjDrgGMFrUsyoBGsHhmvxv9FJU9g+okvkCEQltivjBy2
	 i9R1Vc04b+mhoBsGs7RrqMABABhHbctRObc8vigRCAUnXeZXlPeqUmCsBU3V+8T85o
	 zNmztIjRhs5BTgVFW+viG/5nDdgpn+dPFjz6eWt86zekdz/CRekKDIaS/rgONgt4DP
	 fXKREGipglBJVrLX1+hVhCjIPDc6vI1/23v7s+KX/DgPlt7BlZCCYvP+9tyj5XsR6k
	 Ww8ziE1O0xNqw==
Date: Sat, 20 Jul 2024 08:00:43 +0000
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Jari Ruusu <jariruusu@protonmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Announce loop-AES-v3.8d file/swap crypto package
Message-ID: <zIEccC4mfA_ETwu4qTNHosdNy5ng6aeo8PmR_29jPqGEg18eo55fkS9OodYvXyY9sY5wgF991xwnGSHSpi_YE4e6g888l6mpV-Pb91KXUoA=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: 972074221727eb9ced1fa452b6135c841dcf9287
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

loop-AES changes since previous release:
- Worked around kernel interface changes on 6.10 kernels.

bzip2 compressed tarball is here:

    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8d.tar.bz2
    md5sum 47ec963e18ed1ac8e8b471d3c15e3b7a

    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8d.tar.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

