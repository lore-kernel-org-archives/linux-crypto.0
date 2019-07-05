Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF99C46499
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 14:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CE6720828
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 14:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbfGEOSH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 10:18:07 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53411 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfGEOSH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 10:18:07 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 955FC60004;
        Fri,  5 Jul 2019 14:18:00 +0000 (UTC)
Date:   Fri, 5 Jul 2019 16:18:00 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH] crypto: inside-secure - remove unused struct entry
Message-ID: <20190705141800.GE3926@kwain>
References: <1562314645-22949-1-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1562314645-22949-1-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Pascal,

On Fri, Jul 05, 2019 at 10:17:25AM +0200, Pascal van Leeuwen wrote:
> This patch removes 'engines' from struct safexcel_alg_template, as it is
> no longer used.
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> ---
>  drivers/crypto/inside-secure/safexcel.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
> index 379d0b0..30a222e 100644
> --- a/drivers/crypto/inside-secure/safexcel.h
> +++ b/drivers/crypto/inside-secure/safexcel.h
> @@ -660,7 +660,6 @@ struct safexcel_ahash_export_state {
>  struct safexcel_alg_template {
>  	struct safexcel_crypto_priv *priv;
>  	enum safexcel_alg_type type;
> -	u32 engines;

This patch can't be applied to the cryptodev branch, as 'engines' is
still used. I guess this is done as other (non-applied) patches are
removing the use of this member.

You should wait for either those patches to be merged (or directly
integrate this change in a newer version of those patches), or send this
patch in the same series. Otherwise it's problematic as you do not know
which patches will be applied first.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
