From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: "crypto_hash_setkey" call from atomic context
Date: Fri, 11 Dec 2015 15:42:23 +0800
Message-ID: <20151211074223.GA11688@gondor.apana.org.au>
References: <CACzeOEfg9x+aEwuP9xH3BLd5+RzpDBZBGsnsLw7skW9FP5LVGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, joakim.nordell@intel.com,
	shujuan.chen@intel.com, doru.gucea@intel.com
To: Fabrizio Demaria <fabrizio.f.demaria@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37547 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbLKHm3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Dec 2015 02:42:29 -0500
Content-Disposition: inline
In-Reply-To: <CACzeOEfg9x+aEwuP9xH3BLd5+RzpDBZBGsnsLw7skW9FP5LVGw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46abrizio Demaria <fabrizio.f.demaria@gmail.com> wrote:
> Hello,
>=20
> I am investigating the current usage of kernel crypto-libraries in th=
e
> SCTP code, considering to adopt the same crypto framework for the
> MPTCP implementation.
>=20
> In sm_make_chunk.c, the crypto function "crypto_hash_setkey" is calle=
d
> in an atomic context, despite the fact that this function CAN invoke =
a
> GFP_KERNEL (sleeping) memory allocation. Calling a sleeping function
> from an atomic context can end up in deadlock.
> Is there a way to make sure that =E2=80=9Ccrypto_hash_setkey=E2=80=9D=
 can be safely
> called in an atomic context, considering all the possible code-paths
> followed by the function?

Indeed, in general setkey should not be invoked in atomic contexts.
The only exception would be extremely simple hashes such as CRC.

Keys should be setup before hand.  So SCTP needs to be fixed.

Cheers,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
