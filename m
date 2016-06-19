From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v5 3/7] crypto: Linux Random Number Generator
Date: Sun, 19 Jun 2016 09:58:55 -0700
Message-ID: <20160619165854.GO13997@two.firstfloor.org>
References: <2754489.L1QYabbYUc@positron.chronox.de>
 <1627227.URpHt84zDf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:57841 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbcFSRIa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Jun 2016 13:08:30 -0400
Content-Disposition: inline
In-Reply-To: <1627227.URpHt84zDf@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 19, 2016 at 06:00:21PM +0200, Stephan Mueller wrote:
> The LRNG with all its properties is documented in [1]. This
> documentation covers the functional discussion as well as testing of all
> aspects of entropy processing. In addition, the documentation explains
> the conducted regression tests to verify that the LRNG is API and ABI
> compatible with the legacy /dev/random implementation.
> 
> [1] http://www.chronox.de/lrng.html

A web site is not a replacement for a proper commit message.

-Anid
