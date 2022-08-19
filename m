Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2EDEC32771
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Aug 2022 11:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348674AbiHSLGa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 07:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348679AbiHSLGH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 07:06:07 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B506FBA57
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2022 04:05:50 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oOzor-00Cpp8-Sg; Fri, 19 Aug 2022 21:05:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Aug 2022 19:05:41 +0800
Date:   Fri, 19 Aug 2022 19:05:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Robert Elliott <elliott@hpe.com>
Cc:     ebiggers@google.com, tim.c.chen@linux.intel.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        toshi.kani@hpe.com, rwright@hpe.com, elliott@hpe.com
Subject: Re: [PATCH] crypto: testmgr - don't generate WARN for missing modules
Message-ID: <Yv9uhQY7UAPN7QDE@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220813231443.2706-1-elliott@hpe.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Robert Elliott <elliott@hpe.com> wrote:
> This userspace command:
>    modprobe tcrypt
> or
>    modprobe tcrypt mode=0
> 
> runs all the tcrypt test cases numbered <200 (i.e., all the
> test cases calling tcrypt_test() and returning return values).
> 
> Tests are sparsely numbered from 0 to 1000. For example:
>    modprobe tcrypt mode=12
> tests sha512, and
>    modprobe tcrypt mode=152
> tests rfc4543(gcm(aes))) - AES-GCM as GMAC
> 
> The test manager generates WARNING crashdumps every time it attempts
> a test using an algorithm that is not available (not built-in to the
> kernel or available as a module):
> 
>    alg: skcipher: failed to allocate transform for ecb(arc4): -2
>    ------------[ cut here ]-----------
>    alg: self-tests for ecb(arc4) (ecb(arc4)) failed (rc=-2)
>    WARNING: CPU: 9 PID: 4618 at crypto/testmgr.c:5777
> alg_test+0x30b/0x510
>    [50 more lines....]
> 
>    ---[ end trace 0000000000000000 ]---
> 
> If the kernel is compiled with CRYPTO_USER_API_ENABLE_OBSOLETE
> disabled (the default), then these algorithms are not compiled into
> the kernel or made into modules and trigger WARNINGs:
>    arc4 tea xtea khazad anubis xeta seed
> 
> Additionally, any other algorithms that are not enabled in .config
> will generate WARNINGs. In RHEL 9.0, for example, the default
> selection of algorithms leads to 16 WARNING dumps.
> 
> One attempt to fix this was by modifying tcrypt_test() to check
> crypto_has_alg() and immediately return 0 if crypto_has_alg() fails,
> rather than proceed and return a non-zero error value that causes
> the caller (alg_test() in crypto/testmgr.c) to invoke WARN().
> That knocks out too many algorithms, though; some combinations
> like ctr(des3_ede) would work.
> 
> Instead, change the condition on the WARN to ignore a return
> value is ENOENT, which is the value returned when the algorithm
> or combination of algorithms doesn't exist. Add a pr_warn to
> communicate that information in case the WARN is skipped.
> 
> This approach allows algorithm tests to work that are combinations,
> not provided by one driver, like ctr(blowfish).
> 
> Result - no more WARNINGs:
> modprobe tcrypt
> [  115.541765] tcrypt: testing md5
> [  115.556415] tcrypt: testing sha1
> [  115.570463] tcrypt: testing ecb(des)
> [  115.585303] cryptomgr: alg: skcipher: failed to allocate transform for ecb(des): -2
> [  115.593037] cryptomgr: alg: self-tests for ecb(des) using ecb(des) failed (rc=-2)
> [  115.593038] tcrypt: testing cbc(des)
> [  115.610641] cryptomgr: alg: skcipher: failed to allocate transform for cbc(des): -2
> [  115.618359] cryptomgr: alg: self-tests for cbc(des) using cbc(des) failed (rc=-2)
> ...
> 
> Signed-off-by: Robert Elliott <elliott@hpe.com>
> ---
> crypto/testmgr.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
