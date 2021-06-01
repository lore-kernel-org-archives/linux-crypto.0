Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C83DC4708F
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 23:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04D0A613B1
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 23:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbhFAX4W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234766AbhFAX4V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Jun 2021 19:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68B9D61167;
        Tue,  1 Jun 2021 23:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622591679;
        bh=jiyCehCLO829F6OKGhd/MkEJDDNUeXwesyXS4WzMpFA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QLYXdKbA96urLnwb0KA5Pkwu6brrP+fVjZOZ6gXjseEpPy4bQ8nVEwCBW0r01239W
         4sTn+s0whEDqQXvyTTG6IhbBrhPA8UxmuUEuVWOSOOy/cvYXk0yjdOL1euKxWx5Ao7
         /whdp2MpLv+1WfGIVRc9adHT08WbA2XFGQ1gPLUnzly+SH95GwUNRNOKhAcZn0Os3l
         4ieZoqbnu6Ct5y7frj9n95ylgMgF6vVyC5yr4U84/PKXeCSd8trScLQZbrO5iraR75
         IIMcGH/Gag5EAZnBLv7nAykwVMfxYFACbCgWpyQeY3zn92fM7TKen8PEAj5Y0wgPoH
         smOUfaDRcelSQ==
Date:   Wed, 2 Jun 2021 08:54:31 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Christoph Hellwig <hch@lst.de>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Eric Biederman <ebiederm@xmission.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jessica Yu <jeyu@kernel.org>,
        "Steffen Klassert" <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        kgdb-bugreport <kgdb-bugreport@lists.sourceforge.net>,
        kexec <kexec@lists.infradead.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] kprobes: Fix spelling mistakes
Message-Id: <20210602085431.a4c2f3eb92f020ed50775eda@kernel.org>
In-Reply-To: <20210529110305.9446-2-thunder.leizhen@huawei.com>
References: <20210529110305.9446-1-thunder.leizhen@huawei.com>
        <20210529110305.9446-2-thunder.leizhen@huawei.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 29 May 2021 19:03:02 +0800
Zhen Lei <thunder.leizhen@huawei.com> wrote:

> Fix some spelling mistakes in comments:
> decrese ==> decrease
> immmediately ==> immediately

This looks good to me.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thanks!

> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  include/linux/freelist.h | 2 +-
>  kernel/kprobes.c         | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/freelist.h b/include/linux/freelist.h
> index fc1842b96469..1811c1f3f8cb 100644
> --- a/include/linux/freelist.h
> +++ b/include/linux/freelist.h
> @@ -39,7 +39,7 @@ static inline void __freelist_add(struct freelist_node *node, struct freelist_he
>  	 * and a refcount increment of a node in try_get, then back up to
>  	 * something non-zero, then the refcount increment is done by the other
>  	 * thread) -- so if the CAS to add the node to the actual list fails,
> -	 * decrese the refcount and leave the add operation to the next thread
> +	 * decrease the refcount and leave the add operation to the next thread
>  	 * who puts the refcount back to zero (which could be us, hence the
>  	 * loop).
>  	 */
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 8c0a6fdef771..d4156082d5a5 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -641,7 +641,7 @@ void wait_for_kprobe_optimizer(void)
>  	while (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list)) {
>  		mutex_unlock(&kprobe_mutex);
>  
> -		/* this will also make optimizing_work execute immmediately */
> +		/* this will also make optimizing_work execute immediately */
>  		flush_delayed_work(&optimizing_work);
>  		/* @optimizing_work might not have been queued yet, relax */
>  		cpu_relax();
> -- 
> 2.25.1
> 
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
