From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] to fix vmac test fails on s390
Date: Tue, 16 Feb 2010 20:39:38 +0800
Message-ID: <20100216123938.GA313@gondor.apana.org.au>
References: <1263477930.5880.22.camel@bender> <20100117110546.GA32690@gondor.apana.org.au> <6CADD16F56BC954D8E28F3836FA7ED711EB163307A@shzsmsx501.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Glauber <jang@linux.vnet.ibm.com>,
	"Cihula, Joseph" <joseph.cihula@intel.com>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: "Wang, Shane" <shane.wang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58194 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755684Ab0BPMjn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2010 07:39:43 -0500
Content-Disposition: inline
In-Reply-To: <6CADD16F56BC954D8E28F3836FA7ED711EB163307A@shzsmsx501.ccr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 11, 2010 at 11:18:08AM +0800, Wang, Shane wrote:
>
>  static struct hash_testvec aes_vmac128_tv_template[] = {
>  	{
> +		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
> +			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
> +		.plaintext = NULL,
> +#ifdef __LITTLE_ENDIAN
> +		.digest	= "\x07\x58\x80\x35\x77\xa4\x7b\x54",
> +#else
> +		.digest = "\x54\x7b\xa4\x77\x35\x80\x58\x07",
> +#endif
> +		.psize	= 0,
> +		.ksize	= 16,
> +	}, {

Sorry but you can't fix it like this.  Your hash output must be
invariant with respect to endianness.

That means, whether I run it on a big-endian machine or a little-
endian one it should produce the same output.

Otherwise this hash will be totally useless as soon as you get
onto the network.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
