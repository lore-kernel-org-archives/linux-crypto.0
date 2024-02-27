Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A1C55E7C;
	Tue, 27 Feb 2024 09:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709025748; cv=none; b=epiMreXJd+M3frx4N5RtXmVrgJVAZbr0NXywJE+Ll3S6R2N2PuF+/uoP05sa7F3kiWsQVMAV91JV5EWJys1/mZIk5awJdEpTwo3jL9VCon4Ob12OdNmhvvjRAkEVbdnKw8rql7+XTv7Bhj+nRO0DiNmv73kUkYOp9cKnchiC8+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709025748; c=relaxed/simple;
	bh=8n5SeuaXS9ESMxi7WWn6HeQWdF7/6qZ2yjERbOU9mCE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ehpiFvBZFEA6X7Uda4RFLjdFVzF4jAtzKLaiMk7Ubq3BgqnEnf/oleZjGaFA8a6FMCiZDGJP2ubvjD5F+CSIM/GeziMhcmbI4xmMKWknezRc7ur/xyjQRHNkJ3UIs/Ir6FIfiLFCc6prsgLkW8kvQh7WCBYXDkloq2wIG6tEBbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=neWoXe42; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="neWoXe42"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1709025743;
	bh=8n5SeuaXS9ESMxi7WWn6HeQWdF7/6qZ2yjERbOU9mCE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=neWoXe42MrAZUcU7VfQPt2nnRYcujiHnGtA3//A1kg8aaJeHF+JmKkA5AEaYNBZlV
	 rNdJ8iAxq6ufAlDFNQYqIJ4wcD/sEhYbECjW01fEAH9ValTZOI+lj1Yw0jdRvdSB4V
	 6NiSt/e+ltjti7/DtGiNxCdrCjhXf0Hg+SQs0eyc=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 6A0E566D60;
	Tue, 27 Feb 2024 04:22:21 -0500 (EST)
Message-ID: <b858ec2a84546d7cdb666fd01c44a23714a33332.camel@xry111.site>
Subject: Re: [PATCH] loongarch/crypto: Clean up useless assignment operations
From: Xi Ruoyao <xry111@xry111.site>
To: WANG Xuerui <kernel@xen0n.name>, =?gb2312?Q?=B9=D8=CE=C4=CC=CE?=
	 <guanwentao@uniontech.com>, =?gb2312?Q?=CD=F5=EA=C5=C1=A6?=
	 <wangyuli@uniontech.com>, herbert <herbert@gondor.apana.org.au>, davem
	 <davem@davemloft.net>, chenhuacai <chenhuacai@kernel.org>
Cc: linux-crypto <linux-crypto@vger.kernel.org>, loongarch
	 <loongarch@lists.linux.dev>, linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 27 Feb 2024 17:22:18 +0800
In-Reply-To: <0a7d0a9e-c56e-4ee2-a83b-00164a450abe@xen0n.name>
References: <20240226080328.334021-1-wangyuli@uniontech.com>
	 <48afa638-9145-40ee-9868-fa82a1fce271@xen0n.name>
	 <tencent_29355025499B47007555CE13@qq.com>
	 <0a7d0a9e-c56e-4ee2-a83b-00164a450abe@xen0n.name>
Autocrypt: addr=xry111@xry111.site; prefer-encrypt=mutual;
 keydata=mDMEYnkdPhYJKwYBBAHaRw8BAQdAsY+HvJs3EVKpwIu2gN89cQT/pnrbQtlvd6Yfq7egugi0HlhpIFJ1b3lhbyA8eHJ5MTExQHhyeTExMS5zaXRlPoiTBBMWCgA7FiEEkdD1djAfkk197dzorKrSDhnnEOMFAmJ5HT4CGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQrKrSDhnnEOPHFgD8D9vUToTd1MF5bng9uPJq5y3DfpcxDp+LD3joA3U2TmwA/jZtN9xLH7CGDHeClKZK/ZYELotWfJsqRcthOIGjsdAPuDgEYnkdPhIKKwYBBAGXVQEFAQEHQG+HnNiPZseiBkzYBHwq/nN638o0NPwgYwH70wlKMZhRAwEIB4h4BBgWCgAgFiEEkdD1djAfkk197dzorKrSDhnnEOMFAmJ5HT4CGwwACgkQrKrSDhnnEOPjXgD/euD64cxwqDIqckUaisT3VCst11RcnO5iRHm6meNIwj0BALLmWplyi7beKrOlqKfuZtCLbiAPywGfCNg8LOTt4iMD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-02-27 at 15:42 +0800, WANG Xuerui wrote:
> Sorry. I have checked the manual and it turns out you & Yuli are=20
> correct: even though the narrower CRC instructions doesn't require=20
> GRLEN=3D64, they still *aren't* part of LA32 (LoongArch reference manual
> v1.10, Volume 1, Table 2-1). Counter-intuitive as it is, the original=20
> patch is correct nevertheless.

But I don't think the table in the spec will 100% reflect the real
status of the LA32 hardware.  And we should use CPUCFG to detect it
anyway.

Based on my experience programming some aeronautic device I'd say having
some hardware CRC support should be useful even in embedded area.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
