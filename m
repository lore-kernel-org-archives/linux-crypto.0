Return-Path: <SRS0=BuJA=DQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4CCC433E7
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 04:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05CAC221FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 04:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602217041;
	bh=6HzeqdBIfVdvyZk6B7RpcfY+6wxw2GL9NoatG6xmzKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=zy+ezBxO3c7R/I4utUOA09+eYa+RyBSsjgvsWuh1kUa8YAvfMuzVsRUbGucJYSnYc
	 kW2me4DHq1ZCqs4QdvKs4tHEWF/OfJ7Nsqy2plRGFPG0M/qHwVgtn+xZwH07xLp05f
	 0i8BuXvNKi8ye+NPBtoUPlubFWV9ubaKi92Kz1Xg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgJIERU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Oct 2020 00:17:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgJIERT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Oct 2020 00:17:19 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD8A522248;
        Fri,  9 Oct 2020 04:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602217039;
        bh=6HzeqdBIfVdvyZk6B7RpcfY+6wxw2GL9NoatG6xmzKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dD56mhdY8U+eRBjGbi+EGx+ZnFeHXPfrEHEPb7vS3cPUV7mX9bow2Ui4kHI05CUs0
         SnGPeMJVlzEIbqYwo7BOC++emtF9x4YEa+unrqys2lM7MxJMWslDf2zizmI59sAgBb
         HB4syT/6knjOm3WQXnEGxeoo2k25BO2i6gSW619o=
Date:   Thu, 8 Oct 2020 21:17:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Jessica Yu <jeyu@kernel.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: statically initialize init section freeing data
Message-ID: <20201009041717.GA854@sol.localdomain>
References: <20201008173220.923671-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008173220.923671-1-daniel.m.jordan@oracle.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 08, 2020 at 01:32:20PM -0400, Daniel Jordan wrote:
> Corentin hit the following workqueue warning when running with
> CRYPTO_MANAGER_EXTRA_TESTS:
> 
>   WARNING: CPU: 2 PID: 147 at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
>   Modules linked in: ghash_generic
>   CPU: 2 PID: 147 Comm: modprobe Not tainted
>       5.6.0-rc1-next-20200214-00068-g166c9264f0b1-dirty #545
>   Hardware name: Pine H64 model A (DT)
>   pc : __queue_work+0x3b8/0x3d0
>   Call trace:
>    __queue_work+0x3b8/0x3d0
>    queue_work_on+0x6c/0x90
>    do_init_module+0x188/0x1f0
>    load_module+0x1d00/0x22b0
> 
> I wasn't able to reproduce on x86 or rpi 3b+.
> 
> This is
> 
>   WARN_ON(!list_empty(&work->entry))
> 
> from __queue_work(), and it happens because the init_free_wq work item
> isn't initialized in time for a crypto test that requests the gcm
> module.  Some crypto tests were recently moved earlier in boot as
> explained in commit c4741b230597 ("crypto: run initcalls for generic
> implementations earlier"), which went into mainline less than two weeks
> before the Fixes commit.
> 
> Avoid the warning by statically initializing init_free_wq and the
> corresponding llist.
> 
> Link: https://lore.kernel.org/lkml/20200217204803.GA13479@Red/
> Fixes: 1a7b7d922081 ("modules: Use vmalloc special flag")
> Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Tested-on: sun50i-h6-pine-h64
> Tested-on: imx8mn-ddr4-evk
> Tested-on: sun50i-a64-bananapi-m64
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>

Looks good,

Reviewed-by: Eric Biggers <ebiggers@google.com>
