From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto, sha1: export sha1_update for reuse
Date: Sat, 30 Jul 2011 21:46:50 +0800
Message-ID: <20110730134650.GA26753@gondor.apana.org.au>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com> <1311529994-7924-2-git-send-email-minipli@googlemail.com> <20110728145812.GA8396@gondor.apana.org.au> <CA+rthh-=qKpYM-9F0e=6DUpqxXWbMuMcXnGq9cZTK0V=Kbpg0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
	linux-kernel@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:57215 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1G3NrE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Jul 2011 09:47:04 -0400
Content-Disposition: inline
In-Reply-To: <CA+rthh-=qKpYM-9F0e=6DUpqxXWbMuMcXnGq9cZTK0V=Kbpg0A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 28, 2011 at 05:29:35PM +0200, Mathias Krause wrote:
> On Thu, Jul 28, 2011 at 4:58 PM, Herbert Xu <herbert@gondor.apana.org=
=2Eau> wrote:
> > On Sun, Jul 24, 2011 at 07:53:13PM +0200, Mathias Krause wrote:
> >>
> >> diff --git a/include/crypto/sha.h b/include/crypto/sha.h
> >> index 069e85b..7c46d0c 100644
> >> --- a/include/crypto/sha.h
> >> +++ b/include/crypto/sha.h
> >> @@ -82,4 +82,9 @@ struct sha512_state {
> >> =C2=A0 =C2=A0 =C2=A0 u8 buf[SHA512_BLOCK_SIZE];
> >> =C2=A0};
> >>
> >> +#if defined(CONFIG_CRYPTO_SHA1) || defined (CONFIG_CRYPTO_SHA1_MO=
DULE)
> >> +extern int crypto_sha1_update(struct shash_desc *desc, const u8 *=
data,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int len);
> >> +#endif
> >
> > Please remove the unnecessary #if.
>=20
> The function will only be available when crypto/sha1_generic.o will
> either be build into the kernel or build as a module. Without the #if
> a potential wrong user of this function might not be detected as earl=
y
> as at compilation time but as late as at link time, or even worse, as
> late as on module load time -- which is pretty bad. IMHO it's better
> to detect errors early, as in reading "error: implicit declaration of
> function =E2=80=98crypto_sha1_update=E2=80=99" when trying to compile=
 the code in
> question instead of "Unknown symbol crypto_sha1_update" in dmesg when
> trying to load the module. That for I would like to keep the #if.

In order to be consistent please remove the ifdef.  In most
similar cases in the crypto subsystem we don't do this.  As
adding such ifdefs all over the place would gain very little,
I'd much rather you left it out.

The one case where this would make sense is if it were a trivial
inline in the !defined case.

Thanks!
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
