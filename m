Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B2A28642B
	for <linux-crypto@vger.kernel.org>; Fri,  5 Sep 2025 09:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757063145; cv=none; b=jaCooYO6tdmYruxiDhWeaMSXDuftWOz9phop9/haOc/Cb6iJl2GrElaQtRIOGZ0wcZkSs+gLzU1hzYL/GEbyijRHrb67CdU4STc2zTbDCLpHXdqhpvrUmRdSGNkGEfI7JyuVxDsYh1bOvJNhPeXtf9q+R3zeYFAX3PFt1WqhLnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757063145; c=relaxed/simple;
	bh=7rlP443ba0DDzYK8NU/BhptQqMUCNDKTq2nxVqEIgKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QjYn01EIXmTHVqOapIvhirhdQx4J7NmRL8iOuGHdrvL2bkMj0GV1pR3rk7o/U3PO/IPSYJvymUJshpNsct2VITn8w9j71rTXX7GbqzxCLSUVHitI3PVnerqdthNOWM1Hlt2RLiqwRVi8nipcuwHYwSkhif5TbE+YIXkX/h9na5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dbM/Fo3j; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dbM/Fo3j"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45cb5e5e71eso10882755e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2025 02:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757063142; x=1757667942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ml6kpLurLHQgzI1MKt6btUcw5MKMOYGSJX0YVkxJgts=;
        b=dbM/Fo3jvneDFejTUcgAPsOVX9e3GKcrX4TcHUYR6nJ9mMCkxH/IzFqBK5resNU32A
         DjDe1lJJXPkyaW5cl4Svva2Mt433yEfDVOpCr3hoN5UKBwmLjRo3q5/d+eFAN17ZGnMU
         +NUlk8XawZb4/IUUsbDZxjG4bJgrk9mylsF/A156zamjr0ZpCelMM8+hmkPA8PMcSTET
         16JLLXE7ssm/p8U/MNDss9g8Rgbv9T6fB/noG9K2sveEWAbIQx6NFALbAWsNAvkjaKfq
         rVWjkS1jbnLPkTc+c6TMCm/Td0J6lgvyVdt5cVpQd7bhm1uFurIzb9zgjgQbkmU94dFr
         UIMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063142; x=1757667942;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ml6kpLurLHQgzI1MKt6btUcw5MKMOYGSJX0YVkxJgts=;
        b=WpY7cDPvZWjy3X9C8FFKSQo4txf19XK+FrBZbkcJ356NPURvmacVWhzkUhtuzltRJB
         tvxwF8uUSdxBTUBO0Drr7nZUk3osNLSK9Ugs6s6RhvXlg8YMxLG7RtMSP7Jm7xMQaNZa
         p79QbGY+iHKNHKTzeHBDq9v+3+sezi06OcMUK4P6k7e7BW8kXknXDl4TTdZjsj31mkh/
         tiPZUTfy5Chm/N9hH0Uf9XZx5Y5JtLVo/77g0p81drN5mABSvddGbFMA3PTX4dr/Z0VH
         7gzqfGQZbSffCr57VOq2FiUNUU2ITdv8SPmRXCzLlRDT5ZXc7GiphiFCUelqMbtDYx0f
         Nv4g==
X-Forwarded-Encrypted: i=1; AJvYcCWwyNnC7HaXY6LMwAzkysTFvOx7IMGen0Fv3SjxD8BuNrIFV72b4cfC3PCGYRCErBe8FVsEP+AqHVed+Fg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRV3+2g5ZcU81HKxequqoQ8+dOO6WwiWfJ0arKG7FOeTdFyWEx
	W8yo5eKecrhUNfJsOE6pgkwOFSdPd9gId0pWrXCVOxpPgZrXb9Vh17sUDZHlrX1uDxs=
X-Gm-Gg: ASbGnct/jnZyuwhJ3Hz578gqtyt9nImt0GS9tbQCdLDmKfNeRZ17RvY9AEYTSr199Mp
	A9zkoB8UbUPoEaB/4CV1Gu7u5jIrQ35+ECZxi2WCuWseOlUPOGLy2kBUrc6A7vxRP0UmfNH5iwS
	oooa9/YTu6WocUEGW9JSEsUg2D02R/WI9Z7BYd7MuF3th23uQDKvv5bXWtRPhYDbbVFYQJGA3ij
	5Qc6p+ndxTSinJqpcUvp2zIJr2uO8djL5vhXIABH7yCgLa2i9lTSwfFJcSOZJSgkjavNfYGEVr5
	rK4VW2TlRZB7lFytJH9ThlIgz+cxCkO43Ai2MB7X3dQPZBnTsfyY5LWlap3xIo21yGnjnySSfHy
	o6vrALKs6thCVYCyH3zEmDPtGo8jO0cAp8b7C9JMbTlq/caw=
X-Google-Smtp-Source: AGHT+IELzmyy1eL7EyLMHGA3N8GmuzB2XtybSVBENvuBhEJhkQgQeq9bXjwDmrmHtVrOVJjdzy5lMw==
X-Received: by 2002:a05:600c:4710:b0:45b:8adf:cf2b with SMTP id 5b1f17b1804b1-45b8adfd14bmr148467355e9.21.1757063142188;
        Fri, 05 Sep 2025 02:05:42 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd0350e80sm68794625e9.22.2025.09.05.02.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:05:41 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 0/2] padata: replace wq users and add WQ_PERCPU to alloc_workqueue() users
Date: Fri,  5 Sep 2025 11:05:31 +0200
Message-ID: <20250905090533.105303-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi!

Below is a summary of a discussion about the Workqueue API and cpu isolation
considerations. Details and more information are available here:

        "workqueue: Always use wq_select_unbound_cpu() for WORK_CPU_UNBOUND."
        https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/

=== Current situation: problems ===

Let's consider a nohz_full system with isolated CPUs: wq_unbound_cpumask is
set to the housekeeping CPUs, for !WQ_UNBOUND the local CPU is selected.

This leads to different scenarios if a work item is scheduled on an isolated
CPU where "delay" value is 0 or greater then 0:
        schedule_delayed_work(, 0);

This will be handled by __queue_work() that will queue the work item on the
current local (isolated) CPU, while:

        schedule_delayed_work(, 1);

Will move the timer on an housekeeping CPU, and schedule the work there.

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistentcy cannot be addressed without refactoring the API.

=== Plan and future plans ===

This patchset is the first stone on a refactoring needed in order to
address the points aforementioned; it will have a positive impact also
on the cpu isolation, in the long term, moving away percpu workqueue in
favor to an unbound model.

These are the main steps:
1)  API refactoring (that this patch is introducing)
    -   Make more clear and uniform the system wq names, both per-cpu and
        unbound. This to avoid any possible confusion on what should be
        used.

    -   Introduction of WQ_PERCPU: this flag is the complement of WQ_UNBOUND,
        introduced in this patchset and used on all the callers that are not
        currently using WQ_UNBOUND.

        WQ_UNBOUND will be removed in a future release cycle.

        Most users don't need to be per-cpu, because they don't have
        locality requirements, because of that, a next future step will be
        make "unbound" the default behavior.

2)  Check who really needs to be per-cpu
    -   Remove the WQ_PERCPU flag when is not strictly required.

3)  Add a new API (prefer local cpu)
    -   There are users that don't require a local execution, like mentioned
        above; despite that, local execution yeld to performance gain.

        This new API will prefer the local execution, without requiring it.

=== Introduced Changes by this series ===

1) [P 1] Replace use of system_unbound_wq

        system_unbound_wq is to be used when locality is not required.

        Because of that, system_unbound_wq has been renamed in system_dfl_wq.

2) [P 2] add WQ_PERCPU to remaining alloc_workqueue() users

        Every alloc_workqueue() caller should use one among WQ_PERCPU or
        WQ_UNBOUND. This is actually enforced warning if both or none of them
        are present at the same time.

        WQ_UNBOUND will be removed in a next release cycle.

=== For Maintainers ===

There are prerequisites for this series, already merged in the master branch.
The commits are:

128ea9f6ccfb6960293ae4212f4f97165e42222d ("workqueue: Add system_percpu_wq and
system_dfl_wq")

930c2ea566aff59e962c50b2421d5fcc3b98b8be ("workqueue: Add new WQ_PERCPU flag")


Thanks!

Marco Crivellari (2):
  padata: replace use of system_unbound_wq with system_dfl_wq
  padata: WQ_PERCPU added to alloc_workqueue users

 kernel/padata.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.51.0

