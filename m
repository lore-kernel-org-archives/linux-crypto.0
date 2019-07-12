Return-Path: <SRS0=HUI/=VJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48453C742B2
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 10:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AFC82084B
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 10:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfGLKSM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jul 2019 06:18:12 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:44154 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbfGLKSM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jul 2019 06:18:12 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hlsck-0005dS-D9; Fri, 12 Jul 2019 18:17:54 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hlscb-0008KQ-6Y; Fri, 12 Jul 2019 18:17:45 +0800
Date:   Fri, 12 Jul 2019 18:17:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Wen Yang <wen.yang99@zte.com.cn>
Cc:     linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, cheng.shengyu@zte.com.cn,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: crypto4xx: fix a potential double free in
 ppc4xx_trng_probe
Message-ID: <20190712101745.3owecyrrpltsozmy@gondor.apana.org.au>
References: <1562566745-7447-1-git-send-email-wen.yang99@zte.com.cn>
 <1562566745-7447-2-git-send-email-wen.yang99@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562566745-7447-2-git-send-email-wen.yang99@zte.com.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 08, 2019 at 02:19:03PM +0800, Wen Yang wrote:
> There is a possible double free issue in ppc4xx_trng_probe():
> 
> 85:	dev->trng_base = of_iomap(trng, 0);
> 86:	of_node_put(trng);          ---> released here
> 87:	if (!dev->trng_base)
> 88:		goto err_out;
> ...
> 110:	ierr_out:
> 111:		of_node_put(trng);  ---> double released here
> ...
> 
> This issue was detected by using the Coccinelle software.
> We fix it by removing the unnecessary of_node_put().
> 
> Fixes: 5343e674f32 ("crypto4xx: integrate ppc4xx-rng into crypto4xx")
> Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Allison Randal <allison@lohutok.net>
> Cc: Armijn Hemel <armijn@tjaldur.nl>
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/amcc/crypto4xx_trng.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
