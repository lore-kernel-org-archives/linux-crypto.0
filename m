Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DBF1D278A;
	Tue, 14 Jan 2025 10:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736851812; cv=none; b=E07vecwzAfhRLvN95MYBMWict+7ro+6Z0L8Qqk4aTymnjtBNgJRKzLc2LspdTQqL9LFaDz6+BtrxQpXsLJ5fJhP3rt/G1cRmpXyvTFB9a/c8j9mBh98Cf+26e8zl+QZ8+gcdoiuEbQ9QKEd0xVKSLm7fR6SffoUsVqlSXkYFcrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736851812; c=relaxed/simple;
	bh=n8a7vFvmqe2OHwhpuwdm5skzSSNwSqxHvZCoPNKRZwk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jLLHVc6IZ7QwUVo8ugmO8PvHf/lLW+wXwjujutxI61Pk57rMtgXOyWKbIeysLwz9IWuGty5otce8nCp0AiPnrvsywA0g5zau+msD9ylTyactNWRjyB1eK/qo/kBJPEAvMIC4gHdIt8Sk07K46dVuWl06UCnyrWs4DuZZn18tC9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=EJb0g6W1; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="EJb0g6W1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1736851409;
	bh=Qer/50LAk/T5x76cwpUBQp7jojD6zPs6cu0a9cYAKHU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=EJb0g6W1RVLLnp4AfGKdVUcAlRN79ZcUiB7E0UBJfn3vWRWruId2Jjli8O/q77c1I
	 UeWmzcAJhgtcK+5AKC1ArRjEgXhYVGZx9+/GshkoRR4XMqLD9LiLOX4w91JlH8huXq
	 EeeFrbx7I/UAZwAq8iYZ7p1uoGl4D3vCYPeCSxdw=
Received: from [192.168.124.9] (unknown [113.200.174.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 469E266B25;
	Tue, 14 Jan 2025 05:43:27 -0500 (EST)
Message-ID: <97000576d4ba6d94cea70363e321665476697052.camel@xry111.site>
Subject: Re: [PATCH v1 3/3] misc: ls6000se-sdf: Add driver for Loongson
 6000SE SDF
From: Xi Ruoyao <xry111@xry111.site>
To: Arnd Bergmann <arnd@arndb.de>, Qunqin Zhao <zhaoqunqin@loongson.cn>, Lee
 Jones <lee@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, Greg
 Kroah-Hartman	 <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, "David S .
 Miller"	 <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 "derek.kiernan@amd.com"	 <derek.kiernan@amd.com>, "dragan.cvetic@amd.com"
 <dragan.cvetic@amd.com>,  Yinggang Gu <guyinggang@loongson.cn>
Date: Tue, 14 Jan 2025 18:43:24 +0800
In-Reply-To: <ee65851c-4149-4927-a2e7-356cdce2ba25@app.fastmail.com>
References: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
	 <20250114095527.23722-4-zhaoqunqin@loongson.cn>
	 <ee65851c-4149-4927-a2e7-356cdce2ba25@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-01-14 at 11:17 +0100, Arnd Bergmann wrote:
> On Tue, Jan 14, 2025, at 10:55, Qunqin Zhao wrote:
> > Loongson Secure Device Function device supports the functions specified
> > in "GB/T 36322-2018". This driver is only responsible for sending user
> > data to SDF devices or returning SDF device data to users.
>=20
> I haven't been able to find a public version of the standard

A public copy is available at
https://openstd.samr.gov.cn/bzgk/gb/newGbInfo?hcno=3D69E793FE1769D120C82F78=
447802E14F,
pressing the blue "online preview" button, enter a captcha and you can
see it.  But the copy is in Chinese, and there's an explicit notice
saying translating this copy is forbidden, so I cannot translate it for
you either.

> but
> from the table of contents it sounds like this is a standard for
> cryptographic functions that would otherwise be implemented by a
> driver in drivers/crypto/ so it can use the normal abstractions
> for both userspace and in-kernel users.
>=20
> Is there some reason this doesn't work?

I'm not an lawyer but I guess contributing code for that may have some
"cryptography code export rule compliance" issue.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
