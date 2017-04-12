From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH -next] crypto: caam - fix error return code in
 caam_qi_init()
Date: Wed, 12 Apr 2017 08:18:06 +0000
Message-ID: <VI1PR0401MB25918941634FF14CEE454A2998030@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170411160409.18430-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0071.outbound.protection.outlook.com ([104.47.2.71]:20945
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752725AbdDLISK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2017 04:18:10 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/11/2017 7:04 PM, Wei Yongjun wrote:=0A=
> From: Wei Yongjun <weiyongjun1@huawei.com>=0A=
> =0A=
> Fix to return error code -ENOMEM from the kmem_cache_create() error=0A=
> handling case instead of 0(err is 0 here), as done elsewhere in this=0A=
> function.=0A=
> =0A=
> Fixes: 67c2315def06 ("crypto: caam - add Queue Interface (QI) backend sup=
port")=0A=
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>=0A=
Acked-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
