Return-Path: <SRS0=S8oY=Z7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D72C43603
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 12:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 459322077B
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 12:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfLIMjc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Dec 2019 07:39:32 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:53084 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbfLIMjc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Dec 2019 07:39:32 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0792520561;
        Mon,  9 Dec 2019 13:39:31 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id obF4NnWHq7ae; Mon,  9 Dec 2019 13:39:30 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 428012055E;
        Mon,  9 Dec 2019 13:39:30 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 9 Dec 2019
 13:39:30 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E30F93180AC3;
 Mon,  9 Dec 2019 13:39:29 +0100 (CET)
Date:   Mon, 9 Dec 2019 13:39:29 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: RFD: multithreading in padata
Message-ID: <20191209123929.GQ8621@gauss3.secunet.de>
References: <20191203155841.56egvxekxgf5xctw@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191203155841.56egvxekxgf5xctw@ca-dmjordan1.us.oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 03, 2019 at 10:58:41AM -0500, Daniel Jordan wrote:
> [resending in modified form since this didn't seem to reach the lists]
> 
> Hi,
> 
> padata has been undergoing some surgery lately[0] and now seems ready for
> another enhancement: splitting up and multithreading CPU-intensive kernel work.
> 
> I'm planning to send an RFC for this, but I wanted to post some thoughts on the
> design and a work-in-progress branch first to see if the direction looks ok.
> 
> Quoting from an earlier series[1], this is the problem I'm trying to solve:
> 
>   A single CPU can spend an excessive amount of time in the kernel operating
>   on large amounts of data.  Often these situations arise during initialization-
>   and destruction-related tasks, where the data involved scales with system
>   size.  These long-running jobs can slow startup and shutdown of applications
>   and the system itself while extra CPUs sit idle.
>       
> There are several paths where this problem exists, but here are three to start:
> 
>  - struct page initialization (at boot-time, during memory hotplug, and for
>    persistent memory)
>  - VFIO page pinning (kvm guest initialization)
>  - fallocating a HugeTLB page (database initialization)
> 
> padata is a general mechanism for parallel work and so seems natural for this
> functionality[2], but now it can only manage a series of small, ordered jobs.
> 
> The coming RFC will bring enhancements to split up a large job among a set of
> helper threads according to the user's wishes, load balance the work between
> them, set concurrency limits to control the overall number of helpers in the
> system and per NUMA node, and run extra helper threads beyond the first at a
> low priority level so as not to disturb other activity on the system for the
> sake of an optimization.  (While extra helpers are run at low priority for most
> of the job, their priority is raised one by one at job end to match the
> caller's to avoid starvation on a busy system.)
> 
> The existing padata interfaces and features will remain, but serialization
> becomes optional because these sorts of jobs don't need it.
> 
> The advantage to enhancing padata rather than having the multithreading stand
> alone is that there would be one central place in the kernel to manage the
> number of helper threads that run at any given time.  A machine's idle CPU
> resources can be harnessed yet controlled (the low priority idea) to provide
> the right amount of multithreading for the system.
> 
> Here's a work-in-progress branch with some of this already done in the last
> five patches.
> 
>     git://oss.oracle.com/git/linux-dmjordan.git padata-mt-wip
>     https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=shortlog;h=refs/heads/padata-mt-wip
> 
> Thoughts?  Questions?

I'm ok with this. Please consider to add yourself as
a Co-Maintainer, I guess you know the code in between
much better than I do :)

