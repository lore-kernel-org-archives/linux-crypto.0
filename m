Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05633C4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 00:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFF692053B
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 00:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfJKA7Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 20:59:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3729 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727581AbfJKA7Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 20:59:24 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7D70653CE1520D05020E;
        Fri, 11 Oct 2019 08:59:22 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Fri, 11 Oct 2019
 08:59:15 +0800
Subject: Re: [cryptodev:master 65/78] drivers/crypto//hisilicon/sgl.c:168:16:
 note: in expansion of macro 'cpu_to_le32'
To:     kbuild test robot <lkp@intel.com>
References: <201910102228.edMaKes6%lkp@intel.com>
CC:     <kbuild-all@01.org>, <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Shukun Tan <tanshukun1@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5D9FD3E1.2090605@hisilicon.com>
Date:   Fri, 11 Oct 2019 08:59:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <201910102228.edMaKes6%lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/10/10 22:25, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   504582e8e40b90b8f8c58783e2d1e4f6a2b71a3a
> commit: a92a00f809503c6db9dac518951e060ab3d6f6ee [65/78] crypto: hisilicon - misc fix about sgl
> config: riscv-allyesconfig (attached as .config)
> compiler: riscv64-linux-gcc (GCC) 7.4.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout a92a00f809503c6db9dac518951e060ab3d6f6ee
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=riscv 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from include/linux/byteorder/little_endian.h:5:0,
>                     from arch/riscv/include/uapi/asm/byteorder.h:10,
>                     from include/asm-generic/bitops/le.h:6,
>                     from arch/riscv/include/asm/bitops.h:202,
>                     from include/linux/bitops.h:19,
>                     from include/linux/kernel.h:12,
>                     from include/linux/list.h:9,
>                     from include/linux/kobject.h:19,
>                     from include/linux/device.h:16,
>                     from include/linux/dma-mapping.h:7,
>                     from drivers/crypto//hisilicon/sgl.c:3:
>    drivers/crypto//hisilicon/sgl.c: In function 'sg_map_to_hw_sg':
>    drivers/crypto//hisilicon/sgl.c:168:33: error: 'struct scatterlist' has no member named 'dma_length'; did you mean 'length'?
>      hw_sge->len = cpu_to_le32(sgl->dma_length);

need select NEED_SG_DMA_LENGTH, will fix this.

>                                     ^
>    include/uapi/linux/byteorder/little_endian.h:33:51: note: in definition of macro '__cpu_to_le32'
>     #define __cpu_to_le32(x) ((__force __le32)(__u32)(x))
>                                                       ^
>>> drivers/crypto//hisilicon/sgl.c:168:16: note: in expansion of macro 'cpu_to_le32'
>      hw_sge->len = cpu_to_le32(sgl->dma_length);
>                    ^~~~~~~~~~~
> 
> vim +/cpu_to_le32 +168 drivers/crypto//hisilicon/sgl.c
> 
>    > 3	#include <linux/dma-mapping.h>
>      4	#include <linux/module.h>
>      5	#include <linux/slab.h>
>      6	#include "qm.h"
>      7	
>      8	#define HISI_ACC_SGL_SGE_NR_MIN		1
>      9	#define HISI_ACC_SGL_NR_MAX		256
>     10	#define HISI_ACC_SGL_ALIGN_SIZE		64
>     11	#define HISI_ACC_MEM_BLOCK_NR		5
>     12	
>     13	struct acc_hw_sge {
>     14		dma_addr_t buf;
>     15		void *page_ctrl;
>     16		__le32 len;
>     17		__le32 pad;
>     18		__le32 pad0;
>     19		__le32 pad1;
>     20	};
>     21	
>     22	/* use default sgl head size 64B */
>     23	struct hisi_acc_hw_sgl {
>     24		dma_addr_t next_dma;
>     25		__le16 entry_sum_in_chain;
>     26		__le16 entry_sum_in_sgl;
>     27		__le16 entry_length_in_sgl;
>     28		__le16 pad0;
>     29		__le64 pad1[5];
>     30		struct hisi_acc_hw_sgl *next;
>     31		struct acc_hw_sge sge_entries[];
>     32	} __aligned(1);
>     33	
>     34	struct hisi_acc_sgl_pool {
>     35		struct mem_block {
>     36			struct hisi_acc_hw_sgl *sgl;
>     37			dma_addr_t sgl_dma;
>     38			size_t size;
>     39		} mem_block[HISI_ACC_MEM_BLOCK_NR];
>     40		u32 sgl_num_per_block;
>     41		u32 block_num;
>     42		u32 count;
>     43		u32 sge_nr;
>     44		size_t sgl_size;
>     45	};
>     46	
>     47	/**
>     48	 * hisi_acc_create_sgl_pool() - Create a hw sgl pool.
>     49	 * @dev: The device which hw sgl pool belongs to.
>     50	 * @count: Count of hisi_acc_hw_sgl in pool.
>     51	 * @sge_nr: The count of sge in hw_sgl
>     52	 *
>     53	 * This function creates a hw sgl pool, after this user can get hw sgl memory
>     54	 * from it.
>     55	 */
>     56	struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
>     57							   u32 count, u32 sge_nr)
>     58	{
>     59		u32 sgl_size, block_size, sgl_num_per_block, block_num, remain_sgl = 0;
>     60		struct hisi_acc_sgl_pool *pool;
>     61		struct mem_block *block;
>     62		u32 i, j;
>     63	
>     64		if (!dev || !count || !sge_nr || sge_nr > HISI_ACC_SGL_SGE_NR_MAX)
>     65			return ERR_PTR(-EINVAL);
>     66	
>     67		sgl_size = sizeof(struct acc_hw_sge) * sge_nr +
>     68			   sizeof(struct hisi_acc_hw_sgl);
>     69		block_size = PAGE_SIZE * (1 << (MAX_ORDER - 1));
>     70		sgl_num_per_block = block_size / sgl_size;
>     71		block_num = count / sgl_num_per_block;
>     72		remain_sgl = count % sgl_num_per_block;
>     73	
>     74		if ((!remain_sgl && block_num > HISI_ACC_MEM_BLOCK_NR) ||
>     75		    (remain_sgl > 0 && block_num > HISI_ACC_MEM_BLOCK_NR - 1))
>     76			return ERR_PTR(-EINVAL);
>     77	
>     78		pool = kzalloc(sizeof(*pool), GFP_KERNEL);
>     79		if (!pool)
>     80			return ERR_PTR(-ENOMEM);
>     81		block = pool->mem_block;
>     82	
>     83		for (i = 0; i < block_num; i++) {
>     84			block[i].sgl = dma_alloc_coherent(dev, block_size,
>     85							  &block[i].sgl_dma,
>     86							  GFP_KERNEL);
>     87			if (!block[i].sgl)
>     88				goto err_free_mem;
>     89	
>     90			block[i].size = block_size;
>     91		}
>     92	
>     93		if (remain_sgl > 0) {
>     94			block[i].sgl = dma_alloc_coherent(dev, remain_sgl * sgl_size,
>     95							  &block[i].sgl_dma,
>     96							  GFP_KERNEL);
>     97			if (!block[i].sgl)
>     98				goto err_free_mem;
>     99	
>    100			block[i].size = remain_sgl * sgl_size;
>    101		}
>    102	
>    103		pool->sgl_num_per_block = sgl_num_per_block;
>    104		pool->block_num = remain_sgl ? block_num + 1 : block_num;
>    105		pool->count = count;
>    106		pool->sgl_size = sgl_size;
>    107		pool->sge_nr = sge_nr;
>    108	
>    109		return pool;
>    110	
>    111	err_free_mem:
>    112		for (j = 0; j < i; j++) {
>    113			dma_free_coherent(dev, block_size, block[j].sgl,
>    114					  block[j].sgl_dma);
>    115			memset(block + j, 0, sizeof(*block));
>    116		}
>    117		kfree(pool);
>    118		return ERR_PTR(-ENOMEM);
>    119	}
>    120	EXPORT_SYMBOL_GPL(hisi_acc_create_sgl_pool);
>    121	
>    122	/**
>    123	 * hisi_acc_free_sgl_pool() - Free a hw sgl pool.
>    124	 * @dev: The device which hw sgl pool belongs to.
>    125	 * @pool: Pointer of pool.
>    126	 *
>    127	 * This function frees memory of a hw sgl pool.
>    128	 */
>    129	void hisi_acc_free_sgl_pool(struct device *dev, struct hisi_acc_sgl_pool *pool)
>    130	{
>    131		struct mem_block *block;
>    132		int i;
>    133	
>    134		if (!dev || !pool)
>    135			return;
>    136	
>    137		block = pool->mem_block;
>    138	
>    139		for (i = 0; i < pool->block_num; i++)
>    140			dma_free_coherent(dev, block[i].size, block[i].sgl,
>    141					  block[i].sgl_dma);
>    142	
>    143		kfree(pool);
>    144	}
>    145	EXPORT_SYMBOL_GPL(hisi_acc_free_sgl_pool);
>    146	
>    147	static struct hisi_acc_hw_sgl *acc_get_sgl(struct hisi_acc_sgl_pool *pool,
>    148						   u32 index, dma_addr_t *hw_sgl_dma)
>    149	{
>    150		struct mem_block *block;
>    151		u32 block_index, offset;
>    152	
>    153		if (!pool || !hw_sgl_dma || index >= pool->count)
>    154			return ERR_PTR(-EINVAL);
>    155	
>    156		block = pool->mem_block;
>    157		block_index = index / pool->sgl_num_per_block;
>    158		offset = index % pool->sgl_num_per_block;
>    159	
>    160		*hw_sgl_dma = block[block_index].sgl_dma + pool->sgl_size * offset;
>    161		return (void *)block[block_index].sgl + pool->sgl_size * offset;
>    162	}
>    163	
>    164	static void sg_map_to_hw_sg(struct scatterlist *sgl,
>    165				    struct acc_hw_sge *hw_sge)
>    166	{
>    167		hw_sge->buf = sgl->dma_address;
>  > 168		hw_sge->len = cpu_to_le32(sgl->dma_length);
>    169	}
>    170	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 

