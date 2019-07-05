Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CC8C4649C
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 14:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AF2220989
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 14:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbfGEOkd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 10:40:33 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:40045 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfGEOkd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 10:40:33 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 5B39A100010;
        Fri,  5 Jul 2019 14:40:28 +0000 (UTC)
Date:   Fri, 5 Jul 2019 16:40:28 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH 1/9] crypto: inside-secure - keep ivsize for DES ECB
 modes at 0
Message-ID: <20190705144028.GH3926@kwain>
References: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562078400-969-4-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1562078400-969-4-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Tue, Jul 02, 2019 at 04:39:52PM +0200, Pascal van Leeuwen wrote:
> From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
> 
> The driver incorrectly advertised the IV size for DES and 3DES ECB
> mode as being the DES blocksize of 8. This is incorrect as ECB mode
> does not need any IV.
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index ee8a0c3..7977e4c 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -1033,7 +1033,6 @@ struct safexcel_alg_template safexcel_alg_ecb_des = {
>  		.decrypt = safexcel_ecb_des_decrypt,
>  		.min_keysize = DES_KEY_SIZE,
>  		.max_keysize = DES_KEY_SIZE,
> -		.ivsize = DES_BLOCK_SIZE,
>  		.base = {
>  			.cra_name = "ecb(des)",
>  			.cra_driver_name = "safexcel-ecb-des",
> @@ -1134,7 +1133,6 @@ struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
>  		.decrypt = safexcel_ecb_des3_ede_decrypt,
>  		.min_keysize = DES3_EDE_KEY_SIZE,
>  		.max_keysize = DES3_EDE_KEY_SIZE,
> -		.ivsize = DES3_EDE_BLOCK_SIZE,
>  		.base = {
>  			.cra_name = "ecb(des3_ede)",
>  			.cra_driver_name = "safexcel-ecb-des3_ede",
> -- 
> 1.8.3.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
