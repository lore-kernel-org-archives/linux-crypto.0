Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3875C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 06:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBPGA1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 01:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBPGA1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 01:00:27 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF07305F4
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 22:00:25 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSXJc-00Brg6-QI; Thu, 16 Feb 2023 14:00:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Feb 2023 14:00:20 +0800
Date:   Thu, 16 Feb 2023 14:00:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/10] crypto: aead - Count error stats differently
Message-ID: <Y+3GdBy7H5/sELON@gondor.apana.org.au>
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
 <E1pSE2H-00BVkZ-8X@formenos.hmeau.com>
 <Y+3C6f/W4fHtVgnM@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+3C6f/W4fHtVgnM@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 15, 2023 at 09:45:13PM -0800, Eric Biggers wrote:
>
> This could be just:
> 
> static int __maybe_unused
> crypto_aead_report_stat(struct sk_buff *skb, struct crypto_alg *alg)

Good point.  I'll convert them over.

> But actually it might be better to keep #ifdef-ing this whole function out when
> !CONFIG_CRYPTO_STATS, since in that case it contains an unconditional null
> pointer dereference.  Yes, it's not executed, but it might be confusing.

But then I'd need to compile this twice for testing so I'd rather
keep it this way.

> > +	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
> > +		memset(istat, 0, sizeof(*istat));
> > +
> 
> Above is another place that can just do 'if (istat)'.

As I mentioned before, this would create an unnecessary branch
when STATS are enabled (which would presumably be the common case).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
