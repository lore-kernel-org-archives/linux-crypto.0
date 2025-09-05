Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C4A2F747F
	for <linux-crypto@vger.kernel.org>; Fri,  5 Sep 2025 08:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757062638; cv=none; b=nIqfU0qcf+sRvutCQFldE8jdR+jzxJUaeNMdp4UjfazlHG8nv6BEkfryGoHhPoYn1drqzXMYaYP6Q3eTh+gphuFgJbdDho6W6+VNEPyghiNpsRSX6/FVT0NUb3x53ABBnnOBcQhahQJB6F7NVRtMfMtAoR4Fo1cXniot73Xlb3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757062638; c=relaxed/simple;
	bh=zuvbcqOLzoPAa32zaS/DgxZj9rgIwsJxCNPUawS/9Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ltxNMgNfncAt0kpbSxQaNe8mOI+rrxxzUQloqFk7t5oP1K4HUjob1Z1tbcUPo086hOxGYpz02rITUYEGFkimSk27lS9pV6DQsWYN04XKGCIxRkcEjbQF4H/cIPcBliqlYGpsmhUf+t53amHiZ44m5svMM86gVdFduzY/rYn99k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f4nv9kN5; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f4nv9kN5"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3dce6eed889so1531943f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2025 01:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757062635; x=1757667435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=znwp4C4v95+qHd2E8LFw+2t+5KgGtZOkmrZsAKEXt/s=;
        b=f4nv9kN50iPQc0D32HBh1II0fKrGO1PQzdB8mmhnBSv8PkU4ckNKrxCx7L2U0rBbi0
         g17of2txVGe8BNSojqvsVSWJLTio/siHYrP5BUcaW+0bKYOkA4WAN7wSSipTY2TwIZco
         TTJefp4GwrJJWfl6DN0ZJ3+GC9E5mzjE/I4Eqv5elI982517K8wSeaRCpGIulhoQ3Tzz
         TdKHYTmSe5nbtrj6A1VRliL10iUYSH9FKGlE0Pq5TPt4mHALD7LSylKDKjhRefnCYU23
         OVfoYl/PTSi5c0z4uvHNUYOUfceXBl/nc8d8HYxfJANJqu1q2G/D4e9nDPSQ797QqeMS
         gvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757062635; x=1757667435;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=znwp4C4v95+qHd2E8LFw+2t+5KgGtZOkmrZsAKEXt/s=;
        b=gJ7TEwEkq9rk95FE0CNUdU9ytxLaTGjJYX4wYTPOIiQh6XNa+4cJl+MQaDRCdrVHqc
         qiIP4KC+MWnp/rt6asxierDgPLfCGzv2b7OK2TrAWYnLIKXTOyXPimfDGgyhYOpX4HFf
         qyP6kBy5rJIFbRKWRTrZuWK1XOh5E0BkO4nPjBtJka2tk/C7vkUwY2ey4r8LaEdvfJNs
         m39QQqqitIVEpC3SXRcOoW6KPCz/4w8Bbfj0gPtlk8z3+3wPsJTcr2EW/TYjJMXgdDWS
         AymF+ReDFcprmzmjKKBclpdu9Ev8uMB7HwwTbbErh4dVLstlM1xShZH/437skOBX4tJL
         2giA==
X-Forwarded-Encrypted: i=1; AJvYcCU1O0W+ErF1X1eGUfur69mFESc3z/CXCkcwCvVJEHnCp8pXviHWVxNI8zCaP3FxVYi06OI5y+JYUwE6xlU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6Ch4H8E/+TRln5CtEqBkXVrZ9Ud1J3hCMp6PejDLbLs7goWok
	USjQkMXEF052Ih0hjLvJmMRwTshjwZD0STx7G6P4I3es8slgVRtzHqZZn3M/qogGkgo=
X-Gm-Gg: ASbGncv69euHHrOY6f7RX1r+PdyEeDITJawHg8r8XBeK7SmdVDpeWajatBZ85U07lHO
	axD52BEk9Wq17RIFstg5D/eWrJcV+WQw2rhXz+CiBjL6S/DQ1rDLmSspAVrw9lUJzOb3KRVBuo2
	dJpcwE+DKvwkpYBfUaMPQ1GsTC7eoToTkiWay8h0ci4IhlMNYHUbdJ9RAQV70evvLxAqUaKHHNR
	SP31xHdN2NbXmgcljyo3+BfuHIFJogWPf7EmbFE1dOEiZSFe7MWpSxLxVBMZDuotnJwjUFACfTn
	5u7FIugLzINAB0UavG5XbH8G5nV4GBEbywDNexuEbGs2Otr+BkXpZNSx7EUsx0Uw1/xunmHvyFC
	Tb/W5g45STctoH2DXwyVeqO9SptFew8W/gD0djvDMHMoJ6yFqC2oBnozSww==
X-Google-Smtp-Source: AGHT+IGuYF2bLdMT7mLcoG6rGpsHYL5+Th0o0eIU2Lcti8x5bljtFqT8i7q4b6d9C9pace17CVL/KQ==
X-Received: by 2002:a05:6000:24c8:b0:3e2:9a5a:1f38 with SMTP id ffacd0b85a97d-3e29a5a21e7mr2177856f8f.50.1757062635243;
        Fri, 05 Sep 2025 01:57:15 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e177488999sm5094989f8f.36.2025.09.05.01.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 01:57:14 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	"David S . Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/1] crypto: replace wq users and add WQ_PERCPU to alloc_workqueue() users
Date: Fri,  5 Sep 2025 10:57:00 +0200
Message-ID: <20250905085701.97918-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

1) [P 1] add WQ_PERCPU to remaining alloc_workqueue() users

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

Marco Crivellari (1):
  crypto: WQ_PERCPU added to alloc_workqueue users

 crypto/cryptd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.51.0

