Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E99C7EE29
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jun 2023 10:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbjFBK1K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 06:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbjFBK0p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 06:26:45 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6FB1710
        for <linux-crypto@vger.kernel.org>; Fri,  2 Jun 2023 03:25:02 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q51xo-00G33s-N9; Fri, 02 Jun 2023 18:24:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Jun 2023 18:24:56 +0800
Date:   Fri, 2 Jun 2023 18:24:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Joachim Vandersmissen <git@jvdsn.com>,
        John Cabaj <john.cabaj@canonical.com>
Subject: Re: [PATCH] crypto: jitter - correct health test during
 initialization
Message-ID: <ZHnDeKiJcm82s6ZD@gondor.apana.org.au>
References: <12219330.O9o76ZdvQC@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12219330.O9o76ZdvQC@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 25, 2023 at 07:00:05PM +0200, Stephan Müller wrote:
> With the update of the permanent and intermittent health errors, the
> actual indicator for the health test indicates a potential error only
> for the one offending time stamp gathered in the current iteration
> round. The next iteration round will "overwrite" the health test result.
> 
> Thus, the entropy collection loop in jent_gen_entropy checks for
> the health test failure upon each loop iteration. However, the
> initialization operation checked for the APT health test once for
> an APT window which implies it would not catch most errors.
> 
> Thus, the check for all health errors is now invoked unconditionally
> during each loop iteration for the startup test.
> 
> With the change, the error JENT_ERCT becomes unused as all health
> errors are only reported with the JENT_HEALTH return code. This
> allows the removal of the error indicator.
> 
> Fixes: 3fde2fe99aa6 ("crypto: jitter - permanent and intermittent health errors"
> )
> Reported-by: Joachim Vandersmissen <git@jvdsn.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/jitterentropy.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
