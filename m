Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AE5248BAF;
	Wed, 15 Jan 2025 11:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736939605; cv=none; b=j+CX0NdH2ZLlYZhX92VT8ZE6L+8XvD59qJ6bZ0pSI3obb5PI68fTUxlA1Ij7HyBbRV/DBbFdTI6KxN6L8rdCeGJhoAj0MdYfneaqZY7ji9rOD8dSwd6D+SiFRMMRw5UZbLGNE9/eWY3B4mxf6/QeJEkfEqzcA4aEwAZc02WviyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736939605; c=relaxed/simple;
	bh=C3F4wzb8dl8a7vtcNnwZ0cLspCXDoL7lFlmpLnjVx+0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QT5PpCUbyntRY8gkqgo8EEXoUX7YaY/K2HqZRXBxxNFeM4FFrkqu19gEE6IsfiH/8Z0PrYg0Tq1PBmguwfmbvVgWK/BzbjbC4h10F2ncWwbO4C+1iF3VhaHqssKwESToUGqMmEpstz6jjSRvmHVGjB6+47Oj5SlLV952i9SXQ44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=CXjDm+17; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="CXjDm+17"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1736939596;
	bh=TIRWEc6iv4vNAwxX3OZhGuWgMguFtBQtmtfJppqdcpg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=CXjDm+17Uj4g5U4ToE3QNhSLJC9mScGz4NO4j6J+LpaarhSwU1Ll+qwZlOWQmTHDz
	 I9tH7++LKivPqJtRj4EILjeo4NWofvLTcnkMDEHKKDP6ZJxsUfSDyXFK5iVGbNXE1a
	 9TGabWZZVxCi5phUbqOXjXveH4+v+FiJA7qiIBuA=
Received: from [192.168.124.9] (unknown [113.200.174.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 4963E1A428C;
	Wed, 15 Jan 2025 06:13:13 -0500 (EST)
Message-ID: <d56121dc6c6953d4f052be5da5203a4e28676b4e.camel@xry111.site>
Subject: Re: [PATCH v1 3/3] misc: ls6000se-sdf: Add driver for Loongson
 6000SE SDF
From: Xi Ruoyao <xry111@xry111.site>
To: "Zheng, Yaofei" <Yaofei.Zheng@dell.com>, Greg Kroah-Hartman
	 <gregkh@linuxfoundation.org>, Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee@kernel.org>, Herbert Xu	
 <herbert@gondor.apana.org.au>, "linux-kernel@vger.kernel.org"	
 <linux-kernel@vger.kernel.org>, "loongarch@lists.linux.dev"	
 <loongarch@lists.linux.dev>, "David S . Miller" <davem@davemloft.net>, 
 "linux-crypto@vger.kernel.org"	 <linux-crypto@vger.kernel.org>,
 "derek.kiernan@amd.com" <derek.kiernan@amd.com>,  "dragan.cvetic@amd.com"	
 <dragan.cvetic@amd.com>, Yinggang Gu <guyinggang@loongson.cn>
Date: Wed, 15 Jan 2025 19:13:10 +0800
In-Reply-To: <SA3PR19MB73993DCBDE9117AA1E77C127F9192@SA3PR19MB7399.namprd19.prod.outlook.com>
References: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
	 <20250114095527.23722-4-zhaoqunqin@loongson.cn>
	 <ee65851c-4149-4927-a2e7-356cdce2ba25@app.fastmail.com>
	 <97000576d4ba6d94cea70363e321665476697052.camel@xry111.site>
	 <2025011407-muppet-hurricane-196f@gregkh>
	 <122aab11-f657-a48e-6b83-0e01ddd20ed3@loongson.cn>
	 <2025011527-antacid-spilt-cbef@gregkh>
	 <SA3PR19MB73993DCBDE9117AA1E77C127F9192@SA3PR19MB7399.namprd19.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-01-15 at 10:39 +0000, Zheng, Yaofei wrote:
>=20
> Internal Use - Confidential
> > On Wed, Jan 15, 2025 at 10:58:52AM +0800, Qunqin Zhao wrote:
> > >=20
> > > =E5=9C=A8 2025/1/14 =E4=B8=8B=E5=8D=889:21, Greg Kroah-Hartman =E5=86=
=99=E9=81=93:
> > > > On Tue, Jan 14, 2025 at 06:43:24PM +0800, Xi Ruoyao wrote:
> > > > > On Tue, 2025-01-14 at 11:17 +0100, Arnd Bergmann wrote:
> > > > > > On Tue, Jan 14, 2025, at 10:55, Qunqin Zhao wrote:
> > > > > > > Loongson Secure Device Function device supports the functions
> > > > > > > specified in "GB/T 36322-2018". This driver is only
> > > > > > > responsible for sending user data to SDF devices or returning=
 SDF device data to users.
> > > > > > I haven't been able to find a public version of the standard
> > > > > A public copy is available at
> > > > > https://openstd.samr.gov.cn/bzgk/gb/ne
> > > > > wGbInfo?hcno=3D69E793FE1769D120C82F78447802E14F__;!!LpKI!g7kUt84v=
Oxl
> > > > > 65EbgAJzXoupsM5Bx3FjUDPnKHaEw5RUoyUouS6IwCerRSZ7MIWi0Bw5WHaM2YP7p=
Z
> > > > > IcYiDQOLf3F$ [openstd[.]samr[.]gov[.]cn], pressing the blue
> > > > > "online preview" button, enter a captcha and you can see it.=C2=
=A0 But the copy is in Chinese, and there's an explicit notice saying trans=
lating this copy is forbidden, so I cannot translate it for you either.
> > > > >=20
> > > > > > but
> > > > > > from the table of contents it sounds like this is a standard fo=
r
> > > > > > cryptographic functions that would otherwise be implemented by =
a
> > > > > > driver in drivers/crypto/ so it can use the normal abstractions
> > > > > > for both userspace and in-kernel users.
> > > > > >=20
> > > > > > Is there some reason this doesn't work?
> > > > > I'm not an lawyer but I guess contributing code for that may have
> > > > > some "cryptography code export rule compliance" issue.
> > > > Issue with what?=C2=A0 And why?=C2=A0 It's enabling the functionali=
ty of the
> > > > hardware either way, so the same rules should apply no matter where
> > > > the driver ends up in or what apis it is written against, right?
> > >=20
> > > SDF and tpm2.0 are both=C2=A0 "library specifications",=C2=A0 which m=
eans that
> > >=20
> > > it supports a wide variety of functions not only cryptographic
> > > functions,
> > >=20
> > > but unlike tpm2.0, SDF is only used in China.
> > >=20
> > > You can refer to the tpm2.0 specification:
> > > https://trustedcomputinggroup.org/resource
> > > /tpm-library-specification/__;!!LpKI!g7kUt84vOxl65EbgAJzXoupsM5Bx3FjU=
D
> > > PnKHaEw5RUoyUouS6IwCerRSZ7MIWi0Bw5WHaM2YP7pZIcYiCFoP-hu$
> > > [trustedcomputinggroup[.]org]
> >=20
> > So this is an accelerator device somehow?=C2=A0 If it provides crypto f=
unctions, it must follow the crypto api, you can't just provide a "raw"
> > char device node for it as that's not going to be portable at all.
> > Please fit it into the proper kernel subsystem for the proper user/kern=
el api needed to drive this hardware.
> >=20
> > thanks,
> >=20
> > greg k-h
> >=20
>=20
> Hi Qunqin and Ruoyao,
>=20
> "GB/T 36322-2018" is just a chinese national standard, not ISO standard, =
not an
> enforced one, "T" repensts "=E6=8E=A8=E8=8D=90" which means "recommend". =
From what I understand
> =C2=A0it defined series of C API for cryptography devices after reading t=
he standard.
> Linux kernel have user space socket interface using type AF_ALG, and out =
of tree
> =C2=A0driver "Cryptodev". From my view: "GB/T 36322-2018" can be user spa=
ce library
> using socket interface, just like openssl, if must do it char dev way, do=
 it out
> =C2=A0of tree, and reuse kernel space crypto API.

Figure 1 of the section 6.1 says the GB/T 36322 interface is between
"cryptography device" and "generic cryptography service and cryptography
device management."  IMO in a Linux (or any monolithic-kernel) system at
least "cryptography device management" is the job of the kernel, thus
exposing the GB/T 36322 interface directly to the userspace seems not a
good idea.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
