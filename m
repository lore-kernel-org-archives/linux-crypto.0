Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B316C282C2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 14:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1274C217D4
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 14:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfAWOdH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 09:33:07 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55389 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbfAWOdF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 09:33:05 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1gmJaQ-0000BA-R2; Wed, 23 Jan 2019 15:33:02 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1gmJaQ-0000LB-Bu; Wed, 23 Jan 2019 15:33:02 +0100
Date:   Wed, 23 Jan 2019 15:33:02 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>, kernel@pengutronix.de,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - fix setting IV after decrypt
Message-ID: <20190123143302.zw7vugj6hvecjifg@pengutronix.de>
References: <20181207113123.3394-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181207113123.3394-1-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:23:56 up 2 days,  1:37, 73 users,  load average: 0.10, 0.13, 0.15
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Horia,

On Fri, Dec 07, 2018 at 12:31:23PM +0100, Sascha Hauer wrote:
> The crypto API wants the updated IV in req->info after decryption. The
> updated IV used to be copied correctly to req->info after running the
> decryption job. Since 115957bb3e59 this is done before running the job
> so instead of the updated IV only the unmodified input IV is given back
> to the crypto API.
> 
> This was observed running the gcm(aes) selftest which internally uses
> ctr(aes) implemented by the CAAM engine.
> 
> Fixes: 115957bb3e59 ("crypto: caam - fix IV DMA mapping and updating")
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/crypto/caam/caamalg.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> index 869f092432de..c05c7938439c 100644
> --- a/drivers/crypto/caam/caamalg.c
> +++ b/drivers/crypto/caam/caamalg.c
> @@ -937,6 +937,14 @@ static void skcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
>  		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
>  
>  	skcipher_unmap(jrdev, edesc, req);
> +
> +	/*
> +	 * The crypto API expects us to set the IV (req->iv) to the last
> +	 * ciphertext block.
> +	 */
> +	scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen - ivsize,
> +				 ivsize, 0);
> +

I was wrong. It's not adding the scatterwalk_map_and_copy() here which
fixes gcm(aes) selftest. In fact, this has not to be done.

> @@ -1588,13 +1596,6 @@ static int skcipher_decrypt(struct skcipher_request *req)
>  	if (IS_ERR(edesc))
>  		return PTR_ERR(edesc);
>  
> -	/*
> -	 * The crypto API expects us to set the IV (req->iv) to the last
> -	 * ciphertext block.
> -	 */
> -	scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen - ivsize,
> -				 ivsize, 0);
> -

It's the removal of the scatterwalk_map_and_copy() here which fixes
things. With the above the initialization vector which gets passed in is
overwritten.

Now I don't know enough of the crypto stuff to judge if overwriting the IV
always has to be removed or just in some cases, but as a matter of fact
removing these lines fixes the gcm(aes) selftest on i.MX6. From
115957bb3e59 ("crypto: caam - fix IV DMA mapping and updating")
insmodding tcrypt fails with:

alg: aead: decryption failed on test 1 for gcm_base(ctr-aes-caam,ghash-generic): ret=74
alg: aead: Failed to load transform for gcm(aes): -2
alg: aead: Failed to load transform for rfc4106(gcm(aes)): -2
alg: aead: Failed to load transform for rfc4543(gcm(aes)): -2

With the overwriting removed it works again.

Horia, does this make sense to you or is there more that is wrong here?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
