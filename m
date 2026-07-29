Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F9A331ECF;
	Wed, 29 Jul 2026 19:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785351990; cv=none; b=QtC7iU9+Z3mOy8uOSFy1beX50IE4Brv0rHxLuT05cr2JgdJvJfgiCxUzGHCxDInZoh/Up74O41dszYKmVF2Ri2Un8zT8CkUXf6TUCrz2YaC/QmTPsyqwAa6NrPm6UAahbTklUF+1xWC+dMK9B6TCqgiWWYtpKrS1kPI9fcwYjwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785351990; c=relaxed/simple;
	bh=BKPBU03KntT4Jrk+J3MJCdvJDQD0Yhp8908KlyuPox8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T7Lt+DfueMweSo0oua7Rf8L/Wa7Rq9dQdrwWKGeGRD8VuCxIy9D1e/wkBYfLqtvYNVJj0pIxGMdWDux8yCSeJOa8c1+rEGwLA8JvxWDqpZ/oSmF/1g6EujMLMWgMJWC0RI/popPaj6IVYBGqDmbcelNe0/Vbg2VfbRoE2OD74Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=DTM08EeE; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="DTM08EeE"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id E72D21A1301;
	Wed, 29 Jul 2026 19:06:23 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id BA3E36039A;
	Wed, 29 Jul 2026 19:06:23 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 37DBF11C152A4;
	Wed, 29 Jul 2026 21:06:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1785351979; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=+5OabZdmXYVKu/8Zp7L0cPNnYAaREhauRcN2RNAGARg=;
	b=DTM08EeEzWted8qnnPp+UBnG1Is9PaUui97xXDehf686cQMNGni+uuVEUapgmvk7fAv05X
	9cRX1G1dfVMtHTiauXkLdRZnP0QMm7hwmn2N2WVU+dIw/Tj4V7RQOYasjnAO86Mr/KgKR3
	Bt4o8r4T1H30p3oAIea8hwjQvG46UL/S3S96Y3XLBL/lScLJNXCbUTF9K1wDVH70kZvqsS
	E5fR7CD7klgYFGZzpbmx/19RhFjkUrz6yeYpifNLZRNq2BxAze9tNOWsqjOdajdFTiMF31
	oAJfZROAnF3dtG1Icr8VHrBV6TE8yhxDsn+lwFAQbff8z/uCDz5kAdCKEu0upg==
Message-ID: <e59088fb-0a47-4379-8583-546b7e4ec337@bootlin.com>
Date: Wed, 29 Jul 2026 21:06:13 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ecc - Add NIST P224 curve parameters
To: Thomas Huth <thuth@redhat.com>, Lukas Wunner <lukas@wunner.de>,
 Ignat Korchagin <ignat@linux.win>, Stefan Berger <stefanb@linux.ibm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Simo Sorce <simo@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20260729-add-nist-p224-curve-v1-1-334dfbe16683@bootlin.com>
 <42f6dd7b-8db0-46cc-ad22-c914d64d15bb@redhat.com>
Content-Language: en-US
From: Paul Louvel <paul.louvel@bootlin.com>
In-Reply-To: <42f6dd7b-8db0-46cc-ad22-c914d64d15bb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Hi Thomas, Simo,

On Wed Jul 29, 2026 at 6:43 PM CEST, Thomas Huth wrote:
 > On 29/07/2026 17.51, Paul Louvel wrote:
 >> Add the parameters for the NIST P224 curve and define a new curve ID for
 >> it. Make the curve available in ecc_get_curve().
 >
 > May I ask: Who's going to consume this?

I am in charge of upstreaming the ECDSA and ECDH support of a PKA device. The
downstream driver is using the NIST P224 curve in it's code internally.
We are waiting approval to upstream the driver, and I took the initiative to
send the curve definition ahead of time, as I thought it might be better to have
this definition in the core rather than in the driver itself.

This is an old IP that is more than 10 years old, and seeing Simo Sorce's
comment, it might not be a good idea to use this curve anymore.

 >
 >   Thomas
 >
 >> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
 >> ---
 >>   crypto/ecc.c            |  2 ++
 >>   crypto/ecc_curve_defs.h | 27 +++++++++++++++++++++++++++
 >>   include/crypto/ecdh.h   |  7 ++++---
 >>   3 files changed, 33 insertions(+), 3 deletions(-)
 >>
 >> diff --git a/crypto/ecc.c b/crypto/ecc.c
 >> index 6eb4d97a5f0d..6aa007420ab4 100644
 >> --- a/crypto/ecc.c
 >> +++ b/crypto/ecc.c
 >> @@ -56,6 +56,8 @@ const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
 >>       /* In FIPS mode only allow P256 and higher */
 >>       case ECC_CURVE_NIST_P192:
 >>           return fips_enabled ? NULL : &nist_p192;
 >> +    case ECC_CURVE_NIST_P224:
 >> +        return &nist_p224;
 >>       case ECC_CURVE_NIST_P256:
 >>           return &nist_p256;
 >>       case ECC_CURVE_NIST_P384:
 >> diff --git a/crypto/ecc_curve_defs.h b/crypto/ecc_curve_defs.h
 >> index 0ecade7d02f5..c67b73f2cd5a 100644
 >> --- a/crypto/ecc_curve_defs.h
 >> +++ b/crypto/ecc_curve_defs.h
 >> @@ -29,6 +29,33 @@ static struct ecc_curve nist_p192 = {
 >>       .b = nist_p192_b
 >>   };
 >>
 >> +/* NIST P-224: a = p - 3 */
 >> +static u64 nist_p224_g_x[] = { 0x115c1d21ull, 0x56c21122343280d6ull,
 >> +                   0x321390b94a03c1d3ull, 0xb70e0cbd6bb4bf7full };
 >> +static u64 nist_p224_g_y[] = { 0x85007e34ull, 0x5a07476444d58199ull,
 >> +                   0x4c22dfe6cd4375a0ull, 0xbd376388b5f723fbull };
 >> +static u64 nist_p224_p[] = { 0x00000001ull, 0x0000000000000000ull,
 >> +                 0xffffffffffffffffull, 0xffffffffffffffffull };
 >> +static u64 nist_p224_n[] = { 0x5c5c2a3dull, 0xe0b8f03e13dd2945ull,
 >> +                 0xffffffffffff16a2ull, 0xffffffffffffffffull };
 >> +static u64 nist_p224_a[] = { 0xfffffffeull, 0xffffffffffffffffull,
 >> +                 0xfffffffffffffffeull, 0xffffffffffffffffull };
 >> +static u64 nist_p224_b[] = { 0x2355ffb4ull, 0xd7bfd8ba270b3943ull,
 >> +                 0xf54132565044b0b7ull, 0xb4050a850c04b3abull };
 >> +static struct ecc_curve nist_p224 = {
 >> +    .name = "nist_224",
 >> +    .nbits = 224,
 >> +    .g = {
 >> +        .x = nist_p224_g_x,
 >> +        .y = nist_p224_g_y,
 >> +        .ndigits = 4,
 >> +    },
 >> +    .p = nist_p224_p,
 >> +    .n = nist_p224_n,
 >> +    .a = nist_p224_a,
 >> +    .b = nist_p224_b
 >> +};
 >> +
 >>   /* NIST P-256: a = p - 3 */
 >>   static u64 nist_p256_g_x[] = { 0xF4A13945D898C296ull, 0x77037D812DEB33A0ull,
 >>                   0xF8BCE6E563A440F2ull, 0x6B17D1F2E12C4247ull };
 >> diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
 >> index 9784ecdd2fb4..07e0d3058f5f 100644
 >> --- a/include/crypto/ecdh.h
 >> +++ b/include/crypto/ecdh.h
 >> @@ -24,9 +24,10 @@
 >>
 >>   /* Curves IDs */
 >>   #define ECC_CURVE_NIST_P192    0x0001
 >> -#define ECC_CURVE_NIST_P256    0x0002
 >> -#define ECC_CURVE_NIST_P384    0x0003
 >> -#define ECC_CURVE_NIST_P521    0x0004
 >> +#define ECC_CURVE_NIST_P224    0x0002
 >> +#define ECC_CURVE_NIST_P256    0x0003
 >> +#define ECC_CURVE_NIST_P384    0x0004
 >> +#define ECC_CURVE_NIST_P521    0x0005
 >>
 >>   /**
 >>    * struct ecdh - define an ECDH private key
 >>
 >> ---
 >> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
 >> change-id: 20260729-add-nist-p224-curve-8612b49d6ba2
 >>
 >> Best regards,
 >> --
 >> Paul Louvel, Bootlin
 >> Embedded Linux and Kernel engineering
 >> https://bootlin.com
 >>
 >>

Thanks,




-- 
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

