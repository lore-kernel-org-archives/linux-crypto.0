From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] CRC32C: crc32c module soft dependency
Date: Tue, 25 Feb 2014 20:16:43 +0800
Message-ID: <20140225121643.GA12216@gondor.apana.org.au>
References: <1390505720.3138.77.camel@schen9-DESK>
 <20140209011616.GA16905@gondor.apana.org.au>
 <1392063432.27116.10.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:36830 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaBYMQq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 07:16:46 -0500
Content-Disposition: inline
In-Reply-To: <1392063432.27116.10.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 10, 2014 at 12:17:12PM -0800, Tim Chen wrote:
> On Sun, 2014-02-09 at 09:16 +0800, Herbert Xu wrote:
> > On Thu, Jan 23, 2014 at 11:35:20AM -0800, Tim Chen wrote:
> > > Herbert,
> > > 
> > > It seems like we haven't folded in changes for adding
> > > soft dependency to crc32c to ensure that the accelerated
> > > version is loaded when available.
> > > 
> > > I take a crack with the patch below.
> > 
> > Thanks for the patch Tim.  We should also rename it to crc32c_generic
> > while we're at it.
> 
> How about the following version.  Thanks.

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
