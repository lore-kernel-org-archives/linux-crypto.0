Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3C7C4708E
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 09:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 755E8610FC
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 09:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhE2JXo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 May 2021 05:23:44 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2348 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhE2JXo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 May 2021 05:23:44 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FsbYM5cKkz1BFmf;
        Sat, 29 May 2021 17:17:27 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 17:22:04 +0800
Received: from [10.67.103.212] (10.67.103.212) by
 dggpeml500012.china.huawei.com (7.185.36.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 17:22:04 +0800
Subject: Re: [PATCH 2/3] crypto: hisilicon/sec - add fallback tfm supporting
 for XTS mode
To:     kernel test robot <lkp@intel.com>, <herbert@gondor.apana.org.au>
References: <1622202126-19237-3-git-send-email-yekai13@huawei.com>
 <202105282256.hUBoOJ3Z-lkp@intel.com>
CC:     <kbuild-all@lists.01.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wangzhou1@hisilicon.com>
From:   "yekai(A)" <yekai13@huawei.com>
Message-ID: <c265adb3-4cba-a6f7-6ba5-9a065fe5aeca@huawei.com>
Date:   Sat, 29 May 2021 17:22:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <202105282256.hUBoOJ3Z-lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.212]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2021/5/28 22:13, kernel test robot wrote:
> Hi Kai,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on cryptodev/master]
> [also build test ERROR on crypto/master linux/master linus/master v5.13-rc3 next-20210528]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Kai-Ye/crypto-hisilicon-supports-new-skciphers-for-new-hardware/20210528-194644
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> config: ia64-allmodconfig (attached as .config)
> compiler: ia64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/60bae5ed49c53ea90c82125a8295fb72833a3b68
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Kai-Ye/crypto-hisilicon-supports-new-skciphers-for-new-hardware/20210528-194644
>         git checkout 60bae5ed49c53ea90c82125a8295fb72833a3b68
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=ia64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    drivers/crypto/hisilicon/sec2/sec_crypto.c: In function 'sec_aead_crypto':
>>> drivers/crypto/hisilicon/sec2/sec_crypto.c:1751:40: error: 'sk_req' undeclared (first use in this function); did you mean 'a_req'?
>     1751 |   return sec_skcipher_soft_crypto(ctx, sk_req, encrypt);
>          |                                        ^~~~~~
>          |                                        a_req
>    drivers/crypto/hisilicon/sec2/sec_crypto.c:1751:40: note: each undeclared identifier is reported only once for each function it appears in
>
>
> vim +1751 drivers/crypto/hisilicon/sec2/sec_crypto.c
>
>   1733	
>   1734	static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
>   1735	{
>   1736		struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
>   1737		struct sec_req *req = aead_request_ctx(a_req);
>   1738		struct sec_ctx *ctx = crypto_aead_ctx(tfm);
>   1739		int ret;
>   1740	
>   1741		req->flag = a_req->base.flags;
>   1742		req->aead_req.aead_req = a_req;
>   1743		req->c_req.encrypt = encrypt;
>   1744		req->ctx = ctx;
>   1745	
>   1746		ret = sec_aead_param_check(ctx, req);
>   1747		if (unlikely(ret))
>   1748			return -EINVAL;
>   1749	
>   1750		if (unlikely(ctx->c_ctx.fallback))
>> 1751			return sec_skcipher_soft_crypto(ctx, sk_req, encrypt);
>   1752	
>   1753		return ctx->req_op->process(ctx, req);
>   1754	}
>   1755	
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>


You shouldn't git am this patchset directly, because this patchset 
depends on previous patchset.
the series is "crypto: hisilicon - add new type of sqe for Kunpeng930",
the patchwork is 
https://patchwork.kernel.org/project/linux-crypto/list/?series=490143,
thank you
Kai
