Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F34F0C35679
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 07:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA23720714
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 07:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgBXHRo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Feb 2020 02:17:44 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10679 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725792AbgBXHRo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Feb 2020 02:17:44 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8238FEBECE607EF86A2F;
        Mon, 24 Feb 2020 15:17:36 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Mon, 24 Feb 2020
 15:17:28 +0800
Subject: Re: [PATCH] uacce: unmap remaining mmapping from user space
To:     Zhangfei Gao <zhangfei.gao@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
        <grant.likely@arm.com>, jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        <ilias.apalodimas@linaro.org>, <francois.ozog@linaro.org>,
        <kenneth-lee-2012@foxmail.com>, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        <guodong.xu@linaro.org>
References: <1582528016-2873-1-git-send-email-zhangfei.gao@linaro.org>
CC:     <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-accelerators@lists.ozlabs.org>,
        <linux-crypto@vger.kernel.org>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <a4716453-0607-d613-e632-173d1ebc424e@huawei.com>
Date:   Mon, 24 Feb 2020 15:17:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <1582528016-2873-1-git-send-email-zhangfei.gao@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Zhangfei,


On 2020/2/24 15:06, Zhangfei Gao wrote:
> When uacce parent device module is removed, user app may
> still keep the mmaped area, which can be accessed unsafely.
> When rmmod, Parent device drvier will call uacce_remove,
> which unmap all remaining mapping from user space for safety.
> VM_FAULT_SIGBUS is also reported to user space accordingly.
>
> Suggested-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> ---
>   drivers/misc/uacce/uacce.c | 17 +++++++++++++++++
>   include/linux/uacce.h      |  2 ++
>   2 files changed, 19 insertions(+)
>
> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> index ffced4d..1bcc5e6 100644
> --- a/drivers/misc/uacce/uacce.c
> +++ b/drivers/misc/uacce/uacce.c
> @@ -224,6 +224,7 @@ static int uacce_fops_open(struct inode *inode, struct file *filep)
>   
>   	init_waitqueue_head(&q->wait);
>   	filep->private_data = q;
> +	uacce->inode = inode;
>   	q->state = UACCE_Q_INIT;
>   
>   	return 0;
> @@ -253,6 +254,14 @@ static int uacce_fops_release(struct inode *inode, struct file *filep)
>   	return 0;
>   }
>   
> +static vm_fault_t uacce_vma_fault(struct vm_fault *vmf)
> +{
> +	if (vmf->flags & (FAULT_FLAG_MKWRITE | FAULT_FLAG_WRITE))
> +		return VM_FAULT_SIGBUS;
> +
> +	return 0;
> +}
> +
>   static void uacce_vma_close(struct vm_area_struct *vma)
>   {
>   	struct uacce_queue *q = vma->vm_private_data;
> @@ -265,6 +274,7 @@ static void uacce_vma_close(struct vm_area_struct *vma)
>   }
>   
>   static const struct vm_operations_struct uacce_vm_ops = {
> +	.fault = uacce_vma_fault,
>   	.close = uacce_vma_close,
>   };
>   
> @@ -585,6 +595,13 @@ void uacce_remove(struct uacce_device *uacce)
>   		cdev_device_del(uacce->cdev, &uacce->dev);
>   	xa_erase(&uacce_xa, uacce->dev_id);
>   	put_device(&uacce->dev);
> +
> +	/*
> +	 * unmap remainning mapping from user space, preventing user still
> +	 * access the mmaped area while parent device is already removed
> +	 */
> +	if (uacce->inode)
> +		unmap_mapping_range(uacce->inode->i_mapping, 0, 0, 1);
Should we unmap them at the first of 'uacce_remove',  and before 
'uacce_put_queue'?

Thanks,
Zaibo

.
>   }
>   EXPORT_SYMBOL_GPL(uacce_remove);
>   
> diff --git a/include/linux/uacce.h b/include/linux/uacce.h
> index 904a461..0e215e6 100644
> --- a/include/linux/uacce.h
> +++ b/include/linux/uacce.h
> @@ -98,6 +98,7 @@ struct uacce_queue {
>    * @priv: private pointer of the uacce
>    * @mm_list: list head of uacce_mm->list
>    * @mm_lock: lock for mm_list
> + * @inode: core vfs
>    */
>   struct uacce_device {
>   	const char *algs;
> @@ -113,6 +114,7 @@ struct uacce_device {
>   	void *priv;
>   	struct list_head mm_list;
>   	struct mutex mm_lock;
> +	struct inode *inode;
>   };
>   
>   /**


