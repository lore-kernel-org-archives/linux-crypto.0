From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v4] crypto: caam - map src buffer before access
Date: Tue, 24 Sep 2013 12:07:20 +0300
Message-ID: <52415648.90103@freescale.com>
References: <1379753795-14949-1-git-send-email-yashpal.dutta@freescale.com> <20130923135134.23a7462d143b8e2a1f0cc165@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <yashpal.dutta@freescale.com>, <linux-crypto@vger.kernel.org>,
	<stable@vger.kernel.org>
To: Kim Phillips <kim.phillips@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [216.32.181.183] ([216.32.181.183]:58179 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750823Ab3IXJIj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Sep 2013 05:08:39 -0400
In-Reply-To: <20130923135134.23a7462d143b8e2a1f0cc165@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/23/2013 9:51 PM, Kim Phillips wrote:
> On Sat, 21 Sep 2013 14:26:35 +0530
> Yashpal Dutta <yashpal.dutta@freescale.com> wrote:
>
>> KMap the buffers before copying trailing bytes during hmac into a session
>> temporary buffer. This is required if pinned buffer from user-space is send
>> during hmac and is safe even if hmac request is generated from within kernel.
> it may be "safe" but it adversely affects performance for AF_ALG users,
> no?
>
> why does ocf-linux need this, and not AF_ALG?  Is a patch to ocf-linux
> more appropriate here?

SW hashing (crypto/ahash.c, crypto/shash.c) do the kmap/kunmap.
Crypto engine drivers should do this too. Either by themselves or 
(probably better) try to use existing support in crypto/scatterwalk.c

At the interface level, AF_ALG issues get_user_pages via 
af_alg_make_sg(), similar to what ocf-linux does.

>
>> Cc:stable@vger.kernel.org
> fyi, this violates the following rule in
> Documentation/stable_kernel_rules.txt:
>
>   - It or an equivalent fix must already exist in Linus' tree (upstream).

AFAICT, rules are more flexible, at least that's my understanding. 
Adding a Cc:stable in the signed-off area is more convenient, since it 
provides for automatic inclusion in -stable tree (once patch reaches 
Linus' tree):
  - To have the patch automatically included in the stable tree, add the tag
      Cc: stable@vger.kernel.org
    in the sign-off area. Once the patch is merged it will be applied to
    the stable tree without anything else needing to be done by the author
    or subsystem maintainer.

Horia
