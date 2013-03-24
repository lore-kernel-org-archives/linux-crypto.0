From: Joel A Fernandes <agnel.joel@gmail.com>
Subject: RFC: Crypto performance (omap-sham)
Date: Sun, 24 Mar 2013 20:12:03 +0530
Message-ID: <CAD=GYpaZPwa3mjPN7V6Yt+bMAvw23x=VL25YA8L+vmJ5hQZhgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
	mgreer@animalcreek.com, Ruben <rperez@ti.com>,
	"Porter, Matt" <mporter@ti.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-omap-owner@vger.kernel.org>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

I thought to open a thread on discussing some comparison numbers I=92ve
seen of linux kernel crypto drivers (am33xx device) vs baremetal code.
It feels that the performance is considerably lower with the kernel
crypto driver.

Comparing the 2 setups:
No-os code (Starterware):
Buffersize 8MB in DDR2 (266MHz beaglebone). Single EDMA channel setup
to write to SHA.  110MB/s throughput for crypto SHA operations.

Switching to Linux, And using OpenSSL, the maximum throughput seen so
far is =3D~ 60MB/s  as seen from [1] . This is the standard output of
"openssl speed".

Tracing and reading code, it seems the kernel needs to =93setup=94 afte=
r
every block during the update operation. CPU cycles take considerable
amount the time that needs to be spent just transferring data from DDR
to SHA without _any_ CPU intervention. I have seen some improvement
but not much by increasing BUFSIZE in omap-sham from 4096 to 8192.

One idea I've been contemplating is to possibly perform a lazy DMA:
During Crypto update operation, no DMA is really performed, rather the
data is appended to a physically contiguous buffer. Once the data
accumulates enough or we=92re in the final operation, an EDMA is
performed quickly enough.

Another option I=92ve seen to speed things up on the no-os code side is
to setup an intermediate fast buffer to ping-pong stuff between DDR
and SHA. Since the fast buffer is internal to the SoC, it results in a
good performance improvement. This can be done as a secondary
improvement to improve the perf once the above is addressed.

Summarizing, I think the main bottle neck is the need to have to setup
EDMA for every page, which I feel hurts performance. When there is a
large buffer to SHA, the CPU should set everything up once and then
not have to touch anything till the SHA is done.

Thanks,
Joel Fernandes

[1] http://processors.wiki.ti.com/index.php/AM335x_Crypto_Performance
--
To unsubscribe from this list: send the line "unsubscribe linux-omap" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
