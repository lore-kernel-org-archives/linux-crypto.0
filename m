Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:44800
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726791AbeLJOPV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 09:15:21 -0500
From: Horia Geanta <horia.geanta@nxp.com>
To: Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Aymen Sghaier <aymen.sghaier@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - fix setting IV after decrypt
Date: Mon, 10 Dec 2018 14:15:16 +0000
Message-ID: <VI1PR0402MB34855C6F8F7B08C0DF884B8898A50@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20181207113123.3394-1-s.hauer@pengutronix.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/7/2018 1:32 PM, Sascha Hauer wrote:=0A=
> The crypto API wants the updated IV in req->info after decryption. The=0A=
> updated IV used to be copied correctly to req->info after running the=0A=
> decryption job. Since 115957bb3e59 this is done before running the job=0A=
> so instead of the updated IV only the unmodified input IV is given back=
=0A=
> to the crypto API.=0A=
> =0A=
Saving IV before running the decryption was done to address in-place cbc=0A=
decryption - when the last block is overwritten with plaintext before havin=
g the=0A=
chance to copy it.=0A=
=0A=
Current IV update scheme is ok for cbc (IV <- last ciphertext block), howev=
er=0A=
for ctr the counter should be saved instead; this has to be addressed, but =
IMHO=0A=
is not the root cause for gcm failure.=0A=
=0A=
> This was observed running the gcm(aes) selftest which internally uses=0A=
> ctr(aes) implemented by the CAAM engine.=0A=
> =0A=
I don't see how this patch solves the gcm case you are mentioning, i.e.=0A=
gcm_base(ctr-aes-caam,ghash-generic).=0A=
The IV, updated by ctr(aes) CAAM implementation, doesn't seem to be used=0A=
afterwards - in ghash from gcm SW implementation (crypto/gcm.c).=0A=
=0A=
Considering lack of HW coherency on i.MX, I would rather check whether cach=
eline=0A=
sharing is the culprit - see previous discussion:=0A=
https://patchwork.kernel.org/patch/9801965/=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
