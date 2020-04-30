Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10406C47254
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 21:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E402420870
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 21:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="ejzlSjOS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgD3Vli (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 17:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726447AbgD3Vli (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 17:41:38 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D839C035495
        for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2020 14:41:36 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id p16so5771027edm.10
        for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2020 14:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hkpaJwE+XdImJwiRCGmMrHpnH9Do497AqONxguPuLh4=;
        b=ejzlSjOSQT9fOgnWL9BlmOywT9YUrObwmrAsjURuygWHxwV8OQVp72xlXJtZ02/TVw
         DIT/agnijUbVoAX7BK86VAyjiWzMyGXM2KTuZI6UNemsiX1Cq2rx0pT3HwreM1CaOKlk
         g255rxIrtopXIP8n5gl+jKtXRgHpDyi++7rWe+DxBDgBZCFAwnPQpsWVH19peAeY9FzY
         yaIFdv6+/raAyg7urd5JvKL/fqOUW4UB7EqADLBzSUJ+f8Aahl2Zz0zKvpxAEb37wx7V
         DTqNs130Y7jUegFidoOJ9vnmbx17b9H5MOSZ5HwfoY9hpRUnZWiWdAn+WzCJoM0ygalG
         kz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hkpaJwE+XdImJwiRCGmMrHpnH9Do497AqONxguPuLh4=;
        b=qKn3QmgB0f7h6JSk5TC0Vz+miwdDyeO5IAfuQ82JpP9LD/8ksYDuvWcXiuG/mRVo24
         +14o5IQMH08bp08N/fjOV1Ns/ndEA8KADl5F8vQAEIyP1EKp9GWD/8xoH4VkYUAAAmfR
         1SuJdn+wJuTNblzvr5JHc1TLxRWv3YgR8AadaDDs20bbtK0FY7JPmyMz11Ug5LXrwudP
         SCzSuryAa6f3/ZDmqexVzbnwziRRzR8mB7bVa1mzsciWZBtY/FCBkRqQ35aOnQaDqjeu
         Ly+7s1Ql18R+klxLWn4wVfWkkgDLM7OobDyTwKInA8ulGVLi2OWuCFzLTfisyntUo0Cq
         rQwA==
X-Gm-Message-State: AGi0PuZWqgoqVRXCkjm8rZh2pvtXVudnfTONaUBWWefTJ7EFwbBUzg7R
        pw9BPulW8eJ7OBYyVx6f5g6vu1y8O9Q50I8McUtG6g==
X-Google-Smtp-Source: APiQypJ/NZIDe1nyo+ttBHz9E+jzzV+NreYGwdIKd9gp9L17jS4zp63ur9u6iJDTRLJh3/QP04vldfbKOZe8y5H1q9E=
X-Received: by 2002:a50:c28a:: with SMTP id o10mr979777edf.85.1588282895115;
 Thu, 30 Apr 2020 14:41:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com> <20200430143131.7b8ff07f022ed879305de82f@linux-foundation.org>
In-Reply-To: <20200430143131.7b8ff07f022ed879305de82f@linux-foundation.org>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Thu, 30 Apr 2020 17:40:59 -0400
Message-ID: <CA+CK2bDwg=s6RbTCirm4U5gvRsnCMred-pnrW=WzN9hfGuBsiQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] padata: parallelize deferred page init
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-crypto@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 30, 2020 at 5:31 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 30 Apr 2020 16:11:18 -0400 Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
>
> > Sometimes the kernel doesn't take full advantage of system memory
> > bandwidth, leading to a single CPU spending excessive time in
> > initialization paths where the data scales with memory size.
> >
> > Multithreading naturally addresses this problem, and this series is the
> > first step.
> >
> > It extends padata, a framework that handles many parallel singlethreaded
> > jobs, to handle multithreaded jobs as well by adding support for
> > splitting up the work evenly, specifying a minimum amount of work that's
> > appropriate for one helper thread to do, load balancing between helpers,
> > and coordinating them.  More documentation in patches 4 and 7.
> >
> > The first user is deferred struct page init, a large bottleneck in
> > kernel boot--actually the largest for us and likely others too.  This
> > path doesn't require concurrency limits, resource control, or priority
> > adjustments like future users will (vfio, hugetlb fallocate, munmap)
> > because it happens during boot when the system is otherwise idle and
> > waiting on page init to finish.
> >
> > This has been tested on a variety of x86 systems and speeds up kernel
> > boot by 6% to 49% by making deferred init 63% to 91% faster.
>
> How long is this up-to-91% in seconds?  If it's 91% of a millisecond
> then not impressed.  If it's 91% of two weeks then better :)
>
> Relatedly, how important is boot time on these large machines anyway?
> They presumably have lengthy uptimes so boot time is relatively
> unimportant?

Large machines indeed have a lengthy uptime, but they also can host a
large number of VMs meaning that downtime of the host increases the
downtime of VMs in cloud environments. Some VMs might be very sensible
to downtime: game servers, traders, etc.

>
> IOW, can you please explain more fully why this patchset is valuable to
> our users?
