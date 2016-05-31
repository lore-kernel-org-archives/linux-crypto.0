From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH v5 2/3] crypto: kpp - Add DH software implementation
Date: Tue, 31 May 2016 08:56:59 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D03192F693@IRSMSX102.ger.corp.intel.com>
References: <1462830041-7582-1-git-send-email-salvatore.benedetto@intel.com>
 <1462830041-7582-3-git-send-email-salvatore.benedetto@intel.com>
 <20160531065256.GB13948@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12988 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162208AbcEaI5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 04:57:02 -0400
In-Reply-To: <20160531065256.GB13948@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Tuesday, May 31, 2016 7:53 AM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [PATCH v5 2/3] crypto: kpp - Add DH software implementation
> 
> On Mon, May 09, 2016 at 10:40:40PM +0100, Salvatore Benedetto wrote:
> >
> > +static int dh_set_params(struct crypto_kpp *tfm, void *buffer,
> > +			 unsigned int len)
> > +{
> > +	struct dh_ctx *ctx = dh_get_ctx(tfm);
> > +	struct dh_params *params = (struct dh_params *)buffer;
> > +
> > +	if (unlikely(!buffer || !len))
> > +		return -EINVAL;
> 
> What's the point of len? It's never checked anywhere apart from this non-
> zero check which is pointless.  Just get rid of it.

When I first created the API I thought it would be useful to validate the given
buffer in case the user passed in the wrong structure. The actual check would
have been

If (unlikely(!len && len != sizeof(struct dh_params))
        return -EINVAL;

but I agree I don't see much value in that now. I'll remove it.

Regards,
Salvatore
