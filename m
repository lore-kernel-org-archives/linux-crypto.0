From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Wed, 2 Mar 2016 09:38:31 +0000
Message-ID: <20160302093831.GA2384@sbenedet-virtual-machine>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com>
 <3E4EC1AA-9696-4DBF-9C0A-18EF94300FDC@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57927 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbcCBJid (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Mar 2016 04:38:33 -0500
Content-Disposition: inline
In-Reply-To: <3E4EC1AA-9696-4DBF-9C0A-18EF94300FDC@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 01, 2016 at 12:25:33PM -0800, Marcel Holtmann wrote:

Hi Marcel,

> Hi Salvatore,
> 
> > Implement Diffie-Hellman primitives required by the scheme under the
> > akcipher API. Here is how it works.
> > 1) Call set_pub_key() by passing DH parameters (p,g) in PKCS3 format
> > 2) Call set_priv_key() to set your own private key (xa) in raw format
> 
> this combination seems odd since it is normally the remote public key and the local private key. Generally the public key and private key are both remote ones.

I'm not sure I understand what you mean here. Usually the public key is
remote and the private key is local. How can the private key be remote?

> 
> For using PKCS3 format is this standardized somewhere? I don't think it is a good idea to invent new ones here.

PKCS3 is the format used by openssl for genating DH params, that's why I
used it.

> 
> In addition, how would this work for ECDH?

Don't know. There is not even ECC support right now.

> 
> > 3) Call decrypt() without passing any data as input to get back the
> >   public part which will be computed as g^xa mod p
> > 4) Call encrypt() by passing the counter part public key (yb) in raw format
> >   as input to get back the shared secret calculated as zz = yb^xa mod p
> > 
> > A test is included in the patch. Test vector has been generated with
> > openssl
> > 
> > Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> > ---
> > crypto/Kconfig    |   8 ++
> > crypto/Makefile   |   7 ++
> > crypto/dh.c       | 264 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > crypto/pkcs3.asn1 |   5 ++
> > crypto/tcrypt.c   |   4 +
> > crypto/testmgr.c  | 140 +++++++++++++++++++++++++++--
> > crypto/testmgr.h  | 208 +++++++++++++++++++++++++++++++++++++++++-
> > 7 files changed, 627 insertions(+), 9 deletions(-)
> > create mode 100644 crypto/dh.c
> > create mode 100644 crypto/pkcs3.asn1
> > 
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index f6bfdda..fd5b78d 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -101,6 +101,14 @@ config CRYPTO_RSA
> > 	help
> > 	  Generic implementation of the RSA public key algorithm.
> > 
> > +config CRYPTO_DH
> > +	tristate "Diffie-Hellman algorithm"
> > +	select CRYPTO_AKCIPHER
> > +	select MPILIB
> > +	select ASN1
> 
> I really wonder that depending on ASN1 is a good idea here. As mentioned above ECDH would make sense to actually have supported from the beginning. The Bluetooth subsystem could be then converted to utilize in kernel ECC key generation and ECDH shared secret computation. It would be good to show this is truly generic DH.
> 

This is an RFC. I understand it is not the best approach, but
the idea behind was to try to reuse the akcipher for DH.

Thanks for your comments.

Regards,
Salvatore

> Regards
> 
> Marcel
> 
