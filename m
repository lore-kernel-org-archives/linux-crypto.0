Return-Path: <SRS0=1tzS=TR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6253C04AB4
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 09:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCBF720833
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 09:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfEQJuX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 May 2019 05:50:23 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42201 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfEQJuX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 May 2019 05:50:23 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hRZVO-00075Q-6W; Fri, 17 May 2019 11:50:22 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hRZVK-00081u-R7; Fri, 17 May 2019 11:50:18 +0200
Date:   Fri, 17 May 2019 11:50:18 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     kernel@pengutronix.de,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 2/3] crypto: caam: print debug messages at debug level
Message-ID: <20190517095018.7qcufwb77nu3owb4@pengutronix.de>
References: <20190517092905.1264-1-s.hauer@pengutronix.de>
 <20190517092905.1264-3-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517092905.1264-3-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:45:58 up 59 days, 20:56, 97 users,  load average: 1.21, 1.16,
 1.11
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 17, 2019 at 11:29:04AM +0200, Sascha Hauer wrote:
> The CAAM driver used to put its debug messages inside #ifdef DEBUG and
> then prints the messages at KERN_ERR level. Replace this with proper
> functions printing at KERN_DEBUG level. The #ifdef DEBUG gets
> unnecessary when the right functions are used.
> 
> This replaces:
> 
> - print_hex_dump(KERN_ERR ...) inside #ifdef DEBUG with
>   print_hex_dump_debug(...)
> - dev_err() inside #ifdef DEBUG with dev_dbg()
> - printk(KERN_ERR ...) inside #ifdef DEBUG with dev_dbg()
> 
> Some parts of the driver use these functions already, so it is only
> consequent to use the debug function consistently.
> 
> @@ -993,20 +978,17 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
>  	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
>  	int ivsize = crypto_skcipher_ivsize(skcipher);
>  
> -#ifdef DEBUG
> -	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
> +	print_hex_dump_debug("dstiv  @"__stringify(__LINE__)": ",
>  		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
>  		       edesc->src_nents > 1 ? 100 : ivsize, 1);
> -#endif
> +

I just realized that this print_hex_dump_debug() needs to be inside if (ivsize)
because since eaed71a44ad9 ("crypto: caam - add ecb(*) support") req->iv
can be NULL. This is broken with or without this patch, I can include a
patch fixing this up when doing a v2.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
