From: Andreas Gerlich <linux-crypto@online.de>
Subject: Re: [PATCH] short benchmarks
Date: Thu, 20 Nov 2008 03:26:16 +0100
Message-ID: <4924CAC8.1070504@online.de>
References: <12271034133347-git-send-email-zbr@ioremap.net> <12271034132587-git-send-email-zbr@ioremap.net> <12271034131753-git-send-email-zbr@ioremap.net> <1227103414646-git-send-email-zbr@ioremap.net> <1227103414418-git-send-email-zbr@ioremap.net> <12271034142436-git-send-email-zbr@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYKTC1K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2008 21:27:10 -0500
In-Reply-To: <12271034142436-git-send-email-zbr@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

here some short benchmarks with the new HIFN 795x driver:
---------------------------------------------------------
Hardware which I use:  net5501-70 with vpn1401 (PCI-Card)
                       (Users with vpn1411 mini-pci-card, please
                        report it if the driver works with this card.)

Software which I use:  Latest stable kernel 2.6.27.6 from
                       www.kernel.org.

Chiper: aes-cbc-essiv:sha256, keysize: 256 bits

With hifn_795x driver:
----------------------------------------------------------------------
(/misc is mounted to the crypted partition)

piepmatz:/misc# time dd if=3D/dev/zero of=3Dxxx.img bs=3D1024 count=3D7=
00000
700000+0 Datens=E4tze ein
700000+0 Datens=E4tze aus
716800000 Bytes (717 MB) kopiert, 68,0707 s, 10,5 MB/s

real    1m9.206s
user    0m0.536s
sys     0m7.312s
piepmatz:/misc# time cat xxx.img >/dev/null

real    1m12.737s
user    0m0.080s
sys     0m2.596s
piepmatz:/misc#

----------------------------------------------------------------------


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

As referece the software implementation of AES:

-----------------------------------------------------------------------=
----
piepmatz:/misc# time dd if=3D/dev/zero of=3Dxxx.img bs=3D1024 count=3D7=
00000
700000+0 Datens=E4tze ein
700000+0 Datens=E4tze aus
716800000 Bytes (717 MB) kopiert, 128,616 s, 5,6 MB/s

real    2m8.711s
user    0m0.616s
sys     0m6.652s
piepmatz:/misc# time cat xxx.img >/dev/null

real    2m2.761s
user    0m0.080s
sys     0m2.368s
piepmatz:/misc#
-----------------------------------------------------------------------=
----

With the HIFN 7955 crypto engine the throughput is 10,5 MB/s, nearly
the double of the software implementation of AES. Therefore the time
is nearly the half.

Regards
Andreas Gerlich
--=20
Andreas Gerlich, University of Ulm, Germany
open source project --> http://yaze-ag.de/ (Yet Another Z80 Emulator)
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
