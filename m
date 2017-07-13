From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam - free qman_fq after kill_fq
Date: Thu, 13 Jul 2017 07:01:05 +0000
Message-ID: <VI1PR0401MB2591EA98C70A9701ED2981AE98AC0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170711062107.182889-1-xulin.sun@windriver.com>
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
Received: from mail-ve1eur01on0083.outbound.protection.outlook.com ([104.47.1.83]:12224
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751036AbdGMHBN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2017 03:01:13 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/11/2017 9:21 AM, Xulin Sun wrote:=0A=
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
> the additional kfree to qman_fq.=0A=
> =0A=
> Signed-off-by: Xulin Sun <xulin.sun@windriver.com>=0A=
> ---=0A=
>  drivers/crypto/caam/qi.c | 2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c=0A=
> index 1990ed4..c4b9173 100644=0A=
> --- a/drivers/crypto/caam/qi.c=0A=
> +++ b/drivers/crypto/caam/qi.c=0A=
> @@ -277,6 +277,7 @@ static int kill_fq(struct device *qidev, struct qman_=
fq *fq)=0A=
>  		dev_err(qidev, "OOS of FQID: %u failed\n", fq->fqid);=0A=
>  =0A=
>  	qman_destroy_fq(fq);=0A=
> +	kfree(fq);=0A=
=0A=
There is a case where kfree(fq) is executed and kill_fq() returns !=3D 0 -=
=0A=
that is when qman_oos_fq() returns !=3D 0.=0A=
=0A=
Thus please make sure there is no reference to "fq" after kill_fq(...,=0A=
fq) is called, even if kill_fq() return code is !=3D 0.=0A=
For e.g.:=0A=
	if (kill_fq(qidev, new_fq))=0A=
		dev_warn(qidev, "New CAAM FQ: %u kill failed\n",=0A=
                         new_fq->fqid);=0A=
                         ^^^^^^ already kfree-ed=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
>  =0A=
>  	return ret;=0A=
>  }=0A=
> @@ -511,7 +512,6 @@ int caam_qi_shutdown(struct device *qidev)=0A=
>  =0A=
>  		if (kill_fq(qidev, per_cpu(pcpu_qipriv.rsp_fq, i)))=0A=
>  			dev_err(qidev, "Rsp FQ kill failed, cpu: %d\n", i);=0A=
> -		kfree(per_cpu(pcpu_qipriv.rsp_fq, i));=0A=
>  	}=0A=
>  =0A=
>  	/*=0A=
> =0A=
