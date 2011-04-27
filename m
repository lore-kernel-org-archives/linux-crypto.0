From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/8] s390: add System z hardware support for CTR mode
Date: Wed, 27 Apr 2011 20:40:04 +1000
Message-ID: <20110427104004.GA1697@gondor.apana.org.au>
References: <20110419192913.888086020@linux.vnet.ibm.com> <20110419193248.399099652@linux.vnet.ibm.com> <20110426063437.GA19539@gondor.apana.org.au> <1303900640.3495.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:48236 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab1D0KkL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Apr 2011 06:40:11 -0400
Content-Disposition: inline
In-Reply-To: <1303900640.3495.12.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 27, 2011 at 12:37:20PM +0200, Jan Glauber wrote:
> On Tue, 2011-04-26 at 16:34 +1000, Herbert Xu wrote:
> > On Tue, Apr 19, 2011 at 09:29:17PM +0200, jang@linux.vnet.ibm.com wrote:
> > >
> > > @@ -664,11 +784,6 @@ static int __init aes_s390_init(void)
> > >  	if (ret)
> > >  		goto cbc_aes_err;
> > >  
> > > -	/* skip XTS if MSA-4 is not available */
> > > -	if ((stfle(facility_bits, 2) <= 0) ||
> > > -	    !(facility_bits[1] & (1ULL << (63 - (77 - 64)))))
> > > -		goto out;
> > 
> > Any reason why this hunk is here?
> 
> This hunk is a left-over from development in the XTS patch and
> superfluous so it should be removed. Should I repost the whole series?

No worries.  I'll just kill it in the combined XTS patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
