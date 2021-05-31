Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49E0C47092
	for <linux-crypto@archiver.kernel.org>; Mon, 31 May 2021 00:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF03611AB
	for <linux-crypto@archiver.kernel.org>; Mon, 31 May 2021 00:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhEaAy2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 May 2021 20:54:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:16281 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229887AbhEaAy1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 May 2021 20:54:27 -0400
IronPort-SDR: Ob4lgGooz+d4tR2E4OR3u2fQPZxlVlfKCyFhQBKSy6w0Ff7AFnm1cGHawOVe/TJ7T6Y/dDlcrj
 0t+amLsnxqFA==
X-IronPort-AV: E=McAfee;i="6200,9189,10000"; a="190632004"
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="190632004"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2021 17:52:48 -0700
IronPort-SDR: LNN+Vit3cFlunU+54UbsQAk0XE1QQZyir78WkRN4Ni9nHHsVeoni8fX+VX/ZOTz0iUvk9NmhvE
 dIS7D/H6SkDg==
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="444785294"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.11]) ([10.239.13.11])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2021 17:52:46 -0700
Subject: Re: [kbuild-all] Re: [PATCH 2/3] crypto: hisilicon/sec - add fallback
 tfm supporting for XTS mode
To:     "yekai(A)" <yekai13@huawei.com>, kernel test robot <lkp@intel.com>,
        herbert@gondor.apana.org.au
Cc:     kbuild-all@lists.01.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com
References: <1622202126-19237-3-git-send-email-yekai13@huawei.com>
 <202105282256.hUBoOJ3Z-lkp@intel.com>
 <c265adb3-4cba-a6f7-6ba5-9a065fe5aeca@huawei.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <7c435436-cf38-7c09-9141-8410a8c18cc8@intel.com>
Date:   Mon, 31 May 2021 08:51:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c265adb3-4cba-a6f7-6ba5-9a065fe5aeca@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 5/29/21 5:22 PM, yekai(A) wrote:
>
>
> On 2021/5/28 22:13, kernel test robot wrote:
>> Hi Kai,
>>
>> Thank you for the patch! Yet something to improve:
>>
>> [auto build test ERROR on cryptodev/master]
>> [also build test ERROR on crypto/master linux/master linus/master 
>> v5.13-rc3 next-20210528]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch]
>>
>> url: 
>> https://github.com/0day-ci/linux/commits/Kai-Ye/crypto-hisilicon-supports-new-skciphers-for-new-hardware/20210528-194644
>> base: 
>> https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git 
>> master
>> config: ia64-allmodconfig (attached as .config)
>> compiler: ia64-linux-gcc (GCC) 9.3.0
>> reproduce (this is a W=1 build):
>>         wget 
>> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross 
>> -O ~/bin/make.cross
>>         chmod +x ~/bin/make.cross
>>         # 
>> https://github.com/0day-ci/linux/commit/60bae5ed49c53ea90c82125a8295fb72833a3b68
>>         git remote add linux-review https://github.com/0day-ci/linux
>>         git fetch --no-tags linux-review 
>> Kai-Ye/crypto-hisilicon-supports-new-skciphers-for-new-hardware/20210528-194644
>>         git checkout 60bae5ed49c53ea90c82125a8295fb72833a3b68
>>         # save the attached .config to linux build tree
>>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 
>> make.cross ARCH=ia64
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>    drivers/crypto/hisilicon/sec2/sec_crypto.c: In function 
>> 'sec_aead_crypto':
>>>> drivers/crypto/hisilicon/sec2/sec_crypto.c:1751:40: error: 'sk_req' 
>>>> undeclared (first use in this function); did you mean 'a_req'?
>>     1751 |   return sec_skcipher_soft_crypto(ctx, sk_req, encrypt);
>>          |                                        ^~~~~~
>>          |                                        a_req
>>    drivers/crypto/hisilicon/sec2/sec_crypto.c:1751:40: note: each 
>> undeclared identifier is reported only once for each function it 
>> appears in
>>
>>
>> vim +1751 drivers/crypto/hisilicon/sec2/sec_crypto.c
>>
>>   1733
>>   1734    static int sec_aead_crypto(struct aead_request *a_req, bool 
>> encrypt)
>>   1735    {
>>   1736        struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
>>   1737        struct sec_req *req = aead_request_ctx(a_req);
>>   1738        struct sec_ctx *ctx = crypto_aead_ctx(tfm);
>>   1739        int ret;
>>   1740
>>   1741        req->flag = a_req->base.flags;
>>   1742        req->aead_req.aead_req = a_req;
>>   1743        req->c_req.encrypt = encrypt;
>>   1744        req->ctx = ctx;
>>   1745
>>   1746        ret = sec_aead_param_check(ctx, req);
>>   1747        if (unlikely(ret))
>>   1748            return -EINVAL;
>>   1749
>>   1750        if (unlikely(ctx->c_ctx.fallback))
>>> 1751            return sec_skcipher_soft_crypto(ctx, sk_req, encrypt);
>>   1752
>>   1753        return ctx->req_op->process(ctx, req);
>>   1754    }
>>   1755
>>
>> ---
>> 0-DAY CI Kernel Test Service, Intel Corporation
>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>>
>
>
> You shouldn't git am this patchset directly, because this patchset 
> depends on previous patchset.
> the series is "crypto: hisilicon - add new type of sqe for Kunpeng930",
> the patchwork is 
> https://patchwork.kernel.org/project/linux-crypto/list/?series=490143,
> thank you
> Kai

Hi Kai,

Thanks for the clarification, it could be very helpful for us if 
'--base' for git format-patch used or
there is a patchwork link in cover letter file.

Best Regards,
Rong Chen
