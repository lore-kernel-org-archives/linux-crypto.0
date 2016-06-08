From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH v3] crypto: rsa - return raw integers for the ASN.1 parser
Date: Wed, 8 Jun 2016 10:20:16 +0000
Message-ID: <AMSPR04MB536483CBE33C06138511C79B85E0@AMSPR04MB536.eurprd04.prod.outlook.com>
References: <1465309269-2214-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <4389374.qHp8yZtTYB@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0092.outbound.protection.outlook.com ([157.56.112.92]:54112
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753574AbcFHKxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 06:53:16 -0400
In-Reply-To: <4389374.qHp8yZtTYB@tauon.atsec.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

> >  int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
> >  	      const void *value, size_t vlen)
> >  {
> >  	struct rsa_key *key = context;
> > +	const u8 *ptr = value;
> > +	int ret;
> >
> > -	key->n = mpi_read_raw_data(value, vlen);
> > +	while (!*ptr && vlen) {
> > +		ptr++;
> > +		vlen--;
> > +	}
> 
> As you do this operation 3 times, isn't an inline better here?

Actually this operation makes sense only for n to determine its length.
I will remove the while from rsa_get_e/d. 

> 
> >
> > -	if (!key->n)
> > -		return -ENOMEM;
> > +	/* invalid key provided */
> > +	if (!ptr)
> > +		return -EINVAL;
> 
> Hm, you check the pointer here, but you dereference it already above. So, I
> guess you want to move that check to the beginning of the function?

Sure. Thank you for reviewing!
ta
