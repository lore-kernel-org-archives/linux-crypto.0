From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v2] crypto/nx-842-{powerpc,pseries}: reduce chattiness
 of platform drivers
Date: Tue, 07 Jul 2015 19:36:21 +1000
Message-ID: <1436261781.15289.2.camel@ellerman.id.au>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
	 <20150702224049.GE1712@linux.vnet.ibm.com>
	 <1435887032.3665.1.camel@ellerman.id.au>
	 <20150706170621.GA3578@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Dan Streetman <ddstreet@us.ibm.com>, linux-crypto@vger.kernel.org,
	gustavold@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:52796 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672AbbGGJg3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 05:36:29 -0400
In-Reply-To: <20150706170621.GA3578@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2015-07-06 at 10:06 -0700, Nishanth Aravamudan wrote:
> On 03.07.2015 [11:30:32 +1000], Michael Ellerman wrote:
> > On Thu, 2015-07-02 at 15:40 -0700, Nishanth Aravamudan wrote:
> > > While we never would successfully load on the wrong machine type, there
> > > is extra output by default regardless of machine type.
> > > 
> 
> Thanks Michael!

Thanks for cleaning it up.


> While we never would successfully load on the wrong machine type, there
> is extra output by default regardless of machine type.
> 
> For instance, on a PowerVM LPAR, we see the following:
> 
> nx_compress_powernv: loading
> nx_compress_powernv: no coprocessors found
> 
> even though those coprocessors could never be found.
> 
> Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
> Cc: Dan Streetman <ddstreet@us.ibm.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> 
> ---
> v2:
>   Rather than not loading, just reduce the verbosity

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

I'm assuming Herbert will take this.

cheers
