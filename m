From: Karl Hiramoto <karl@hiramoto.org>
Subject: Re: ixp4xx_crypto panic with fragmented packets in scatterlist
Date: Wed, 25 Feb 2009 15:35:48 +0100
Message-ID: <49A55744.3010702@hiramoto.org>
References: <49A2E421.5050806@hiramoto.org> <49A3F3FA.1000801@hiramoto.org> <20090225090735.GA6283@elara.bln.innominate.local> <49A5110B.2050803@hiramoto.org> <20090225115407.GB6283@elara.bln.innominate.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Christian Hohnstaedt <chohnstaedt@innominate.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:55209 "EHLO
	spunkymail-a18.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758602AbZBYOgq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 09:36:46 -0500
In-Reply-To: <20090225115407.GB6283@elara.bln.innominate.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Christian Hohnstaedt wrote:
>
>
> looks like there are different, incompatible sg chaining implementations:
>
> include/crypto/scatterwalk.h:scatterwalk_sg_chain()  uses
> sg->lenght == 0 as indicator for a chained sg
>
> include/linux/scatterlist.h:sg_chain() uses
> bit 0 of sg->page_link to indicate chaining
>
> Maybe the matters for b2ab4a57b018aafbba35bff088218f5cc3d2142e
> are obsolete now...
>
> However the scatterlist iteration in the arm implementation of
> dma_map_sg() uses neither of them, but simply sg++
>
> Please try the attached compile-tested patch.
>
>   
I had to adapt the change in dma_map_sg() a bit for 2.6.28.7.   The
patch  fixed the BUG() and  kernel panic.    But a ping with a
fragmented packet does not get a proper response.

Note: below, the 2nd half of the fragmented packet has the data 0x0000



What i see on   the PC host 192.168.10.51   where the IXP434
(192.168.10.54)  is doing  "ping -s 2000 -c1  192.168.10.51"

 tcpdump -i eth0 -vnXX esp
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 96
bytes
15:28:36.373270 IP (tos 0x0, ttl 64, id 26818, offset 0, flags [+],
proto ESP (50), length 1500) 192.168.10.54 > 192.168.10.51:
ESP(spi=0x00000101,seq=0xd), length 1480
        0x0000:  0015 c509 9b4a 9a39 d3c6 3651 0800 4500  .....J.9..6Q..E.
        0x0010:  05dc 68c2 2000 4032 5674 c0a8 0a36 c0a8  ..h...@2Vt...6..
        0x0020:  0a33 0000 0101 0000 000d 0f22 c952 606e  .3.........".R`n
        0x0030:  3d01 2214 d019 90ae ce7d 7bef 8067 4371  =."......}{..gCq
        0x0040:  6404 e937 0054 9835 a09a 080e ea31 b599  d..7.T.5.....1..
        0x0050:  353a d9a2 1074 3cb3 d856 0da7 13a9 a6c6  5:...t<..V......
15:28:36.373662 IP (tos 0x0, ttl 64, id 26818, offset 1480, flags
[none], proto ESP (50), length 580) 192.168.10.54 > 192.168.10.51: esp
        0x0000:  0015 c509 9b4a 9a39 d3c6 3651 0800 4500  .....J.9..6Q..E.
        0x0010:  0244 68c2 00b9 4032 7953 c0a8 0a36 c0a8  .Dh...@2yS...6..
        0x0020:  0a33 0000 0000 0000 0000 0000 0000 0000  .3..............
        0x0030:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0040:  0000 0000 0000 0000 0000 0000 0000 0000  ................
        0x0050:  0000 0000 0000 0000 0000 0000 0000 0000  ................
15:28:36.373952 IP (tos 0xc0, ttl 64, id 48218, offset 0, flags [none],
proto ESP (50), length 604) 192.168.10.51 > 192.168.10.54:
ESP(spi=0x00000201,seq=0xf), length 584
        0x0000:  9a39 d3c6 3651 0015 c509 9b4a 0800 45c0  .9..6Q.....J..E.
        0x0010:  025c bc5a 0000 4032 259c c0a8 0a33 c0a8  .\.Z..@2%....3..
        0x0020:  0a36 0000 0201 0000 000f a250 69a6 bf1f  .6.........Pi...
        0x0030:  bdc7 9873 1f25 cc84 b3f9 f1cf 2339 36c6  ...s.%......#96.
        0x0040:  fd2a 5097 bcef e915 437a 7c8f bc0b 4905  .*P.....Cz|...I.
        0x0050:  a73b ddb9 1bf9 b54b 6ade c59c ed80 9047  .;.....Kj......G



Thanks

--

Karl
