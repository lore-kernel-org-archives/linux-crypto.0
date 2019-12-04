Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DBFC432C0
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 01:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85E8A2073B
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 01:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfLDBKn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 20:10:43 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6743 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfLDBKn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 20:10:43 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BF9586C4C0B7FB096718;
        Wed,  4 Dec 2019 09:10:36 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Wed, 4 Dec 2019
 09:10:24 +0800
Subject: Re: [PATCH v3 1/5] crypto: hisilicon - add HiSilicon SEC V2 driver
To:     Marco Elver <elver@google.com>
References: <1573643468-1812-1-git-send-email-xuzaibo@huawei.com>
 <1573643468-1812-2-git-send-email-xuzaibo@huawei.com>
 <20191203120148.GA68157@google.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>, <linuxarm@huawei.com>,
        <fanghao11@huawei.com>, <yekai13@huawei.com>,
        <zhangwei375@huawei.com>, <forest.zhouchang@huawei.com>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <4c45461f-7c72-8f3c-4785-3a119383df0b@huawei.com>
Date:   Wed, 4 Dec 2019 09:10:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20191203120148.GA68157@google.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 2019/12/3 20:01, Marco Elver wrote:
> Avoid using __sync builtins and instead prefer the kernel's own
> facilities:
>
> See comments below for suggestions, preserving the assumed memory
> ordering requirements (but please double-check). By using atomic_t
> instead of __sync, you'd also avoid any data races due to plain
> concurrent accesses.
>
> Reported in: https://lore.kernel.org/linux-crypto/CANpmjNM2b26Oo6k-4EqfrJf1sBj3WoFf-NQnwsLr3EW9B=G8kw@mail.gmail.com/
Okay, I will check, and send out a patch to fixed them, thanks.

>
> On Wed, 13 Nov 2019, Zaibo Xu wrote:
>
>> SEC driver provides PCIe hardware device initiation with
>> AES, SM4, and 3DES skcipher algorithms registered to Crypto.
>> It uses Hisilicon QM as interface to CPU.
>>
>> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>   drivers/crypto/hisilicon/Kconfig           |  16 +
>>   drivers/crypto/hisilicon/Makefile          |   1 +
>>   drivers/crypto/hisilicon/sec2/Makefile     |   2 +
>>   drivers/crypto/hisilicon/sec2/sec.h        | 132 +++++
>>   drivers/crypto/hisilicon/sec2/sec_crypto.c | 886 +++++++++++++++++++++++++++++
>>   drivers/crypto/hisilicon/sec2/sec_crypto.h | 198 +++++++
>>   drivers/crypto/hisilicon/sec2/sec_main.c   | 640 +++++++++++++++++++++
>>   7 files changed, 1875 insertions(+)
>>   create mode 100644 drivers/crypto/hisilicon/sec2/Makefile
>>   create mode 100644 drivers/crypto/hisilicon/sec2/sec.h
>>   create mode 100644 drivers/crypto/hisilicon/sec2/sec_crypto.c
>>   create mode 100644 drivers/crypto/hisilicon/sec2/sec_crypto.h
>>   create mode 100644 drivers/crypto/hisilicon/sec2/sec_main.c
> [...]
>> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
>> new file mode 100644
>> index 0000000..443b6c5
>> --- /dev/null
>> +++ b/drivers/crypto/hisilicon/sec2/sec.h
>> @@ -0,0 +1,132 @@
> [...]
>> +
>> +/* SEC request of Crypto */
>> +struct sec_req {
>> +	struct sec_sqe sec_sqe;
>> +	struct sec_ctx *ctx;
>> +	struct sec_qp_ctx *qp_ctx;
>> +
>> +	/* Cipher supported only at present */
>> +	struct sec_cipher_req c_req;
>> +	int err_type;
>> +	int req_id;
>> +
>> +	/* Status of the SEC request */
>> +	int fake_busy;
> This could be
>
> 	atomic_t fake_busy;
Yes, atomic_t is better.
>
>> +};
>> +
> [...]
>> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>> new file mode 100644
>> index 0000000..23092a9
>> --- /dev/null
>> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>> @@ -0,0 +1,886 @@
> Add
>
> 	#include <linux/atomic.h>
Okay.
>
> [...]
>> +static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
>> +{
>> +	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
>> +	int ret;
>> +
>> +	mutex_lock(&qp_ctx->req_lock);
>> +	ret = hisi_qp_send(qp_ctx->qp, &req->sec_sqe);
>> +	mutex_unlock(&qp_ctx->req_lock);
>> +
>> +	if (ret == -EBUSY)
>> +		return -ENOBUFS;
>> +
>> +	if (!ret) {
>> +		if (req->fake_busy)
> This could be:
>
> 	atomic_read(&req->fake_busy)
yes.
>
>> +			ret = -EBUSY;
>> +		else
>> +			ret = -EINPROGRESS;
>> +	}
>> +
>> +	return ret;
>> +}
> [...]
>> +static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req)
>> +{
>> +	struct skcipher_request *sk_req = req->c_req.sk_req;
>> +	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
>> +
>> +	atomic_dec(&qp_ctx->pending_reqs);
>> +	sec_free_req_id(req);
>> +
>> +	/* IV output at encrypto of CBC mode */
>> +	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && req->c_req.encrypt)
>> +		sec_update_iv(req);
>> +
>> +	if (__sync_bool_compare_and_swap(&req->fake_busy, 1, 0))
> This could be:
>
> 	int expect_val = 1;
> 	...
> 	if (atomic_try_cmpxchg_relaxed(&req->fake_busy, &expect_val, 0))
okay
>
>> +		sk_req->base.complete(&sk_req->base, -EINPROGRESS);
>> +
>> +	sk_req->base.complete(&sk_req->base, req->err_type);
>> +}
>> +
>> +static void sec_request_uninit(struct sec_ctx *ctx, struct sec_req *req)
>> +{
>> +	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
>> +
>> +	atomic_dec(&qp_ctx->pending_reqs);
>> +	sec_free_req_id(req);
>> +	sec_put_queue_id(ctx, req);
>> +}
>> +
>> +static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
>> +{
>> +	struct sec_qp_ctx *qp_ctx;
>> +	int issue_id, ret;
>> +
>> +	/* To load balance */
>> +	issue_id = sec_get_queue_id(ctx, req);
>> +	qp_ctx = &ctx->qp_ctx[issue_id];
>> +
>> +	req->req_id = sec_alloc_req_id(req, qp_ctx);
>> +	if (req->req_id < 0) {
>> +		sec_put_queue_id(ctx, req);
>> +		return req->req_id;
>> +	}
>> +
>> +	if (ctx->fake_req_limit <= atomic_inc_return(&qp_ctx->pending_reqs))
>> +		req->fake_busy = 1;
>> +	else
>> +		req->fake_busy = 0;
> These could be:
>
> 	atomic_set(&req->fake_busy, ...)
Yes, thanks.

cheers,
Zaibo
.
>


