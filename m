Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAFAECAAD2
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Sep 2022 19:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbiIATvz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234733AbiIATvw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 15:51:52 -0400
Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [IPv6:2a0b:5c81:1c1::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4ECA5A165
        for <linux-crypto@vger.kernel.org>; Thu,  1 Sep 2022 12:51:49 -0700 (PDT)
Received: from [10.0.0.10] (87-100-246-149.bb.dnainternet.fi [87.100.246.149])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: jussi.kivilinna)
        by lahtoruutu.iki.fi (Postfix) with ESMTPSA id D87CD1B001B0;
        Thu,  1 Sep 2022 22:51:45 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
        t=1662061906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lbZzyLhP+GD+MOmFl3LUIL3OmLTAo1+/TnWHWGF5cWk=;
        b=hWo9GFj8ukgnWqy09aln3my0g1AmPhEDkQkRW0nSshtmZzpqzc+OSW9RVZDe3QMlx2ZTSp
        Hz0xdWt26i5BvKuyj7t7aHl8EKqhLgG74dUPj4TnI4X/q//NjrsujSS5nrO+eBJnlB0uGF
        pdBubiq/Kc+ZChRnXlyPKfUMRsl/D3cR3BgXc5B5wOTeEwLLmK6JNZxL/0VwGv1TMt/BoC
        blhOkheLse7mjixiYB+Oyc+nyCwFbRKmyO4iiD3Q79K2LsN6GkD4KNI7FDKKJ2fU8iGR3K
        lJnHSwHPI7+R1H5X6SIw2wi/WZf71A++ArHvYpgvmMTt1quHcKt6CBjkcwZ9+w==
Message-ID: <c6535c51-e069-ef46-3f7d-a08aecc0c957@iki.fi>
Date:   Thu, 1 Sep 2022 22:51:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, elliott@hpe.com,
        herbert@gondor.apana.org.au, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, davem@davemloft.net, bp@alien8.de,
        x86@kernel.org, hpa@zytor.com
References: <20220826053131.24792-1-ap420073@gmail.com>
 <20220826053131.24792-3-ap420073@gmail.com>
From:   Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [PATCH v2 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
 implementation of aria cipher
In-Reply-To: <20220826053131.24792-3-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=jussi.kivilinna smtp.mailfrom=jussi.kivilinna@iki.fi
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1662061906; a=rsa-sha256;
        cv=none;
        b=ffqhKa622dsbYTbxK10nheWkHmhN9Oh66mPCvhj9VIdjVP7WtFle8brbseBOGmSigL5sIn
        8Clnmsw+5YArMtEcA1d6ry5vaYsAzeQ3WUvEO1F3zklXKw9qk/CYjkY05zYVQ9GhUcKH7R
        RZ0GvvBEqbcDH88TqTIH7c0jCGSsO2CkMfUTEyqEoqoNskKKWzkhUftA0OhbK70GKAz17Q
        XxbicEF0Ki78FHhQlAukUSQFe/NJaVYahVtvxQPRgmlKPSOPKN2oa+OHyIK/FO6GMZfd96
        LFYP3bKi6bdXEBYbjDgQgchLlGtrm39MOI0+vF+0JOmJ6Z4yv61ZotlHWDtQ7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=lahtoruutu; t=1662061906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lbZzyLhP+GD+MOmFl3LUIL3OmLTAo1+/TnWHWGF5cWk=;
        b=GTvXByxhXOS8cum+Lr+70Ze02GyF3Q6qbsIve93FtHwpKF1aBCtO6NT10m/pKHvWWLObf/
        /8mTgxbxnYtMMxTuVF/0sASgzFsFzVK4vadefp1BToFX5hBdQtc9ILh5Dd2j4kG/YsyOZs
        C/OycD1bUwmOYztPAkL4BqlCvGHaanHKUkQ+5e5nuQTDrLoGBFeDBXOq98wMf/8DP3GOVY
        7Vm+H8Q+Xl7OxUFJxduMKJllUuYNlSoH3pnMfuJJntv6AE24AytniuvJifRv0QiK8nae6a
        u4eAGlQkcZ4ZYujpNS4kok0RT78AKNtloeTai6PRnKrYcQHJ533YpiBFjDvd1A==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

On 26.8.2022 8.31, Taehee Yoo wrote:
> +#define aria_sbox_8way(x0, x1, x2, x3,			\
> +		       x4, x5, x6, x7,			\
> +		       t0, t1, t2, t3,			\
> +		       t4, t5, t6, t7)			\
> +	vpxor t0, t0, t0;				\
> +	vaesenclast t0, x0, x0;				\
> +	vaesenclast t0, x4, x4;				\
> +	vaesenclast t0, x1, x1;				\
> +	vaesenclast t0, x5, x5;				\
> +	vaesdeclast t0, x2, x2;				\
> +	vaesdeclast t0, x6, x6;				\
> +							\
> +	/* AES inverse shift rows */			\
> +	vmovdqa .Linv_shift_row, t0;			\
> +	vmovdqa .Lshift_row, t1;			\
> +	vpshufb t0, x0, x0;				\
> +	vpshufb t0, x4, x4;				\
> +	vpshufb t0, x1, x1;				\
> +	vpshufb t0, x5, x5;				\
> +	vpshufb t0, x3, x3;				\
> +	vpshufb t0, x7, x7;				\
> +	vpshufb t1, x2, x2;				\
> +	vpshufb t1, x6, x6;				\
> +							\
> +	vmovdqa .Linv_lo, t0;				\
> +	vmovdqa .Linv_hi, t1;				\
> +	vmovdqa .Ltf_lo_s2, t2;				\
> +	vmovdqa .Ltf_hi_s2, t3;				\
> +	vmovdqa .Ltf_lo_x2, t4;				\
> +	vmovdqa .Ltf_hi_x2, t5;				\
> +	vbroadcastss .L0f0f0f0f, t6;			\
> +							\
> +	/* extract multiplicative inverse */		\
> +	filter_8bit(x1, t0, t1, t6, t7);		\
> +	/* affine transformation for S2 */		\
> +	filter_8bit(x1, t2, t3, t6, t7);		\

Here's room for improvement. These two affine transformations
could be combined into single filter_8bit...

> +	/* extract multiplicative inverse */		\
> +	filter_8bit(x5, t0, t1, t6, t7);		\
> +	/* affine transformation for S2 */		\
> +	filter_8bit(x5, t2, t3, t6, t7);		\
> +							\
> +	/* affine transformation for X2 */		\
> +	filter_8bit(x3, t4, t5, t6, t7);		\
> +	vpxor t7, t7, t7;				\
> +	vaesenclast t7, x3, x3;				\
> +	/* extract multiplicative inverse */		\
> +	filter_8bit(x3, t0, t1, t6, t7);		\
> +	/* affine transformation for X2 */		\
> +	filter_8bit(x7, t4, t5, t6, t7);		\
> +	vpxor t7, t7, t7;				\
> +	vaesenclast t7, x7, x7;                         \
> +	/* extract multiplicative inverse */		\
> +	filter_8bit(x7, t0, t1, t6, t7);

... as well as these two filter_8bit could be replaced with
one operation if 'vaesenclast' would be changed to 'vaesdeclast'.

With these optimizations, 'aria_sbox_8way' would look like this:

/////////////////////////////////////////////////////////
#define aria_sbox_8way(x0, x1, x2, x3,			\
		       x4, x5, x6, x7,			\
		       t0, t1, t2, t3,			\
		       t4, t5, t6, t7)			\
	vpxor t7, t7, t7;				\
	vmovdqa .Linv_shift_row, t0;			\
	vmovdqa .Lshift_row, t1;			\
	vpbroadcastd .L0f0f0f0f, t6;			\
	vmovdqa .Ltf_lo__inv_aff__and__s2, t2;		\
	vmovdqa .Ltf_hi__inv_aff__and__s2, t3;		\
	vmovdqa .Ltf_lo__x2__and__fwd_aff, t4;		\
	vmovdqa .Ltf_hi__x2__and__fwd_aff, t5;		\
							\
	vaesenclast t7, x0, x0;				\
	vaesenclast t7, x4, x4;				\
	vaesenclast t7, x1, x1;				\
	vaesenclast t7, x5, x5;				\
	vaesdeclast t7, x2, x2;				\
	vaesdeclast t7, x6, x6;				\
							\
	/* AES inverse shift rows */			\
	vpshufb t0, x0, x0;				\
	vpshufb t0, x4, x4;				\
	vpshufb t0, x1, x1;				\
	vpshufb t0, x5, x5;				\
	vpshufb t1, x3, x3;				\
	vpshufb t1, x7, x7;				\
	vpshufb t1, x2, x2;				\
	vpshufb t1, x6, x6;				\
							\
	/* affine transformation for S2 */		\
	filter_8bit(x1, t2, t3, t6, t0);		\
	/* affine transformation for S2 */		\
	filter_8bit(x5, t2, t3, t6, t0);		\
							\
	/* affine transformation for X2 */		\
	filter_8bit(x3, t4, t5, t6, t0);		\
	/* affine transformation for X2 */		\
	filter_8bit(x7, t4, t5, t6, t0);		\
	vaesdeclast t7, x3, x3;				\
	vaesdeclast t7, x7, x7;

/* AES inverse affine and S2 combined:
  *      1 1 0 0 0 0 0 1     x0     0
  *      0 1 0 0 1 0 0 0     x1     0
  *      1 1 0 0 1 1 1 1     x2     0
  *      0 1 1 0 1 0 0 1     x3     1
  *      0 1 0 0 1 1 0 0  *  x4  +  0
  *      0 1 0 1 1 0 0 0     x5     0
  *      0 0 0 0 0 1 0 1     x6     0
  *      1 1 1 0 0 1 1 1     x7     1
  */
.Ltf_lo__inv_aff__and__s2:
	.octa 0x92172DA81A9FA520B2370D883ABF8500
.Ltf_hi__inv_aff__and__s2:
	.octa 0x2B15FFC1AF917B45E6D8320C625CB688

/* X2 and AES forward affine combined:
  *      1 0 1 1 0 0 0 1     x0     0
  *      0 1 1 1 1 0 1 1     x1     0
  *      0 0 0 1 1 0 1 0     x2     1
  *      0 1 0 0 0 1 0 0     x3     0
  *      0 0 1 1 1 0 1 1  *  x4  +  0
  *      0 1 0 0 1 0 0 0     x5     0
  *      1 1 0 1 0 0 1 1     x6     0
  *      0 1 0 0 1 0 1 0     x7     0
  */
.Ltf_lo__x2__and__fwd_aff:
	.octa 0xEFAE0544FCBD1657B8F95213ABEA4100
.Ltf_hi__x2__and__fwd_aff:
	.octa 0x3F893781E95FE1576CDA64D2BA0CB204
/////////////////////////////////////////////////////////

I tested above quickly in userspace against aria-generic
and your original aria-avx implementation and output matches
to these references. In quick and dirty benchmark, function
execution time was ~30% faster on AMD Zen3 and ~20% faster
on Intel tiger-lake.

-Jussi
