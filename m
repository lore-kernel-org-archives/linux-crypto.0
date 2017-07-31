From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v5 0/6] make io{read|write}64 globally usable
Date: Mon, 31 Jul 2017 10:29:28 +0000
Message-ID: <VI1PR0401MB2591E913B99E7B24E8BF828298B20@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170726231917.6073-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>
To: Logan Gunthorpe <logang@deltatee.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/27/2017 2:19 AM, Logan Gunthorpe wrote:=0A=
> Changes since v4:=0A=
> - Add functions so the powerpc implementation of iomap.c compiles. (As=0A=
> noticed by Horia)=0A=
=0A=
Tested-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
more exactly: crypto self-tests pass on CAAM crypto engine=0A=
on NXP platforms LS1046A (ARMv8 A53), T1040 (PPC64 e5500), P4080 (PPC=0A=
e500mc).=0A=
=0A=
> =0A=
> Changes since v3:=0A=
> =0A=
> - I noticed powerpc didn't use the appropriate functions seeing=0A=
> readq/writeq were not defined when iomap.h was included. Thus I've=0A=
> included a patch to adjust this=0A=
> - Fixed some mistakes with a couple of the defines in io-64-nonatomic*=0A=
> headers=0A=
> - Fixed a typo noticed by Horia.=0A=
> =0A=
> (earlier versions were drastically different)=0A=
> =0A=
> =0A=
> Horia Geant=E3 (1):=0A=
>   crypto: caam: cleanup CONFIG_64BIT ifdefs when using io{read|write}64=
=0A=
> =0A=
> Logan Gunthorpe (5):=0A=
>   powerpc: io.h: move iomap.h include so that it can use readq/writeq=0A=
>     defs=0A=
>   powerpc: iomap.c: introduce io{read|write}64_{lo_hi|hi_lo}=0A=
>   iomap: introduce io{read|write}64_{lo_hi|hi_lo}=0A=
>   io-64-nonatomic: add io{read|write}64[be]{_lo_hi|_hi_lo} macros=0A=
>   ntb: ntb_hw_intel: use io-64-nonatomic instead of in-driver hacks=0A=
> =0A=
>  arch/powerpc/include/asm/io.h         |   6 +-=0A=
>  arch/powerpc/kernel/iomap.c           |  40 +++++++++++=0A=
>  drivers/crypto/caam/regs.h            |  35 ++-------=0A=
>  drivers/ntb/hw/intel/ntb_hw_intel.c   |  30 +-------=0A=
>  include/asm-generic/iomap.h           |  26 +++++--=0A=
>  include/linux/io-64-nonatomic-hi-lo.h |  60 ++++++++++++++++=0A=
>  include/linux/io-64-nonatomic-lo-hi.h |  60 ++++++++++++++++=0A=
>  lib/iomap.c                           | 132 ++++++++++++++++++++++++++++=
++++++=0A=
>  8 files changed, 322 insertions(+), 67 deletions(-)=0A=
> =0A=
> --=0A=
> 2.11.0=0A=
> =0A=
