From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: Re: [PATCH] crypto: vmx: Remove dubiously licensed crypto code
Date: Fri, 5 May 2017 15:52:41 +0200
Message-ID: <20170505155241.2274f347@kitsune.suse.cz>
References: <20170329125639.14288-1-msuchanek@suse.de>
 <20170329145135.GA28057@kroah.com>
 <20170329171327.38d4fdd6@kitsune.suse.cz>
 <7ec54553-610c-a5dc-d4d9-3c83f6a161d9@linux.vnet.ibm.com>
 <8591ac8ff6ef6fa9c4bd264017ac360d@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@samba.org>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>,
 appro@openssl.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
 linuxppc-dev@lists.ozlabs.org, "David S.
 Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <8591ac8ff6ef6fa9c4bd264017ac360d@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

Hello,

On Thu, 30 Mar 2017 13:30:17 -0300
Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com> wrote:

> On 2017-03-29 20:08, Tyrel Datwyler wrote:
> > On 03/29/2017 08:13 AM, Michal Such=C3=A1nek wrote: =20
> >> On Wed, 29 Mar 2017 16:51:35 +0200
> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >>  =20
> >>> On Wed, Mar 29, 2017 at 02:56:39PM +0200, Michal Suchanek wrote: =20
> >>>> While reviewing commit 11c6e16ee13a ("crypto: vmx - Adding asm
> >>>> subroutines for XTS") which adds the OpenSSL license header to
> >>>> drivers/crypto/vmx/aesp8-ppc.pl licensing of this driver came
> >>>> into qestion. The whole license reads:
> >>>>=20
> >>>>  # Licensed under the OpenSSL license (the "License").  You may
> >>>> not use # this file except in compliance with the License.  You
> >>>> can obtain a # copy
> >>>>  # in the file LICENSE in the source distribution or at
> >>>>  # https://www.openssl.org/source/license.html
> >>>>=20
> >>>>  #
> >>>>  #
> >>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>> # Written by Andy Polyakov <appro@openssl.org> for the OpenSSL #
> >>>> project. The module is, however, dual licensed under OpenSSL and
> >>>> # CRYPTOGAMS licenses depending on where you obtain it. For
> >>>> further # details see http://www.openssl.org/~appro/cryptogams/.
> >>>> #
> >>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>=20
> >>>> After seeking legal advice it is still not clear that this driver
> >>>> can be legally used in Linux. In particular the "depending on
> >>>> where you obtain it" part does not make it clear when you can
> >>>> apply the GPL and when the OpenSSL license.
> >>>>=20
> >>>> I tried contacting the author of the code for clarification but
> >>>> did not hear back. In absence of clear licensing the only
> >>>> solution I see is removing this code. =20
> >=20
> > A quick 'git grep OpenSSL' of the Linux tree returns several other
> > crypto files under the ARM architecture that are similarly
> > licensed. Namely:
> >=20
> > arch/arm/crypto/sha1-armv4-large.S
> > arch/arm/crypto/sha256-armv4.pl
> > arch/arm/crypto/sha256-core.S_shipped
> > arch/arm/crypto/sha512-armv4.pl
> > arch/arm/crypto/sha512-core.S_shipped
> > arch/arm64/crypto/sha256-core.S_shipped
> > arch/arm64/crypto/sha512-armv8.pl
> > arch/arm64/crypto/sha512-core.S_shipped
> >=20
> > On closer inspection of some of those files have the addendum that
> > "Permission to use under GPL terms is granted", but not all of them.
> >=20
> > -Tyrel =20
>=20
> In 2015,  , the author, replied in this mailing list [1]:
>=20
> "I have no problems with reusing assembly modules in kernel context.
> The whole idea behind cryptogams initiative was exactly to reuse code
> in different contexts."
>=20
> [1] https://patchwork.kernel.org/patch/6027481/
>=20

So you have an e-mail message from one of the authors of the code.
Andy Polyakov wrote most of the code but there are probably other
contributors who never gave explicit consent for using their code
outside of OpenSSL. The OpenSSL maintainers made it explicitly clear by
stamping the OpenSSL license incompatible with GPL2 on the file that
they are not OK with hosting development for Linux kernel code.

This Cryptograms project did not seem to get anywhere so there is no
source for the code other than the OpenSSL tree. Merging code from
OpenSSL into Linux does not look legally feasible.

Andy Polyakov is unresponsive in discussions concerning his awesome
licensing terms.

The MAINTAINERS file has
IBM Power VMX Cryptographic instructions
M:	Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
M:	Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
L:	linux-crypto@vger.kernel.org
S:	Supported

So presumably the maintainers have access to necessary legal advice to
determine what steps are necessary to make this driver maintainable
legally.

I do not expect this will be resolved overnight. However, there is no
progress on this issue whatsoever so I suggest removal of the driver.

Thanks

Michal
