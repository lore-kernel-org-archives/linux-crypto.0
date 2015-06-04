From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/9] crypto: Add ChaCha20-Poly1305 AEAD support for IPsec
Date: Thu, 4 Jun 2015 16:13:55 +0800
Message-ID: <20150604081355.GA23360@gondor.apana.org.au>
References: <1433159044-30753-1-git-send-email-martin@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37581 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbbFDIOJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2015 04:14:09 -0400
Content-Disposition: inline
In-Reply-To: <1433159044-30753-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 01, 2015 at 01:43:55PM +0200, Martin Willi wrote:
> This is a first version of a patch series implementing the ChaCha20-Poly1305
> AEAD construction defined in RFC7539. It is based on the current cryptodev tree.
> 
> The first two patches implement the ChaCha20 cipher, the second two the Poly1305
> authenticator, both in portable C for all architectures. Patch 5 and 6
> provide an AEAD construction using the two cipher primitives, named rfc7539.
> 
> Patch 7 and 8 add a variant of the same AEAD that uses additional key material
> as a nonce to shorten the explicit IV to 8 bytes, as defined for use in IPsec
> in draft-ietf-ipsecme-chacha20-poly1305. The last patch exposes that AEAD
> to IPsec users.
> 
> I don't expect any technical changes to draft-ietf-ipsecme-chacha20-poly1305,
> but we don't have an RFC name yet to reference the AEAD. We therefore simply
> name it rfc7539esp, but other suggestions are welcome.
> 
> The AEAD uses the crypto_nivaead_type to make it available to IPsec. However,
> I was unable to run test vectors against this type of AEAD on cryptodev, but
> I've verified the vectors against the same AEAD using crypto_aead_type.
> Additionally IPsec traffic has been tested against our userland ESP backend in
> strongSwan.
> 
> On my x64_64 test setup the IPsec throughput is ~700Mbits/s with these portable
> drivers. Architecture specific drivers subject to a future patchset can improve
> performance, for example with SSE doubling performance is feasible.

All applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
