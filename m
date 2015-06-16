From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Tue, 16 Jun 2015 10:50:28 +0800
Message-ID: <20150616025028.GA19474@gondor.apana.org.au>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1>
 <20150615201842.15697.59701.stgit@tstruk-mobl1>
 <20150615235954.GC16562@gondor.apana.org.au>
 <557F883C.5040207@intel.com>
 <20150616022947.GB19040@gondor.apana.org.au>
 <557F8E04.7000209@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59689 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbbFPCun (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 22:50:43 -0400
Content-Disposition: inline
In-Reply-To: <557F8E04.7000209@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 07:46:28PM -0700, Tadeusz Struk wrote:
>
> Ok I wanted to handle everything in the parse_key helper without any help from the implementation.
> I can change the helper to return the key and implementation will store it in the ctx. Is this
> what you are suggesting?

If you want to keep the helper generic what you can do is have
it take struct rsa_key instead of struct crypto_ablkcipher.

It definitely should just be an optional helper as opposed to
a required part of crypto_akcipher since you could have a piece
of hardware that takes the encoded key directly in which case
you wouldn't need the helper at all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
