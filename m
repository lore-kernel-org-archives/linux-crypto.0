From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v2] crypto: caam - free qman_fq after kill_fq
Date: Thu, 13 Jul 2017 09:56:34 +0000
Message-ID: <VI1PR0401MB25910CB1266F42DB5E28909298AC0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170711062107.182889-1-xulin.sun@windriver.com>
 <20170713092101.145505-1-xulin.sun@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xulinsun@gmail.com" <xulinsun@gmail.com>
To: Xulin Sun <xulin.sun@windriver.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0055.outbound.protection.outlook.com ([104.47.1.55]:39117
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750854AbdGMJ4l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2017 05:56:41 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/13/2017 12:21 PM, Xulin Sun wrote:=0A=
> kill_fq removes a complete frame queue, it needs to free the qman_fq=0A=
> in the last. Else kmemleak will report the below warning:=0A=
> =0A=
> unreferenced object 0xffff800073085c80 (size 128):=0A=
>   comm "cryptomgr_test", pid 199, jiffies 4294937850 (age 67.840s)=0A=
>   hex dump (first 32 bytes):=0A=
>     00 00 00 00 00 00 00 00 a0 80 7e 00 00 80 ff ff=0A=
>     00 00 00 00 00 00 00 00 04 00 04 00 5c 01 00 00=0A=
>   backtrace:=0A=
>     [<ffff8000001e5760>] create_object+0xf8/0x258=0A=
>     [<ffff800000994e38>] kmemleak_alloc+0x58/0xa0=0A=
>     [<ffff8000001d5f18>] kmem_cache_alloc_trace+0x2c8/0x358=0A=
>     [<ffff8000007e8410>] create_caam_req_fq+0x40/0x170=0A=
>     [<ffff8000007e870c>] caam_drv_ctx_update+0x54/0x248=0A=
>     [<ffff8000007fca54>] aead_setkey+0x154/0x300=0A=
>     [<ffff800000452120>] setkey+0x50/0xf0=0A=
>     [<ffff80000045b144>] __test_aead+0x5ec/0x1028=0A=
>     [<ffff80000045c28c>] test_aead+0x44/0xc8=0A=
>     [<ffff80000045c368>] alg_test_aead+0x58/0xd0=0A=
>     [<ffff80000045bdb4>] alg_test+0x14c/0x308=0A=
>     [<ffff8000004588e8>] cryptomgr_test+0x50/0x58=0A=
>     [<ffff8000000c3b2c>] kthread+0xdc/0xf0=0A=
>     [<ffff800000083c00>] ret_from_fork+0x10/0x50=0A=
> =0A=
> And check where the function kill_fq() is called to remove=0A=
> the additional kfree to qman_fq and avoid re-calling the released qman_fq=
.=0A=
> =0A=
> Signed-off-by: Xulin Sun <xulin.sun@windriver.com>=0A=
Acked-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
