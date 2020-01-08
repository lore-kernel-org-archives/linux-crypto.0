Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D664C33C99
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 01:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E5502075A
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 01:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgAHBIz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jan 2020 20:08:55 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9121 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbgAHBIz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jan 2020 20:08:55 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 10948CCB81128B92F9C4;
        Wed,  8 Jan 2020 09:08:53 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 8 Jan 2020
 09:08:42 +0800
Subject: Re: [PATCH] crypto: hisilicon/sec2 - Use atomics instead of __sync
To:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Longfang Liu <liulongfang@huawei.com>
References: <20200107200926.3659010-1-arnd@arndb.de>
CC:     Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <b89ff368-31ae-473b-c2c9-3f7b99714781@huawei.com>
Date:   Wed, 8 Jan 2020 09:08:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200107200926.3659010-1-arnd@arndb.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I will send out a patch set soon, which fixes this problem. Thanks.

cheers,

Zaibo

.


On 2020/1/8 4:08, Arnd Bergmann wrote:
> The use of __sync functions for atomic memory access is not
> supported in the kernel, and can result in a link error depending
> on configuration:
>
> ERROR: "__tsan_atomic32_compare_exchange_strong" [drivers/crypto/hisilicon/sec2/hisi_sec2.ko] undefined!
> ERROR: "__tsan_atomic64_fetch_add" [drivers/crypto/hisilicon/sec2/hisi_sec2.ko] undefined!
>
> Use the kernel's own atomic interfaces instead. This way the
> debugfs interface actually reads the counter atomically.
>
> Fixes: 416d82204df4 ("crypto: hisilicon - add HiSilicon SEC V2 driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/crypto/hisilicon/sec2/sec.h        |  6 +++---
>   drivers/crypto/hisilicon/sec2/sec_crypto.c | 12 ++++++------
>   drivers/crypto/hisilicon/sec2/sec_main.c   | 14 ++++++++++++--
>   3 files changed, 21 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
> index 26754d0570ba..b846d73d9a85 100644
> --- a/drivers/crypto/hisilicon/sec2/sec.h
> +++ b/drivers/crypto/hisilicon/sec2/sec.h
> @@ -40,7 +40,7 @@ struct sec_req {
>   	int req_id;
>   
>   	/* Status of the SEC request */
> -	int fake_busy;
> +	atomic_t fake_busy;
>   };
>   
>   /**
> @@ -132,8 +132,8 @@ struct sec_debug_file {
>   };
>   
>   struct sec_dfx {
> -	u64 send_cnt;
> -	u64 recv_cnt;
> +	atomic64_t send_cnt;
> +	atomic64_t recv_cnt;
>   };
>   
>   struct sec_debug {
> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> index 62b04e19067c..0a5391fff485 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> @@ -120,7 +120,7 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
>   		return;
>   	}
>   
> -	__sync_add_and_fetch(&req->ctx->sec->debug.dfx.recv_cnt, 1);
> +	atomic64_inc(&req->ctx->sec->debug.dfx.recv_cnt);
>   
>   	req->ctx->req_op->buf_unmap(req->ctx, req);
>   
> @@ -135,13 +135,13 @@ static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
>   	mutex_lock(&qp_ctx->req_lock);
>   	ret = hisi_qp_send(qp_ctx->qp, &req->sec_sqe);
>   	mutex_unlock(&qp_ctx->req_lock);
> -	__sync_add_and_fetch(&ctx->sec->debug.dfx.send_cnt, 1);
> +	atomic64_inc(&ctx->sec->debug.dfx.send_cnt);
>   
>   	if (ret == -EBUSY)
>   		return -ENOBUFS;
>   
>   	if (!ret) {
> -		if (req->fake_busy)
> +		if (atomic_read(&req->fake_busy))
>   			ret = -EBUSY;
>   		else
>   			ret = -EINPROGRESS;
> @@ -641,7 +641,7 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req)
>   	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && req->c_req.encrypt)
>   		sec_update_iv(req);
>   
> -	if (__sync_bool_compare_and_swap(&req->fake_busy, 1, 0))
> +	if (atomic_cmpxchg(&req->fake_busy, 1, 0) != 1)
>   		sk_req->base.complete(&sk_req->base, -EINPROGRESS);
>   
>   	sk_req->base.complete(&sk_req->base, req->err_type);
> @@ -672,9 +672,9 @@ static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
>   	}
>   
>   	if (ctx->fake_req_limit <= atomic_inc_return(&qp_ctx->pending_reqs))
> -		req->fake_busy = 1;
> +		atomic_set(&req->fake_busy, 1);
>   	else
> -		req->fake_busy = 0;
> +		atomic_set(&req->fake_busy, 0);
>   
>   	ret = ctx->req_op->get_res(ctx, req);
>   	if (ret) {
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index 74f0654028c9..ab742dfbab99 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -608,6 +608,14 @@ static const struct file_operations sec_dbg_fops = {
>   	.write = sec_debug_write,
>   };
>   
> +static int debugfs_atomic64_t_get(void *data, u64 *val)
> +{
> +        *val = atomic64_read((atomic64_t *)data);
> +        return 0;
> +}
> +DEFINE_DEBUGFS_ATTRIBUTE(fops_atomic64_t_ro, debugfs_atomic64_t_get, NULL,
> +                        "%lld\n");
> +
>   static int sec_core_debug_init(struct sec_dev *sec)
>   {
>   	struct hisi_qm *qm = &sec->qm;
> @@ -628,9 +636,11 @@ static int sec_core_debug_init(struct sec_dev *sec)
>   
>   	debugfs_create_regset32("regs", 0444, tmp_d, regset);
>   
> -	debugfs_create_u64("send_cnt", 0444, tmp_d, &dfx->send_cnt);
> +	debugfs_create_file("send_cnt", 0444, tmp_d, &dfx->send_cnt,
> +			    &fops_atomic64_t_ro);
>   
> -	debugfs_create_u64("recv_cnt", 0444, tmp_d, &dfx->recv_cnt);
> +	debugfs_create_file("recv_cnt", 0444, tmp_d, &dfx->recv_cnt,
> +			    &fops_atomic64_t_ro);
>   
>   	return 0;
>   }


