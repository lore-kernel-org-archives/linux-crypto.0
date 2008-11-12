From: Tobias Geiger <tobias.geiger@vido.info>
Subject: Re: dm-crypt using hifn_795x - still broken
Date: Wed, 12 Nov 2008 20:43:06 +0100
Message-ID: <200811122043.06790.tobias.geiger@vido.info>
References: <200811121710.41666.tobias.geiger@vido.info> <20081112162009.GA2051@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.vido.info ([78.47.43.171]:39878 "EHLO mail.vido.info"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751726AbYKLTnP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Nov 2008 14:43:15 -0500
In-Reply-To: <20081112162009.GA2051@ioremap.net>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Evgeniy,

i tried that, know it just hangs while mounting the decrypted device. No 
special dmesg error or anything.:

ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
hifn795x 0000:00:09.0: PCI INT A -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
hifn795x: assuming 66MHz clock speed, override with 
hifn_pll_ref=ext<frequency>
hifn0: AES 128 ECB test has been successfully passed.
Driver for HIFN 795x crypto accelerator chip has been successfully registered.
spurious 8259A interrupt: IRQ7.
XFS mounting filesystem dm-0

Greetings
Tobias

Am Mittwoch, 12. November 2008 schrieb Evgeniy Polyakov:
> Hi Tobias.
>
> On Wed, Nov 12, 2008 at 05:10:41PM +0100, Tobias Geiger 
(tobias.geiger@vido.info) wrote:
> > hifn0: r: 00000000, active: 0, started: 20, success: 4247: qlen: 0/1,
> > reset: 1.
>
> Please try to disable watchdog for now, its logic to detect stall
> hardware is a bit subtle:
>
> --- drivers/crypto/hifn_795x.c~	2008-11-12 19:20:18.000000000 +0300
> +++ drivers/crypto/hifn_795x.c	2008-11-12 19:20:50.000000000 +0300
> @@ -2689,7 +2689,7 @@
>  		goto err_out_unregister_rng;
>
>  	INIT_DELAYED_WORK(&dev->work, hifn_work);
> -	schedule_delayed_work(&dev->work, HZ);
> +	//schedule_delayed_work(&dev->work, HZ);
>
>  	dprintk("HIFN crypto accelerator card at %s has been "
>  			"successfully registered as %s.\n",


