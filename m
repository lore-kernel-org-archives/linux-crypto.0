Return-Path: <SRS0=4IwG=SP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02C4C10F0E
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Apr 2019 02:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D5B5218AF
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Apr 2019 02:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555123238;
	bh=luZ0Q8sXIj5TXHakVIwFFiySc+AY/UgOPPRKqs/nEq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=g/x257XORy2ZrtiO5GOuiJFRZHYFn8fLTb7M9lkIBeqxK6yuwtJX20mRQyJLwrGI5
	 KK1UuAGDI7FZCMtVMENkeCG8NxZp/FIfafE6wxsTXo4eTPZSAYakIj6BnFIbkIDc3e
	 Jm3YcOQ/2nAKlXBKMNk2N1PGvJDl//oKI+SVhsFw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfDMCkh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 22:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbfDMCkg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 22:40:36 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43A5620869;
        Sat, 13 Apr 2019 02:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555123235;
        bh=luZ0Q8sXIj5TXHakVIwFFiySc+AY/UgOPPRKqs/nEq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YevITFvy/9FEpzaqcR/qqgbvAZ7igaCNKWsVI5kmlDRPO4GzWm26eSAN1Qd+USLv7
         C62b/f2rLRWRtwlGRkMChxwQMkPWdcxEKrG6XRBMixqa3jeVr0JY4Uz/JyNDhHhHEe
         FuO2eRNtv//lbWtwDSZkfvxaPJMXm4Rq7EDRRfLI=
Date:   Fri, 12 Apr 2019 19:40:33 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/7] crypto: fuzz algorithms against their generic
 implementation
Message-ID: <20190413024032.GA5859@sol.localdomain>
References: <20190412045742.1725-1-ebiggers@kernel.org>
 <CAKv+Gu_CyA1NnkMFN9zJ4kJ5ACo5FD_ZvBAqcWu07WiWD0A93g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_CyA1NnkMFN9zJ4kJ5ACo5FD_ZvBAqcWu07WiWD0A93g@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 12, 2019 at 02:04:20PM -0700, Ard Biesheuvel wrote:
> On Thu, 11 Apr 2019 at 22:00, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Hello,
> >
> > In the crypto API, all implementations of each algorithm are supposed to
> > produce the same results.  However, testing of this is currently limited
> > to the list of test vectors hardcoded for each algorithm.  Although
> > after recent improvements the self-tests do much more with each test
> > vector, hardcoded test vectors can never cover all cases.
> >
> > This series improves the situation by making the self-tests
> > automatically generate random test vectors using the corresponding
> > generic implementation, then run them against the algorithm under test.
> > This detects bugs where the implementations don't match.
> >
> > This has already found many bugs and inconsistencies, including an
> > integer overflow bug in the x86_64 implementation of Poly1305.
> >
> > These new fuzz tests are behind CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.
> >
> > Patch 1-6 are the testmgr changes themselves.  Patch 7 makes the generic
> > implementations be registered earlier so that they're available when
> > optimized implementations are being tested, when both are built-in.
> > Note that even after this, for many algorithms it's still possible to
> > make the generic implementation unset or modular.  Thus a missing
> > generic implementation just causes the comparison tests to be skipped
> > with a warning; they aren't failed.
> >
> > So far I've tested all generic, x86, arm, and arm64 algorithms, plus
> > some PowerPC algorithms.  I have not tested hardware drivers.  I
> > encourage people to run the tests on drivers and other architectures, as
> > they will find more bugs.
> >
> > This can also be found in git at:
> >
> >         URL: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> >         Branch: cryptofuzz-vs-generic
> >
> > Changed since v1:
> >
> >     - Make cryptomgr use arch_initcall(), so we don't rely on the order
> >       in which the object files are linked.
> >
> >     - Show the expected error code when a test fails due to the wrong
> >       error code being returned.
> >
> >     - Generate zero-length associated data more often for AEADs
> >       (about 1/4 of the time rather than about 1/256 of the time).
> >
> >     - A few other minor cleanups.
> >
> > Eric Biggers (7):
> >   crypto: testmgr - expand ability to test for errors
> >   crypto: testmgr - identify test vectors by name rather than number
> >   crypto: testmgr - add helpers for fuzzing against generic
> >     implementation
> >   crypto: testmgr - fuzz hashes against their generic implementation
> >   crypto: testmgr - fuzz skciphers against their generic implementation
> >   crypto: testmgr - fuzz AEADs against their generic implementation
> >   crypto: run initcalls for generic implementations earlier
> >
> 
> This looks alright to me, but I have to admit I did not look at every
> patch in great detail. I did put it through kernelci, though, and it
> built and booted fine on all systems.
> 
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 

Thanks Ard.  Note that the logs from the kernelci run do show new test failures
in two drivers:

	alg: skcipher: ecb-aes-s5p encryption failed on test vector \"random: len=0 klen=32\"; expected_error=0, actual_error=-22, cfg=\"random: inplace use_final src_divs=[<flush>73.70%@alignmask+4049, 11.97%@+3977, <reimport,nosimd>3.65%@+4013, <reimport>10.68%@alignmask+12] iv_offset=4\"
	alg: skcipher: cbc-aes-s5p encryption failed on test vector \"random: len=0 klen=32\"; expected_error=0, actual_error=-22, cfg=\"random: use_finup src_divs=[<reimport>100.0%@+22] dst_divs=[100.0%@+258]\"
	alg: skcipher: blocksize for ctr-aes-s5p (16) doesn't match generic impl (1)

	alg: skcipher: ecb-aes-rk encryption failed on test vector \"random: len=0 klen=32\"; expected_error=0, actual_error=-22, cfg=\"random: inplace use_digest src_divs=[100.0%@alignmask+2107] iv_offset=38\"


So, unlike the generic implementations, the s5p-sss driver doesn't allow empty
messages for AES-ECB and AES-CBC, and it sets cra_blocksize for AES-CTR to 16
bytes rather than 1.  (It's supposed to be set to 1 for all stream ciphers.)

And the Rockchip crypto driver doesn't allow empty messages for AES-ECB.

None of these appear super important, but the tests seem to be working as
intended to find them, and they'll need to be fixed.

- Eric
