From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Tue, 19 Jun 2012 13:51:23 +0200
Message-ID: <20120619115123.GN9122@philter.vipri.net>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
 <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
 <20120618134718.GL9122@philter.vipri.net>
 <20120618201235.GA20755@schnuecks.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, cloudy.linux@gmail.com,
	andrew@lunn.ch
To: Simon Baatz <gmbnomis@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:35241 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2FSLvc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jun 2012 07:51:32 -0400
Content-Disposition: inline
In-Reply-To: <20120618201235.GA20755@schnuecks.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Simon,

On Mon, Jun 18, 2012 at 10:12:36PM +0200, Simon Baatz wrote:
> On Mon, Jun 18, 2012 at 03:47:18PM +0200, Phil Sutter wrote:
> > On Sat, Jun 16, 2012 at 02:20:19AM +0200, Simon Baatz wrote:
> > > thanks for providing these patches; it's great to finally see DMA
> > > support for CESA in the kernel. Additionally, the implementation =
seems
> > > to be fine regarding cache incoherencies (at least my test in [*]
> > > works).
> >=20
> > Thanks for testing and the fixes. Could you also specify the platfo=
rm
> > you are testing on?
>=20
> This is a Marvell Kirkwood MV88F6281-A1.=20

OK, thanks. Just wanted to be sure it's not already the Orion test I'm
hoping for. :)

> I see one effect that I don't fully understand.=20
> Similar to the previous implementation, the system is mostly in
> kernel space when accessing an encrypted dm-crypt device:
>=20
> # cryptsetup --cipher=3Daes-cbc-plain --key-size=3D128 create c_sda2 =
/dev/sda2=20
> Enter passphrase:=20
> # dd if=3D/dev/mapper/c_sda2 of=3D/dev/null bs=3D64k count=3D2048
> 2048+0 records in
> 2048+0 records out
> 134217728 bytes (134 MB) copied, 10.7324 s, 12.5 MB/s
>=20
> Doing an "mpstat 1" at the same time gives:
>=20
> 21:21:42     CPU    %usr   %nice    %sys %iowait    %irq   %soft ...
> 21:21:45     all    0.00    0.00    0.00    0.00    0.00    0.00
> 21:21:46     all    0.00    0.00   79.00    0.00    0.00    2.00
> 21:21:47     all    0.00    0.00   95.00    0.00    0.00    5.00
> 21:21:48     all    0.00    0.00   94.00    0.00    0.00    6.00
> 21:21:49     all    0.00    0.00   96.00    0.00    0.00    4.00
> ...
>=20
> The underlying device is a SATA drive and should not be the limit:
>=20
> # dd if=3D/dev/sda2 of=3D/dev/null bs=3D64k count=3D2048
> 2048+0 records in
> 2048+0 records out
> 134217728 bytes (134 MB) copied, 1.79804 s, 74.6 MB/s
>=20
> I did not dare hope the DMA implementation to be much faster than the
> old one, but I would have expected a rather low CPU usage using DMA.=20
> Do you have an idea where the kernel spends its time?  (Am I hitting
> a non/only partially accelerated path here?)

Hmm. Though you passed bs=3D64k to dd, block sizes may still be the
bottleneck. No idea if the parameter is really passed down to dm-crypt
or if that uses the underlying device's block size anyway. I just did a
short speed test on the 2.6.39.2 we're using productively:

| Testing AES-128-CBC cipher:
|  Encrypting in chunks of 512 bytes: done. 46.19 MB in 5.00 secs: 9.24=
 MB/sec
|  Encrypting in chunks of 1024 bytes: done. 81.82 MB in 5.00 secs: 16.=
36 MB/sec
|  Encrypting in chunks of 2048 bytes: done. 124.63 MB in 5.00 secs: 24=
=2E93 MB/sec
|  Encrypting in chunks of 4096 bytes: done. 162.88 MB in 5.00 secs: 32=
=2E58 MB/sec
|  Encrypting in chunks of 8192 bytes: done. 200.47 MB in 5.00 secs: 40=
=2E09 MB/sec
|  Encrypting in chunks of 16384 bytes: done. 226.61 MB in 5.00 secs: 4=
5.32 MB/sec
|  Encrypting in chunks of 32768 bytes: done. 242.78 MB in 5.00 secs: 4=
8.55 MB/sec
|  Encrypting in chunks of 65536 bytes: done. 251.85 MB in 5.00 secs: 5=
0.36 MB/sec
|
| Testing AES-256-CBC cipher:
|  Encrypting in chunks of 512 bytes: done. 45.15 MB in 5.00 secs: 9.03=
 MB/sec
|  Encrypting in chunks of 1024 bytes: done. 78.72 MB in 5.00 secs: 15.=
74 MB/sec
|  Encrypting in chunks of 2048 bytes: done. 117.59 MB in 5.00 secs: 23=
=2E52 MB/sec
|  Encrypting in chunks of 4096 bytes: done. 151.59 MB in 5.00 secs: 30=
=2E32 MB/sec
|  Encrypting in chunks of 8192 bytes: done. 182.95 MB in 5.00 secs: 36=
=2E59 MB/sec
|  Encrypting in chunks of 16384 bytes: done. 204.00 MB in 5.00 secs: 4=
0.80 MB/sec
|  Encrypting in chunks of 32768 bytes: done. 216.17 MB in 5.00 secs: 4=
3.23 MB/sec
|  Encrypting in chunks of 65536 bytes: done. 223.22 MB in 5.00 secs: 4=
4.64 MB/sec

Observing top while it was running revealed that system load was
decreasing with increased block sizes - ~75% at 512B, ~20% at 32kB. I
fear this is a limitation we have to live with, the overhead of setting
up DMA descriptors and handling the returned data is quite high,
especially when compared to the time it takes the engine to encrypt
512B. I was playing around with descriptor preparation at some point
(i.e. preparing the next descriptor chaing while the engine is active),
but without satisfying results. Maybe I should have another look at it,
especially regarding the case of small chunk sizes. OTOH this all makes
sense only when used asymmetrically, and I have no idea whether dm-cryp=
t
(or fellows like IPsec) makes use of that interface at all.

> > > - My system locked up hard when mv_dma and mv_cesa were built as
> > >   modules. mv_cesa has code to enable the crypto clock in 3.5, bu=
t
> > >   mv_dma already accesses the CESA engine before. Thus, we need t=
o
> > >   enable this clock here, too.
> >=20
> > I have folded them into my patch series, thanks again. I somewhat m=
iss
> > the orion_clkdev_add() part for orion5x platforms, but also fail to=
 find
> > any equivalent place in the correspondent subdirectory. So I hope i=
t is
> > OK like this.
>=20
> The change follows the original clk changes by Andrew. I don't know
> orion5x, but apparently, only kirkwood has such fine grained clock
> gates:
>=20
> /* Create clkdev entries for all orion platforms except kirkwood.
>    Kirkwood has gated clocks for some of its peripherals, so creates
>    its own clkdev entries. For all the other orion devices, create
>    clkdev entries to the tclk. */
>=20
> (from plat-orion/common.c)
>=20
> This is why the clock enabling code in the modules ignores the case
> that the clock can't be found.  I think the clocks defined by
> plat-orion are for those drivers that need the actual TCLK rate (but
> there is no clock gate functionality here).

Ah, OK. Reading helps, they say. Thanks anyway for your explanation.

Greetings, Phil


Phil Sutter
Software Engineer

--=20


Viprinet GmbH
Mainzer Str. 43
55411 Bingen am Rhein
Germany

Phone/Zentrale:         +49-6721-49030-0
Direct line/Durchwahl:  +49-6721-49030-134
=46ax:                    +49-6721-49030-209

phil.sutter@viprinet.com
http://www.viprinet.com

Registered office/Sitz der Gesellschaft: Bingen am Rhein
Commercial register/Handelsregister: Amtsgericht Mainz HRB40380
CEO/Gesch=C3=A4ftsf=C3=BChrer: Simon Kissel
