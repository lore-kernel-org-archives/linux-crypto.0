From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: initialize entry len for null input in crypto
 hash sg list walk
Date: Wed, 23 Jul 2014 09:07:45 -0700
Message-ID: <1406131665.2970.820.camel@schen9-DESK>
References: <1405034288.2970.647.camel@schen9-DESK>
	 <20140723130945.GA29178@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40592 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190AbaGWQIO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Jul 2014 12:08:14 -0400
In-Reply-To: <20140723130945.GA29178@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2014-07-23 at 21:09 +0800, Herbert Xu wrote:
> On Thu, Jul 10, 2014 at 04:18:08PM -0700, Tim Chen wrote:
> > For the special case when we have a null input string, we want
> > to initialize the entry len to 0 for the hash/ahash walk, so
> > cyrpto_hash_walk_last will return the correct result indicating
> > that we have completed the scatter list walk.  Otherwise we may
> > keep walking the sg list and access bogus memory address.
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> 
> Sorry but which driver is broken by this?
> 

I haven't tested other driver, but I see this problem when
I was testing the new multi-buffer sha1 driver

Tim
