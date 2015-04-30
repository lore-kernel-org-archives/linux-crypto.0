From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 1/2] crypto: add PKE API
Date: Fri, 1 May 2015 06:43:12 +0800
Message-ID: <20150430224312.GA30417@gondor.apana.org.au>
References: <20150430223647.10157.82156.stgit@tstruk-mobl1>
 <20150430223652.10157.86151.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: corbet@lwn.net, keescook@chromium.org, qat-linux@intel.com,
	jwboyer@redhat.com, richard@nod.at, d.kasatkin@samsung.com,
	linux-kernel@vger.kernel.org, steved@redhat.com,
	dhowells@redhat.com, vgoyal@redhat.com, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	jdelvare@suse.de, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55690 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbD3Wnq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Apr 2015 18:43:46 -0400
Content-Disposition: inline
In-Reply-To: <20150430223652.10157.86151.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 30, 2015 at 03:36:52PM -0700, Tadeusz Struk wrote:
>
> +struct pke_alg {
> +	int (*sign)(struct pke_request *pkereq);
> +	int (*verify)(struct pke_request *pkereq);
> +	int (*encrypt)(struct pke_request *pkereq);
> +	int (*decrypt)(struct pke_request *pkereq);
> +
> +	u8 pub_mpis;	/* Number of MPIs in public key */
> +	u8 sec_mpis;	/* Number of MPIs in secret key */
> +	u8 sig_mpis;	/* Number of MPIs in a signature */
> +#define PKEY_CAN_ENCRYPT	0x01
> +#define PKEY_CAN_DECRYPT	0x02
> +#define PKEY_CAN_SIGN		0x04
> +#define PKEY_CAN_VERIFY		0x08
> +	u8 capabilities;
> +};

Please remodel it after pcompress or the newly converted rng type.

This union stuff has been obsolete since 2008 and it's time for
it to die.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
