Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7117C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 18:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9866208FE
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602527703;
	bh=4bedygPxkAIdJoSdpOeA13U7DggA6lrz5iExsiBazPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2fHh5Y6N5Hdd50miue+Msh1Mrgryw368n5JykR4gnMC+qvZg5U5hXR06ow+DsofM0
	 OyhGOnpMGQGJsqmUEsJN6hsNILWwzfuEUAV1j6nQ2mWh1z62sGrpVVjIVY3y01AkIY
	 TrjNvirlNWk8XgK5PrhLlFUxDCU7PUJzKkcqSFwk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389336AbgJLSfD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 14:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389213AbgJLSfC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 14:35:02 -0400
Received: from linux-8ccs (p57a236d4.dip0.t-ipconnect.de [87.162.54.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9933020797;
        Mon, 12 Oct 2020 18:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602527702;
        bh=4bedygPxkAIdJoSdpOeA13U7DggA6lrz5iExsiBazPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S7hfWuJJGRQ3EMneN7eL6QLc2STkWB9VKl2NCkFX2dzbQzYkhWqgWUnpuMWjdxE8f
         vsaSAbVKrj7hDPWwY3cbGtzd30e24nBJ06PiSqY5i+XD6mVmYioG9FLrREZev5ksn/
         PGJzqGfubIl9Q5894Dbr2c9fOoOqO6wZCoMuBfTA=
Date:   Mon, 12 Oct 2020 20:34:57 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: statically initialize init section freeing data
Message-ID: <20201012183456.GA7338@linux-8ccs>
References: <20201008173220.923671-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201008173220.923671-1-daniel.m.jordan@oracle.com>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

+++ Daniel Jordan [08/10/20 13:32 -0400]:
>Corentin hit the following workqueue warning when running with
>CRYPTO_MANAGER_EXTRA_TESTS:
>
>  WARNING: CPU: 2 PID: 147 at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
>  Modules linked in: ghash_generic
>  CPU: 2 PID: 147 Comm: modprobe Not tainted
>      5.6.0-rc1-next-20200214-00068-g166c9264f0b1-dirty #545
>  Hardware name: Pine H64 model A (DT)
>  pc : __queue_work+0x3b8/0x3d0
>  Call trace:
>   __queue_work+0x3b8/0x3d0
>   queue_work_on+0x6c/0x90
>   do_init_module+0x188/0x1f0
>   load_module+0x1d00/0x22b0
>
>I wasn't able to reproduce on x86 or rpi 3b+.
>
>This is
>
>  WARN_ON(!list_empty(&work->entry))
>
>from __queue_work(), and it happens because the init_free_wq work item
>isn't initialized in time for a crypto test that requests the gcm
>module.  Some crypto tests were recently moved earlier in boot as
>explained in commit c4741b230597 ("crypto: run initcalls for generic
>implementations earlier"), which went into mainline less than two weeks
>before the Fixes commit.
>
>Avoid the warning by statically initializing init_free_wq and the
>corresponding llist.
>
>Link: https://lore.kernel.org/lkml/20200217204803.GA13479@Red/
>Fixes: 1a7b7d922081 ("modules: Use vmalloc special flag")
>Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
>Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
>Tested-on: sun50i-h6-pine-h64
>Tested-on: imx8mn-ddr4-evk
>Tested-on: sun50i-a64-bananapi-m64
>Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>

Applied, thanks!

Jessica
