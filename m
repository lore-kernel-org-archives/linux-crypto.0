Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432CBC10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 14:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D7582077C
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 14:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="fInuLOzo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfDKOr3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 10:47:29 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:45529 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfDKOr3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 10:47:29 -0400
Received: by mail-pf1-f174.google.com with SMTP id e24so3548750pfi.12
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 07:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=zp6Q/Y68BYTeE7T9SUFNkX3FL9mBezuutY6a0rQMjqw=;
        b=fInuLOzoiqDBCH4uFPPOO+Tazakc+UjFBe8d2l61/3ZaV2IwtXR2KlcQJEDSYxqU82
         9EU4tfx3XjSFP+d0R8Bn/nH3Xk3wYn1d0cAuZLeNORqUyqCT+j8nDVLxjGOjFgf85rDT
         0go2tyaDzA2258lpwGPSCQDgY8fxA2rIoKHzQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zp6Q/Y68BYTeE7T9SUFNkX3FL9mBezuutY6a0rQMjqw=;
        b=gjdvWCTsYz1R68Mly1QV9pmjTO9TZfeeoBociR3V30PxoK02NIseffLZfrIw1G2/sQ
         7VC0LbIJOR2d3oj94gJhTFj//Ur8tAKqoxU3GNsCUUccnxd42r0BWXz5npa/IICvUIzW
         5eLo412hKfghieCG+KVpmtJSDWaOR+pkWTzhp3pi3YUdbxZ+igxhfAqw7ET1v8jSgeiP
         2cvoIEFj7DhHm0M4JPGI/E2KNduKuq3BBWEUKP/fxGtOF3QJPAp1S0FQ45sEUgPfjfKK
         LBwVqao9gjLivrK0ONsBkuUXBKf7hhnSP8LRQLZXI0PXRGiaHuvTKYC4nF5SSaXV6G+s
         mpLA==
X-Gm-Message-State: APjAAAWCUKLBBjJH4/MkLKu+A+BzRvODJA0SVIRba6PcK+1GVPd9XPQy
        LPGU5hokKJ1vsrFq0+j/twyxig==
X-Google-Smtp-Source: APXvYqwEJqahLrU1YyR56rULJ8BC07JHMa9D8Y/hEj3sxNiOJwh/6ikQST/MpwiqMNjSa+w2Ep5Znw==
X-Received: by 2002:a63:8143:: with SMTP id t64mr46518636pgd.301.1554994048994;
        Thu, 11 Apr 2019 07:47:28 -0700 (PDT)
Received: from localhost (124-171-136-51.dyn.iinet.net.au. [124.171.136.51])
        by smtp.gmail.com with ESMTPSA id e21sm53062402pfd.177.2019.04.11.07.47.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Apr 2019 07:47:26 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     omosnacek@gmail.com, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
In-Reply-To: <20190410070234.GA12406@sol.localdomain>
References: <20190315020901.16509-1-dja@axtens.net> <20190315022414.GA1671@sol.localdomain> <875zsku5mk.fsf@dja-thinkpad.axtens.net> <20190315043433.GC1671@sol.localdomain> <8736nou2x5.fsf@dja-thinkpad.axtens.net> <20190410070234.GA12406@sol.localdomain>
Date:   Fri, 12 Apr 2019 00:47:22 +1000
Message-ID: <87imvkwqdh.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> Hi Daniel,
>
> On Fri, Mar 15, 2019 at 04:23:02PM +1100, Daniel Axtens wrote:
>> Eric Biggers <ebiggers@kernel.org> writes:
>> 
>> > Hi Daniel,
>> >
>> > On Fri, Mar 15, 2019 at 03:24:35PM +1100, Daniel Axtens wrote:
>> >> Hi Eric,
>> >> 
>> >> >> The original assembly imported from OpenSSL has two copy-paste
>> >> >> errors in handling CTR mode. When dealing with a 2 or 3 block tail,
>> >> >> the code branches to the CBC decryption exit path, rather than to
>> >> >> the CTR exit path.
>> >> >
>> >> > So does this need to be fixed in OpenSSL too?
>> >> 
>> >> Yes, I'm getting in touch with some people internally (at IBM) about
>> >> doing that.
>> >> 
>> >> >> This leads to corruption of the IV, which leads to subsequent blocks
>> >> >> being corrupted.
>> >> >> 
>> >> >> This can be detected with libkcapi test suite, which is available at
>> >> >> https://github.com/smuellerDD/libkcapi
>> >> >> 
>> >> >
>> >> > Is this also detected by the kernel's crypto self-tests, and if not why not?
>> >> > What about with the new option CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?
>> >> 
>> >> It seems the self-tests do not catch it. To catch it, there has to be a
>> >> test where the blkcipher_walk creates a walk.nbytes such that
>> >> [(the number of AES blocks) mod 8] is either 2 or 3. This happens with
>> >> AF_ALG pretty frequently, but when I booted with self-tests it only hit
>> >> 1, 4, 5, 6 and 7 - it missed 0, 2 and 3.
>> >> 
>> >> I don't have the EXTRA_TESTS option - I'm testing with 5.0-rc6. Is it in
>> >> -next?
>> >> 
>> >> Regards,
>> >> Daniel
>> >
>> > The improvements I recently made to the self-tests are intended to catch exactly
>> > this sort of bug.  They were just merged for v5.1, so try the latest mainline.
>> > This almost certainly would be caught by EXTRA_TESTS (and if not I'd want to
>> > know), but it may be caught by the regular self-tests now too.
>> 
>> Well, even the patched code fails with the new self-tests, so clearly
>> they're catching something! I'll investigate in more detail next week.
>> 
>> Regards,
>> Daniel
>> 
>> >
>> > - Eric

Hi Eric,

>
> Are you still planning to fix the remaining bug?  I booted a ppc64le VM, and I
> see the same test failure (I think) you were referring to:
>
> alg: skcipher: p8_aes_ctr encryption test failed (wrong result) on test vector 3, cfg="uneven misaligned splits, may sleep"
>

Yes, that's the one I saw. I don't have time to follow it up at the
moment, but Nayna is aware of it.

Regards,
Daniel

> - Eric
