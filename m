From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: talitos - consolidate cra_type assignments
Date: Mon, 20 Aug 2012 16:33:00 +0800
Message-ID: <20120820083300.GG22951@gondor.apana.org.au>
References: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
 <1343917001-20001-5-git-send-email-horia.geanta@freescale.com>
 <20120806204751.1f6277ba8f7b1de92fd128ac@freescale.com>
 <FD18E5D573A8AB48A365D4D78185DE9929291E@039-SN1MPN1-001.039d.mgd.msft.net>
 <FD18E5D573A8AB48A365D4D78185DE99293799@039-SN1MPN1-001.039d.mgd.msft.net>
 <20120807212748.d805c751b83e14e20b397cc1@freescale.com>
 <20120808203200.54353e16f8bd5e8a6b839f2f@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:48484 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753864Ab2HTIdD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2012 04:33:03 -0400
Content-Disposition: inline
In-Reply-To: <20120808203200.54353e16f8bd5e8a6b839f2f@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 08, 2012 at 08:32:00PM -0500, Kim Phillips wrote:
> lighten driver_algs[] by moving them to talitos_alg_alloc().
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Both patches applied.  Thanks Kim!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
