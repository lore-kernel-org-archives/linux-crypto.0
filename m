Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE544C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 06:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8193E61206
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 06:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbhEQGKz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 02:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230062AbhEQGKv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 02:10:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5412611CD;
        Mon, 17 May 2021 06:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621231775;
        bh=gES0Ehu40rCdH6iySppTng7VxFfjn0gR+e+q6KrOMKw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=tufFpCQ1H5anOXAZ+gs0cV1nfiUOv5ZN5rQLRjJfju9zLEupDj6DKLii5cRwevgq6
         aRBdfVPT7K3CDAIukiRI944gK3m+F5wBAEzhxtLtRcfJJJvRnsdXd5vhUP8EAWD9MN
         qWEdw/G0anbeOXy3RsO8F6oVHxAsr9Q6V1UDwRWGnlNlOIPdMI2hKzyaPz76lDxSh8
         ySI02484T9t0zERUiKvHybuNWSHcYdiwcc405TWQs/rqv4quvsO/MWe4x4EBoHjmR7
         6HgjSnIIG485UUPtjHO9pJwVExeCVCTbiZXcU+8eihnYh8sj16LB8pKyQ4zGiJ2ULE
         p9CkIBBW5C/3Q==
Subject: Re: [PATCH 0/6] Misc. SA2UL fixes/cleanups
To:     Suman Anna <s-anna@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Deepak Saxena <dsaxena@plexity.net>, Keerthy <j-keerthy@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        Vaibhav Gupta <v_gupta@ti.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210514161246.22517-1-s-anna@ti.com>
From:   Tero Kristo <kristo@kernel.org>
Message-ID: <e28bebf5-0701-797c-414a-b18855dda624@kernel.org>
Date:   Mon, 17 May 2021 09:09:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210514161246.22517-1-s-anna@ti.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 14/05/2021 19:12, Suman Anna wrote:
> Hi All,
> 
> The following series includes various fixes for multiple minor
> cleanup issues on failure paths in the TI K3 SA2UL Crypto driver.
> The patches are all based on top of 5.13-rc1.
> 
> Patch 1 is the only non SA2UL patch, and allows the OMAP RNG driver
> to be built for K3 platforms and probed properly when SA2UL is
> selected, and the SA2UL driver is probed (the rng device is a child
> of the sa2ul device).
> 
> regards
> Suman
> 
> Suman Anna (6):
>    hwrng: omap - Enable driver for TI K3 family
>    crypto: sa2ul - Fix leaks on failure paths with sa_dma_init()
>    crypto: sa2ul - Fix pm_runtime enable in sa_ul_probe()
>    crypto: sa2ul - Use of_device_get_match_data() helper
>    crypto: sa2ul - Use devm_platform_ioremap_resource()
>    crypto: sa2ul - Remove child devices in remove

For the whole series:

Reviewed-by: Tero Kristo <kristo@kernel.org>

> 
>   drivers/char/hw_random/Kconfig |  2 +-
>   drivers/crypto/sa2ul.c         | 46 ++++++++++++++++++----------------
>   2 files changed, 25 insertions(+), 23 deletions(-)
> 

