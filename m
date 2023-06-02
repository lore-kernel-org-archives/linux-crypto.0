Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4274DC7EE29
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jun 2023 10:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbjFBK0q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 06:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbjFBK0T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 06:26:19 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC90510EC;
        Fri,  2 Jun 2023 03:24:44 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q51xP-00G316-Qw; Fri, 02 Jun 2023 18:24:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Jun 2023 18:24:31 +0800
Date:   Fri, 2 Jun 2023 18:24:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Bharat Bhushan <bbhushan2@marvell.com>
Cc:     olivia@selenic.com, Jason@zx2c4.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com
Subject: Re: [PATCH v2] hwrng: cn10k: Add extended trng register support
Message-ID: <ZHnDX5h4kByVYPBu@gondor.apana.org.au>
References: <20230525034200.22298-1-bbhushan2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525034200.22298-1-bbhushan2@marvell.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 25, 2023 at 09:12:00AM +0530, Bharat Bhushan wrote:
> The way random data is read from hardware has changed from
> Octeon CN10KA-B0 and later SoCs onwards. A new set of registers
> have been added to read random data and to verify whether the
> read data is valid or not. This patch extends and uses
> RNM_PF_TRNG_DAT and RNM_PF_TRNG_STS CSRs to read random number
> and status for the applicable silicon variants.
> 
> Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
> ---
> v2:
>  - Change return type of cn10k_read_trng() to bool
> 
>  drivers/char/hw_random/cn10k-rng.c | 63 ++++++++++++++++++++++++++++--
>  1 file changed, 59 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
