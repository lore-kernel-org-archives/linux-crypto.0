From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: Sahara performance on i.MX53
Date: Mon, 27 Apr 2015 19:34:05 +0200
Message-ID: <20150427173405.GR19889@pengutronix.de>
References: <553E6EE6.2050803@parkeon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Martin Fuzzey <mfuzzey@parkeon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49673 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817AbbD0ReI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 13:34:08 -0400
Content-Disposition: inline
In-Reply-To: <553E6EE6.2050803@parkeon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

On Mon, Apr 27, 2015 at 07:16:22PM +0200, Martin Fuzzey wrote:
> Hi,
> 
> I've been trying the Sahara crypto module on i.MX53 [mainline 3.19
> kernel + b251638c46a (crypto: sahara - use the backlog)]
> 
> I tested using dm-crypt with AES-128:
> cryptsetup -v  --key-size=128 luksFormat /dev/mmcblk0p7
> cryptsetup luksOpen /dev/mmcblk0p7 cryptotest
> 
> dd if=/dev/mapper/cryptotest of=/dev/null bs=1M count=100
> 
> 
> CPU Freq (MHz)       Time (s) WITHOUT Sahara        Time (s) WITH Sahara
> 1200                          3.26         5.34
> 1000                          3.26         5.62
> 800                            4.0           6.24
> 400                            7.72         9.86
> 166                            18.42       18.87
> 
> I was hoping for something better.
> There is a reduction in CPU usage as expected but the performance
> figures aren't looking very good.
> As this is in kernel use by dm-crypt cryptodev or af_alg aren't involved.
> 
> Has anyone else done any measurements?
> 

Yes. My measurements wheren't overwhelming either. :-(
The problem with the Sahara is: NDAs. So, I am Jon Snow
and know nothing :-(

Everything I do know, is from the Freescale kernel git repo.
Maybe I missed something. The FSL driver is very cryptic if
you ask me; so it is absolutely possible.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
