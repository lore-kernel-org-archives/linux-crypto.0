Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A57C3A5A7
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Dec 2022 09:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbiLFJHN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Dec 2022 04:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiLFJHN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Dec 2022 04:07:13 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C57D2BFD
        for <linux-crypto@vger.kernel.org>; Tue,  6 Dec 2022 01:07:11 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p2Tuu-004P1A-Qt; Tue, 06 Dec 2022 17:07:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Dec 2022 17:07:08 +0800
Date:   Tue, 6 Dec 2022 17:07:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Markus Stockhausen <markus.stockhausen@gmx.de>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] crypto/realtek: add new driver
Message-ID: <Y48GPMnLd12AKj0B@gondor.apana.org.au>
References: <20221013184026.63826-1-markus.stockhausen@gmx.de>
 <fe7800282ff11f7822778eb9109864f1f3b144f2.camel@gmx.de>
 <Y47AycWFkn48EvL5@gondor.apana.org.au>
 <c5fcd63053fb117582fc8788e276fa5d6ffd3e78.camel@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5fcd63053fb117582fc8788e276fa5d6ffd3e78.camel@gmx.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 06, 2022 at 09:59:49AM +0100, Markus Stockhausen wrote:
>
> 	const struct rtcr_ahash_req *hexp = in;
> 
> 	hreq->state = hexp->state; << *** maybe unaligned? ***

Try

	const struct rctr_ahash_req __packed *hexp = in;

This should tell the compiler to use unaligned accessors.

> Comparing this to safeexcel_ahash_import() where I got my ideas from
> one sees a similar coding:
> 
> 	...
> 	const struct safexcel_ahash_export_state *export = in;

This is equally broken unless that driver can only be used on
platforms where unaligned access is legal (such as x86).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
