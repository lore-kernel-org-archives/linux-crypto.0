Return-Path: <SRS0=Wzqe=4C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CB7C352A3
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 01:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD58B217F4
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 01:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgBNBkt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 20:40:49 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2569 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727848AbgBNBkt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 20:40:49 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 1345E3E420F2A9B5488E;
        Fri, 14 Feb 2020 09:40:47 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 14 Feb 2020 09:40:46 +0800
Received: from architecture4 (10.160.196.180) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 14 Feb 2020 09:40:46 +0800
Date:   Fri, 14 Feb 2020 09:39:33 +0800
From:   Gao Xiang <gaoxiang25@huawei.com>
To:     Maksym Planeta <mplaneta@os.inf.tu-dresden.de>
CC:     Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, <dm-devel@redhat.com>,
        Song Liu <song@kernel.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-erofs@lists.ozlabs.org>
Subject: Re: [PATCH] Remove WQ_CPU_INTENSIVE flag from unbound wq's
Message-ID: <20200214013932.GA73422@architecture4>
References: <20200213141823.2174236-1-mplaneta@os.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200213141823.2174236-1-mplaneta@os.inf.tu-dresden.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.160.196.180]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 13, 2020 at 03:18:23PM +0100, Maksym Planeta wrote:
> The documentation [1] says that WQ_CPU_INTENSIVE is "meaningless" for
> unbound wq. I remove this flag from places where unbound queue is
> allocated. This is supposed to improve code readability.
> 
> 1. https://www.kernel.org/doc/html/latest/core-api/workqueue.html#flags
> 
> Signed-off-by: Maksym Planeta <mplaneta@os.inf.tu-dresden.de>
> ---
>  drivers/crypto/hisilicon/qm.c | 3 +--
>  drivers/md/dm-crypt.c         | 2 +-
>  drivers/md/dm-verity-target.c | 2 +-
>  drivers/md/raid5.c            | 2 +-
>  fs/erofs/zdata.c              | 2 +-

I'm okay for EROFS part,

Acked-by: Gao Xiang <gaoxiang25@huawei.com>

Thanks,
Gao Xiang

>  5 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index b57da5ef8b5b..4a39cb2c6a0b 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -1148,8 +1148,7 @@ struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
>  	qp->qp_id = qp_id;
>  	qp->alg_type = alg_type;
>  	INIT_WORK(&qp->work, qm_qp_work_func);
> -	qp->wq = alloc_workqueue("hisi_qm", WQ_UNBOUND | WQ_HIGHPRI |
> -				 WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 0);
> +	qp->wq = alloc_workqueue("hisi_qm", WQ_UNBOUND | WQ_HIGHPRI | WQ_MEM_RECLAIM, 0);
>  	if (!qp->wq) {
>  		ret = -EFAULT;
>  		goto err_free_qp_mem;
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index c6a529873d0f..44d56325fa27 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -3032,7 +3032,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  						  1, devname);
>  	else
>  		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
> -						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
> +						  WQ_MEM_RECLAIM | WQ_UNBOUND,
>  						  num_online_cpus(), devname);
>  	if (!cc->crypt_queue) {
>  		ti->error = "Couldn't create kcryptd queue";
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 0d61e9c67986..20f92c7ea07e 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1190,7 +1190,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	}
>  
>  	/* WQ_UNBOUND greatly improves performance when running on ramdisk */
> -	v->verify_wq = alloc_workqueue("kverityd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
> +	v->verify_wq = alloc_workqueue("kverityd", WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
>  	if (!v->verify_wq) {
>  		ti->error = "Cannot allocate workqueue";
>  		r = -ENOMEM;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ba00e9877f02..cd93a1731b82 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8481,7 +8481,7 @@ static int __init raid5_init(void)
>  	int ret;
>  
>  	raid5_wq = alloc_workqueue("raid5wq",
> -		WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE|WQ_SYSFS, 0);
> +		WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_SYSFS, 0);
>  	if (!raid5_wq)
>  		return -ENOMEM;
>  
> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index 80e47f07d946..b2a679f720e9 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -43,7 +43,7 @@ void z_erofs_exit_zip_subsystem(void)
>  static inline int z_erofs_init_workqueue(void)
>  {
>  	const unsigned int onlinecpus = num_possible_cpus();
> -	const unsigned int flags = WQ_UNBOUND | WQ_HIGHPRI | WQ_CPU_INTENSIVE;
> +	const unsigned int flags = WQ_UNBOUND | WQ_HIGHPRI;
>  
>  	/*
>  	 * no need to spawn too many threads, limiting threads could minimum
> -- 
> 2.24.1
> 
