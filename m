From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v8 1/3] crypto: Key-agreement Protocol Primitives API
 (KPP)
Date: Wed, 15 Jun 2016 17:41:00 +0800
Message-ID: <20160615094100.GA15907@gondor.apana.org.au>
References: <1465854948-9084-1-git-send-email-salvatore.benedetto@intel.com>
 <1465854948-9084-2-git-send-email-salvatore.benedetto@intel.com>
 <20160614113430.GA21063@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D031933C15@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53985 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbcFOJlI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 05:41:08 -0400
Content-Disposition: inline
In-Reply-To: <309B30E91F5E2846B79BD9AA9711D031933C15@IRSMSX102.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 14, 2016 at 02:36:54PM +0000, Benedetto, Salvatore wrote:
>
> My very first patch used PKCS3 and there were some objections to that.
> https://patchwork.kernel.org/patch/8311881/
>  
> Both Bluetooth or keyctl KEYCTL_DH_COMPUTE would have to first pack the
> key to whatever format we choose and I don't see that very convinient. We
> only want to provide the acceleration here, without bounding the user to a
> certain key format.

Have you looked at the rtnetlink encoding used by authenc.c? It is
much more light-weight.  There is no need to depend on ASN.1 parsers
at all.

To make it even easier for users such as bluetooth, you can create
helpers that convert struct dh to a byte stream, and vice versa.
For example, the interface could look like this:

	struct dh key;
	char *buf;
	unsigned int len;

	/* init key */
	key = ...;

	len = crypto_dh_key_len(&key);

	buf = kmalloc(len, GFP_KERNEL);
	if (!buf)
		...;

	crypto_dh_encode_key(buf, len, &key);
	crypto_kpp_set_secret(tfm, buf, len);

The driver would do:

set_secret(char *buf, unsigned int len)
{
	struct dh key;
	int err;

	err = crypto_dh_decode_key(buf, len, &key);
	...

>  akcipher is different as PKCS1 is a recognized standard for RSA keys.
>  
>  Please don't get me wrong, it's not much of an issue for me to respin the
>  patchset and change that to PKCS3 for example, but I see no harm in leaving
>  it as it is and moving the key check format to whatever upper layer is using us
>  (like BT and keyctl). Just more work for who is using the API.
>  
>  Could you reconsider that?

I'm sorry but using a void * for this is not acceptable.  We're
talking about a data structure that comes from arbitrary users
and then has to be decoded by random drivers.  It's something
totally different compared to a limited environment where the
same author is writing the code that creates and consumes the
pointer.

Throwing random void pointers at drivers is not a good idea.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
