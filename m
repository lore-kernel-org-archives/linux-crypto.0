From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 5/5] crypto: talitos - add IPsec ESN support
Date: Mon, 20 Aug 2012 16:32:12 +0800
Message-ID: <20120820083212.GE22951@gondor.apana.org.au>
References: <1344440805-20324-1-git-send-email-horia.geanta@freescale.com>
 <20120808202215.da5ef82b25f655956cabae80@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia Geanta <horia.geanta@freescale.com>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:58522 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753864Ab2HTIcO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2012 04:32:14 -0400
Content-Disposition: inline
In-Reply-To: <20120808202215.da5ef82b25f655956cabae80@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 08, 2012 at 08:22:15PM -0500, Kim Phillips wrote:
> On Wed, 8 Aug 2012 18:46:45 +0300
> Horia Geanta <horia.geanta@freescale.com> wrote:
> 
> > Support for ESNs (extended sequence numbers).
> > Tested with strongswan on a P2020RDB back-to-back setup.
> > Extracted from /etc/ipsec.conf:
> > esp=aes-sha1-esn-modp4096!
> > 
> > Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> > ---
> 
> series:
> 
> Reviewed-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
