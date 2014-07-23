From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: initialize entry len for null input in crypto
 hash sg list walk
Date: Wed, 23 Jul 2014 21:09:45 +0800
Message-ID: <20140723130945.GA29178@gondor.apana.org.au>
References: <1405034288.2970.647.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35333 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaGWNKN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Jul 2014 09:10:13 -0400
Content-Disposition: inline
In-Reply-To: <1405034288.2970.647.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 10, 2014 at 04:18:08PM -0700, Tim Chen wrote:
> For the special case when we have a null input string, we want
> to initialize the entry len to 0 for the hash/ahash walk, so
> cyrpto_hash_walk_last will return the correct result indicating
> that we have completed the scatter list walk.  Otherwise we may
> keep walking the sg list and access bogus memory address.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Sorry but which driver is broken by this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
