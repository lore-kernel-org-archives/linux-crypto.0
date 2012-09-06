From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: 842 - remove .cra_list initialization
Date: Thu, 6 Sep 2012 13:22:44 -0700
Message-ID: <20120906202244.GJ24269@gondor.apana.org.au>
References: <20120829203725.6424.60519.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Seth Jennings <sjenning@linux.vnet.ibm.com>,
	Robert Jennings <rcj@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:59495 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759647Ab2IFUWq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Sep 2012 16:22:46 -0400
Content-Disposition: inline
In-Reply-To: <20120829203725.6424.60519.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 29, 2012 at 11:37:25PM +0300, Jussi Kivilinna wrote:
> .cra_list initialization is unneeded and have been removed from all other
> crypto modules except 842.
> 
> Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
> Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
