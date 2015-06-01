From: Martin Willi <martin@strongswan.org>
Subject: [PATCH 0/9] crypto: Add ChaCha20-Poly1305 AEAD support for IPsec
Date: Mon,  1 Jun 2015 13:43:55 +0200
Message-ID: <1433159044-30753-1-git-send-email-martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:40459 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbbFAMYK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 08:24:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a first version of a patch series implementing the ChaCha20-Poly1305
AEAD construction defined in RFC7539. It is based on the current cryptodev tree.

The first two patches implement the ChaCha20 cipher, the second two the Poly1305
authenticator, both in portable C for all architectures. Patch 5 and 6
provide an AEAD construction using the two cipher primitives, named rfc7539.

Patch 7 and 8 add a variant of the same AEAD that uses additional key material
as a nonce to shorten the explicit IV to 8 bytes, as defined for use in IPsec
in draft-ietf-ipsecme-chacha20-poly1305. The last patch exposes that AEAD
to IPsec users.

I don't expect any technical changes to draft-ietf-ipsecme-chacha20-poly1305,
but we don't have an RFC name yet to reference the AEAD. We therefore simply
name it rfc7539esp, but other suggestions are welcome.

The AEAD uses the crypto_nivaead_type to make it available to IPsec. However,
I was unable to run test vectors against this type of AEAD on cryptodev, but
I've verified the vectors against the same AEAD using crypto_aead_type.
Additionally IPsec traffic has been tested against our userland ESP backend in
strongSwan.

On my x64_64 test setup the IPsec throughput is ~700Mbits/s with these portable
drivers. Architecture specific drivers subject to a future patchset can improve
performance, for example with SSE doubling performance is feasible.

Martin Willi (9):
  crypto: Add a generic ChaCha20 stream cipher implementation
  crypto: testmgr - Add ChaCha20 test vectors from RFC7539
  crypto: Add a generic Poly1305 authenticator implementation
  crypto: testmgr - Add Poly1305 test vectors from RFC7539
  crypto: Add a ChaCha20-Poly1305 AEAD construction, RFC7539
  crypto: testmgr - Add ChaCha20-Poly1305 test vectors from RFC7539
  crypto: chacha20poly1305 - Add an IPsec variant for RFC7539 AEAD
  crypto: testmgr - Add draft-ietf-ipsecme-chacha20-poly1305 test vector
  xfrm: Define ChaCha20-Poly1305 AEAD XFRM algo for IPsec users

 crypto/Kconfig            |  34 ++
 crypto/Makefile           |   3 +
 crypto/chacha20_generic.c | 216 +++++++++++
 crypto/chacha20poly1305.c | 687 +++++++++++++++++++++++++++++++++++
 crypto/poly1305_generic.c | 300 ++++++++++++++++
 crypto/testmgr.c          |  54 +++
 crypto/testmgr.h          | 884 ++++++++++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_algo.c      |  12 +
 8 files changed, 2190 insertions(+)
 create mode 100644 crypto/chacha20_generic.c
 create mode 100644 crypto/chacha20poly1305.c
 create mode 100644 crypto/poly1305_generic.c

--
1.9.1
