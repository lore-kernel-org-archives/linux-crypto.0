Received: from n169-111.mail.139.com (n169-111.mail.139.com [120.232.169.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EF83D9DD3;
	Tue, 28 Apr 2026 08:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777366649; cv=none; b=u5sJ/iR7hBuKgevES7AwKHhYB/7rtjPbZCBOVE/cktBwwq8xoe1eJ5b8vONdzLH5n00KOn01pFsEybIEMFSbFmPMKPFJ96Z3p0nXYke3BR615aanst8fgRvmw2q7pvQowgqgkr6enNA8IvdX0f+4xii/KMQB2BUm6MdG3LXcvEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777366649; c=relaxed/simple;
	bh=K+2AlydItDpwcJJn/4PPx8mtDdI3scpVOKfjw6ehdsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b0Kv7GIpKyTzBoAhyBOlWrHWws/w78wdB+1Wcr500zFbfBRpYnysgGKFwcU34BACztntqUY0aq7L6SJ2K6Ynpvlt3YMI4Pq9ZLcnFweqDHBqdNhbtwzdmyfV2GUKhUDfQwoAyGjLEFmJUE7I2zhtbeY4RH3Fw6+nOiOsoa5YC1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=ckj4jJzx; arc=none smtp.client-ip=120.232.169.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="ckj4jJzx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=ckj4jJzx6GdrKhc2mW2cg3rwhQzwzafn5i8tl+JA3Y6CnxE9HRtn244R7wjsZYDkLFl/OWH+V+rLq
	 VVQbowftvm6O9JzIWeugH812M2Ni+oWBbEV6xhH98tkNzS5i3mKEtd3Lo2YWzthb+tXAjR3ZiGvLpL
	 NA9Mp1B9TGLdv93w=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from China-139-kernel-team (unknown[47.95.114.252])
	by rmsmtp-lg-appmail-14-12003 (RichMail) with SMTP id 2ee369f07660cf4-01d18;
	Tue, 28 Apr 2026 16:57:10 +0800 (CST)
X-RM-TRANSID:2ee369f07660cf4-01d18
From: Bin Lan <lanbincn@139.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 5.10.y 0/2] backport to fix a race condition/UAF in the padata subsystem
Date: Tue, 28 Apr 2026 16:56:59 +0800
Message-ID: <20260428085701.1480-1-lanbincn@139.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series backports the padata use-after-free fix and its follow-up
cleanup to the 5.10.y stable branch. There is a race condition in 
padata_reorder() dating back to the initial padata commit.

Backport notes for 5.10.y:

  - The upstream fix (commit 71203f68c774) was written against mainline
    which uses the 2-argument cpumask_next_wrap(cpu, mask) API introduced
    by dc5bb9b769c9 ("cpumask: deprecate cpumask_next_wrap()"). Since
    6.1.y still has the original 4-argument API, the call in
    padata_reorder() is adapted to:
      cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false)
    This is functionally equivalent.

  - The context in padata_find_next() differs from mainline due to
    f954a2d37637 ("padata: switch padata_find_next() to using
    cpumask_next_wrap()") not being present in 6.1.y. The conflict was
    resolved.

After applying this series, kernel/padata.c matches the upstream file at
commit 71203f68c774 with a few differences. None of these differences 
affect the fix, the core changes to padata_find_next(), padata_reorder(), 
and padata_do_serial() are identical.

Testing:
  - Built and booted on x86_64 (4 CPUs)
  - All 4 test cases passed:
    * Basic parallel->serial reorder (64 jobs)
    * Out-of-order parallel completion reorder (64 jobs)
    * Concurrent jobs + padata_replace race (64 jobs)
    * Stress test (10 iterations x 64 jobs, random delays)
  - No KASAN/BUG/WARNING/UAF detected in dmesg

Bin Lan

Herbert Xu (2):
  padata: Fix pd UAF once and for all
  padata: Remove comment for reorder_work

 include/linux/padata.h |   4 --
 kernel/padata.c        | 136 +++++++++++------------------------------
 2 files changed, 37 insertions(+), 103 deletions(-)

-- 
2.43.0


