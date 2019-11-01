Return-Path: <SRS0=WdwO=YZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9C6CA9ECF
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 11:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68FBF21734
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 11:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfKALEO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Nov 2019 07:04:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37748 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729855AbfKALEO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Nov 2019 07:04:14 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 72A3E30F05D50A6BFC73;
        Fri,  1 Nov 2019 19:04:08 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Fri, 1 Nov 2019
 19:03:59 +0800
Subject: Re: [cryptodev:master 162/163]
 drivers/crypto/hisilicon/zip/zip_main.c:154:13: error: 'head' undeclared; did
 you mean '_end'?
To:     kbuild test robot <lkp@intel.com>
References: <201911011637.ZqPb4BBG%lkp@intel.com>
CC:     <kbuild-all@lists.01.org>, <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Shukun Tan <tanshukun1@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5DBC111D.7020101@hisilicon.com>
Date:   Fri, 1 Nov 2019 19:03:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <201911011637.ZqPb4BBG%lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/11/1 16:33, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   298b4c604008025b134bc6fccbc4018449945d60
> commit: 700f7d0d29c795c36517dcd3541e4432a76c2efc [162/163] crypto: hisilicon - fix to return sub-optimal device when best device has no qps
> config: alpha-allyesconfig (attached as .config)
> compiler: alpha-linux-gcc (GCC) 7.4.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 700f7d0d29c795c36517dcd3541e4432a76c2efc
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=alpha 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/crypto/hisilicon/zip/zip_main.c: In function 'find_zip_device':
>>> drivers/crypto/hisilicon/zip/zip_main.c:154:13: error: 'head' undeclared (first use in this function); did you mean '_end'?
>      free_list(&head);
>                 ^~~~
>                 _end
>    drivers/crypto/hisilicon/zip/zip_main.c:154:13: note: each undeclared identifier is reported only once for each function it appears in
>    drivers/crypto/hisilicon/zip/zip_main.c:153:1: warning: label 'err' defined but not used [-Wunused-label]
>     err:
>     ^~~

will fix this by IS_ENABLED(CONFIG_NUMA).

> 
> vim +154 drivers/crypto/hisilicon/zip/zip_main.c
> 
>    104	
>    105	struct hisi_zip *find_zip_device(int node)
>    106	{
>    107		struct hisi_zip *ret = NULL;
>    108	#ifdef CONFIG_NUMA
>    109		struct hisi_zip_resource *res, *tmp;
>    110		struct hisi_zip *hisi_zip;
>    111		struct list_head *n;
>    112		struct device *dev;
>    113		LIST_HEAD(head);
>    114	
>    115		mutex_lock(&hisi_zip_list_lock);
>    116	
>    117		list_for_each_entry(hisi_zip, &hisi_zip_list, list) {
>    118			res = kzalloc(sizeof(*res), GFP_KERNEL);
>    119			if (!res)
>    120				goto err;
>    121	
>    122			dev = &hisi_zip->qm.pdev->dev;
>    123			res->hzip = hisi_zip;
>    124			res->distance = node_distance(dev->numa_node, node);
>    125	
>    126			n = &head;
>    127			list_for_each_entry(tmp, &head, list) {
>    128				if (res->distance < tmp->distance) {
>    129					n = &tmp->list;
>    130					break;
>    131				}
>    132			}
>    133			list_add_tail(&res->list, n);
>    134		}
>    135	
>    136		list_for_each_entry(tmp, &head, list) {
>    137			if (hisi_qm_get_free_qp_num(&tmp->hzip->qm)) {
>    138				ret = tmp->hzip;
>    139				break;
>    140			}
>    141		}
>    142	
>    143		free_list(&head);
>    144	#else
>    145		mutex_lock(&hisi_zip_list_lock);
>    146	
>    147		ret = list_first_entry(&hisi_zip_list, struct hisi_zip, list);
>    148	#endif
>    149		mutex_unlock(&hisi_zip_list_lock);
>    150	
>    151		return ret;
>    152	
>    153	err:
>  > 154		free_list(&head);
>    155		mutex_unlock(&hisi_zip_list_lock);
>    156		return NULL;
>    157	}
>    158	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 

