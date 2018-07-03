From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v18 6/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Tue, 3 Jul 2018 12:31:26 -0300
Message-ID: <CAOMZO5DpwPsidKQ9wfe8mNTgdOpkdHHgqHMa4yQBx9uRrfFmww@mail.gmail.com>
References: <20180622194752.11221-1-logang@deltatee.com> <20180622194752.11221-7-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, linux-ntb@googlegroups.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Logan Gunthorpe <logang@deltatee.com>,
        Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180622194752.11221-7-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Logan,

On Fri, Jun 22, 2018 at 4:47 PM, Logan Gunthorpe <logang@deltatee.com> wrot=
e:
> Clean up the extra ifdefs which defined the wr_reg64 and rd_reg64
> functions in non-64bit cases in favour of the new common
> io-64-nonatomic-lo-hi header.
>
> To be consistent with CAAM engine HW spec: in case of 64-bit registers,
> irrespective of device endianness, the lower address should be read from
> / written to first, followed by the upper address. Indeed the I/O
> accessors in CAAM driver currently don't follow the spec, however this
> is a good opportunity to fix the code.
>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Reviewed-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Dan Douglass <dan.douglass@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>

This is now in linux-next as commit 46e4bf08f6388 and it breaks
booting imx6 (32-bit ARM):

[    1.872473] caam 2100000.caam: Entropy delay =3D 3200
[    1.938223] caam 2100000.caam: Instantiated RNG4 SH0
[    1.998983] caam 2100000.caam: Instantiated RNG4 SH1
[    2.004019] caam 2100000.caam: device ID =3D 0x0a16010000000000 (Era 4)
[    2.010484] caam 2100000.caam: job rings =3D 2, qi =3D 0
[    2.027389] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    2.028867] caam algorithms registered in /proc/crypto
[    2.035925] mmc1: queuing unknown CIS tuple 0x80 (4 bytes)
[    2.041187] caam_jr 2101000.jr0: job ring error: irqstate: 00000103
[    2.049878] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
[    2.056591] Modules linked in:
[    2.059671] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
4.18.0-rc3-next-20180703 #484
[    2.067338] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[    2.073892] PC is at caam_jr_interrupt+0x120/0x12c
[    2.078702] LR is at vprintk_emit+0x228/0x43c
[    2.083069] pc : [<c075eb38>]    lr : [<c01815ec>]    psr: 60000193
[    2.089344] sp : c1001d80  ip : c1001be0  fp : c1001da4
[    2.094576] r10: c107ffe7  r9 : ec749e00  r8 : 0000012d
[    2.099810] r7 : c1001de0  r6 : c17ecc10  r5 : ec7a6010  r4 : 00000103
[    2.106346] r3 : ba36048e  r2 : ba36048e  r1 : 00000001  r0 : 00000037
[    2.112884] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment none
[    2.120116] Control: 10c5387d  Table: 1000404a  DAC: 00000051
[    2.125873] Process swapper/0 (pid: 0, stack limit =3D 0x(ptrval))
[    2.131890] Stack: (0xc1001d80 to 0xc1002000)
[    2.136262] 1d80: ec5b5f00 ec749e64 00000000 c1001de0 0000012d
ec749e00 c1001ddc c1001da8
[    2.144454] 1da0: c0183584 c075ea24 c0176ea4 c0176850 c1001dfc
c1008908 ec749e64 ec749e00
[    2.152644] 1dc0: 00000000 00000001 ec008400 f4000100 c1001e04
c1001de0 c018364c c0183504
[    2.160834] 1de0: 00000000 ba36048e c0a87070 ec749e00 ec749e64
c1014ee4 c1001e24 c1001e08
[    2.169025] 1e00: c01836e0 c0183628 ec749e00 ec749e64 c1014ee4
00000000 c1001e44 c1001e28
[    2.177215] 1e20: c0187460 c01836ac c0f840a8 0000012d c1008a90
00000000 c1001e54 c1001e48
[    2.185406] 1e40: c018264c c01873b0 c1001e7c c1001e58 c0182cdc
c0182630 f400010c 000003eb
[    2.193597] 1e60: 000003ff 00000000 c1001eb8 c10280b0 c1001eb4
c1001e80 c047686c c0182c7c
[    2.201787] 1e80: ffffffff f4001100 00000000 c01091e8 20000013
ffffffff c1001eec 00000000
[    2.209977] 1ea0: c1000000 c1008908 c1001f14 c1001eb8 c0101a30
c0476814 00000001 00000001
[    2.218166] 1ec0: 00000000 c100bfc0 c1000000 c100892c 00000001
c100896c 00000000 c0f839b0
[    2.226356] 1ee0: c1008908 c1001f14 c1001ed8 c1001f08 c0174ddc
c01091e8 20000013 ffffffff
[    2.234545] 1f00: 00000051 00000000 c1001f24 c1001f18 c0a86e20
c01091cc c1001f64 c1001f28
[    2.242735] 1f20: c01587dc c0a86e04 00000000 00000000 c1008900
ba36048e c1008908 000000c3
[    2.250925] 1f40: 00000002 c1080480 c1008900 c1080480 c1008908
c0f66a4c c1001f74 c1001f68
[    2.259114] 1f60: c0158c88 c015862c c1001f9c c1001f78 c0a7e898
c0158c74 00000000 00000000
[    2.267304] 1f80: c0a7e78c c1001f90 c10804d8 ffffffff c1001ff4
c1001fa0 c0f00d68 c0a7e694
[    2.275493] 1fa0: ffffffff ffffffff 00000000 c0f00718 00000000
efffcb40 00000000 c0f66a4c
[    2.283683] 1fc0: ba32168e 00000000 00000000 c0f00330 00000051
10c0387d 0000113c 18000000
[    2.291873] 1fe0: 412fc09a 10c5387d 00000000 c1001ff8 00000000
c0f009e0 00000000 00000000

Any ideas on how to fix this issue?
