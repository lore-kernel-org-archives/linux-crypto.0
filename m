From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - reinitialize keys_fit_inline for decrypt
 and givencrypt
Date: Tue, 13 May 2014 19:45:31 +0800
Message-ID: <20140513114531.GB22078@gondor.apana.org.au>
References: <1398612374-1746-1-git-send-email-vakul@freescale.com>
 <20140502191008.db1408c0735f14ed1a0bdb8b@freescale.com>
 <72e203ad27a64b66b1b876e7b9978e5c@BL2PR03MB162.namprd03.prod.outlook.com>
 <20140505133725.33abd0d08a1662a147c498f5@freescale.com>
 <70e10fa687e249f08a102f148edd3231@BL2PR03MB162.namprd03.prod.outlook.com>
 <20140506151114.e44a1af14c9d5b63ecbac603@freescale.com>
 <20140508135255.GA13355@gondor.apana.org.au>
 <20140509203440.6148a33a29c0e7003b7f152b@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Garg Vakul-B16394 <vakul@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Geanta Neag Horia Ioan-B05471 <Horia.Geanta@freescale.com>,
	Gupta Ruchika-R66431 <ruchika.gupta@freescale.com>,
	Porosanu Alexandru-B06830 <alexandru.porosanu@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:55283 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759422AbaEMLpf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2014 07:45:35 -0400
Content-Disposition: inline
In-Reply-To: <20140509203440.6148a33a29c0e7003b7f152b@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 09, 2014 at 08:34:40PM -0500, Kim Phillips wrote:
> From: Vakul Garg <vakul@freescale.com>
> 
> Re-initialize keys_fit_inline to avoid using its stale encrypt() shared
> descriptor value prior to building descriptors for the decrypt() and
> givencrypt() cases.
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> [reworded commit text, enhanced code readability]
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
