Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.29
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792685458;
	b=wlnoAByZgiVr+pD3+YpuIAGJcMk14BxmDpAVQAm/sqIVF3oa8GBQJ0ieMDcI9SouwpXG
	 crKn1vmySseX4lMu4sz/zvHA/0Q8CBNagrvpMNM7dUPVwI6OiVPLJWLofRCKYrhE0Laoo
	 xqtaxCnWoGrPgaPKOh1ENmPUBL0XpQvfEua0475HDHgPNu2zpwSn9uqvntFUfEi8YsIkh
	 UehaSUhFN+BOrHW38f67V1LlTISbtjoLHXpfAe3pgf8kgVXTqwylBcxOSb4WyuK9VJ1v1
	 9N1WHvjk12G8VEhu1pGLapAVDyKX+tDl1NTF8TgcLAG5Sev/DTyDFhpXmfp4r57fi2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792685458;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Co6eDYKk8IPN/9s3Hazm6D79Q0aT4q9Rf8hjYlsuRkU=;
	b=HblTjqPnix8EkNx67EYP0e5VPGFZBIscEc0jZudTSeZfeJORQj/sxS3t3Qj+NSFurXGf
	 inuST9wzymSndE+mVs496eUXlae/ngbNnsTqjF1XhqiUbEB1SZIgbL4NunuP5ikr02jC+
	 mXok0aqbxQJHbvrlRelalx2E04RyuIKAk7OVKqCgUE1e3gwLXzT507i6iUiMSKQpm7DcH
	 kW/6O7iNDwFK8hyZ6Kn5GOF09q9jre0dlff1gqO2ydjuHIkakg3CarYC6zRJnxpbc3RFA
	 JT3pz2oA1fgAJpqXBe0cCGI7x3gk5qBzXkCWQGGeUsAiEQgGOoKafCR3HPU+nahIRlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=H6oo81Ot;
	arc=none smtp.remote-ip=109.224.244.29
Received: from mail-24429.protonmail.ch (mail-24429.protonmail.ch [109.224.244.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C080606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 16:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C080606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=H6oo81Ot
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1792685455; x=1792944655;
	bh=Co6eDYKk8IPN/9s3Hazm6D79Q0aT4q9Rf8hjYlsuRkU=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=H6oo81Ot8Ts0+5TF5zA2or2zUkYXRa+SysyfnN/wE74gfQd/QMuVB2PfFbB3Y3fyi
	 LP3XJrZMjsu5e8RussQ8zizMjpi0iqyRGK4kCQj205GH5Gm3sbZbTOWAAQLJRynCCD
	 tEAR5/6rtoZJdso3QzrRmuQ/HHfniBy2sG1KiOVz0hb+pkaVzPS8E+VKSnLzTiu8DM
	 IBSWi39y1Z5MY1eet1/1isVdMeVjbm/gF/aSkcc0e0uvdQEmwA2PUGLzmM2T/GfFNc
	 sIjzGRfaxQMhwnND5d1BuS5Dxbm1N8thSongkxz3d4dgGm3JyfMPjrBFJ/cl6yuII6
	 mvMCusYndL1Kg==
Date: Thu, 22 Oct 2026 16:10:50 +0000
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Jari Ruusu <jariruusu@protonmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Announce loop-AES-v3.8k file/swap crypto package
Message-ID: <qT_dp1nX4gUxLWZJZNpUypK4gL0sHtBtd_J4VuwH8_DmYHe2DGyao5tSCy9o0Mj-p78v2ac2hqcsr_f4hiUGm_4BP9xiP25RaN6miBASR6w=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: 15057aa9cf4a7ffc9219eabc19d84ba5e5d725fa
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

loop-AES changes since previous release:
- Worked around kernel interface changes on 7.3 kernels.
=20
bzip2 compressed tarball is here:
=20
    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8k.tar.bz2
    md5sum fdc2cbb4694dd9a8c951e59a53182da9
=20
    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8k.tar.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

