From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v2]crypto:hifn_795x.c Fix warning: variable 'ctx' set
 but not used
Date: Tue, 6 Jul 2010 12:51:08 -0500
Message-ID: <20100706125108.fc4dffb4.kim.phillips@freescale.com>
References: <1278435578-3638-1-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
	davem@davemloft.net, jkosina@suse.cz
To: "Justin P. Mattock" <justinmattock@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:36036 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab0GFRvM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Jul 2010 13:51:12 -0400
Received: from az33smr01.freescale.net (az33smr01.freescale.net [10.64.34.199])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id o66Hp9We009896
	for <linux-crypto@vger.kernel.org>; Tue, 6 Jul 2010 10:51:11 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net [10.64.32.10])
	by az33smr01.freescale.net (8.13.1/8.13.0) with ESMTP id o66I1aEn024519
	for <linux-crypto@vger.kernel.org>; Tue, 6 Jul 2010 13:01:36 -0500 (CDT)
In-Reply-To: <1278435578-3638-1-git-send-email-justinmattock@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 6 Jul 2010 09:59:38 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> @@ -2035,7 +2034,7 @@ static void hifn_flush(struct hifn_device *dev)
>  
>  	spin_lock_irqsave(&dev->lock, flags);
>  	while ((async_req = crypto_dequeue_request(&dev->queue))) {
> -		ctx = crypto_tfm_ctx(async_req->tfm);
> +		crypto_tfm_ctx(async_req->tfm);

delete the entire line.

> -		ctx = crypto_tfm_ctx(async_req->tfm);
> +		crypto_tfm_ctx(async_req->tfm);

here too.

Kim
