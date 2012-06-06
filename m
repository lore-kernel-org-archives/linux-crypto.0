From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: mv_cesa 1920 limit still happening
Date: Wed, 6 Jun 2012 16:31:41 +0200
Message-ID: <20120606143141.GC9122@philter.vipri.net>
References: <4E322BC03786A946BBEEBD86B35E53F3013F45@EXMBX11.netplexity.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ajay Matai <ajay@symform.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47815 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab2FFObx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Jun 2012 10:31:53 -0400
Content-Disposition: inline
In-Reply-To: <4E322BC03786A946BBEEBD86B35E53F3013F45@EXMBX11.netplexity.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Tue, Jun 05, 2012 at 08:36:18PM +0000, Ajay Matai wrote:
>  I am running QNAP NAS device with Marvell SoC and having issues with=
 both AES and SHA1 when accelerated through mv_cesa. Both the encryptio=
n and hash algorithms work fine for file sizes up to 1920 bytes, while =
anything greater than that gets broken (comparing AES with openssl and =
SHA1 output with sha1sum command).
>=20
> This is what I have done:
> Back ported the mv_cesa driver from linux-3.4.rc7 to linux-2.6.33.2
> Built and insmoded the driver, which loads fine and the algorithms sh=
ow up in /proc/crypto
>=20
> The kernel/userspace interface is provided by crypto-linux-1.4
                                                ~~~~~~~~~~~~
This should read "cryptodev-linux", I guess?

> Unfortunately, I am unable to test mv_cesa with latest kernel as this=
 device is running linux-2.6.33.2 and QNAP has not made linux-3.x based=
 firmware available.
>=20
> Here's the CPU info:
> [/share/HDA_DATA/Public/linux-3.4-rc7/drivers/crypto] # cat /proc/cpu=
info
> Processor       : Feroceon 88F6281 rev 1 (v5l)
> BogoMIPS        : 799.53
> Features        : swp half thumb fastmult edsp
> CPU implementer : 0x56
> CPU architecture: 5TE
> CPU variant     : 0x2
> CPU part        : 0x131
> CPU revision    : 1
>=20
> Hardware        : Feroceon-KW ARM
> Revision        : 0000
> Serial          : 0000000000000000
>=20
> Do you think this is a genuine bug or an artifact of running mv_cesa =
under linux-2.6.33.2 ?
> Thanks for any help.

This should not happen unless there were some crucial changes to the
infrastructure in between 2.6.33.2 and 2.6.39.2 (which we're using
here).=20

You're using the hmac_comp tool, right? Did you hexdump and compare the
results already? Does encryption/hashing of blocks > 1920bytes fail
every time, also on first try (call 'hmac_comp 1920')?

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
