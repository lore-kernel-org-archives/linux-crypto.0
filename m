From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Tue, 1 Mar 2016 12:25:33 -0800
Message-ID: <3E4EC1AA-9696-4DBF-9C0A-18EF94300FDC@holtmann.org>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [82.165.8.211] ([82.165.8.211]:49186 "EHLO mail.holtmann.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751032AbcCAUZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Mar 2016 15:25:58 -0500
In-Reply-To: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Salvatore,

> Implement Diffie-Hellman primitives required by the scheme under the
> akcipher API. Here is how it works.
> 1) Call set_pub_key() by passing DH parameters (p,g) in PKCS3 format
> 2) Call set_priv_key() to set your own private key (xa) in raw format

this combination seems odd since it is normally the remote public key and the local private key. Generally the public key and private key are both remote ones.

For using PKCS3 format is this standardized somewhere? I don't think it is a good idea to invent new ones here.

In addition, how would this work for ECDH?

> 3) Call decrypt() without passing any data as input to get back the
>   public part which will be computed as g^xa mod p
> 4) Call encrypt() by passing the counter part public key (yb) in raw format
>   as input to get back the shared secret calculated as zz = yb^xa mod p
> 
> A test is included in the patch. Test vector has been generated with
> openssl
> 
> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> ---
> crypto/Kconfig    |   8 ++
> crypto/Makefile   |   7 ++
> crypto/dh.c       | 264 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> crypto/pkcs3.asn1 |   5 ++
> crypto/tcrypt.c   |   4 +
> crypto/testmgr.c  | 140 +++++++++++++++++++++++++++--
> crypto/testmgr.h  | 208 +++++++++++++++++++++++++++++++++++++++++-
> 7 files changed, 627 insertions(+), 9 deletions(-)
> create mode 100644 crypto/dh.c
> create mode 100644 crypto/pkcs3.asn1
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index f6bfdda..fd5b78d 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -101,6 +101,14 @@ config CRYPTO_RSA
> 	help
> 	  Generic implementation of the RSA public key algorithm.
> 
> +config CRYPTO_DH
> +	tristate "Diffie-Hellman algorithm"
> +	select CRYPTO_AKCIPHER
> +	select MPILIB
> +	select ASN1

I really wonder that depending on ASN1 is a good idea here. As mentioned above ECDH would make sense to actually have supported from the beginning. The Bluetooth subsystem could be then converted to utilize in kernel ECC key generation and ECDH shared secret computation. It would be good to show this is truly generic DH.

Regards

Marcel
