Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF6CC2BB41
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 07:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiHPHHg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 03:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiHPHHT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 03:07:19 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09799FAB9
        for <linux-crypto@vger.kernel.org>; Mon, 15 Aug 2022 19:43:19 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oNmXn-00BSZV-BK; Tue, 16 Aug 2022 12:43:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Aug 2022 10:43:03 +0800
Date:   Tue, 16 Aug 2022 10:43:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Robert Elliott <elliott@hpe.com>, tim.c.chen@linux.intel.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        toshi.kani@hpe.com, rwright@hpe.com,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: testmgr - don't generate WARN for missing modules
Message-ID: <YvsEN+6k4lTvXY7I@gondor.apana.org.au>
References: <20220813231443.2706-1-elliott@hpe.com>
 <Yvq65Xd6GjeLdmO5@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yvq65Xd6GjeLdmO5@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 15, 2022 at 02:30:13PM -0700, Eric Biggers wrote:
>
> Note that this is only a problem because tcrypt calls alg_test() directly.  The
> normal way that alg_test() gets called is for the registration-time self-test.
> It's not clear to me why tcrypt calls alg_test() directly; the registration-time
> test should be enough.  Herbert, do you know?

The tcrypt code predates testmgr.  So at the beginning we only had
the enumerative testing.  Registration-time testing was added later.

We could remove the enumerative testing, but I think the FIPS people
have grown rather attached to it because it ticks some sort of a box
at boot-time.

Stephane, would it be a problem for FIPS if we simply got rid of the
enumerative testing in tcrypt and instead relied on registration-time
testing?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
