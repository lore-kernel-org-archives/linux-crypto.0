Return-Path: <SRS0=CDDf=4T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF2EC3F2CD
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 18:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FA362173E
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 18:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgCBSAQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Mar 2020 13:00:16 -0500
Received: from foss.arm.com ([217.140.110.172]:35876 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgCBSAQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Mar 2020 13:00:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4343D2F;
        Mon,  2 Mar 2020 10:00:16 -0800 (PST)
Received: from [10.1.196.37] (e121345-lin.cambridge.arm.com [10.1.196.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 768873F6C4;
        Mon,  2 Mar 2020 10:00:12 -0800 (PST)
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
To:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     mark.rutland@arm.com, jiangshanlai@gmail.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tj@kernel.org, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <20200217204803.GA13479@Red>
 <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
 <20200220090350.GA19858@Red>
 <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
 <20200228123311.GE3275@willie-the-truck>
 <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
 <20200301175351.GA11684@Red>
 <20200302172510.fspofleipqjcdxak@ca-dmjordan1.us.oracle.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <e7c92da2-42c0-a97d-7427-6fdc769b41b9@arm.com>
Date:   Mon, 2 Mar 2020 18:00:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200302172510.fspofleipqjcdxak@ca-dmjordan1.us.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 02/03/2020 5:25 pm, Daniel Jordan wrote:
> On Sun, Mar 01, 2020 at 06:53:51PM +0100, Corentin Labbe wrote:
>> I tried to bisect this problem, but the result is:
> ...
>> # first bad commit: [81ff5d2cba4f86cd850b9ee4a530cd221ee45aa3] Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
>>
>> The only interesting thing I see in this MR is: "Add fuzz testing to testmgr"
>>
>> But this wont help.
> 
> Hm, that merge commit has only a couple lines of powerpc build change, so maybe
> there's something nondeterministic going on.

Something smelled familiar about this discussion, and sure enough that 
merge contains c4741b230597 ("crypto: run initcalls for generic 
implementations earlier"), which has raised its head before[1].

> Does this fix it?  I can't verify but figure it's worth trying the simplest
> explanation first, which is that the work isn't initialized by the time it's
> queued.

The relative initcall levels would appear to explain the symptom - I 
guess the question is whether this represents a bug in a particular 
test/algorithm (as with the unaligned accesses) or a fundamental problem 
in the infrastructure now being able to poke the module loader too early.

Robin.

[1] 
https://lore.kernel.org/linux-arm-kernel/20190530170737.GB70051@gmail.com/

> thanks,
> daniel
> 
> ---8<---
> 
> Subject: [PATCH] module: statically initialize init section freeing data
> 
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
>   kernel/module.c | 13 +++----------
>   1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 33569a01d6e1..db0cda206167 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -88,8 +88,9 @@ EXPORT_SYMBOL_GPL(module_mutex);
>   static LIST_HEAD(modules);
>   
>   /* Work queue for freeing init sections in success case */
> -static struct work_struct init_free_wq;
> -static struct llist_head init_free_list;
> +static void do_free_init(struct work_struct *w);
> +static DECLARE_WORK(init_free_wq, do_free_init);
> +static LLIST_HEAD(init_free_list);
>   
>   #ifdef CONFIG_MODULES_TREE_LOOKUP
>   
> @@ -3501,14 +3502,6 @@ static void do_free_init(struct work_struct *w)
>   	}
>   }
>   
> -static int __init modules_wq_init(void)
> -{
> -	INIT_WORK(&init_free_wq, do_free_init);
> -	init_llist_head(&init_free_list);
> -	return 0;
> -}
> -module_init(modules_wq_init);
> -
>   /*
>    * This is where the real work happens.
>    *
> 
