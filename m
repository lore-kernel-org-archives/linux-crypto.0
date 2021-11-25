Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13181C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Nov 2021 05:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhKYFas (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Nov 2021 00:30:48 -0500
Received: from mga04.intel.com ([192.55.52.120]:37710 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238444AbhKYF2s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Nov 2021 00:28:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="234174725"
X-IronPort-AV: E=Sophos;i="5.87,262,1631602800"; 
   d="scan'208";a="234174725"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 21:25:37 -0800
X-IronPort-AV: E=Sophos;i="5.87,262,1631602800"; 
   d="scan'208";a="457721499"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.249.174.10]) ([10.249.174.10])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 21:25:33 -0800
Subject: Re: [kbuild-all] Re: [PATCH v43 01/15] Linux Random Number Generator
To:     Stephan Mueller <smueller@chronox.de>, Tso Ted <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, Willy Tarreau <w@1wt.eu>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>
References: <4641592.OV4Wx5bFTl@positron.chronox.de>
 <202111221831.lPHo6KJJ-lkp@intel.com> <5540546.7F5nsSknLy@tauon.chronox.de>
From:   "Chen, Rong A" <rong.a.chen@intel.com>
Message-ID: <7ee4a94e-496e-67a0-897a-0dd84bbce72f@intel.com>
Date:   Thu, 25 Nov 2021 13:25:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <5540546.7F5nsSknLy@tauon.chronox.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/22/2021 7:47 PM, Stephan Mueller wrote:
> Am Montag, 22. November 2021, 11:33:26 CET schrieb kernel test robot:
> 
> Hi,
> 
>> All errors (new ones prefixed by >>):
>>>> drivers/char/lrng/lrng_chacha20.c:32:8: error: structure variable
>>>> 'chacha20' with 'latent_entropy' attribute has a non-integer field
>>>> 'block'
>>        32 | struct chacha20_state chacha20 __latent_entropy;
>>
>>           |        ^~~~~~~~~~~~~~
>>
>> vim +32 drivers/char/lrng/lrng_chacha20.c
> 
> Thanks for the notification.
> 
> I think this is a false-positive discussed before. __latent_entropy is
> seemingly allowed for an entire linear buffer as seen in the declaration of
> the variable input_pool_data in driver/char/random.c which is an array of u32.
> 
> The struct chacha20_state is a linear buffer of u32 words.
> 
> struct chacha20_block {
>          u32 constants[4];
>          union {
>                  u32 u[CHACHA_KEY_SIZE_WORDS];
>                  u8  b[CHACHA_KEY_SIZE];
>          } key;
>          u32 counter;
>          u32 nonce[3];
> };
> 
> Therefore it should be identical to the aforementioned example. The
> __latent_entropy marker therefore seems to be appropriate for this structure.
> 
> Ciao
> Stephan
> 
> 

Hi Stephan,

Thanks for the explanation, we'll add the error to the ignore list.

Best Regards,
Rong Chen
