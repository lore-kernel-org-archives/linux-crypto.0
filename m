Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9493EC433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 11:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69D9E610EA
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 11:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhENLgV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 07:36:21 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37216 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhENLgU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 07:36:20 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.89 #2 (Debian))
        id 1lhW5v-0002uv-Fe; Fri, 14 May 2021 19:35:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lhW5s-0002Xc-R3; Fri, 14 May 2021 19:35:00 +0800
Date:   Fri, 14 May 2021 19:35:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     gcherian@marvell.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: cavium - Use 'hlist_for_each_entry' to simplify
 code
Message-ID: <20210514113500.kafadgv7oyo7hh5v@gondor.apana.org.au>
References: <5a7692aa1d2ffb81e981fdf87b060db7e55956b8.1619593010.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a7692aa1d2ffb81e981fdf87b060db7e55956b8.1619593010.git.christophe.jaillet@wanadoo.fr>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 28, 2021 at 09:33:37AM +0200, Christophe JAILLET wrote:
> Use 'hlist_for_each_entry' instead of hand writing it.
> This saves a few lines of code.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested only
> ---
>  drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
