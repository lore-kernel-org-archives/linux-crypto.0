Return-Path: <SRS0=w/0I=TU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D737BC04AB4
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 01:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD802206B6
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 01:59:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="DgtPfu3o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfETB7M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 May 2019 21:59:12 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40585 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfETB7M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 May 2019 21:59:12 -0400
Received: by mail-pf1-f194.google.com with SMTP id u17so6396574pfn.7
        for <linux-crypto@vger.kernel.org>; Sun, 19 May 2019 18:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=cfMVUA9OHUdd5CDYIB9t/NcZ2QxAx68ucJtfg3HumEY=;
        b=DgtPfu3otLiv9qY9QtIMym29sEKjSBgirtSpoBV3ktnaE57i/3Pa82u6EsNSHZFw4Y
         CQkBjaP6LY6wF+XBomC4uPNQZgcGBQ0+sx0gOss35QFw71IwpRwR+kU0jSzYo2JcbFrU
         QKj6iC2q2AQaOj6sgFLGL0CZUj3xBZuOaxFXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=cfMVUA9OHUdd5CDYIB9t/NcZ2QxAx68ucJtfg3HumEY=;
        b=SIjQyKMfyxGFBHYk6SVYQwPgdwIA9BMYsImeln/DOD+EXX+vTwixAP24SwzhPSyXiX
         huZOepfFnAcS1gAgpAuR1ZKsCZdW72VhVpiFa3Mid1ipjPdhoQu7yIlDFC4CK7wbuims
         NkWIcDkqkmQekttz6SA/HL6TdfNFkyDna/ARpCDOfj44kletvox1i0sogxsqEqijxWT0
         uGur3W7vRonSOe9kn4CtSPGVIeK5rfV5VZm/bGASdhgO5oDkNh1zhVBmnOst1Jd/mwNQ
         O16dgesXC1QtuFaR3lIXnEe0/P5OssY6fXj8yPNYvPE03UStVYn3bTutRgf5UgR06KIs
         MtlQ==
X-Gm-Message-State: APjAAAWWLt3pPrZW8wpT47y+rYaea7A0snhgCw0SSA+V/RDMUByv+Hkr
        dDTuEsqTFDSDciEpmSYTNKEq6g==
X-Google-Smtp-Source: APXvYqwiinPVc2YzhEDXGip4I/nfanOcL+4bEKa+BGmzUf0Y6zIMqM/QDPYW/hfRPIPv1BgkhwnIzA==
X-Received: by 2002:a63:2d87:: with SMTP id t129mr72619662pgt.451.1558317551425;
        Sun, 19 May 2019 18:59:11 -0700 (PDT)
Received: from localhost (ppp167-251-205.static.internode.on.net. [59.167.251.205])
        by smtp.gmail.com with ESMTPSA id h123sm24653201pfe.80.2019.05.19.18.59.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 May 2019 18:59:10 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     mpe@ellerman.id.au, ebiggers@kernel.org,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org,
        gcwilson@linux.ibm.com, omosnacek@gmail.com
Subject: Re: [PATCH] crypto: vmx - CTR: always increment IV as quadword
In-Reply-To: <20190515102450.30557-1-dja@axtens.net>
References: <20190515102450.30557-1-dja@axtens.net>
Date:   Mon, 20 May 2019 11:59:05 +1000
Message-ID: <87r28tzy1i.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Daniel Axtens <dja@axtens.net> writes:

> The kernel self-tests picked up an issue with CTR mode:
> alg: skcipher: p8_aes_ctr encryption test failed (wrong result) on test vector 3, cfg="uneven misaligned splits, may sleep"
>
> Test vector 3 has an IV of FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD, so
> after 3 increments it should wrap around to 0.
>
> In the aesp8-ppc code from OpenSSL, there are two paths that
> increment IVs: the bulk (8 at a time) path, and the individual
> path which is used when there are fewer than 8 AES blocks to
> process.
>
> In the bulk path, the IV is incremented with vadduqm: "Vector
> Add Unsigned Quadword Modulo", which does 128-bit addition.
>
> In the individual path, however, the IV is incremented with
> vadduwm: "Vector Add Unsigned Word Modulo", which instead
> does 4 32-bit additions. Thus the IV would instead become
> FFFFFFFFFFFFFFFFFFFFFFFF00000000, throwing off the result.
>
> Use vadduqm.
>
> This was probably a typo originally, what with q and w being
> adjacent. It is a pretty narrow edge case: I am really
> impressed by the quality of the kernel self-tests!
>
> Fixes: 5c380d623ed3 ("crypto: vmx - Add support for VMS instructions by ASM")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Axtens <dja@axtens.net>
>
> ---
>
> I'll pass this along internally to get it into OpenSSL as well.

I passed this along to OpenSSL and got pretty comprehensively schooled:
https://github.com/openssl/openssl/pull/8942

It seems we tweak the openssl code to use a 128-bit counter, whereas
the original code was in fact designed for a 32-bit counter. We must
have changed the vaddu instruction in the bulk path but not in the
individual path, as they're both vadduwm (4x32-bit) upstream.

I think this change is still correct with regards to the kernel,
but I guess it's probably something where I should have done a more
thorough read of the documentation before diving in to the code, and
perhaps we should note it in the code somewhere too. Ah well.

Regards,
Daniel

> ---
>  drivers/crypto/vmx/aesp8-ppc.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-ppc.pl
> index de78282b8f44..9c6b5c1d6a1a 100644
> --- a/drivers/crypto/vmx/aesp8-ppc.pl
> +++ b/drivers/crypto/vmx/aesp8-ppc.pl
> @@ -1357,7 +1357,7 @@ Loop_ctr32_enc:
>  	addi		$idx,$idx,16
>  	bdnz		Loop_ctr32_enc
>  
> -	vadduwm		$ivec,$ivec,$one
> +	vadduqm		$ivec,$ivec,$one
>  	 vmr		$dat,$inptail
>  	 lvx		$inptail,0,$inp
>  	 addi		$inp,$inp,16
> -- 
> 2.19.1
