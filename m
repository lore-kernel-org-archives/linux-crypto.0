Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7753AC432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 12:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3304E2070A
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 12:12:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ovlderoV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfLCMM2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 07:12:28 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34375 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLCMM2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 07:12:28 -0500
Received: by mail-wr1-f68.google.com with SMTP id t2so3424384wrr.1
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2019 04:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=egfxZvN+cvsQtmBow/3PPW55svDd9ZmHAX6h31xjP1k=;
        b=ovlderoV0HSu1wcavNqCuuo2rKc5iHLKcRlAd/3gkcPClL/4WrItCD/jWzoU0NAXRm
         DE2jPwGvhboPua0SdlFXzd0IkIzrr6PGmhkR4uKcfPhBvjTUMmHKsoaTFBYpULJA6r8E
         5/EMxEvgvhe+WSQ6YtNarceo2yBvZSvrPYQXYPGXNj3LD152NOS5yiCe1hSL2rvClB5T
         QfWDwG33zBTV6amcUIwtOame47w/PbbRPvi991hsRQCjf53qnxvygwotwZa9QSFL1baR
         VurpzSQQBOGV2gUPbiX1Tv0X2n5wDBpMw5trH52XjC71p0yF9Pshi0DoIJ82O3oy7PRv
         r2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=egfxZvN+cvsQtmBow/3PPW55svDd9ZmHAX6h31xjP1k=;
        b=d6jXZNbvXuFSZwKbAK3//bJbuujloYpyCBSfeXC7ouzqyc5RbHLZnDHaEfz59f+cr1
         WuWWWIyBeu5QY3ZqkzRY+hMqM6Q93OYu1ziiXR+ZP1JKlxTgDIweao53Z9ohL6QmjeKl
         b1jpfS/bCVvmmH5RzF0gje1/7QbUVbURZKIeVQlXRbraKd3/quEKTQ1dvCS5otCkR/ie
         wtWEL2w+ISuGATUXX86WWi9Om6HR2FA3ejnymoHU0JYgQy4Ugn+cF7+reRwhvymd9rzu
         kfDDYoizAKTmqU+YhsJFw+oQI5WTIFjSb4Di1zTSk+7x0J5E53LhaqBAMFoUou63s+g7
         orVA==
X-Gm-Message-State: APjAAAXazdcl/4XrYhUZDJPjVQDFZ6/IPyTtQ7PGCaBOginOHkddhNTJ
        92wFk28iYxIgDw+HIclNbGy3NQ==
X-Google-Smtp-Source: APXvYqypW4VdP2nQ/akyIA/sX0je4Iy7eJcaf29xIGUv1fgNLHlJGfUga1cUaAUbLonsR112hz2L0w==
X-Received: by 2002:a5d:4acb:: with SMTP id y11mr5001746wrs.106.1575375144057;
        Tue, 03 Dec 2019 04:12:24 -0800 (PST)
Received: from google.com ([100.105.32.75])
        by smtp.gmail.com with ESMTPSA id c1sm2588468wmk.22.2019.12.03.04.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 04:12:23 -0800 (PST)
Date:   Tue, 3 Dec 2019 13:12:17 +0100
From:   Marco Elver <elver@google.com>
To:     Zaibo Xu <xuzaibo@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com, linuxarm@huawei.com, fanghao11@huawei.com,
        yekai13@huawei.com, zhangwei375@huawei.com,
        forest.zhouchang@huawei.com
Subject: Re: [PATCH v3 4/5] crypto: hisilicon - add DebugFS for HiSilicon SEC
Message-ID: <20191203121217.GA76025@google.com>
References: <1573643468-1812-1-git-send-email-xuzaibo@huawei.com>
 <1573643468-1812-5-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573643468-1812-5-git-send-email-xuzaibo@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Likewise, avoid using __sync builtins and prefer kernel's own
facilities.

Reported in: https://lore.kernel.org/linux-crypto/CANpmjNM2b26Oo6k-4EqfrJf1sBj3WoFf-NQnwsLr3EW9B=G8kw@mail.gmail.com/

On Wed, 13 Nov 2019, Zaibo Xu wrote:

> The HiSilicon SEC engine driver uses DebugFS
> to provide main debug information for user space.
> 
> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec.h        |  23 +++
>  drivers/crypto/hisilicon/sec2/sec_crypto.c |   3 +
>  drivers/crypto/hisilicon/sec2/sec_main.c   | 306 +++++++++++++++++++++++++++++
>  3 files changed, 332 insertions(+)
> 
> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
> index 69b37f2..26754d0 100644
> --- a/drivers/crypto/hisilicon/sec2/sec.h
> +++ b/drivers/crypto/hisilicon/sec2/sec.h
> @@ -119,9 +119,32 @@ enum sec_endian {
>  	SEC_64BE
>  };
>  
> +enum sec_debug_file_index {
> +	SEC_CURRENT_QM,
> +	SEC_CLEAR_ENABLE,
> +	SEC_DEBUG_FILE_NUM,
> +};
> +
> +struct sec_debug_file {
> +	enum sec_debug_file_index index;
> +	spinlock_t lock;
> +	struct hisi_qm *qm;
> +};
> +
> +struct sec_dfx {
> +	u64 send_cnt;
> +	u64 recv_cnt;

These could be atomic_t.

> +};
> +
> +struct sec_debug {
> +	struct sec_dfx dfx;
> +	struct sec_debug_file files[SEC_DEBUG_FILE_NUM];
> +};
> +
>  struct sec_dev {
>  	struct hisi_qm qm;
>  	struct list_head list;
> +	struct sec_debug debug;
>  	u32 ctx_q_num;
>  	u32 num_vfs;
>  	unsigned long status;
> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> index 23092a9..dc1eb97 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> @@ -120,6 +120,8 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
>  		return;
>  	}
>  
> +	__sync_add_and_fetch(&req->ctx->sec->debug.dfx.recv_cnt, 1);

This could be:

	atomic_inc(&req->ctx->sec->debug.dfx.recv_cnt);

> +
>  	req->ctx->req_op->buf_unmap(req->ctx, req);
>  
>  	req->ctx->req_op->callback(req->ctx, req);
> @@ -133,6 +135,7 @@ static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
>  	mutex_lock(&qp_ctx->req_lock);
>  	ret = hisi_qp_send(qp_ctx->qp, &req->sec_sqe);
>  	mutex_unlock(&qp_ctx->req_lock);
> +	__sync_add_and_fetch(&ctx->sec->debug.dfx.send_cnt, 1);

This could be:

	atomic_inc(&ctx->sec->debug.dfx.send_cnt);

>  
>  	if (ret == -EBUSY)
>  		return -ENOBUFS;
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index 00dd4c3..74f0654 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -4,6 +4,7 @@
>  #include <linux/acpi.h>
>  #include <linux/aer.h>
>  #include <linux/bitops.h>
> +#include <linux/debugfs.h>
>  #include <linux/init.h>
>  #include <linux/io.h>
>  #include <linux/kernel.h>
> @@ -32,6 +33,8 @@
>  #define SEC_PF_DEF_Q_BASE		0
>  #define SEC_CTX_Q_NUM_DEF		24
>  
> +#define SEC_CTRL_CNT_CLR_CE		0x301120
> +#define SEC_CTRL_CNT_CLR_CE_BIT		BIT(0)
>  #define SEC_ENGINE_PF_CFG_OFF		0x300000
>  #define SEC_ACC_COMMON_REG_OFF		0x1000
>  #define SEC_CORE_INT_SOURCE		0x301010
> @@ -72,6 +75,8 @@
>  
>  #define SEC_DELAY_10_US			10
>  #define SEC_POLL_TIMEOUT_US		1000
> +#define SEC_VF_CNT_MASK			0xffffffc0
> +#define SEC_DBGFS_VAL_MAX_LEN		20
>  
>  #define SEC_ADDR(qm, offset) ((qm)->io_base + (offset) + \
>  			     SEC_ENGINE_PF_CFG_OFF + SEC_ACC_COMMON_REG_OFF)
> @@ -82,6 +87,7 @@ struct sec_hw_error {
>  };
>  
>  static const char sec_name[] = "hisi_sec2";
> +static struct dentry *sec_debugfs_root;
>  static LIST_HEAD(sec_list);
>  static DEFINE_MUTEX(sec_list_lock);
>  
> @@ -129,6 +135,35 @@ struct sec_dev *sec_find_device(int node)
>  	return ret;
>  }
>  
> +static const char * const sec_dbg_file_name[] = {
> +	[SEC_CURRENT_QM] = "current_qm",
> +	[SEC_CLEAR_ENABLE] = "clear_enable",
> +};
> +
> +static struct debugfs_reg32 sec_dfx_regs[] = {
> +	{"SEC_PF_ABNORMAL_INT_SOURCE    ",  0x301010},
> +	{"SEC_SAA_EN                    ",  0x301270},
> +	{"SEC_BD_LATENCY_MIN            ",  0x301600},
> +	{"SEC_BD_LATENCY_MAX            ",  0x301608},
> +	{"SEC_BD_LATENCY_AVG            ",  0x30160C},
> +	{"SEC_BD_NUM_IN_SAA0            ",  0x301670},
> +	{"SEC_BD_NUM_IN_SAA1            ",  0x301674},
> +	{"SEC_BD_NUM_IN_SEC             ",  0x301680},
> +	{"SEC_ECC_1BIT_CNT              ",  0x301C00},
> +	{"SEC_ECC_1BIT_INFO             ",  0x301C04},
> +	{"SEC_ECC_2BIT_CNT              ",  0x301C10},
> +	{"SEC_ECC_2BIT_INFO             ",  0x301C14},
> +	{"SEC_BD_SAA0                   ",  0x301C20},
> +	{"SEC_BD_SAA1                   ",  0x301C24},
> +	{"SEC_BD_SAA2                   ",  0x301C28},
> +	{"SEC_BD_SAA3                   ",  0x301C2C},
> +	{"SEC_BD_SAA4                   ",  0x301C30},
> +	{"SEC_BD_SAA5                   ",  0x301C34},
> +	{"SEC_BD_SAA6                   ",  0x301C38},
> +	{"SEC_BD_SAA7                   ",  0x301C3C},
> +	{"SEC_BD_SAA8                   ",  0x301C40},
> +};
> +
>  static int sec_pf_q_num_set(const char *val, const struct kernel_param *kp)
>  {
>  	struct pci_dev *pdev;
> @@ -335,6 +370,19 @@ static int sec_set_user_domain_and_cache(struct sec_dev *sec)
>  	return sec_engine_init(sec);
>  }
>  
> +/* sec_debug_regs_clear() - clear the sec debug regs */
> +static void sec_debug_regs_clear(struct hisi_qm *qm)
> +{
> +	/* clear current_qm */
> +	writel(0x0, qm->io_base + QM_DFX_MB_CNT_VF);
> +	writel(0x0, qm->io_base + QM_DFX_DB_CNT_VF);
> +
> +	/* clear rdclr_en */
> +	writel(0x0, qm->io_base + SEC_CTRL_CNT_CLR_CE);
> +
> +	hisi_qm_debug_regs_clear(qm);
> +}
> +
>  static void sec_hw_error_enable(struct sec_dev *sec)
>  {
>  	struct hisi_qm *qm = &sec->qm;
> @@ -407,6 +455,235 @@ static void sec_hw_error_uninit(struct sec_dev *sec)
>  	writel(GENMASK(12, 0), sec->qm.io_base + SEC_QM_ABNORMAL_INT_MASK);
>  }
>  
> +static u32 sec_current_qm_read(struct sec_debug_file *file)
> +{
> +	struct hisi_qm *qm = file->qm;
> +
> +	return readl(qm->io_base + QM_DFX_MB_CNT_VF);
> +}
> +
> +static int sec_current_qm_write(struct sec_debug_file *file, u32 val)
> +{
> +	struct hisi_qm *qm = file->qm;
> +	struct sec_dev *sec = container_of(qm, struct sec_dev, qm);
> +	u32 vfq_num;
> +	u32 tmp;
> +
> +	if (val > sec->num_vfs)
> +		return -EINVAL;
> +
> +	/* According PF or VF Dev ID to calculation curr_qm_qp_num and store */
> +	if (!val) {
> +		qm->debug.curr_qm_qp_num = qm->qp_num;
> +	} else {
> +		vfq_num = (qm->ctrl_qp_num - qm->qp_num) / sec->num_vfs;
> +
> +		if (val == sec->num_vfs)
> +			qm->debug.curr_qm_qp_num =
> +				qm->ctrl_qp_num - qm->qp_num -
> +				(sec->num_vfs - 1) * vfq_num;
> +		else
> +			qm->debug.curr_qm_qp_num = vfq_num;
> +	}
> +
> +	writel(val, qm->io_base + QM_DFX_MB_CNT_VF);
> +	writel(val, qm->io_base + QM_DFX_DB_CNT_VF);
> +
> +	tmp = val |
> +	      (readl(qm->io_base + QM_DFX_SQE_CNT_VF_SQN) & CURRENT_Q_MASK);
> +	writel(tmp, qm->io_base + QM_DFX_SQE_CNT_VF_SQN);
> +
> +	tmp = val |
> +	      (readl(qm->io_base + QM_DFX_CQE_CNT_VF_CQN) & CURRENT_Q_MASK);
> +	writel(tmp, qm->io_base + QM_DFX_CQE_CNT_VF_CQN);
> +
> +	return 0;
> +}
> +
> +static u32 sec_clear_enable_read(struct sec_debug_file *file)
> +{
> +	struct hisi_qm *qm = file->qm;
> +
> +	return readl(qm->io_base + SEC_CTRL_CNT_CLR_CE) &
> +			SEC_CTRL_CNT_CLR_CE_BIT;
> +}
> +
> +static int sec_clear_enable_write(struct sec_debug_file *file, u32 val)
> +{
> +	struct hisi_qm *qm = file->qm;
> +	u32 tmp;
> +
> +	if (val != 1 && val)
> +		return -EINVAL;
> +
> +	tmp = (readl(qm->io_base + SEC_CTRL_CNT_CLR_CE) &
> +	       ~SEC_CTRL_CNT_CLR_CE_BIT) | val;
> +	writel(tmp, qm->io_base + SEC_CTRL_CNT_CLR_CE);
> +
> +	return 0;
> +}
> +
> +static ssize_t sec_debug_read(struct file *filp, char __user *buf,
> +			       size_t count, loff_t *pos)
> +{
> +	struct sec_debug_file *file = filp->private_data;
> +	char tbuf[SEC_DBGFS_VAL_MAX_LEN];
> +	u32 val;
> +	int ret;
> +
> +	spin_lock_irq(&file->lock);
> +
> +	switch (file->index) {
> +	case SEC_CURRENT_QM:
> +		val = sec_current_qm_read(file);
> +		break;
> +	case SEC_CLEAR_ENABLE:
> +		val = sec_clear_enable_read(file);
> +		break;
> +	default:
> +		spin_unlock_irq(&file->lock);
> +		return -EINVAL;
> +	}
> +
> +	spin_unlock_irq(&file->lock);
> +	ret = snprintf(tbuf, SEC_DBGFS_VAL_MAX_LEN, "%u\n", val);
> +
> +	return simple_read_from_buffer(buf, count, pos, tbuf, ret);
> +}
> +
> +static ssize_t sec_debug_write(struct file *filp, const char __user *buf,
> +			       size_t count, loff_t *pos)
> +{
> +	struct sec_debug_file *file = filp->private_data;
> +	char tbuf[SEC_DBGFS_VAL_MAX_LEN];
> +	unsigned long val;
> +	int len, ret;
> +
> +	if (*pos != 0)
> +		return 0;
> +
> +	if (count >= SEC_DBGFS_VAL_MAX_LEN)
> +		return -ENOSPC;
> +
> +	len = simple_write_to_buffer(tbuf, SEC_DBGFS_VAL_MAX_LEN - 1,
> +				     pos, buf, count);
> +	if (len < 0)
> +		return len;
> +
> +	tbuf[len] = '\0';
> +	if (kstrtoul(tbuf, 0, &val))
> +		return -EFAULT;
> +
> +	spin_lock_irq(&file->lock);
> +
> +	switch (file->index) {
> +	case SEC_CURRENT_QM:
> +		ret = sec_current_qm_write(file, val);
> +		if (ret)
> +			goto err_input;
> +		break;
> +	case SEC_CLEAR_ENABLE:
> +		ret = sec_clear_enable_write(file, val);
> +		if (ret)
> +			goto err_input;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto err_input;
> +	}
> +
> +	spin_unlock_irq(&file->lock);
> +
> +	return count;
> +
> + err_input:
> +	spin_unlock_irq(&file->lock);
> +	return ret;
> +}
> +
> +static const struct file_operations sec_dbg_fops = {
> +	.owner = THIS_MODULE,
> +	.open = simple_open,
> +	.read = sec_debug_read,
> +	.write = sec_debug_write,
> +};
> +
> +static int sec_core_debug_init(struct sec_dev *sec)
> +{
> +	struct hisi_qm *qm = &sec->qm;
> +	struct device *dev = &qm->pdev->dev;
> +	struct sec_dfx *dfx = &sec->debug.dfx;
> +	struct debugfs_regset32 *regset;
> +	struct dentry *tmp_d;
> +
> +	tmp_d = debugfs_create_dir("sec_dfx", sec->qm.debug.debug_root);
> +
> +	regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
> +	if (!regset)
> +		return -ENOENT;
> +
> +	regset->regs = sec_dfx_regs;
> +	regset->nregs = ARRAY_SIZE(sec_dfx_regs);
> +	regset->base = qm->io_base;
> +
> +	debugfs_create_regset32("regs", 0444, tmp_d, regset);
> +
> +	debugfs_create_u64("send_cnt", 0444, tmp_d, &dfx->send_cnt);
> +
> +	debugfs_create_u64("recv_cnt", 0444, tmp_d, &dfx->recv_cnt);

These could be changed to 'debugfs_create_atomic_t'. It does not look
like there is a 64-bit equivalent, however.

Thanks,
-- Marco
