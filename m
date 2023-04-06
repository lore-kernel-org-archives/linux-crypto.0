Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B83C7618D
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Apr 2023 08:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbjDFIuO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Apr 2023 04:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbjDFIuM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Apr 2023 04:50:12 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD7D4ED2
        for <linux-crypto@vger.kernel.org>; Thu,  6 Apr 2023 01:50:08 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pkLJi-00D1x1-FY; Thu, 06 Apr 2023 16:50:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Apr 2023 16:50:02 +0800
Date:   Thu, 6 Apr 2023 16:50:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>
Subject: Re: [PATCH v4] crypto: jitter - permanent and intermittent health
 errors
Message-ID: <ZC6HuugQ9ddW0hed@gondor.apana.org.au>
References: <12194787.O9o76ZdvQC@positron.chronox.de>
 <4478169.LvFx2qVVIh@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4478169.LvFx2qVVIh@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 27, 2023 at 09:03:52AM +0200, Stephan Müller wrote:
> According to SP800-90B, two health failures are allowed: the intermittend
> and the permanent failure. So far, only the intermittent failure was
> implemented. The permanent failure was achieved by resetting the entire
> entropy source including its health test state and waiting for two or
> more back-to-back health errors.
> 
> This approach is appropriate for RCT, but not for APT as APT has a
> non-linear cutoff value. Thus, this patch implements 2 cutoff values
> for both RCT/APT. This implies that the health state is left untouched
> when an intermittent failure occurs. The noise source is reset
> and a new APT powerup-self test is performed. Yet, whith the unchanged
> health test state, the counting of failures continues until a permanent
> failure is reached.
> 
> Any non-failing raw entropy value causes the health tests to reset.
> 
> The intermittent error has an unchanged significance level of 2^-30.
> The permanent error has a significance level of 2^-60. Considering that
> this level also indicates a false-positive rate (see SP800-90B section 4.2)
> a false-positive must only be incurred with a low probability when
> considering a fleet of Linux kernels as a whole. Hitting the permanent
> error may cause a panic(), the following calculation applies: Assuming
> that a fleet of 10^9 Linux kernels run concurrently with this patch in
> FIPS mode and on each kernel 2 health tests are performed every minute
> for one year, the chances of a false positive is about 1:1000
> based on the binomial distribution.
> 
> In addition, any power-up health test errors triggered with
> jent_entropy_init are treated as permanent errors.
> 
> A permanent failure causes the entire entropy source to permanently
> return an error. This implies that a caller can only remedy the situation
> by re-allocating a new instance of the Jitter RNG. In a subsequent
> patch, a transparent re-allocation will be provided which also changes
> the implied heuristic entropy assessment.
> 
> In addition, when the kernel is booted with fips=1, the Jitter RNG
> is defined to be part of a FIPS module. The permanent error of the
> Jitter RNG is translated as a FIPS module error. In this case, the entire
> FIPS module must cease operation. This is implemented in the kernel by
> invoking panic().
> 
> The patch also fixes an off-by-one in the RCT cutoff value which is now
> set to 30 instead of 31. This is because the counting of the values
> starts with 0.
> 
> Reviewed-by: Vladis Dronov <vdronov@redhat.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
> 
> v4:
>  - fix comment regarding fips=1
>  - update patch subject to match common naming schema
>  - remove now unused jent_panic function
>  - added Reviewed-by line
> 
> v3:
>  - remove an unused goto target
> 
> v2:
>  - Drop the enforcement of permanent disabling the entropy source
> 
>  crypto/jitterentropy-kcapi.c |  51 ++++++-------
>  crypto/jitterentropy.c       | 144 +++++++++++++----------------------
>  crypto/jitterentropy.h       |   1 -
>  3 files changed, 76 insertions(+), 120 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
