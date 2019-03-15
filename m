Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EC4C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 05:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EECF218A1
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 05:23:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="SjD4/V2h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfCOFXH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 01:23:07 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37111 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfCOFXH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 01:23:07 -0400
Received: by mail-pf1-f195.google.com with SMTP id 8so2060790pfr.4
        for <linux-crypto@vger.kernel.org>; Thu, 14 Mar 2019 22:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=qMdwfvZITrowvpwdZKU/+XKGW/QRW91nSYH9YGEXUSA=;
        b=SjD4/V2has6vbuD3Jv2vY9unoSW+Ndx9LSg/P2JQ125jdC0qMqhiF6pZZg5rKUt+fW
         rOa6+M47H1CA3NmSUD0CRyY3sOFo1c71rFVpFawHwNNDIfZmRyNuwilNxRuCbC4wq6b4
         5NcNoIEaXS39cegwDjPOhoIU+oq4eWZ9tIoOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qMdwfvZITrowvpwdZKU/+XKGW/QRW91nSYH9YGEXUSA=;
        b=DDtlXLDvdcGnxqouk73dh/TZj6V85cm57q1j7dlhI8V1EyqD9szt+qt8DEmq3dw9pD
         r6BjTd2L8bs/e5aluOO3zb3wabclTi/aPtYld8FV0GHvst2HMyBYHJeax8BJyp+lx9bl
         95YIdlZkGFT0GPylI0bKJ3CzENS62lthXQkf5lcvnnXDwadg1hyGcw3fVdgYsaWz2AHm
         D38frfo2yEfLskuNo4tOUHoPxSYzPMrd0mDpyOvLBEvChMBm95uRqm7Yz2nb1uw2E6+y
         PsHW9c0saOvx0JAL1uGzCb31rx4ym1ZCgXjg29pmi9ONW8s9IHlKHk2Is2XMM6hYCYJ2
         ID0g==
X-Gm-Message-State: APjAAAVYBzBFpxZvjblXAxvWPTIJtaVgmh48h6E6G+x56WzzKAwD/RiO
        Td+1byrLiDnsBpiWycxRHK3wYA==
X-Google-Smtp-Source: APXvYqweGIS4KtAzEejVFS0vNqdG/bIMkHtK/QkNeLPWDbeK/jLdbk4yfJpYVEUz7MF+IKxzS2FPiA==
X-Received: by 2002:a17:902:801:: with SMTP id 1mr2121725plk.299.1552627386748;
        Thu, 14 Mar 2019 22:23:06 -0700 (PDT)
Received: from localhost (124-171-209-25.dyn.iinet.net.au. [124.171.209.25])
        by smtp.gmail.com with ESMTPSA id d11sm1403181pfh.29.2019.03.14.22.23.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 22:23:05 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     omosnacek@gmail.com, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
In-Reply-To: <20190315043433.GC1671@sol.localdomain>
References: <20190315020901.16509-1-dja@axtens.net> <20190315022414.GA1671@sol.localdomain> <875zsku5mk.fsf@dja-thinkpad.axtens.net> <20190315043433.GC1671@sol.localdomain>
Date:   Fri, 15 Mar 2019 16:23:02 +1100
Message-ID: <8736nou2x5.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> Hi Daniel,
>
> On Fri, Mar 15, 2019 at 03:24:35PM +1100, Daniel Axtens wrote:
>> Hi Eric,
>> 
>> >> The original assembly imported from OpenSSL has two copy-paste
>> >> errors in handling CTR mode. When dealing with a 2 or 3 block tail,
>> >> the code branches to the CBC decryption exit path, rather than to
>> >> the CTR exit path.
>> >
>> > So does this need to be fixed in OpenSSL too?
>> 
>> Yes, I'm getting in touch with some people internally (at IBM) about
>> doing that.
>> 
>> >> This leads to corruption of the IV, which leads to subsequent blocks
>> >> being corrupted.
>> >> 
>> >> This can be detected with libkcapi test suite, which is available at
>> >> https://github.com/smuellerDD/libkcapi
>> >> 
>> >
>> > Is this also detected by the kernel's crypto self-tests, and if not why not?
>> > What about with the new option CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?
>> 
>> It seems the self-tests do not catch it. To catch it, there has to be a
>> test where the blkcipher_walk creates a walk.nbytes such that
>> [(the number of AES blocks) mod 8] is either 2 or 3. This happens with
>> AF_ALG pretty frequently, but when I booted with self-tests it only hit
>> 1, 4, 5, 6 and 7 - it missed 0, 2 and 3.
>> 
>> I don't have the EXTRA_TESTS option - I'm testing with 5.0-rc6. Is it in
>> -next?
>> 
>> Regards,
>> Daniel
>
> The improvements I recently made to the self-tests are intended to catch exactly
> this sort of bug.  They were just merged for v5.1, so try the latest mainline.
> This almost certainly would be caught by EXTRA_TESTS (and if not I'd want to
> know), but it may be caught by the regular self-tests now too.

Well, even the patched code fails with the new self-tests, so clearly
they're catching something! I'll investigate in more detail next week.

Regards,
Daniel

>
> - Eric
