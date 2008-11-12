From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: dm-crypt using hifn_795x - still broken
Date: Wed, 12 Nov 2008 19:20:10 +0300
Message-ID: <20081112162009.GA2051@ioremap.net>
References: <200811121710.41666.tobias.geiger@vido.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tobias Geiger <tobias.geiger@vido.info>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from netgear.net.ru ([195.178.208.66]:46460 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbYKLQUQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Nov 2008 11:20:16 -0500
Content-Disposition: inline
In-Reply-To: <200811121710.41666.tobias.geiger@vido.info>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tobias.

On Wed, Nov 12, 2008 at 05:10:41PM +0100, Tobias Geiger (tobias.geiger@vido.info) wrote:
> hifn0: r: 00000000, active: 0, started: 20, success: 4247: qlen: 0/1, reset: 
> 1.

Please try to disable watchdog for now, its logic to detect stall
hardware is a bit subtle:

--- drivers/crypto/hifn_795x.c~	2008-11-12 19:20:18.000000000 +0300
+++ drivers/crypto/hifn_795x.c	2008-11-12 19:20:50.000000000 +0300
@@ -2689,7 +2689,7 @@
 		goto err_out_unregister_rng;
 
 	INIT_DELAYED_WORK(&dev->work, hifn_work);
-	schedule_delayed_work(&dev->work, HZ);
+	//schedule_delayed_work(&dev->work, HZ);
 
 	dprintk("HIFN crypto accelerator card at %s has been "
 			"successfully registered as %s.\n",

-- 
	Evgeniy Polyakov
