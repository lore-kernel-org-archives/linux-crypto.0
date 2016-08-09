From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] hwrng: core - Allow for multiple simultaneous active
 hwrng devices
Date: Tue, 9 Aug 2016 17:18:46 -0300
Message-ID: <20160809201846.GA4684@khazad-dum.debian.net>
References: <1469477255-26824-1-git-send-email-keithp@keithp.com>
 <20160809095058.GA6618@gondor.apana.org.au>
 <20160809165710.GC2013@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Keith Packard <keithp@keithp.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33360 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449AbcHIUSu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 16:18:50 -0400
Content-Disposition: inline
In-Reply-To: <20160809165710.GC2013@io.lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 09 Aug 2016, Jason Cooper wrote:
> Perhaps a /dev/hwrng[0-9] per rng?  That would lend itself nicely to a
> sysfs interface for per device quality, rate, and enabled attributes.
> e.g. /sys/class/hw_random/hwrng0/{device/,quality,rate,enabled}

IMHO, this is mightly annoying to use from inside a rngd-like utility in
a race-free, safe way.  It looks to me that ioctl() would be a much
better interface for everything but the "enabled" functionality (which
should be reported to the rngd-like utility as open() on the real device
failing with, e.g., ENXIO, when that source is disabled).

-- 
  Henrique Holschuh
