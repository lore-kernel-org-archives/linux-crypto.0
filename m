From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: add support for Orion5X crypto engine
Date: Mon, 10 Aug 2009 12:50:23 +1000
Message-ID: <20090810025023.GA28837@gondor.apana.org.au>
References: <alpine.LFD.2.00.0906111513420.31536@xanadu.home> <20090611201530.GA11486@Chamillionaire.breakpoint.cc> <alpine.LFD.2.00.0906111625280.31536@xanadu.home> <20090611210734.GA11920@Chamillionaire.breakpoint.cc> <alpine.LFD.2.00.0906111712060.31536@xanadu.home> <20090801093803.GA2362@Chamillionaire.breakpoint.cc> <alpine.LFD.2.00.0908021008450.3066@xanadu.home> <20090803165750.GB17083@Chamillionaire.breakpoint.cc> <alpine.LFD.2.00.0908031453570.8735@xanadu.home> <20090805072425.GA32367@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Nicolas Pitre <nico@cam.org>, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51887 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751899AbZHJCvR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 9 Aug 2009 22:51:17 -0400
Content-Disposition: inline
In-Reply-To: <20090805072425.GA32367@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 05, 2009 at 09:24:25AM +0200, Sebastian Andrzej Siewior wrote:
> From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> This adds support for Marvell's Cryptographic Engines and Security
> Accelerator (CESA) which can be found on a few SoC.
> Tested with dm-crypt.
> 
> Acked-by: Nicolas Pitre <nico@marvell.com>
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Patch applied.  Thanks Sebastian!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
