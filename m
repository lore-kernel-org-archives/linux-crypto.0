Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C921DA60D;
	Wed, 30 Jul 2025 14:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.77.79.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753884192; cv=none; b=ejaQq1ZwLSphNzv+VfAGI4jvBmI53Dq7+xjbg2vCFQa64H67KfMo5+32wWvqzhNL1v6XQzoYg17GEB+5UKlv7fS92eGF3BFJJwCebWaT2TxJEVT4aJIPWJpREZu52GDgyb8HjCcK1AOR4xWnZkmVpl5lf8zf2CyfxkfBG3Kc/bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753884192; c=relaxed/simple;
	bh=1NEGKQ/LM0y7ZaQHjmjPcE0qDG3GSP3wZLpeB0YVfpk=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=pqoVuErLI5drD6n87D3ujFeXmkIRucl2cUMqeO1QxaTtjyI34O5+KU8rRNqjL7K2fHLnqQz+QRUthHB40rSIQ9svaQ1zQenSEjFg+hgY2LcRxh3ZER1AqD3h+W6E+9avMB52Y+/9mg3T4ECPfG5/prhXNtWFApPlSZHKAjrz73k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=hA25UO3B; arc=none smtp.client-ip=51.77.79.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="hA25UO3B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1753884180; x=1754143380;
	bh=0+nuwECbZBoAOPJXsyfoPI9NziWmRZTaVHbqneD7ZOA=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=hA25UO3BEGmbmQPuAAvRhFy91fzzcc1YETs/ejHTlblfKbPZYmzoL3u5Y8DoQjCEW
	 WdgSFJ+d1NpZbLq+7Bz3gd9H41SpEbPem5y3mJZh+/qiBKBOkzM27kULJeVt2xo7Pa
	 dxOaHplpmHvh9/Poa5FFMGie7vzxKWb+0ed2/55NAeLmZ37YL9BI5evS73pUymQapr
	 hkRnCB71AhuGIEnn7Gih7OvNGmjB7gb5uS0e6pGbqMM80WpXh0vJE6FwQS4OH08Z4C
	 NGW9Nm0l9MuNSc8rYTGEEIyg2i3BQbQrNs1nuoCKyvv7fhQdDiaVH+kKMXMCcDr67O
	 rkXQsTyiR7lOg==
Date: Wed, 30 Jul 2025 14:02:54 +0000
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Jari Ruusu <jariruusu@protonmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Announce loop-AES-v3.8g file/swap crypto package
Message-ID: <EgWAx-u0h-QtLng0b2TNkEkTvUnzayuJpMBB-AYnaEIaJxcCUYEtWzFPJhfiGS2y2ngMTszoB7Catm9paVsA12JpWy8E6Tf87_OQxuST5ww=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: 98f53528c5a1fa3aa7791d36086d3d188ed8d8ad
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

loop-AES changes since previous release:
- Worked around kernel interface changes on 6.16 kernels.

bzip2 compressed tarball is here:

    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8g.tar.bz2
    md5sum 7e48c0659deb6c5b8086c1601cad5533

    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8g.tar.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

