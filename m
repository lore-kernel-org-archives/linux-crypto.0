Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302B9C432C0
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 01:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0920F206E4
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 01:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfLDBM5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 20:12:57 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:49588 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfLDBM5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 20:12:57 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 38185636C5AEB7794929;
        Wed,  4 Dec 2019 09:12:53 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Wed, 4 Dec 2019
 09:12:43 +0800
Subject: Re: [PATCH v3 4/5] crypto: hisilicon - add DebugFS for HiSilicon SEC
To:     Marco Elver <elver@google.com>
References: <1573643468-1812-1-git-send-email-xuzaibo@huawei.com>
 <1573643468-1812-5-git-send-email-xuzaibo@huawei.com>
 <20191203121217.GA76025@google.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>, <linuxarm@huawei.com>,
        <fanghao11@huawei.com>, <yekai13@huawei.com>,
        <zhangwei375@huawei.com>, <forest.zhouchang@huawei.com>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <d7454cf4-f232-9868-3e87-621786023868@huawei.com>
Date:   Wed, 4 Dec 2019 09:12:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20191203121217.GA76025@google.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,


On 2019/12/3 20:12, Marco Elver wrote:
> Likewise, avoid using __sync builtins and prefer kernel's own
> facilities.
>
> Reported in: https://lore.kernel.org/linux-crypto/CANpmjNM2b26Oo6k-4EqfrJf1sBj3WoFf-NQnwsLr3EW9B=G8kw@mail.gmail.com/
>
> On Wed, 13 Nov 2019, Zaibo Xu wrote:
>
>> The HiSilicon SEC engine driver uses DebugFS
>> to provide main debug information for user space.
>>
>> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>   drivers/crypto/hisilicon/sec2/sec.h        |  23 +++
>>   drivers/crypto/hisilicon/sec2/sec_crypto.c |   3 +
>>   drivers/crypto/hisilicon/sec2/sec_main.c   | 306 +++++++++++++++++++++++++++++
>>   3 files changed, 332 insertions(+)
>>
>> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
>> index 69b37f2..26754d0 100644
>> --- a/drivers/crypto/hisilicon/sec2/sec.h
>> +++ b/drivers/crypto/hisilicon/sec2/sec.h
>> @@ -119,9 +119,32 @@ enum sec_endian {
>>   	SEC_64BE
>>   };
>>   
>> +enum sec_debug_file_index {
>> +	SEC_CURRENT_QM,
>> +	SEC_CLEAR_ENABLE,
>> +	SEC_DEBUG_FILE_NUM,
>> +};
>> +
>> +struct sec_debug_file {
>> +	enum sec_debug_file_index index;
>> +	spinlock_t lock;
>> +	struct hisi_qm *qm;
>> +};
>> +
>> +struct sec_dfx {
>> +	u64 send_cnt;
>> +	u64 recv_cnt;
> These could be atomic_t.
yes.
>
>> +};
>> +
>> +struct sec_debug {
>> +	struct sec_dfx dfx;
>> +	struct sec_debug_file files[SEC_DEBUG_FILE_NUM];
>> +};
>> +
>>   struct sec_dev {
>>   	struct hisi_qm qm;
>>   	struct list_head list;
>> +	struct sec_debug debug;
>>   	u32 ctx_q_num;
>>   	u32 num_vfs;
>>   	unsigned long status;
>> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>> index 23092a9..dc1eb97 100644
>> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
>> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>> @@ -120,6 +120,8 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
>>   		return;
>>   	}
>>   
>> +	__sync_add_and_fetch(&req->ctx->sec->debug.dfx.recv_cnt, 1);
> This could be:
>
> 	atomic_inc(&req->ctx->sec->debug.dfx.recv_cnt);
Agree
>> +
>>   	req->ctx->req_op->buf_unmap(req->ctx, req);
>>   
>>   	req->ctx->req_op->callback(req->ctx, req);
>> @@ -133,6 +135,7 @@ static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
>>   	mutex_lock(&qp_ctx->req_lock);
>>   	ret = hisi_qp_send(qp_ctx->qp, &req->sec_sqe);
>>   	mutex_unlock(&qp_ctx->req_lock);
>> +	__sync_add_and_fetch(&ctx->sec->debug.dfx.send_cnt, 1);
> This could be:
>
> 	atomic_inc(&ctx->sec->debug.dfx.send_cnt);
yes.
>>   
>>   	if (ret == -EBUSY)
>>   		return -ENOBUFS;
>> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
>> index 00dd4c3..74f0654 100644
>> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
>> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
>> @@ -4,6 +4,7 @@
>>   #include <linux/acpi.h>
>>   #include <linux/aer.h>
>>   #include <linux/bitops.h>
>> +#include <linux/debugfs.h>
>>   #include <linux/init.h>
>>   #include <linux/io.h>
>>   #include <linux/kernel.h>
>> @@ -32,6 +33,8 @@
>>   #define SEC_PF_DEF_Q_BASE		0
>>   #define SEC_CTX_Q_NUM_DEF		24
>>   
>> +#define SEC_CTRL_CNT_CLR_CE		0x301120
>> +#define SEC_CTRL_CNT_CLR_CE_BIT		BIT(0)
>>   #define SEC_ENGINE_PF_CFG_OFF		0x300000
>>   #define SEC_ACC_COMMON_REG_OFF		0x1000
>>   #define SEC_CORE_INT_SOURCE		0x301010
>> @@ -72,6 +75,8 @@
>>   
[...]
>> +
>> +static int sec_core_debug_init(struct sec_dev *sec)
>> +{
>> +	struct hisi_qm *qm = &sec->qm;
>> +	struct device *dev = &qm->pdev->dev;
>> +	struct sec_dfx *dfx = &sec->debug.dfx;
>> +	struct debugfs_regset32 *regset;
>> +	struct dentry *tmp_d;
>> +
>> +	tmp_d = debugfs_create_dir("sec_dfx", sec->qm.debug.debug_root);
>> +
>> +	regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
>> +	if (!regset)
>> +		return -ENOENT;
>> +
>> +	regset->regs = sec_dfx_regs;
>> +	regset->nregs = ARRAY_SIZE(sec_dfx_regs);
>> +	regset->base = qm->io_base;
>> +
>> +	debugfs_create_regset32("regs", 0444, tmp_d, regset);
>> +
>> +	debugfs_create_u64("send_cnt", 0444, tmp_d, &dfx->send_cnt);
>> +
>> +	debugfs_create_u64("recv_cnt", 0444, tmp_d, &dfx->recv_cnt);
> These could be changed to 'debugfs_create_atomic_t'. It does not look
> like there is a 64-bit equivalent, however.
>
'debugfs_create_atomic_t ' is preferring, I think.

cheers,
Zaibo

.


