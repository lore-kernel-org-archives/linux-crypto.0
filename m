Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC63C49ED7
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 17:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F67021479
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 17:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437201AbfIJRw7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 13:52:59 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:43297 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437172AbfIJRw7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 13:52:59 -0400
Received: from localhost (unknown [148.69.85.38])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 06262240003;
        Tue, 10 Sep 2019 17:52:56 +0000 (UTC)
Date:   Tue, 10 Sep 2019 18:32:46 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH 1/2] crypto: inside-secure - Added support for the
 CHACHA20 skcipher
Message-ID: <20190910173246.GA14055@kwain>
References: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568126293-4039-2-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1568126293-4039-2-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Tue, Sep 10, 2019 at 04:38:12PM +0200, Pascal van Leeuwen wrote:
>  
> @@ -112,7 +123,7 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
>  			block_sz = DES3_EDE_BLOCK_SIZE;
>  			cdesc->control_data.options |= EIP197_OPTION_2_TOKEN_IV_CMD;
>  			break;
> -		case SAFEXCEL_AES:
> +		default: /* case SAFEXCEL_AES */

Can't you keep an explicit case here?

>  			block_sz = AES_BLOCK_SIZE;
>  			cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
>  			break;

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
