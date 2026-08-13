Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC5340B6E9;
	Thu, 13 Aug 2026 20:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786651823; cv=none; b=A7P3SVRDhBs1y3VP9zmRt0CA8vK4NU9SWBuDev/0W8WW0VVxRnhqahbHAM6RnZ4vkaCHr53onKgL5COSE6EMRVyKX9vqsquzHsbx51Tz/liM3mcwSIq5Cbbv7U9DeNU1ROl+s1WwgBJTA3iFMyLI25f5qoEK0olTzMRC6E/mG/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786651823; c=relaxed/simple;
	bh=vdvsBlhMVAoKGtAcv6poTmeuiiL/sdPHF9Fb4e9Q8T8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2ImcNGWDLg7z1SYA0pTUUtsfMLcFFOCHGWBKKLRkBk+MSCRo0/4/8hT2n2sx7IRCzjQbde1Wz2HQj91wkSbFyQKFAIbj/sYELGqE8ZPW6291qj4kJPIhKXX2RhfFo+0YghV4ZnEcFUDtmCtXFFcbRnTDgnveNxwJsylonuWSIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4X6jOsu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4X6jOsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBE21F000E9;
	Thu, 13 Aug 2026 20:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786651821;
	bh=+O/RjKz8VvaPPQMBTUPAO9bROziXqWuh74ARHIp9xKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J4X6jOsueE1Brvi+7ETrR4bW3h8czj+b8LgIin2e4xwGiazfCXEivoPDy7JzOqFig
	 FHaQYV6v4/zal8ZLNqu01clp1jnSh7cUVkkuqI1F8ZPoIKJm2fDk3bVNZ76IxFJR2h
	 Wdj1Uqhtrfdcw0hxlzQYqAalYB3nysu4JDlglXoRqSmHa0kiQqXA854dc7iquG0uOt
	 hmyqX5mINWbHZRGhUsL/oxHI2UwaaNisDM1bD9Ffy356KP4CwJ/giK1a/8rwmsmao9
	 tNShEuWin3dK39yWHA4YcAS7T0TV1JzMhGlaMDdwbGTQRONMW6ZtlLXnTEx0EudPrE
	 iYBXo+SHUhwtA==
Date: Thu, 13 Aug 2026 20:10:19 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
Message-ID: <20260813201019.GA987015@google.com>
References: <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark>
 <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark>
 <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
 <20260811224110.GC1905@sol>
 <CAMRc=MfVqphaVsfcmUXjGmu6m+F6nJYXgAPuTVjZBwFnd48BkA@mail.gmail.com>
 <bc95e0b0-2cc5-4ad6-a319-ae4e159b92fe@gmail.com>
 <CAMRc=Mcno_F2UuLXZ3ruaVSbYhssVK90m3KM=+dwskLMSp8TXg@mail.gmail.com>
 <0d2706c6-79fa-40fc-a24a-6d5ffbf02330@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d2706c6-79fa-40fc-a24a-6d5ffbf02330@gmail.com>

On Thu, Aug 13, 2026 at 03:09:36PM -0400, Demi Marie Obenour wrote:
> > SM8650 with the QCE is FIPS 140-2 certified and apparently this makes
> > a difference. Don't ask me if that makes sense, I don't claim to understand
> > the legal aspects of it.
> 
> That sounds like the kind of thing that would cause someone to use
> a worse implementation of cryptographic algorithms 🙂.
> 
> For what it is worth, many common uses of kernel cryptography can't
> use the QCE.  This notably applies to the CSPRNG (/dev/urandom etc),
> storage encryption, and AF_ALG.  Therefore, I expect that anyone who
> needs FIPS 140 compliance with Linux needs to ensure that the software
> crypto is certified, as that's what actually gets used in most cases.

Well there's that, and also the Inline Crypto Engine (which is actually
being used and is unrelated to QCE) has its own FIPS certification.

Which upstream kernel feature, if any, is QCE being used with?  I have
asked this multiple times and still not gotten an answer.

Does the perceived value perhaps come merely from "offering" FIPS
certified cryptography on the system -- then not actually using it in
practice?  That can maybe be understandable in some cases, but it's also
not really something that belongs upstream where actual technical merit
is expected.  Also, could ICE be enough to check that checkbox?

- Eric
