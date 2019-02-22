Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC41C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 11:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E379D2070B
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 11:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfBVL7I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:59:08 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:54816 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfBVL7I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 06:59:08 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gx9Tl-0000Z8-EJ; Fri, 22 Feb 2019 19:58:57 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gx9Tj-0007Bl-8w; Fri, 22 Feb 2019 19:58:55 +0800
Date:   Fri, 22 Feb 2019 19:58:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] crypto: ccree - fix missing break in switch statement
Message-ID: <20190222115855.bbiblrup5mnmjxct@gondor.apana.org.au>
References: <20190211183131.GA19193@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211183131.GA19193@embeddedor>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 11, 2019 at 12:31:31PM -0600, Gustavo A. R. Silva wrote:
> Add missing break statement in order to prevent the code from falling
> through to case S_DIN_to_DES.
> 
> This bug was found thanks to the ongoing efforts to enable
> -Wimplicit-fallthrough.
> 
> Fixes: 63ee04c8b491 ("crypto: ccree - add skcipher support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/crypto/ccree/cc_cipher.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
