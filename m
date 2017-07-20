From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v4 1/5] powerpc: io.h: move iomap.h include so that it can
 use readq/writeq defs
Date: Thu, 20 Jul 2017 12:36:07 +0000
Message-ID: <VI1PR0401MB259189A76FFD80DC02ACCF8998A70@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170718165528.7383-1-logang@deltatee.com>
 <20170718165528.7383-2-logang@deltatee.com>
 <87iniphsug.fsf@concordia.ellerman.id.au>
 <15b6ea7d-5817-c0cd-aee4-c8a52d8808f9@deltatee.com>
 <VI1PR0401MB2591205D2621B5FEB4EAE2CC98A70@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>
To: Logan Gunthorpe <logang@deltatee.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr00061.outbound.protection.outlook.com ([40.107.0.61]:11388
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934643AbdGTMgL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jul 2017 08:36:11 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/20/2017 1:27 PM, Horia Geant=E3 wrote:=0A=
> On 7/19/2017 7:04 PM, Logan Gunthorpe wrote:=0A=
>>=0A=
>>=0A=
>> On 18/07/17 11:57 PM, Michael Ellerman wrote:=0A=
>>> Seems fair enough, have you tested it at all?=0A=
>>=0A=
>> It's only been compile tested and the kbuild robot has beat up on it a b=
it.=0A=
>>=0A=
> Looks like the patch set does not compile on PPC (.config generated=0A=
> using make corenet64_smp_defconfig):=0A=
> =0A=
> [...]=0A=
>   LD      vmlinux.o=0A=
>   MODPOST vmlinux.o=0A=
> drivers/crypto/caam/jr.o: In function `rd_reg64':=0A=
> /home/b05471/repos/cryptodev-2.6/drivers/crypto/caam/regs.h:154:=0A=
> undefined reference to `.ioread64be_lo_hi'=0A=
> /home/b05471/repos/cryptodev-2.6/drivers/crypto/caam/regs.h:151:=0A=
> undefined reference to `.ioread64_lo_hi'=0A=
> /home/b05471/repos/cryptodev-2.6/drivers/crypto/caam/regs.h:151:=0A=
> undefined reference to `.ioread64_lo_hi'=0A=
> /home/b05471/repos/cryptodev-2.6/drivers/crypto/caam/regs.h:154:=0A=
> undefined reference to `.ioread64be_lo_hi'=0A=
> drivers/crypto/caam/jr.o: In function `wr_reg64':=0A=
> /home/b05471/repos/cryptodev-2.6/drivers/crypto/caam/regs.h:141:=0A=
> undefined reference to `.iowrite64_lo_hi'=0A=
> /home/b05471/repos/cryptodev-2.6/drivers/crypto/caam/regs.h:141:=0A=
> undefined reference to `.iowrite64_lo_hi'=0A=
> /home/b05471/repos/cryptodev-2.6/drivers/crypto/caam/regs.h:144:=0A=
> undefined reference to `.iowrite64be_lo_hi'=0A=
> /home/b05471/repos/cryptodev-2.6/drivers/crypto/caam/regs.h:144:=0A=
> undefined reference to `.iowrite64be_lo_hi'=0A=
> make: *** [vmlinux] Error 1=0A=
> =0A=
include/asm-generic/iomap.h is included before=0A=
include/linux/io-64-nonatomic-lo-hi.h:=0A=
=0A=
include/linux/io.h -> arch/powerpc/include/asm/io.h ->=0A=
include/asm-generic/iomap.h=0A=
=0A=
Thus, the "extern" version of ioread64_lo_hi and friends will be used=0A=
(and not the inline version from io-64-nonatomic-lo-hi.h).=0A=
=0A=
But for this kernel .config:=0A=
-CONFIG_GENERIC_IOMAP=3Dn and=0A=
-there is no implementation of io{read|write}64[be]{_lo_hi|_hi_lo} in=0A=
arch/powerpc/kernel/iomap.c=0A=
=0A=
Regards,=0A=
Horia=0A=
