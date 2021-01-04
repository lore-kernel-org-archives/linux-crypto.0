Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7585C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 05:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94E5820E65
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 05:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbhADFpK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 00:45:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:1593 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727905AbhADFpJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 00:45:09 -0500
IronPort-SDR: WjxSSSTdeuZWSC7Eq/g21pYCPuSjXZ4vOKSoDiMT2i33zamMBTtKwDj6jz60rS6usmsaLb4loC
 VV3seG1kJFGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="174335889"
X-IronPort-AV: E=Sophos;i="5.78,473,1599548400"; 
   d="scan'208";a="174335889"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2021 21:44:29 -0800
IronPort-SDR: X/UxyYHawPqkjHG0RB8SuxBbO58d7l/rOVxA9j/VolDcimKV4hFOa2TqGwQbDJ0IMv41Arol8f
 7U5dvkqddp8A==
X-IronPort-AV: E=Sophos;i="5.78,473,1599548400"; 
   d="scan'208";a="349770773"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.249.170.207]) ([10.249.170.207])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2021 21:44:26 -0800
Subject: Re: [kbuild-all] Re: [PATCH v2 2/2] crypto: x86/aes-ni-xts - rewrite
 and drop indirections via glue helper
To:     Ard Biesheuvel <ardb@kernel.org>, kernel test robot <lkp@intel.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kbuild-all@lists.01.org, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Uros Bizjak <ubizjak@gmail.com>
References: <20201231164155.21792-3-ardb@kernel.org>
 <202101010632.59pt4uvv-lkp@intel.com>
 <CAMj1kXFZ77ptJXqp-JWembc-U6ouhZs3G8079Y+qkPQ47VQogA@mail.gmail.com>
From:   "Chen, Rong A" <rong.a.chen@intel.com>
Message-ID: <166bbc6f-cb22-0593-68a6-e763c9fe1c8f@intel.com>
Date:   Mon, 4 Jan 2021 13:44:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXFZ77ptJXqp-JWembc-U6ouhZs3G8079Y+qkPQ47VQogA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 1/4/2021 4:31 AM, Ard Biesheuvel wrote:
> On Thu, 31 Dec 2020 at 23:37, kernel test robot <lkp@intel.com> wrote:
>>
>> Hi Ard,
>>
>> I love your patch! Yet something to improve:
>>
>> [auto build test ERROR on cryptodev/master]
>> [also build test ERROR on crypto/master linus/master v5.11-rc1 next-20201223]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch]
>>
> 
> This is a false positive, and the cover letter mentions that these
> patches depend on the cts(cbc(aes)) patch which is now in the
> cryptodev tree

Hi Ard,

Thanks for the clarification，the bot doesn't support analyzing the base
patch from cover letter yet.

> 
> I will try to remember to use --base next time.

Thanks a lot!

Best Regards,
Rong Chen

> 
> 
>> url:    https://github.com/0day-ci/linux/commits/Ard-Biesheuvel/crypto-x86-aes-ni-xts-recover-and-improve-performance/20210101-004902
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
>> config: x86_64-allyesconfig (attached as .config)
>> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
>> reproduce (this is a W=1 build):
>>          # https://github.com/0day-ci/linux/commit/120e62f276c7436572e8a67ecfb9bbb1125bfd8d
>>          git remote add linux-review https://github.com/0day-ci/linux
>>          git fetch --no-tags linux-review Ard-Biesheuvel/crypto-x86-aes-ni-xts-recover-and-improve-performance/20210101-004902
>>          git checkout 120e62f276c7436572e8a67ecfb9bbb1125bfd8d
>>          # save the attached .config to linux build tree
>>          make W=1 ARCH=x86_64
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>     ld: arch/x86/crypto/aesni-intel_asm.o: in function `aesni_xts_encrypt':
>>>> (.text+0x8909): undefined reference to `.Lcts_permute_table'
>>     ld: arch/x86/crypto/aesni-intel_asm.o: in function `aesni_xts_decrypt':
>>     (.text+0x8af6): undefined reference to `.Lcts_permute_table'
>>
>> ---
>> 0-DAY CI Kernel Test Service, Intel Corporation
>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org
> 
