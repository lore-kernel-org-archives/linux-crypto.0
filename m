From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: initialize entry len for null input in crypto
 hash sg list walk
Date: Mon, 11 Aug 2014 13:32:00 -0700
Message-ID: <1407789120.2583.2.camel@schen9-DESK>
References: <1405034288.2970.647.camel@schen9-DESK>
	 <20140723130945.GA29178@gondor.apana.org.au>
	 <1406131665.2970.820.camel@schen9-DESK>
	 <20140801141816.GA14651@gondor.apana.org.au>
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
Received: from mga09.intel.com ([134.134.136.24]:22436 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbaHKUcM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Aug 2014 16:32:12 -0400
In-Reply-To: <20140801141816.GA14651@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2014-08-01 at 22:18 +0800, Herbert Xu wrote:
> On Wed, Jul 23, 2014 at 09:07:45AM -0700, Tim Chen wrote:
> > On Wed, 2014-07-23 at 21:09 +0800, Herbert Xu wrote:
> > > On Thu, Jul 10, 2014 at 04:18:08PM -0700, Tim Chen wrote:
> > > > For the special case when we have a null input string, we want
> > > > to initialize the entry len to 0 for the hash/ahash walk, so
> > > > cyrpto_hash_walk_last will return the correct result indicating
> > > > that we have completed the scatter list walk.  Otherwise we may
> > > > keep walking the sg list and access bogus memory address.
> > > > 
> > > > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > > 
> > > Sorry but which driver is broken by this?
> > > 
> > 
> > I haven't tested other driver, but I see this problem when
> > I was testing the new multi-buffer sha1 driver
> 
> OK, I'll add this patch along with the rest of your series then.
> I thought it affected existing drivers but it seems that it's
> only your driver that's affected.
> 
> Thanks,

Thanks Herbert.  I was out on vacation for a while.  Wonder if
you are planning to pick up the multi-buffer SHA1 series for 3.17
kernel?

Tim
