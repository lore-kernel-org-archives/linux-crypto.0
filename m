From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-crypt] cryptsetup problem on Raspberry Pi 2 w 512bit key-size
 (works on Raspberry Pi 1, x86_64, 256bit)
Date: Mon, 23 Feb 2015 20:03:19 +0100
Message-ID: <54EB7977.70503@gmail.com>
References: <2E68FEAA-A69B-4E25-84F9-F30B2E7DFB69@gmail.com> <54E7B46D.8060805@tu-ilmenau.de> <E401AE9C-F988-4839-AC13-62D4FADD7290@gmail.com> <54E82B80.8000607@gmail.com> <EE112BA4-BDD8-4CB3-BD7B-BDA984D15089@gmail.com> <54EA39FA.7010408@gmail.com> <707C4FCB-0182-44E3-946A-19434F32BEAB@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dm-crypt@saout.de, Lars Winterfeld <lars.winterfeld@tu-ilmenau.de>,
	linux-crypto@vger.kernel.org
To: Johannes Ernst <johannes.ernst@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42845 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbbBWTDY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Feb 2015 14:03:24 -0500
Received: by wghl2 with SMTP id l2so695224wgh.9
        for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2015 11:03:23 -0800 (PST)
In-Reply-To: <707C4FCB-0182-44E3-946A-19434F32BEAB@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/23/2015 07:44 PM, Johannes Ernst wrote:
> 1. There was a (cryptic, to me) comment by one of the core Arch Linux
> ARM developers on my post. He said "Something on my mind about kernel
> mode neon on imx6, can't find it now=E2=80=9D
> (http://archlinuxarm.org/forum/viewtopic.php?f=3D60&t=3D8489&p=3D4539=
5#p45364)
> I have little idea what this could mean, but I figure I pass it on in
> case somebody here does.
>=20
> 2. I disabled the mentioned kernel modules:
>=20
> blacklist af_alg blacklist algif_skcipher
>=20
> and, magic happens, it behaves as intended: cryptsetup opens file on
> first try.

Ok, so it means there is something wrong when using AF_ALG/SKCIPHER
on new Raspberry Pi2.
(Please can you post luksDump as well - just to be sure which mode
and cipher it is - I guess it is aes-xts but cannot find it in log.)

CC kernel crypto api list ... maybe someone knows about known problem h=
ere.

The link to failing cryptsetup debug log for reference:
http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/7973

Thanks,
Milan
