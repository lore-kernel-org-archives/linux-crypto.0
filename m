From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: FW: [Fwd: [PATCH]Using Intel CRC32 instruction to implement hardware accelerated CRC32c algorithm.]
Date: Tue, 8 Jul 2008 16:00:53 +0400
Message-ID: <20080708120050.GA6410@2ka.mipt.ru>
References: <000901c8e0d4$6f5cf230$7fb410ac@ccr.corp.intel.com> <1215512754.2906.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	chaapala@cisco.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, arjan@linux.intel.com
To: austin zhang <austin_zhang@linux.intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756779AbYGHMBj@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1215512754.2906.23.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi.

On Tue, Jul 08, 2008 at 06:25:54AM -0400, austin zhang (austin_zhang@li=
nux.intel.com) wrote:
> > designed to support sync just as well as async despite the name)
> =EF=BB=BFDo you mean use async_xxx interface?

No, async_xxx is very different hardware assist, although it can be
converted to cryptoapi too.

> > to rewrite the crypto/crc32c implementation such that one tfm can
> > be used by multiple users.  All that has to be done is to move
> > the state from the tfm into the request object.
> =20
> > 2) Convert all crc32c users to use the crypto interface and phase
> > out lib/crc32c completely.
> >=20
> > 3) Add the Intel-specific crc32c implementation through the crypto
> > API.
> Agreed. And which module in crypto is the template for following the =
crypto API?

This is some kind of how cbc(cipher) or ecb(cipher) templates are done:
cbc(aes), cbc(aes-i686) for example.
The same would be possible to do with crc32c but for checksumming (whic=
h
is effectively a hash).

--=20
	Evgeniy Polyakov
