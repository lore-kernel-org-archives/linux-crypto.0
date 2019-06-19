Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4CAC31E49
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 12:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3334B2147A
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 12:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731178AbfFSM1m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 08:27:42 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:57079 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbfFSM1m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 08:27:42 -0400
X-Originating-IP: 90.88.23.150
Received: from localhost (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 1C88940003;
        Wed, 19 Jun 2019 12:27:37 +0000 (UTC)
Date:   Wed, 19 Jun 2019 14:27:37 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
Subject: Re: [PATCH 3/3] crypto: inside-secure - add support for using the
 EIP197 without firmware images
Message-ID: <20190619122737.GB3254@kwain>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
 <1560837384-29814-4-git-send-email-pvanleeuwen@insidesecure.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1560837384-29814-4-git-send-email-pvanleeuwen@insidesecure.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Tue, Jun 18, 2019 at 07:56:24AM +0200, Pascal van Leeuwen wrote:
>  
>  static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
>  {
> +	/*
> +	 * The embedded one-size-fits-all MiniFW is just for handling TR
> +	 * prefetch & invalidate. It does not support any FW flows, effectively
> +	 * turning the EIP197 into a glorified EIP97
> +	 */
> +	const u32 ipue_minifw[] = {
> +		 0x24808200, 0x2D008204, 0x2680E208, 0x2780E20C,
> +		 0x2200F7FF, 0x38347000, 0x2300F000, 0x15200A80,
> +		 0x01699003, 0x60038011, 0x38B57000, 0x0119F04C,
> +		 0x01198548, 0x20E64000, 0x20E75000, 0x1E200000,
> +		 0x30E11000, 0x103A93FF, 0x60830014, 0x5B8B0000,
> +		 0xC0389000, 0x600B0018, 0x2300F000, 0x60800011,
> +		 0x90800000, 0x10000000, 0x10000000};
> +	const u32 ifpp_minifw[] = {
> +		 0x21008000, 0x260087FC, 0xF01CE4C0, 0x60830006,
> +		 0x530E0000, 0x90800000, 0x23008004, 0x24808008,
> +		 0x2580800C, 0x0D300000, 0x205577FC, 0x30D42000,
> +		 0x20DAA7FC, 0x43107000, 0x42220004, 0x00000000,
> +		 0x00000000, 0x00000000, 0x00000000, 0x00000000,
> +		 0x00060004, 0x20337004, 0x90800000, 0x10000000,
> +		 0x10000000};

What is the license of this firmware? With this patch, it would be
shipped with Linux kernel images and this question is then very
important.

In addition to this, the direction the kernel has taken was to *remove*
binary firmwares from its source code. I'm afraid adding this is a
no-go.

The proper solution I believe would be to support loading this "MiniFW",
which (depending on the license) could be either distributed in the
rootfs and loaded (like what's done currently), or through
CONFIG_EXTRA_FIRMWARE.

This should be discussed first before discussing the implementation of
this particular patch.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
