Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38873BBFB6
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 18:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783362016; cv=none; b=irHb/qY99/S2jhEfYNAm765tzPTyBpOq2hqNGcZ2WVmRclBZTeHS6IeeguDNFxgaJnPYfXRRwW76qGbn/lFz5TsrOXFkwVsQPu1ZKPjGEBamFmVn9HuQzctBI3fa01fz9FwiwZGEWVc1l8Kn+Od5vSx0T3iyFSfUuuw3l20nrN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783362016; c=relaxed/simple;
	bh=+mBC3wHds5hkqQoAbrs/ckZqUqlq5DGBoM+aQ6GSbN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ezifQc6zMekgqGrLbQ9QeSUDi4gqUXZWM5QOB/9srsnxfXFMKTWR6GdI+b0OLbPaleF67vKFcnUcMoEXpCJTbExjmrWP7JxY+Ce7jh2wN5TSL3ELLzAJvw/HHDL0D2PPuSPTyOe4qAqIQHhe53VBRTOdTUsU3MnNMR2YwadwZvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9+QfX1d; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9+QfX1d"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47ddf7b09aaso992739f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 11:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783362012; x=1783966812; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/oh7qDp/45FgXXQqrTzgauJ39HP74+OOVGmB/m/72Sk=;
        b=Z9+QfX1dlYDzB47Apqo7xukv3o1dKc+n2QUUH54Q4/HyRrhZflF3i4gqRtCI/fRIka
         2eTSNgrgBIqltmd4p7a2DRmQYTYZLe8v4NHBjC818dXbsg69ro8WifoQDV2V73BvQMyy
         0f4Bxg1mHXXpuo6rqFVI92EbEdevPZuhkPPfsoUFIlbca5MWfxoKlIwA3+SewcUAyLHA
         nlibZ8TFCvWi8mK8YiOTByDG3i0ijTvqK+rhbO0+b3qWEfz3l9MyUoDd+5h9vwdh4+IZ
         4XLpBsZ7CE1S5/wauVHk9U+8b2qKXs3jbI1c13GBDBqW+jEjb/pP8q1lvsQvV1XORUzL
         zLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783362012; x=1783966812;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/oh7qDp/45FgXXQqrTzgauJ39HP74+OOVGmB/m/72Sk=;
        b=m+ppXJMrr41SXCEZhAg8pK0Ah6qQV85blsmYlK3Y7IYQtqQf1ymDphD5SCULtI4mal
         RtRytO9OnIxfaqEhwUVcC5v5IZxN968L2GrDQ0H7FOlpV7SsobWf5xV42sAKd08XkN3y
         svDiw1FQpxkAqGy8lEucGLu6+BZ0eFYLpUnYbV4K9JOtjUGUObThix0gJxUXNx7c0pvd
         +firPnEHmebU4GNuPKFCot7cvrbMXpryf7bbzdmokSkxRy4IX/u7PeafxawS0LV8jMAI
         VtUcvXREpKIKd6+wz7JNDfBhW5n5a+ypALRKvPQfpdBUxyCtFs7NOPyTtf7Nhr/JImxk
         LoOA==
X-Forwarded-Encrypted: i=1; AHgh+Rrx342Wtb9Wze8N6j3jpng8l1XZHAjtIvDof99bvpjrPC+DexXDUGv3khi6KiAd1SE6OhtzHEzcPFeqjb8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyfkd/YAkEvkOgf6mEK+cl3TqVAkPiFheEvoGW1S22nc1WZ5Jjq
	7ygkIu7T3Q0Uy/sq0qzz/fyezNXL/5xCjiCeqJmubng3cQLxPzRnqShs
X-Gm-Gg: AfdE7clMTg42xVAvIUmYmxMpjxO12lgBCokpMA05zqZag63fXS5RhaUjZWtQ5Jnn9F+
	yMwyHiaiWM/qRAQctUQKCh3ceLokyk5Y+iVySYH4yKsfUzHBRIkm/8hvzHnJVm+WSBpEWZlEMI4
	URJerxXqD6L2LmbnpEwvib5uZdKvxvbrfwu2mPTrA5zC9pgIoIHtRilKwMmp6JwtwDp3RcQ1wXS
	XKerYUMNLg0+XykJT7NuvG9+sUXaYLQ9dmmITcLGqawr81s7pAlw9cafuetSUbtAWIEDmYMg5Rk
	wHQy0/2a+FcmqCdAkbBM3jy/1Okk81MWZJoH8/KeQHtThl1ed2ywMB5WAYs5lXEiAGIs1QshSl0
	zy1BAadDdkwC1f8ZPACAVOYXi1lTkeVBbk7nWFkCsX5wa6bRGdhXeJRlVJ2fT6/RDzreXufeW62
	SR5xKOVQAKyd4lQVS89INes/WTOPGWfQ1msOksng==
X-Received: by 2002:a05:6000:461e:b0:454:a41f:d082 with SMTP id ffacd0b85a97d-47de66677fdmr1640454f8f.3.1783362012186;
        Mon, 06 Jul 2026 11:20:12 -0700 (PDT)
Received: from [192.168.2.14] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0f213e8sm23719930f8f.34.2026.07.06.11.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 11:20:11 -0700 (PDT)
Message-ID: <276a4c4e-bbe4-4f6f-9f9a-c1e195e06c86@gmail.com>
Date: Mon, 6 Jul 2026 20:20:10 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: af_alg - Allow additional ciphers for cryptsetup
To: Eric Biggers <ebiggers@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20260705184419.40762-1-ebiggers@kernel.org>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20260705184419.40762-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/5/26 8:44 PM, Eric Biggers wrote:
> Add "xts(camellia)", "xts(serpent)", and "xts(twofish)" to the allowlist
> for af_alg_restrict=1.  These niche AES alternatives have continued to
> see rare but persistent use via cryptsetup, which has historically
> relied on the AF_ALG support for these ciphers in XTS mode for
> performing the keyslot encryption.  (cryptsetup v2.8.7 and later fall
> back to a temporary dm-crypt mapping, but that requires root.)
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   crypto/algif_skcipher.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index 2b8069667974..49ae779b3b6b 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -45,6 +45,9 @@ static const struct af_alg_allowlist_entry skcipher_allowlist[] = {
>   	{ "ecb(des)", true }, /* iwd */
>   	{ "hctr2(aes)", false }, /* cryptsetup */
>   	{ "xts(aes)", false }, /* cryptsetup benchmark */
> +	{ "xts(camellia)", false }, /* cryptsetup */
> +	{ "xts(serpent)", false }, /* cryptsetup */
> +	{ "xts(twofish)", false }, /* cryptsetup */
>   	{},

Well, if we are going this way, I would also add Aria and SM4 (currently usable only in cryptsetup main branch).

Milan

p.s.
There is another user of AF_ALG hash, hardlink in util-linux, see
https://github.com/util-linux/util-linux/blob/master/lib/fileeq.c

