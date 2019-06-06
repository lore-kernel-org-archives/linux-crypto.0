Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CFDC04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 330BE20673
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfFFGv2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 02:51:28 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38730 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFGv2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 02:51:28 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYmFD-0006tP-3b; Thu, 06 Jun 2019 14:51:27 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYmFA-0006hF-A1; Thu, 06 Jun 2019 14:51:24 +0800
Date:   Thu, 6 Jun 2019 14:51:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, Reto Buerki <reet@codelabs.ch>
Subject: Re: [PATCH] crypto: Jitter RNG - update implementation to 2.1.2
Message-ID: <20190606065124.xpyshz3al7wwivrp@gondor.apana.org.au>
References: <6808423.xveKLjRae5@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6808423.xveKLjRae5@positron.chronox.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 29, 2019 at 09:24:25PM +0200, Stephan Müller wrote:
> The Jitter RNG implementation is updated to comply with upstream version
> 2.1.2. The change covers the following aspects:
> 
> * Time variation measurement is conducted over the LFSR operation
> instead of the XOR folding
> 
> * Invcation of stuck test during initialization
> 
> * Removal of the stirring functionality and the Von-Neumann
> unbiaser as the LFSR using a primitive and irreducible polynomial
> generates an identical distribution of random bits
> 
> This implementation was successfully used in FIPS 140-2 validations
> as well as in German BSI evaluations.
> 
> This kernel implementation was tested as follows:
> 
> * The unchanged kernel code file jitterentropy.c is compiled as part
> of user space application to generate raw unconditioned noise
> data. That data is processed with the NIST SP800-90B non-IID test
> tool to verify that the kernel code exhibits an equal amount of noise
> as the upstream Jitter RNG version 2.1.2.
> 
> * Using AF_ALG with the libkcapi tool of kcapi-rng the Jitter RNG was
> output tested with dieharder to verify that the output does not
> exhibit statistical weaknesses. The following command was used:
> kcapi-rng -n "jitterentropy_rng" -b 100000000000 | dieharder -a -g 200
> 
> * The unchanged kernel code file jitterentropy.c is compiled as part
> of user space application to test the LFSR implementation. The
> LFSR is injected a monotonically increasing counter as input and
> the output is fed into dieharder to verify that the LFSR operation
> does not exhibit statistical weaknesses.
> 
> * The patch was tested on the Muen separation kernel which returns
> a more coarse time stamp to verify that the Jitter RNG does not cause
> regressions with its initialization test considering that the Jitter
> RNG depends on a high-resolution timer.
> 
> Tested-by: Reto Buerki <reet@codelabs.ch>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/jitterentropy-kcapi.c |   5 -
>  crypto/jitterentropy.c       | 305 ++++++++++-------------------------
>  2 files changed, 82 insertions(+), 228 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
