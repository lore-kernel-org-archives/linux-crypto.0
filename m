From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: remove padding logic from rsa.c
Date: Sat, 27 Feb 2016 18:40:05 +0000
Message-ID: <20160227184005.GA8856@gondor.apana.org.au>
References: <20160224171258.29272.1684.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, tadeusz.struk@intel.com,
	linux-kernel@vger.kernel.org, balrogg@googlemail.com,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com,
	James Morris <jmorris@namei.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44647 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbcB0SkS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2016 13:40:18 -0500
Content-Disposition: inline
In-Reply-To: <20160224171258.29272.1684.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk <tadeusz.struk@intel.com> wrote:
>
> diff --git a/crypto/rsa.c b/crypto/rsa.c
> index 9a7c9ca..77d737f 100644
> --- a/crypto/rsa.c
> +++ b/crypto/rsa.c
> @@ -16,78 +16,6 @@
> #include <crypto/algapi.h>
> 
> /*
> - * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
> - */
> -static const u8 rsa_digest_info_md5[] = {
> -       0x30, 0x20, 0x30, 0x0c, 0x06, 0x08,
> -       0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x02, 0x05, /* OID */
> -       0x05, 0x00, 0x04, 0x10
> -};

Where did this come from? It's not in my tree.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
