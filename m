Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD2737C929
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 09:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783502578; cv=none; b=LlGYTK89P4B7LB+AuTMKUsVt6qNDnJTZq6N0W2M/00PtKv6g8L3lGOV0i0bwlrz1kRx5PnXvf6QSVz0RYeKgou+lHaeBJTMxW1sh5NHwZufgxyluh20L/F+VKGbpi7dAdH9CQfXK7Blfu/T6An9bR3ddHXYLpRlahrj1yfe+Uf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783502578; c=relaxed/simple;
	bh=71IPpVxSL6rELSFV3RscCJl7aym1gXBpQyo2V285sW4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QAjzgU/gu8jWESuGBhI3ma3WMvKtLX/V9aulYgus4QYKVPcVA7vQM8461GVBTuTnQWrX/kiNtnYnL8ZN5YNheBiiSE1ATuRiRzmLFpqiMNjTZ6soshPUHs+9dw8BqzPvmxR+zKMrDIjhEpWfw5XXqMdKw3m+IkH1ooc+ZwXnMLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oiAX3HRW; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oiAX3HRW"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-381216921aaso477787a91.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2026 02:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783502576; x=1784107376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bESlo7lvNwhdiVElYDSnZy0QW9Bj+WsccRVrVGGNJng=;
        b=oiAX3HRWBGooIDPulrZn1l987zJdstH6BPbfN05ASw4hB35iJdMBZ0YS8nsNTs7ePL
         j3IRes2PnwojXzYU9NApKi2RPH1kFghEsvJNjad8A6lt6NAlQaacFDggaaA2t0aOzkeP
         f7v0sXq0y/aGroJ8n16OTv5EUFZztalq3WLGn5J9wrYco9f2DIqB03K/KNJ7u25p35WY
         Q5ClouECdVbbyz0uZqQM0Se4l21yINh6j2LzNPH+4Zf12OWh6bK0ZFma4b2+btlDju8u
         b43opC16xq8o0VFCk0hr9hp3uu29bs14ZReLVRqPFZ3K2hFvatl1D2nBqAZyadRfMo3k
         zxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783502576; x=1784107376;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bESlo7lvNwhdiVElYDSnZy0QW9Bj+WsccRVrVGGNJng=;
        b=J4k9uIUUl/IQYhDq7zNHXy7yg+GI5gLNGH5bKK6TS/DIwZ4Gi6k5ugJ3lhrvuJ+PNv
         toLcH4iB0+zvinI1ISAS41Y+h/hSLSgzYYs/c6bvKIMk5mzBPh+J9qrMt4FTMTAGtPMS
         0+DenJB5yhpRsPbGfbWyrBmcy6uth59/wazYwJwwgqY59f/dPhr6r3ZxfE5Eyev1Tigm
         XkvPOnaDicc3cNDwF7S2XQL0vhqXC0u5v99irsDqdZlINgvXAZ/8sEh/t5oPtRYUZgde
         ijc59um4a2dtMb8p+nnhdHq7i6wp7IohWZg5qwFOcuvspw1EkZdIDXZt4f7Ez9VCW1n0
         I2LQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpx/Ade8/jWNVN9/i8MdfUPq0AgOT9u4JHoMv4y9AsOcRDLjttR2fBCufvL5K964S65Atx/LLOUvgYl0Sk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yza8O8XiF3bfAraTMrWtZ3MqicHX7nl+63d2ZhsuW7Sd+l4UKGm
	yxRuBPJKiHc7Gx6O/tfZLbXrL2NPPrRqAC/nu4lEj5s/pt+R/dBaCdJoTPmv+A==
X-Gm-Gg: AfdE7ckoAeRdPUrZi3e/zG5Iww+ItOAS2XdtNONQYH1DTrZT1ZZUPlGcGVgtXVLWG2G
	4e8+5rTDQ/C/s5l3rjjNMNAgpmtm0iOihQ5SnmFljUIohlXzvGkNaudA0QaSiSQ3ljnf/xDHbsS
	WhL6CJGTIAaxnmiLOo9bLhFnEnTRFDuqQ/jtq8SCHuvsPoi3tyrmOhHX3rAbr3N8gP9K5xcOXPe
	+FS3Yt4v/dUwTNSlpI5IxD2I6LA1/XsTL790f6kPulKg1qg009ks4vBeO0UE8GPDsO55QvJhfCZ
	RVGHiIjfCnEHsCLsWYLwumWCsyKZR2LoDS+d1qXEjX8EhDadoDFQsGmfquMEA0qVigK98zfQB3t
	qOU4AuI5fXmsktOSt+ABo0BSwIwp8w5xSCo784dm6lf1JmGV5lZ+hpgZ8tDvg132HOiHBQRhURk
	TMQSvd
X-Received: by 2002:a17:90b:17c1:b0:37f:ed7e:7e42 with SMTP id 98e67ed59e1d1-3893ff630c1mr1831193a91.14.1783502576376;
        Wed, 08 Jul 2026 02:22:56 -0700 (PDT)
Received: from homebox ([66.75.253.8])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3118389d9bcsm9985334eec.20.2026.07.08.02.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 02:22:56 -0700 (PDT)
From: Yuan Tan <yuantan098@gmail.com>
To: linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org
Cc: yuantan098@gmail.com,
	jhs@mojatatu.com,
	gregkh@linuxfoundation.org,
	sven@narfation.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [RFC] VEGA: a syzbot-like workflow for LLM-found kernel bugs
Date: Wed,  8 Jul 2026 02:22:47 -0700
Message-ID: <20260708092247.4188498-1-yuantan098@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

We would like to ask for feedback on a proposed workflow for reporting Linux
kernel bugs found by an LLM-assisted code auditing tool that we have
been developing since earlier this year.

Since February, we have been developing an LLM-driven kernel code auditing
tool called VEGA. It started as a side project, but the results became much
substantial than we expected: VEGA has found hundreds of valid bugs in Linux
kernel.

That immediately created a practical problem: we do not want to dump a large
pile of bug reports onto mail lists and annoy the maintainers.

The first thing we tried was to fix as many as we could ourselves. We
started working with a group of student volunteers. Most of them are
college students, so we have been training them, reviewing their patches,
and trying to build an internal review process before anything is sent to
the mailing list. The goal is to turn these findings into useful fixes, and
also to help new contributors grow into people who can reduce maintainer
workload instead of adding to it.

The process was not perfect. Some patches were not good enough, and we also
made some mistakes early on when deciding what should be called a security
issue.  Our internal review process has been improving with the help of the
community.

Since March, we picked up non-root triggerable bug first and have worked on
fixes for more than 100 validated kernel bugs. we especially want to thank
the students and professor who have helped a lot with this effort.

But the remaining queue is still too large for us to handle.

Recently Jamal pointed out problems around our tags. That made me realize
that we should probably stop treating this as an ad-hoc patch effort and
build something closer to syzbot: public, reproducible, trackable,
deduplicated, and useful to maintainers.

So this mail is an RFC for a VEGA reporting workflow.

The rough idea
==============

VEGA would have a public dashboard, similar to syzbot, and would
send selected bug reports to the relevant kernel mailing lists.

The goal is to send reports that contain enough information for maintainers
or other developers to pick up, understand, reproduce and fix the issue.

For each public report, we expect to include:

  - a description of the bug
  - the tested kernel tree and commit
  - the kernel config and environment
  - the crash log
  - a minimized user-space reproducer
  - the suspected introducing commit
  - a suggested fix patch

The suggested fix patch is meant to reduce maintainer burden. It still need
human review, but hopefully it can save a lot time from building a patch
from scratch.

What will be public
===================

All VEGA findings that we have evaluated as not having major security
impact can be published on the VEGA dashboard. The dashboard would make it
possible to see what VEGA found, whether the issue was reproduced, whether
a fix exists, whether it was reported to a mailing list, and whether it has
been fixed upstream.

For issues that we have validated as having possible serious security
impact, we will not publish it on the public dashboard before going through
the appropriate kernel security process.

Dumping everything onto the mailing list may be annoying. During the initial
stage, reports will be rate-limited and sent manually. We will check for
duplicates against lore/upstream, and make sure the issue is not already
fixed or reported.

Report identity and tags
========================

Each public VEGA report will have a stable identity, similar to
syzbot reports.

One possible format is:

  Reported-by: VEGA <vega+HASH@DOMAIN>
  Closes: <public dashboard URL>

=========

We would like to hear what maintainers think about this before we start
sending these reports.

We do not want VEGA to become another source of mailing list noise. The goal
is to make LLM-based bug finding transparent and useful, and to make sure
the reports come with enough context, reproducers, suggested fixes, and
tracking so that they reduce work rather than create more.

Thanks,
Yuan

