Return-Path: <SRS0=FyHQ=TQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F28C04AB4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 05:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54C1A20848
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 05:28:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="K3yURH+N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfEPF2z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 May 2019 01:28:55 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42661 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfEPF2y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 May 2019 01:28:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id 13so1198682pfw.9
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2019 22:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=P6Om30hL1lPYEC7LolkN41RsDPGpD0LCsRqwi5B5jWE=;
        b=K3yURH+NDfUWMqTOpua/7r5NCvFuqC9PK7/CLdehE8H9uPl3b4hdV6wANMC9dMh7Kt
         ewSjowvpr/e6nfdwlyRpAC5O7AyLsuuiu4rx2rQ5nhtfi4hYizA4ChwCcmFizAwm7owY
         BYmUC9ZZfXqOf2Cc6WEkvMwFhAWf1x22kK7Ew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=P6Om30hL1lPYEC7LolkN41RsDPGpD0LCsRqwi5B5jWE=;
        b=KClLEaIG6zdmla+Kpa8i9Ma/jQTe1wx3m8wjDivFsyvGFpf5BKNmfLIttjJD4XCGa9
         9uTyVC8Cd/YjUkG96NbssDYP0aIK6MhsZKv5GgvQEW0vRl5PQgD5ALYoasNbpGwrI0cn
         fy6D1ruQ2prZTphN0kXb9CHDphAC2BJ1SYPbfHYdnWdCsJbRHJELZeZz0H55qfkdcbkH
         pZDgSBM+Wuulh9pPzrEMPJu3u4YZ48diCUDtP4JWTg0Sp9Veorp4O64A10oZ3eupWmEw
         6Qa3qc2LgcXGvJe+qhVnrAdDIh6cCcCvJFlycgXpuTUDNJZLlT6AUhWU0fA9NLCdEwz0
         v5ng==
X-Gm-Message-State: APjAAAWdt1wrioYQE30JoivsYegh/qMFsuBtQxNUB3ku+XEA7Lu7fpNf
        NxD7R7M2JbdxwmnB/C0WkMN8KQ==
X-Google-Smtp-Source: APXvYqwum0SV0hydhMO+lnKZbSz1Jasre9WxPrR7OGSKbB3tCJgemnT7WtKvnf64qYIKSp6N8hBJRw==
X-Received: by 2002:a63:6ac1:: with SMTP id f184mr49177523pgc.25.1557984533903;
        Wed, 15 May 2019 22:28:53 -0700 (PDT)
Received: from localhost (dip-220-235-49-186.wa.westnet.com.au. [220.235.49.186])
        by smtp.gmail.com with ESMTPSA id w12sm4259997pgp.51.2019.05.15.22.28.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 May 2019 22:28:52 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nayna <nayna@linux.vnet.ibm.com>, leo.barbosa@canonical.com,
        Stephan Mueller <smueller@chronox.de>, nayna@linux.ibm.com,
        omosnacek@gmail.com, leitao@debian.org, pfsmorigo@gmail.com,
        linux-crypto@vger.kernel.org, marcelo.cerri@canonical.com,
        George Wilson <gcwilson@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
In-Reply-To: <20190516025603.GB23200@sol.localdomain>
References: <87imvkwqdh.fsf@dja-thinkpad.axtens.net> <2c8b042f-c7df-cb8b-3fcd-15d6bb274d08@linux.vnet.ibm.com> <8736mmvafj.fsf@concordia.ellerman.id.au> <20190506155315.GA661@sol.localdomain> <20190513005901.tsop4lz26vusr6o4@gondor.apana.org.au> <87pnomtwgh.fsf@concordia.ellerman.id.au> <877eat0wi0.fsf@dja-thinkpad.axtens.net> <20190515035336.y42wzhs3wzqdpwzn@gondor.apana.org.au> <874l5w1axv.fsf@dja-thinkpad.axtens.net> <871s0z171b.fsf@dja-thinkpad.axtens.net> <20190516025603.GB23200@sol.localdomain>
Date:   Thu, 16 May 2019 15:28:48 +1000
Message-ID: <87y337ynlb.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> On Thu, May 16, 2019 at 12:12:48PM +1000, Daniel Axtens wrote:
>> 
>> I'm also seeing issues with ghash with the extended tests:
>> 
>> [    7.582926] alg: hash: p8_ghash test failed (wrong result) on test vector 0, cfg="random: use_final src_divs=[<reimport>9.72%@+39832, <reimport>18.2%@+65504, <reimport,nosimd>45.57%@alignmask+18, <reimport,nosimd>15.6%@+65496, 6.83%@+65514, <reimport,nosimd>1.2%@+25, <reim"
>> 
>> It seems to happen when one of the source divisions has nosimd and the
>> final result uses the simd finaliser, so that's interesting.
>> 
>
> The bug is that p8_ghash uses different shash_descs for the SIMD and no-SIMD
> cases.  So if you start out doing the hash in SIMD context but then switch to
> no-SIMD context or vice versa, the digest will be wrong.  Note that there can be
> an ->export() and ->import() in between, so it's not quite as obscure a case as
> one might think.

Ah cool, I was just in the process of figuring this out for myself -
always lovely to have my theory confirmed!

> To fix it I think you'll need to make p8_ghash use 'struct ghash_desc_ctx' just
> like ghash-generic so that the two code paths can share the same shash_desc.
> That's similar to what the various SHA hash algorithms do.

This is very helpful, thank you. I guess I will do that then.

Regards,
Daniel

>
> - Eric
