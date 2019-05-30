Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECA3C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 02:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC835218D1
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 02:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfE3CeL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 May 2019 22:34:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59044 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbfE3CeL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 May 2019 22:34:11 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hWAtH-0000Lt-Ia; Thu, 30 May 2019 10:34:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hWAtB-00059j-7J; Thu, 30 May 2019 10:33:57 +0800
Date:   Thu, 30 May 2019 10:33:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Richard Weinberger <richard@nod.at>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        festevam@gmail.com, kernel@pengutronix.de, s.hauer@pengutronix.de,
        shawnguo@kernel.org, davem@davemloft.net, david@sigma-star.at
Subject: Re: [RFC PATCH 1/2] crypto: Allow working with key references
Message-ID: <20190530023357.2mrjtslnka4i6dbl@gondor.apana.org.au>
References: <20190529224844.25203-1-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529224844.25203-1-richard@nod.at>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 30, 2019 at 12:48:43AM +0200, Richard Weinberger wrote:
> Some crypto accelerators allow working with secure or hidden keys.
> This keys are not exposed to Linux nor main memory. To use them
> for a crypto operation they are referenced with a device specific id.
> 
> This patch adds a new flag, CRYPTO_TFM_REQ_REF_KEY.
> If this flag is set, crypto drivers should tread the key as
> specified via setkey as reference and not as regular key.
> Since we reuse the key data structure such a reference is limited
> by the key size of the chiper and is chip specific.
> 
> TODO: If the cipher implementation or the driver does not
> support reference keys, we need a way to detect this an fail
> upon setkey.
> How should the driver indicate that it supports this feature?
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

We already have existing drivers doing this.  Please have a look
at how they're doing it and use the same paradigm.  You can grep
for paes under drivers/crypto.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
