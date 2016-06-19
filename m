From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 3/7] crypto: Linux Random Number Generator
Date: Sun, 19 Jun 2016 20:31:43 +0200
Message-ID: <3478149.23BVjtJb5k@positron.chronox.de>
References: <2754489.L1QYabbYUc@positron.chronox.de> <1627227.URpHt84zDf@positron.chronox.de> <20160619165854.GO13997@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, Theodore Tso <tytso@mit.edu>,
	sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37302 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbcFSSbr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Jun 2016 14:31:47 -0400
In-Reply-To: <20160619165854.GO13997@two.firstfloor.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 19. Juni 2016, 09:58:55 schrieb Andi Kleen:

Hi Andi,

> On Sun, Jun 19, 2016 at 06:00:21PM +0200, Stephan Mueller wrote:
> > The LRNG with all its properties is documented in [1]. This
> > documentation covers the functional discussion as well as testing of all
> > aspects of entropy processing. In addition, the documentation explains
> > the conducted regression tests to verify that the LRNG is API and ABI
> > compatible with the legacy /dev/random implementation.
> > 
> > [1] http://www.chronox.de/lrng.html
> 
> A web site is not a replacement for a proper commit message.

I will provide a complete commit message in the next round.

Thanks.

Ciao
Stephan
