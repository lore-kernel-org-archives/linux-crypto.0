Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B63AC28D13
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Aug 2022 23:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242642AbiHSXPh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 19:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243949AbiHSXPW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 19:15:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1477D10AE35
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2022 16:15:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B799BB82997
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2022 23:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E56C433D6;
        Fri, 19 Aug 2022 23:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660950918;
        bh=IkSOh28b9wS33qLhqH/n00vhPuyBOQF3iWAhqvekhmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t++30a5mn2utUYmOP1BVEDZvtzviKFLWcAubCP0E+ifsnFYy9H1cdNVo8B085ZK57
         6EerfUSSGvlJSF+InvuVQunrymU3MXdMlyJcZwJT8gz5xfrHz8YbKrMX/pAQruMr3n
         Kzpy8pg81eH1JgU84qHKqlGL0qpCJRwySM+ZbqNqQgQqOu+0ahQCzIPYuPSrQ1pSyJ
         OVqBmdvqVaJ9FopAp/BGF41N12LSe1GE7Ym0F9ob4M//ALXXZ3NtoMm9MZE/qGKW49
         2Mq0g/frapt6f7JyiseKh/JiSAZISEUbwOruENVyABYAhUnICjKKh2Dovh+Xs2mgnD
         rGPo6r3LifixA==
Date:   Fri, 19 Aug 2022 16:15:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Robert Elliott <elliott@hpe.com>, tim.c.chen@linux.intel.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        toshi.kani@hpe.com, rwright@hpe.com
Subject: Re: [PATCH] crypto: testmgr - don't generate WARN for missing modules
Message-ID: <YwAZhFLCrlHXegr9@sol.localdomain>
References: <20220813231443.2706-1-elliott@hpe.com>
 <Yv9uhQY7UAPN7QDE@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv9uhQY7UAPN7QDE@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 19, 2022 at 07:05:41PM +0800, Herbert Xu wrote:
> Robert Elliott <elliott@hpe.com> wrote:
> > This userspace command:
> >    modprobe tcrypt
> > or
> >    modprobe tcrypt mode=0
> > 
> > runs all the tcrypt test cases numbered <200 (i.e., all the
> > test cases calling tcrypt_test() and returning return values).
> > 
> > Tests are sparsely numbered from 0 to 1000. For example:
> >    modprobe tcrypt mode=12
> > tests sha512, and
> >    modprobe tcrypt mode=152
> > tests rfc4543(gcm(aes))) - AES-GCM as GMAC
> > 
> > The test manager generates WARNING crashdumps every time it attempts
> > a test using an algorithm that is not available (not built-in to the
> > kernel or available as a module):
> > 
> >    alg: skcipher: failed to allocate transform for ecb(arc4): -2
> >    ------------[ cut here ]-----------
> >    alg: self-tests for ecb(arc4) (ecb(arc4)) failed (rc=-2)
> >    WARNING: CPU: 9 PID: 4618 at crypto/testmgr.c:5777
> > alg_test+0x30b/0x510
> >    [50 more lines....]
> > 
> >    ---[ end trace 0000000000000000 ]---
> > 
> > If the kernel is compiled with CRYPTO_USER_API_ENABLE_OBSOLETE
> > disabled (the default), then these algorithms are not compiled into
> > the kernel or made into modules and trigger WARNINGs:
> >    arc4 tea xtea khazad anubis xeta seed
> > 
> > Additionally, any other algorithms that are not enabled in .config
> > will generate WARNINGs. In RHEL 9.0, for example, the default
> > selection of algorithms leads to 16 WARNING dumps.
> > 
> > One attempt to fix this was by modifying tcrypt_test() to check
> > crypto_has_alg() and immediately return 0 if crypto_has_alg() fails,
> > rather than proceed and return a non-zero error value that causes
> > the caller (alg_test() in crypto/testmgr.c) to invoke WARN().
> > That knocks out too many algorithms, though; some combinations
> > like ctr(des3_ede) would work.
> > 
> > Instead, change the condition on the WARN to ignore a return
> > value is ENOENT, which is the value returned when the algorithm
> > or combination of algorithms doesn't exist. Add a pr_warn to
> > communicate that information in case the WARN is skipped.
> > 
> > This approach allows algorithm tests to work that are combinations,
> > not provided by one driver, like ctr(blowfish).
> > 
> > Result - no more WARNINGs:
> > modprobe tcrypt
> > [  115.541765] tcrypt: testing md5
> > [  115.556415] tcrypt: testing sha1
> > [  115.570463] tcrypt: testing ecb(des)
> > [  115.585303] cryptomgr: alg: skcipher: failed to allocate transform for ecb(des): -2
> > [  115.593037] cryptomgr: alg: self-tests for ecb(des) using ecb(des) failed (rc=-2)
> > [  115.593038] tcrypt: testing cbc(des)
> > [  115.610641] cryptomgr: alg: skcipher: failed to allocate transform for cbc(des): -2
> > [  115.618359] cryptomgr: alg: self-tests for cbc(des) using cbc(des) failed (rc=-2)
> > ...
> > 
> > Signed-off-by: Robert Elliott <elliott@hpe.com>
> > ---
> > crypto/testmgr.c | 7 +++++--
> > 1 file changed, 5 insertions(+), 2 deletions(-)
> 
> Patch applied.  Thanks.

I thought the conclusion from the discussion was that this should instead be
solved by a tcrypt change?  Either dropping the enumerative testing support from
tcrypt, or making tcrypt just try to allocate the algorithms (relying on the
registration-time self-tests) rather than call alg_test() directly.

- Eric
