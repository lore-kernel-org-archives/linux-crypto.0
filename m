From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH v9 2/3] crypto: kpp - Add DH software implementation
Date: Mon, 20 Jun 2016 11:44:43 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D03193588B@IRSMSX102.ger.corp.intel.com>
References: <1466174265-4546-1-git-send-email-salvatore.benedetto@intel.com>
 <1466174265-4546-3-git-send-email-salvatore.benedetto@intel.com>
 <20160620111310.GA10601@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33549 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbcFTLtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 07:49:04 -0400
In-Reply-To: <20160620111310.GA10601@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Monday, June 20, 2016 12:13 PM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [PATCH v9 2/3] crypto: kpp - Add DH software implementation
> 
> On Fri, Jun 17, 2016 at 03:37:44PM +0100, Salvatore Benedetto wrote:
> >
> > +int crypto_dh_encode_key(char *buf, unsigned int len, const struct dh
> > +*params) {
> > +	struct kpp_secret *secret = (struct kpp_secret *)buf;
> 
> You can't do that.  The memory under buf may not be aligned so you need to
> copy it.

OK, I'll fix that and send a new version unless you have other comments.

Thanks for reviewing.

Salvatore
