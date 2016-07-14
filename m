From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 0/2] Automatically load the vmx_crypto module if supported
Date: Thu, 14 Jul 2016 13:34:49 +1000
Message-ID: <20160714033449.GB18277@balbir.ozlabs.ibm.com>
References: <1468388840-12068-1-git-send-email-alastair@au1.ibm.com>
 <1468389299.4705.26.camel@au1.ibm.com>
Reply-To: bsingharora@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Alastair D'Silva <alastair@au1.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36071 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbcGNDe6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jul 2016 23:34:58 -0400
Content-Disposition: inline
In-Reply-To: <1468389299.4705.26.camel@au1.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 13, 2016 at 03:54:59PM +1000, Alastair D'Silva wrote:
> On Wed, 2016-07-13 at 15:47 +1000, alastair@au1.ibm.com wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> > > This series allows the vmx_crypto module to be detected and
> > automatically
> > loaded via UDEV if the CPU supports the vector crypto feature.
> > > Alastair D'Silva (2):
> > =A0 powerpc: Add module autoloading based on CPU features
> > =A0 crypto: vmx - Convert to CPU feature based module autoloading
> > > =A0arch/powerpc/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0|=A0=A01 +
> > =A0arch/powerpc/include/asm/cpufeature.h | 70
> > +++++++++++++++++++++++++++++++++++
> > =A0drivers/crypto/vmx/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0|=A0=
=A02 +-
> > =A0drivers/crypto/vmx/vmx.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
|=A0=A06 +--
> > =A04 files changed, 74 insertions(+), 5 deletions(-)
> > =A0create mode 100644 arch/powerpc/include/asm/cpufeature.h
>=20
> Please ignore the following:
> =A0 [PATCH 1/2] Allow drivers to be autoloaded.
> =A0 [PATCH 2/2] Automatically load the vmx_crypto module if supported=
=2E
>

Do you want to repost the series?

Balbir=20
