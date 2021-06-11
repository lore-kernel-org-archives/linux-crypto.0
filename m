Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA62C48BD1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 07:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5766610F8
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 07:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhFKH0K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 03:26:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50562 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229540AbhFKH0J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 03:26:09 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lrbWO-0005Ol-Qc; Fri, 11 Jun 2021 15:24:04 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lrbWK-0002Nk-41; Fri, 11 Jun 2021 15:24:00 +0800
Date:   Fri, 11 Jun 2021 15:24:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        acostag.ubuntu@gmail.com, lee.jones@linaro.org,
        Jampala.Srikanth@cavium.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: cavium/nitrox - Fix an erro rhandling path in
 'nitrox_probe()'
Message-ID: <20210611072400.GH23016@gondor.apana.org.au>
References: <26f71d3925541924bfda1dca9114a48db5ffafe4.1622897629.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26f71d3925541924bfda1dca9114a48db5ffafe4.1622897629.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 05, 2021 at 02:55:56PM +0200, Christophe JAILLET wrote:
> If an error occurs after a successful 'ioremap()' call, it must be undone
> by a corresponding 'iounmap()' call, as already done in the remove
> function.
> Ass a 'pf_sw_fail' label in the error handling path and add the missing
> 'iounmap()'.
> 
> While at it, also add a 'flr_fail' label in the error handling path and use
> it to avoid some code duplication.
> 
> Fixes: 14fa93cdcd9b ("crypto: cavium - Add support for CNN55XX adapters.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_main.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
