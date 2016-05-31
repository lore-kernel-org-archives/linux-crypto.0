From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH v5 3/3] crypto: kpp - Add ECDH software support
Date: Tue, 31 May 2016 08:41:16 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D03192F66C@IRSMSX102.ger.corp.intel.com>
References: <1462830041-7582-1-git-send-email-salvatore.benedetto@intel.com>
 <1462830041-7582-4-git-send-email-salvatore.benedetto@intel.com>
 <20160531065525.GC13948@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:19049 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779AbcEaIlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 04:41:25 -0400
In-Reply-To: <20160531065525.GC13948@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Tuesday, May 31, 2016 7:55 AM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [PATCH v5 3/3] crypto: kpp - Add ECDH software support
> 
> On Mon, May 09, 2016 at 10:40:41PM +0100, Salvatore Benedetto wrote:
> >
> > +	do {
> > +		if (tries++ >= MAX_TRIES)
> > +			goto err_retries;
> > +
> > +		ecc_point_mult(pk, &curve->g, priv, NULL, curve->p, ndigits);
> > +
> > +	} while (ecc_point_is_zero(pk));
> 
> You might want to read this again.  The original code did this because it
> changed the private key in the loop, in your code priv is constant...

Yep, I'll fix that. Thanks for reviewing.

Salvatore 
