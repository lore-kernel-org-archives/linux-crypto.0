Return-Path: <SRS0=KAtS=VF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9084DC48BE7
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jul 2019 06:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7023720665
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jul 2019 06:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbfGHG1Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jul 2019 02:27:25 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:40642 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728474AbfGHG1Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jul 2019 02:27:25 -0400
X-IronPort-AV: E=Sophos;i="5.63,465,1557180000"; 
   d="scan'208";a="390824413"
Received: from abo-12-105-68.mrs.modulonet.fr (HELO hadrien) ([85.68.105.12])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 08:27:22 +0200
Date:   Mon, 8 Jul 2019 08:27:22 +0200 (CEST)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To:     Wen Yang <wen.yang99@zte.com.cn>
cc:     linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, cheng.shengyu@zte.com.cn,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: crypto4xx: fix a potential double free in
 ppc4xx_trng_probe
In-Reply-To: <1562566745-7447-2-git-send-email-wen.yang99@zte.com.cn>
Message-ID: <alpine.DEB.2.21.1907080827080.2585@hadrien>
References: <1562566745-7447-1-git-send-email-wen.yang99@zte.com.cn> <1562566745-7447-2-git-send-email-wen.yang99@zte.com.cn>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Mon, 8 Jul 2019, Wen Yang wrote:

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

Acked-by: Julia Lawall <julia.lawall@lip6.fr>


> ---
>  drivers/crypto/amcc/crypto4xx_trng.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/crypto/amcc/crypto4xx_trng.c b/drivers/crypto/amcc/crypto4xx_trng.c
> index 02a6bed3..f10a87e 100644
> --- a/drivers/crypto/amcc/crypto4xx_trng.c
> +++ b/drivers/crypto/amcc/crypto4xx_trng.c
> @@ -108,7 +108,6 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
>  	return;
>
>  err_out:
> -	of_node_put(trng);
>  	iounmap(dev->trng_base);
>  	kfree(rng);
>  	dev->trng_base = NULL;
> --
> 2.9.5
>
>
