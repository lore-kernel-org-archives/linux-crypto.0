Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67BE2C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 06:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiF3GjH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 02:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiF3GjG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 02:39:06 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985D0BF7F
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2022 23:39:04 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o6npM-00CwIx-4G; Thu, 30 Jun 2022 16:39:01 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jun 2022 14:39:00 +0800
Date:   Thu, 30 Jun 2022 14:39:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        ap420073@gmail.com
Subject: Re: [PATCH 0/2] crypto: Introduce ARIA symmetric cipher algorithm
Message-ID: <Yr1FBOC8Zi1ltlBi@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620164127.6380-1-ap420073@gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Taehee Yoo <ap420073@gmail.com> wrote:
> This patchset adds a new ARIA(RFC 5794) symmetric cipher algorithm.
> 
> Like SEED, the ARIA is a standard cipher algorithm in South Korea.
> Especially Government and Banking industry have been using this algorithm.
> So the implementation of ARIA will be useful for them and network vendors.
> 
> Usecases of this algorithm are TLS[1], and IPSec.
> It would be very useful for them if it implements kTLS for ARIA.

You haven't added any glue to use this for IPsec.  Unless there is
an in-kernel user we won't add any new algorithms.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
