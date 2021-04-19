Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE1DC433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Apr 2021 19:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC6A61260
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Apr 2021 19:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237037AbhDST54 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Apr 2021 15:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235788AbhDST5z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Apr 2021 15:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BF3D61360;
        Mon, 19 Apr 2021 19:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618862245;
        bh=HN0agvC5bpDMcncxRoCVtj+sJEGGse5OK4cctuCruIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=li3eqTraRCQeU+2rPjISToZ8X+4Pujb11JK09sKn5RoDGXX/zRtzLpuM82lc448Qa
         DHTcZ7OSRhai218/9S6E30xtQfPVpP+7jVwuVv73UgvpFOgC3WOST01Je/zdGuxm44
         Ksz4yQfKT6t2OwDpVlIKuZRV8bmMwzF0gtNCgOd2xRp59r4q8PPGznWF2CYvyvtJOa
         HATOmgFU9UWn8gG5AYqKOYVCcbRO8R9zHrJY1uUADqLJk9mIZmUWjJdwq1Kr1Dqv13
         ELsBI+T9Ie4B72bbZqsMaohV2ixHr5S1sQDxengZ+IZAb4ZQF+TV/3llwEPZzcJ+dG
         f1SGvkqM3nNLQ==
Date:   Mon, 19 Apr 2021 12:57:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Mothershead, Hailey" <hailmo@amazon.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: jitterentropy - change back to module_init()
Message-ID: <YH3go6m2ypOWo5pw@gmail.com>
References: <9A0645BD-E7B0-4A7B-BB8F-80C5616502FE@amazon.com>
 <5289E5EC-C15F-44EB-BC5F-C5A515FFF272@amazon.com>
 <4C32DE1B-7EED-432F-8BAE-4BA890ADAACC@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C32DE1B-7EED-432F-8BAE-4BA890ADAACC@amazon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 19, 2021 at 04:16:13AM +0000, Mothershead, Hailey wrote:
> Hello,
>  
> The patch quoted below causes the kernel to panic when fips is enabled with:
>         
>        alg: ecdh: test failed on vector 2, err=-14
>        Kernel panic - not syncing: alg: self-tests for ecdh-generic (ecdh) failed in fips mode!
>  
> This test fails because jitterentropy hasn’t been initialized yet. The assumption that the patch makes, that jitter is not used by the crypto self-tests, does not hold with fips enabled.
>  
> With the patch reverted, i.e. with jitter initialized with module_init, the kernel is able to boot. How can this best be handled to allow the kernel to boot with fips enabled without running into issues with certain clocksources?
>  
> Best, 
> Hailey

I'd recommend looking into why the self-tests would be calling into
jitterentropy in the first place.  That shouldn't be necessary; it doesn't make
sense for known-answer tests to be consuming random numbers.

- Eric
