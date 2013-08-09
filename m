From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] drivers/crypto/nx: saves chaining value from
 co-processor
Date: Fri, 9 Aug 2013 16:30:03 +1000
Message-ID: <20130809063003.GB23506@gondor.apana.org.au>
References: <1375917350.16050.14.camel@what-is-leg>
 <1376029504.32100.16.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, mhcerri@linux.vnet.ibm.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:39039 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030220Ab3HIGaM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Aug 2013 02:30:12 -0400
Content-Disposition: inline
In-Reply-To: <1376029504.32100.16.camel@pasglop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 09, 2013 at 04:25:04PM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2013-08-07 at 18:15 -0500, Fionnuala Gunter wrote:
> > This patch fixes a bug that is triggered when cts(cbc(aes)) is used with
> > nx-crypto driver on input larger than 32 bytes.
> > 
> > The chaining value from co-processor was not being saved. This value is
> > needed because it is used as the IV by cts(cbc(aes)).
> > 
> > Signed-off-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> > Reviewed-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
> 
> Herbert, I assume you will handle this along with all the other NX fixes
> and I can safely take them out of linuxppc patchwork ?

Yes of course.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
