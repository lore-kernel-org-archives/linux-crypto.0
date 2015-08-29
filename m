From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Fix ASN.1 key handling for RSA akcipher
Date: Sat, 29 Aug 2015 14:55:52 +0800
Message-ID: <20150829065552.GA18342@gondor.apana.org.au>
References: <C966DBDA-0161-4523-A705-43D96C7B8A04@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org,
	dhowells@redhat.com, dwmw2@infradead.org
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52475 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbbH2G4G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 29 Aug 2015 02:56:06 -0400
Content-Disposition: inline
In-Reply-To: <C966DBDA-0161-4523-A705-43D96C7B8A04@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Marcel Holtmann <marcel@holtmann.org> wrote:
> 
> I am not in favor of just hacking in this split until the semantics are actually understood. As said, the right solution from my point of view is to remove setkey from akcipher and replace it with setkeyid instead.

It's the keys system that should not be decoding the keys since
it doesn't know what to do with them.  The keys system should not
have any algorithm-specific knowledge in it.  You need to have
algorithm-specific knowledge to parse the keys, so that's why
the parsing should happen in the crypto API and not in the key
storage system.

> Remember that a private key contains the public key as well. Meaning operations are mutually exclusive. And there is really no point in forcing the caller to split things into two. With asymmetric cryptography you either have private and public key or you just have the public key. The case where you only have the private key is pointless.
> 
> We could keep the setkey as it is to load the private + public key information and add an extra setpubkey for loading only the public key. Then again a setkeyid would solve both of these problems since the key material would be nicely represented in a struct key.
> 
> However we actually want to load the keys into the asymmetric key type and use it from there. The asymmetric key type should be the only entity that has to deal with ASN.1 encoding. Having an akcipher deal with ASN.1 is just wrong.
> 
> What we really want is to be able to use keys from certificates to verify and encrypt information. And we want this all in one single place and not duplicate this whole ASN.1 stuff in the keys subsystem and the crypto subsystem. This means I am strongly against trying to add setkey, setpubkey, setcert, setkeychain or whatever else you might need when it comes to akcipher. There is one thing that is needed and that is setkeyid and have to reference the key serial from the keys subsystem.

I disagree.  I think having separate functions for setting public
and private keys makes sense.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
