Return-Path: <SRS0=AMvw=QM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EE3C282CB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Feb 2019 08:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3530220821
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Feb 2019 08:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbfBEIbv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Feb 2019 03:31:51 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54345 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfBEIbv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Feb 2019 03:31:51 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1gqw8y-0002Wc-Bc; Tue, 05 Feb 2019 09:31:48 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1gqw8w-000224-LS; Tue, 05 Feb 2019 09:31:46 +0100
Date:   Tue, 5 Feb 2019 09:31:46 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - Do not overwrite IV
Message-ID: <20190205083146.icnk3y46vonpxsin@pengutronix.de>
References: <20190131061225.15541-1-s.hauer@pengutronix.de>
 <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:31:20 up 14 days, 18:44, 70 users,  load average: 0.07, 0.07,
 0.09
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Horia,

On Mon, Feb 04, 2019 at 12:26:26PM +0000, Horia Geanta wrote:
> On 1/31/2019 8:12 AM, Sascha Hauer wrote:
> > In skcipher_decrypt() the IV passed in by the caller is overwritten and
> > the tcrypt module fails with:
> > 
> > alg: aead: decryption failed on test 1 for gcm_base(ctr-aes-caam,ghash-generic): ret=74
> > alg: aead: Failed to load transform for gcm(aes): -2
> > 
> > With this patch tcrypt runs without errors.
> > 
> This doesn't mean the patch is correct.
> crypto API requires skcipher implementations to update the IV with the last
> ciphertext block.
> 
> The root cause of the issue is cache line sharing.
> 
> struct crypto_gcm_req_priv_ctx {
>         u8 iv[16];
>         u8 auth_tag[16];
> 	[...]
> };
> 
> Since caam does not support ghash on i.MX6, only ctr skcipher part of the gcm is
> offloaded.
> The skcipher request received by caam has req->src pointing to auth_tag[16] (1st
> S/G entry) and req->iv pointing to iv[16].
> caam driver:
> 1-DMA maps req->src
> 2-copies original req->iv to internal buffer
> 3-updates req->iv (scatterwalk_map_and_copy from last block in req->src)
> 4-sends job to crypto engine
> 
> Problem is that operation 3 above is writing iv[16], which is on the same cache
> line as auth_tag[16] that was previously DMA mapped.
> 
> I've checked that forcing auth_tag and iv to be on separate cache lines
> -       u8 auth_tag[16];
> +       u8 auth_tag[16] ____cacheline_aligned;
> solves the issue.

I can confirm that this solves it here on my side aswell.

I have no idea what's best to do here, but I'd like to have that fixed.

Is there some easy to reproduce testcase to show the issues that arise
with my patch? Apparently tcrypt doesn't do chaining, right?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
