Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4408742C4E3
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 16:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785343415; cv=none; b=TpjmNyLlFJDJ11biYC37hT2iUIZkaPNjnAMlc5+0o4GxW7vK3JPVwZHbpdjLG/8HWkLPXR//NvhicikI3F/VLtCKYj0C5AWALdO3TfNY9/j054AEvm68UsT1OpLX6lSz/2LcAAvx7yo0HgMfm5uwXrLJ8m89rqwdyQRFPli5b+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785343415; c=relaxed/simple;
	bh=LH+nF6lGxnKMskcPILwToHtNo9zR7QTN8/nHoSVjnYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cKXKucDk/Bw1Pny4XknyuXTURxrgj70gWUWMwYtYBF32ZkS8hGJ+wlej0pvSuoWVboY+8j0UA4PI0k/uSIMtsIyF5h78fX6fKyl8BpEr/B0OBeyw+d0MDGElBmRv5qymXsTq+HEzMztgyc0fE4tqetgNK/gP8CfH/Cz17UPXetg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TbfVirrt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aRCjJ7df; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TbfVirrt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aRCjJ7df"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785343413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2cx/h8qL0DmpPIvUzpNfOn3YFbXxtGqOjdSwngMPScY=;
	b=TbfVirrtCS2Ej8wrfCgWMJNTZWpJtTMxzPO4cq0o1AdrssLkWLYk3/r1Gatq7Xkak9kAVk
	QbZAtK4P0xsaDc+SZ6EoMDzV/HVofZABGjvyE7iRXQDhNOzYpYHGdf41VuPv/dSq0X7qdS
	FXrPql55zP+Pq4lgnAyllrnGBST8lP0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-SbmvDgItOyG0HAegcf3y5Q-1; Wed, 29 Jul 2026 12:43:31 -0400
X-MC-Unique: SbmvDgItOyG0HAegcf3y5Q-1
X-Mimecast-MFC-AGG-ID: SbmvDgItOyG0HAegcf3y5Q_1785343411
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47f84ac1990so861382f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 09:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785343410; x=1785948210; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2cx/h8qL0DmpPIvUzpNfOn3YFbXxtGqOjdSwngMPScY=;
        b=aRCjJ7dfUnNq32xxa7z9qtNPQlCbZ3brm3Z/3+Azl7cs4eOvHIxt34yT45vCj5R8is
         MELFKn2h0enPKi9jS1vUKXAJvsTVvNByfj+00xNxgg0SMghJ/KGxFUOR/PJwb2PGTtII
         3RHsvCuJJLg2NpaoLV37Grcj7p1iFIWbRBBXEGPaI5y822BPuldlo3Ewxt1BKoouc88S
         oO51zdjdBGXX7/Z0QpQLORT9wT0NdpdzRcWzjwdvt9/rXmLx1SsEFkJVAnjfd5NzVQ/1
         a1rV1WMN4HCb7M2py5U1dhuI3fv3o9UXgZeXBNRoehsLzXBCkKp/z0UiEntukxw6y7Mq
         WmYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785343410; x=1785948210;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2cx/h8qL0DmpPIvUzpNfOn3YFbXxtGqOjdSwngMPScY=;
        b=EJKaqzQWxT9ugBVxF7JVQoaXVIfbRejUb2sIc+OTktedRfXdB3/+9+ThDt9I71O7sP
         pcef7A+IuZvBQIVQhNkEVA1BAk+eu/2WwJ5FOyyPbuBw+vIqX/PTZyeRWahATVztOD5b
         6SE3KSsw6blrWfYsTDgEdmdshkJtdcwQ6SQX2z3FTg230IV1qJAxzvzsjHG+zY76+alC
         7A0bg2fQOD3szduaQQmZxJpJGG8kY6IHck4To4hWT4Z6K2irySDa5OlMcFY1WWDUZqX7
         AgL49YYr/NZRrr3thrx4fTJHFQVtvEXhgIQ7KVPqeg7RnNGvjH0ql+XJNn2S+DOZdPV8
         BM/g==
X-Gm-Message-State: AOJu0Yz6R/XEoAij8+f+blQ224NvN/N6w5UEXiBU0pI7Oh9VnWGmg4FP
	eV/pr5FIOeDOv5NC6oQXIW5IaTR0Xj2QItIaA0ZCxa3vxYcel13M/TsmRHpaCI4L6MCmjClg17C
	VZXXNsqVjoe3b8xc5WAOouTfmbrKYLrdiS0mpgX/esYysRuv054RhZDOKOTIR0msCTg==
X-Gm-Gg: AR+sD11gtjxe2ZlU0k53fa+RFpr8yAPZuhq15PurQfE4xraLi2nlXpe7IxekremF0jl
	mRl6NuYBG7nxFS6lNI7mxRvEe92cv9GAAnfxD3kLEWEAfB1awOGOvSmRePYNsH5L4kL0w/rPKIy
	trSBCRcmkElA2cqXg7wsnPyTzEYmKMnwvpZhSAIZtVjriJZeH/v6U5nkAirTIJx5V4QeDr6zMIU
	Dt6cJ0j8QOTeAD1aUKy8ifhQ8eZVc1zDS3jIXFm5cHwb/UzW80sVS/U7JnFsbn7OYn8He2epOYz
	PecwW1PodOnwRbpJk842g75rjrKZjIjfluCgkFJKnwu15pXpDQg9s90rboDjEKevUq9yiNw=
X-Received: by 2002:a05:6000:1789:b0:47f:25e4:5c34 with SMTP id ffacd0b85a97d-47fb1ea7b07mr8556325f8f.29.1785343410640;
        Wed, 29 Jul 2026 09:43:30 -0700 (PDT)
X-Received: by 2002:a05:6000:1789:b0:47f:25e4:5c34 with SMTP id ffacd0b85a97d-47fb1ea7b07mr8556290f8f.29.1785343410267;
        Wed, 29 Jul 2026 09:43:30 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.51.53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b2755dsm9941768f8f.36.2026.07.29.09.43.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 09:43:29 -0700 (PDT)
Message-ID: <42f6dd7b-8db0-46cc-ad22-c914d64d15bb@redhat.com>
Date: Wed, 29 Jul 2026 18:43:26 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ecc - Add NIST P224 curve parameters
To: Paul Louvel <paul.louvel@bootlin.com>, Lukas Wunner <lukas@wunner.de>,
 Ignat Korchagin <ignat@linux.win>, Stefan Berger <stefanb@linux.ibm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20260729-add-nist-p224-curve-v1-1-334dfbe16683@bootlin.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260729-add-nist-p224-curve-v1-1-334dfbe16683@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/07/2026 17.51, Paul Louvel wrote:
> Add the parameters for the NIST P224 curve and define a new curve ID for
> it. Make the curve available in ecc_get_curve().

May I ask: Who's going to consume this?

  Thomas

> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
>   crypto/ecc.c            |  2 ++
>   crypto/ecc_curve_defs.h | 27 +++++++++++++++++++++++++++
>   include/crypto/ecdh.h   |  7 ++++---
>   3 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 6eb4d97a5f0d..6aa007420ab4 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -56,6 +56,8 @@ const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
>   	/* In FIPS mode only allow P256 and higher */
>   	case ECC_CURVE_NIST_P192:
>   		return fips_enabled ? NULL : &nist_p192;
> +	case ECC_CURVE_NIST_P224:
> +		return &nist_p224;
>   	case ECC_CURVE_NIST_P256:
>   		return &nist_p256;
>   	case ECC_CURVE_NIST_P384:
> diff --git a/crypto/ecc_curve_defs.h b/crypto/ecc_curve_defs.h
> index 0ecade7d02f5..c67b73f2cd5a 100644
> --- a/crypto/ecc_curve_defs.h
> +++ b/crypto/ecc_curve_defs.h
> @@ -29,6 +29,33 @@ static struct ecc_curve nist_p192 = {
>   	.b = nist_p192_b
>   };
>   
> +/* NIST P-224: a = p - 3 */
> +static u64 nist_p224_g_x[] = { 0x115c1d21ull, 0x56c21122343280d6ull,
> +			       0x321390b94a03c1d3ull, 0xb70e0cbd6bb4bf7full };
> +static u64 nist_p224_g_y[] = { 0x85007e34ull, 0x5a07476444d58199ull,
> +			       0x4c22dfe6cd4375a0ull, 0xbd376388b5f723fbull };
> +static u64 nist_p224_p[] = { 0x00000001ull, 0x0000000000000000ull,
> +			     0xffffffffffffffffull, 0xffffffffffffffffull };
> +static u64 nist_p224_n[] = { 0x5c5c2a3dull, 0xe0b8f03e13dd2945ull,
> +			     0xffffffffffff16a2ull, 0xffffffffffffffffull };
> +static u64 nist_p224_a[] = { 0xfffffffeull, 0xffffffffffffffffull,
> +			     0xfffffffffffffffeull, 0xffffffffffffffffull };
> +static u64 nist_p224_b[] = { 0x2355ffb4ull, 0xd7bfd8ba270b3943ull,
> +			     0xf54132565044b0b7ull, 0xb4050a850c04b3abull };
> +static struct ecc_curve nist_p224 = {
> +	.name = "nist_224",
> +	.nbits = 224,
> +	.g = {
> +		.x = nist_p224_g_x,
> +		.y = nist_p224_g_y,
> +		.ndigits = 4,
> +	},
> +	.p = nist_p224_p,
> +	.n = nist_p224_n,
> +	.a = nist_p224_a,
> +	.b = nist_p224_b
> +};
> +
>   /* NIST P-256: a = p - 3 */
>   static u64 nist_p256_g_x[] = { 0xF4A13945D898C296ull, 0x77037D812DEB33A0ull,
>   				0xF8BCE6E563A440F2ull, 0x6B17D1F2E12C4247ull };
> diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
> index 9784ecdd2fb4..07e0d3058f5f 100644
> --- a/include/crypto/ecdh.h
> +++ b/include/crypto/ecdh.h
> @@ -24,9 +24,10 @@
>   
>   /* Curves IDs */
>   #define ECC_CURVE_NIST_P192	0x0001
> -#define ECC_CURVE_NIST_P256	0x0002
> -#define ECC_CURVE_NIST_P384	0x0003
> -#define ECC_CURVE_NIST_P521	0x0004
> +#define ECC_CURVE_NIST_P224	0x0002
> +#define ECC_CURVE_NIST_P256	0x0003
> +#define ECC_CURVE_NIST_P384	0x0004
> +#define ECC_CURVE_NIST_P521	0x0005
>   
>   /**
>    * struct ecdh - define an ECDH private key
> 
> ---
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
> change-id: 20260729-add-nist-p224-curve-8612b49d6ba2
> 
> Best regards,
> --
> Paul Louvel, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com
> 
> 

