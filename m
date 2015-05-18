From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v9 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Date: Mon, 18 May 2015 16:33:08 +0800
Message-ID: <20150518083308.GB18195@gondor.apana.org.au>
References: <1431608341-10936-1-git-send-email-clabbe.montjoie@gmail.com>
 <1431608341-10936-5-git-send-email-clabbe.montjoie@gmail.com>
 <20150517104508.468b032f@bbrezillon>
 <20150517103440.GA7800@gondor.apana.org.au>
 <20150517124811.797fab32@bbrezillon>
 <20150518004121.GA11910@gondor.apana.org.au>
 <20150518092449.2364d21e@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
	davem@davemloft.net, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, mchehab@osg.samsung.com,
	joe@perches.com, tj@kernel.org, arnd@arndb.de,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60278 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbbERId7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 May 2015 04:33:59 -0400
Content-Disposition: inline
In-Reply-To: <20150518092449.2364d21e@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 18, 2015 at 09:24:49AM +0200, Boris Brezillon wrote:
> 
> Okay, just to be sure, what does "Asynchronous" mean in ablkcipher or
> ahash ?
> Is it related to the fact that crypto operations can be done in
> multiple steps (e.g.: one set_key + several encrypt chunk operations),
> or is this something else ?

It gives you the ability to postpone the processing.  However
it doesn't mean that you have to postpone the processing.  For
instance, all of our sync software algorithms are also available
through the async interface for obvious reasons.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
