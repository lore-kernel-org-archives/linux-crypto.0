Return-Path: <SRS0=FyHQ=TQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8348C04E84
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 02:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AC3520848
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 02:12:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="diGpPQUv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfEPCMx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 22:12:53 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40542 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfEPCMx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 22:12:53 -0400
Received: by mail-pf1-f196.google.com with SMTP id u17so957924pfn.7
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2019 19:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=P1EJ1RRPpfxvuymwKbVdpkG8jtFroZ7XoSxbEw7EEDk=;
        b=diGpPQUvm5HSFAy+VLt5eOwRlixnUhHkksBGIzBsBzh/MBpy6JPSkSleSXUipe4h7P
         K/HBmfOJtXeFye86w4oHBVGSdu17ef1ZyvuT0TqMkKvz6c9CvoxDyFEUES2mkTKoXY/I
         MLFvlXUK8yNmWyIKd25+axaHewj41UfMrKGp8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=P1EJ1RRPpfxvuymwKbVdpkG8jtFroZ7XoSxbEw7EEDk=;
        b=l4fKbvdpckAbWnv57TjGMaNjq9uJ8KOwyv7rLQwp34b3SFXv34N7H8H40coY6cikqU
         eEWS5kmnxkaoC7ysMAlx7k/JMGCQt0/U4WCBgZ05SmihXSBtkYVJnjDCAmnnpECb8V8S
         Ya/gkePehYJ3j9+HLuUQ7BUXS53gt7sMUIZqECB/4VStrj4UEO8pqth77PSJnoM1+8+M
         XBkZu69eh0lfUh6Mn6OVrL55WVY9PqmontFuI9NiUCDJGGX7XsNy2sGTLZJuNm7ZRFYh
         r84eepIP/12dJZJfXL3Ay18txKxUhnOINHD2M901WXZOy3U3GVCo4q1kLb7Axj9exHNZ
         lMsg==
X-Gm-Message-State: APjAAAXOotq+qUFL8dWL3UL8Ibsw3wyG0FGizDhDDXstQE0yFU4AC0fu
        HGvfMMz7sQQutLWRPn4peRm2vw==
X-Google-Smtp-Source: APXvYqx9Ch2TUCqBHQUNB0h/htgu14X1hw6d4YC3kulfKT/9lZ5ws04g0kx2rz8qhRljndmNx2xFdQ==
X-Received: by 2002:aa7:95bb:: with SMTP id a27mr39662147pfk.30.1557972772641;
        Wed, 15 May 2019 19:12:52 -0700 (PDT)
Received: from localhost (dip-220-235-49-186.wa.westnet.com.au. [220.235.49.186])
        by smtp.gmail.com with ESMTPSA id 132sm4162765pga.79.2019.05.15.19.12.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 May 2019 19:12:51 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Nayna <nayna@linux.vnet.ibm.com>, leo.barbosa@canonical.com,
        Stephan Mueller <smueller@chronox.de>, nayna@linux.ibm.com,
        omosnacek@gmail.com, leitao@debian.org, pfsmorigo@gmail.com,
        linux-crypto@vger.kernel.org, marcelo.cerri@canonical.com,
        George Wilson <gcwilson@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
In-Reply-To: <874l5w1axv.fsf@dja-thinkpad.axtens.net>
References: <20190315043433.GC1671@sol.localdomain> <8736nou2x5.fsf@dja-thinkpad.axtens.net> <20190410070234.GA12406@sol.localdomain> <87imvkwqdh.fsf@dja-thinkpad.axtens.net> <2c8b042f-c7df-cb8b-3fcd-15d6bb274d08@linux.vnet.ibm.com> <8736mmvafj.fsf@concordia.ellerman.id.au> <20190506155315.GA661@sol.localdomain> <20190513005901.tsop4lz26vusr6o4@gondor.apana.org.au> <87pnomtwgh.fsf@concordia.ellerman.id.au> <877eat0wi0.fsf@dja-thinkpad.axtens.net> <20190515035336.y42wzhs3wzqdpwzn@gondor.apana.org.au> <874l5w1axv.fsf@dja-thinkpad.axtens.net>
Date:   Thu, 16 May 2019 12:12:48 +1000
Message-ID: <871s0z171b.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Daniel Axtens <dja@axtens.net> writes:

> Herbert Xu <herbert@gondor.apana.org.au> writes:
>
>> On Wed, May 15, 2019 at 03:35:51AM +1000, Daniel Axtens wrote:
>>>
>>> By all means disable vmx ctr if I don't get an answer to you in a
>>> timeframe you are comfortable with, but I am going to at least try to
>>> have a look.
>>
>> I'm happy to give you guys more time.  How much time do you think
>> you will need?
>>
> Give me till the end of the week: if I haven't solved it by then I will
> probably have to give up and go on to other things anyway.

So as you've hopefully seen, I've nailed it down and posted a patch.
(http://patchwork.ozlabs.org/patch/1099934/)

I'm also seeing issues with ghash with the extended tests:

[    7.582926] alg: hash: p8_ghash test failed (wrong result) on test vector 0, cfg="random: use_final src_divs=[<reimport>9.72%@+39832, <reimport>18.2%@+65504, <reimport,nosimd>45.57%@alignmask+18, <reimport,nosimd>15.6%@+65496, 6.83%@+65514, <reimport,nosimd>1.2%@+25, <reim"

It seems to happen when one of the source divisions has nosimd and the
final result uses the simd finaliser, so that's interesting.

Regards,
Daniel

>
> (FWIW, it seems to happen when encoding greater than 4 but less than 8
> AES blocks - in particular with both 7 and 5 blocks encoded I can see it
> go wrong from block 4 onwards. No idea why yet, and the asm is pretty
> dense, but that's where I'm at at the moment.)
>
> Regards,
> Daniel
>
>> Thanks,
>> -- 
>> Email: Herbert Xu <herbert@gondor.apana.org.au>
>> Home Page: http://gondor.apana.org.au/~herbert/
>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
