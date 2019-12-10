Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6797C43603
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 06:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82CE9206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 06:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfLJGTK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 01:19:10 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:35630 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726085AbfLJGTK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 01:19:10 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A7EEE695893D429303CB;
        Tue, 10 Dec 2019 14:19:08 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 10 Dec 2019
 14:19:02 +0800
Subject: Re: [PATCH] crypto: hisilicon - still no need to check return value
 of debugfs_create functions
To:     Zhou Wang <wangzhou1@hisilicon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20191209152151.GA1282293@kroah.com>
 <5DEF1993.8020307@hisilicon.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <7c93bc03-c25c-6460-22df-9b0f5bcf7ffc@huawei.com>
Date:   Tue, 10 Dec 2019 14:19:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <5DEF1993.8020307@hisilicon.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Okay, I will fix this, thanks.

Cheers,

Zaibo

.

On 2019/12/10 12:05, Zhou Wang wrote:
> On 2019/12/9 23:21, Greg Kroah-Hartman wrote:
>> Just like in 4a97bfc79619 ("crypto: hisilicon - no need to check return
>> value of debugfs_create functions"), there still is no need to ever
>> check the return value.  The function can work or not, but the code
>> logic should never do something different based on this.
> Thanks for fix this, +To Zaibo Xu who is the maintainer of this module :)
>
> Best,
> Zhou
>
>> Cc: Zhou Wang <wangzhou1@hisilicon.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: linux-crypto@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>   drivers/crypto/hisilicon/hpre/hpre_main.c | 28 +++++------------------
>>   1 file changed, 6 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
>> index 34e0424410bf..711f5d18b641 100644
>> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
>> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
>> @@ -557,7 +557,7 @@ static const struct file_operations hpre_ctrl_debug_fops = {
>>   static int hpre_create_debugfs_file(struct hpre_debug *dbg, struct dentry *dir,
>>   				    enum hpre_ctrl_dbgfs_file type, int indx)
>>   {
>> -	struct dentry *tmp, *file_dir;
>> +	struct dentry *file_dir;
>>   
>>   	if (dir)
>>   		file_dir = dir;
>> @@ -571,10 +571,8 @@ static int hpre_create_debugfs_file(struct hpre_debug *dbg, struct dentry *dir,
>>   	dbg->files[indx].debug = dbg;
>>   	dbg->files[indx].type = type;
>>   	dbg->files[indx].index = indx;
>> -	tmp = debugfs_create_file(hpre_debug_file_name[type], 0600, file_dir,
>> -				  dbg->files + indx, &hpre_ctrl_debug_fops);
>> -	if (!tmp)
>> -		return -ENOENT;
>> +	debugfs_create_file(hpre_debug_file_name[type], 0600, file_dir,
>> +			    dbg->files + indx, &hpre_ctrl_debug_fops);
>>   
>>   	return 0;
>>   }
>> @@ -585,7 +583,6 @@ static int hpre_pf_comm_regs_debugfs_init(struct hpre_debug *debug)
>>   	struct hisi_qm *qm = &hpre->qm;
>>   	struct device *dev = &qm->pdev->dev;
>>   	struct debugfs_regset32 *regset;
>> -	struct dentry *tmp;
>>   
>>   	regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
>>   	if (!regset)
>> @@ -595,10 +592,7 @@ static int hpre_pf_comm_regs_debugfs_init(struct hpre_debug *debug)
>>   	regset->nregs = ARRAY_SIZE(hpre_com_dfx_regs);
>>   	regset->base = qm->io_base;
>>   
>> -	tmp = debugfs_create_regset32("regs", 0444,  debug->debug_root, regset);
>> -	if (!tmp)
>> -		return -ENOENT;
>> -
>> +	debugfs_create_regset32("regs", 0444,  debug->debug_root, regset);
>>   	return 0;
>>   }
>>   
>> @@ -609,15 +603,12 @@ static int hpre_cluster_debugfs_init(struct hpre_debug *debug)
>>   	struct device *dev = &qm->pdev->dev;
>>   	char buf[HPRE_DBGFS_VAL_MAX_LEN];
>>   	struct debugfs_regset32 *regset;
>> -	struct dentry *tmp_d, *tmp;
>> +	struct dentry *tmp_d;
>>   	int i, ret;
>>   
>>   	for (i = 0; i < HPRE_CLUSTERS_NUM; i++) {
>>   		sprintf(buf, "cluster%d", i);
>> -
>>   		tmp_d = debugfs_create_dir(buf, debug->debug_root);
>> -		if (!tmp_d)
>> -			return -ENOENT;
>>   
>>   		regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
>>   		if (!regset)
>> @@ -627,9 +618,7 @@ static int hpre_cluster_debugfs_init(struct hpre_debug *debug)
>>   		regset->nregs = ARRAY_SIZE(hpre_cluster_dfx_regs);
>>   		regset->base = qm->io_base + hpre_cluster_offsets[i];
>>   
>> -		tmp = debugfs_create_regset32("regs", 0444, tmp_d, regset);
>> -		if (!tmp)
>> -			return -ENOENT;
>> +		debugfs_create_regset32("regs", 0444, tmp_d, regset);
>>   		ret = hpre_create_debugfs_file(debug, tmp_d, HPRE_CLUSTER_CTRL,
>>   					       i + HPRE_CLUSTER_CTRL);
>>   		if (ret)
>> @@ -668,9 +657,6 @@ static int hpre_debugfs_init(struct hpre *hpre)
>>   	int ret;
>>   
>>   	dir = debugfs_create_dir(dev_name(dev), hpre_debugfs_root);
>> -	if (!dir)
>> -		return -ENOENT;
>> -
>>   	qm->debug.debug_root = dir;
>>   
>>   	ret = hisi_qm_debug_init(qm);
>> @@ -1014,8 +1000,6 @@ static void hpre_register_debugfs(void)
>>   		return;
>>   
>>   	hpre_debugfs_root = debugfs_create_dir(hpre_name, NULL);
>> -	if (IS_ERR_OR_NULL(hpre_debugfs_root))
>> -		hpre_debugfs_root = NULL;
>>   }
>>   
>>   static void hpre_unregister_debugfs(void)
>>
> .
>


