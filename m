Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11422459E7
	for <linux-crypto@vger.kernel.org>; Fri,  5 Sep 2025 09:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757063148; cv=none; b=R7ohKfJqCc5/eTHUQ38tWCcIfj/CLX+lrFcu0x6Fx0fBGMC133PFOY6geKb8YAxewBi/WDeKj2wFlGe5N680YqOsggEJZZvutxEebHN2w/lVR0xDoFcIuV+DxR9N8dZo2CnDu9lgMsEJeNXIQX79eAgE2AOZguiLFM/RBnLtVFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757063148; c=relaxed/simple;
	bh=D19ZMh3k4zThuhjljLy3Ws9w4Xh4cdeVcim8AnQYOTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NxSLq/2sPoMYbBw7wQt4zILbO64H4xvxU+IJkZ6UuQS77j5C7O1B9xjG3bhWziWn0u6pysP2/4pmRTNE4XYENkEORMPN+PgzkFWt0fOSBU45negP973MR+EB6yoaJ3FsMlSoCRuNu55W1USjp8Y6ECiBseoT+LPxUYbtvp2djJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FRL9zxM/; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FRL9zxM/"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45dd513f4ecso7989865e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2025 02:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757063144; x=1757667944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dbpbADN/lQjW6NzzP05gKXfeMJELXaHMuSRw+eYkohE=;
        b=FRL9zxM/u9+LV74c9ppiuPmWm6lADdr3muxKDiPzABcd1CSV3ZBTqbf1WmRY+Qlt4S
         HlQ9AMP2wnPJRQ8dq9VVWp8X/eFsh/ZVo2yb/20H6jRxjhQNylzB2vwFDReCDRwGXBFW
         xXVpQb44luIhTIDSf2DvHPHoh0gh6mPjIEOjOcbBInRIKA8h/IpmFEE0f4wx+jCU00w0
         g2vuH/O2/2cRLdQG1e26TGSutgIvDOLnP1f8X8XDApD+c4Hb2FNJibu4zQeUbhO93Bp5
         nKc0mcLvn/sF69v1Zhtmbi0HQ2lcp3YgSCks6/YBffLVwzVQpVWYDmY2FDxQrAv0RUyb
         A7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063144; x=1757667944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dbpbADN/lQjW6NzzP05gKXfeMJELXaHMuSRw+eYkohE=;
        b=Y//f5aeXtxwJpGykKHE/PfUyfQFnDwBOuoMUbIivQYrZNZGTMgToWmH16f/MKF5YB+
         DJ3F8A2OXYJUogCmIFbd1KeWXTPKy6W+Y6p2MOYoMZIO8Zt73QP7tvg5JS+I1XNbThrF
         rrsAtKLSsbMSb4TIJpQBvFCn73t6IjJGbYkgsh3UP3HtlUHSUBJg3CZZQgsruDg8DUuh
         CSmsHaJfGCytxGfXoBpHPCFFTzfLJ+NG+537JD86Ph4utVlXD/un3GV6TigsPLpvhONs
         DeW/Mu4141i/pcYuYsRn4lvsKQbxB15McxU4VWElptNIjNFFA3AbbKFrCLuP7uhaquE/
         RiMA==
X-Forwarded-Encrypted: i=1; AJvYcCWxyp1t+0qWLH60hEcWpRZ6oRfEsc3wkK6c6KPoHQgTz+fMdMUyvgdQkwi6feSh7rPjPY5+tFzQoebZS+U=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv8G56rgAqE8XLZgvEgQWLrEqtlhIS9Qb0thg6a0j76U9q205r
	kZWRK+WSdMUomo1TBBUNy9m8Nn5QOep2OFXfCDgqsDCKSinw5QuvWAXxpPck+4uW4T8=
X-Gm-Gg: ASbGncsCNEwlN6L04opl3Bbj0/TN7jBMO/JpIvLdun/Wtdhoja+pT4LlaEQvzlW3bxG
	KNv+N86L/fxkh3sF3aqU27kzxpiqX5ADwI5jQBtLBr0qu+ns9krfiK+crXm7ijiyOZrK/43KKmN
	4w82ffVUfZAa/FLXUOMqbnVubWKG6zzONAIZK6TF1S0HW2jNlr1ptNCZinYQqVVNlWjb2wu/mih
	C/73BVGo3xLyEuyVQBUdtMLoIowM1gGZ0TpFO7GUTShAyssogENLsIGUuTRnFMsjQrRXEZnPdRz
	QmniSHBdrwdPCAACKds7o6l7csvWz/MbsrhUz0jv71smt8WP4DXyNk7wSdOxe2LojgAKzune/y2
	M0l+Ye0aPwC3dsvF3z0dJIpUg7cWKWHjHqaoCsLwolap7El77m3a5Ft10Nw==
X-Google-Smtp-Source: AGHT+IG+GG+Qa6JTGoB2snUOkxAyjairFMb2vNLcDce0lP41wW3LRGVkmOC/LouqaKcL/4gKsHqEwg==
X-Received: by 2002:a05:600c:138e:b0:45b:47e1:ef72 with SMTP id 5b1f17b1804b1-45b8559ccdcmr196954465e9.37.1757063144043;
        Fri, 05 Sep 2025 02:05:44 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd0350e80sm68794625e9.22.2025.09.05.02.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:05:43 -0700 (PDT)
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
Subject: [PATCH 2/2] padata: WQ_PERCPU added to alloc_workqueue users
Date: Fri,  5 Sep 2025 11:05:33 +0200
Message-ID: <20250905090533.105303-3-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905090533.105303-1-marco.crivellari@suse.com>
References: <20250905090533.105303-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistentcy cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This patch adds a new WQ_PERCPU flag to explicitly request the use of
the per-CPU behavior. Both flags coexist for one release cycle to allow
callers to transition their calls.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

All existing users have been updated accordingly.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 kernel/padata.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 76b39fc8b326..26cc9b748b3d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1030,8 +1030,9 @@ struct padata_instance *padata_alloc(const char *name)
 
 	cpus_read_lock();
 
-	pinst->serial_wq = alloc_workqueue("%s_serial", WQ_MEM_RECLAIM |
-					   WQ_CPU_INTENSIVE, 1, name);
+	pinst->serial_wq = alloc_workqueue("%s_serial",
+					   WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE | WQ_PERCPU,
+					   1, name);
 	if (!pinst->serial_wq)
 		goto err_put_cpus;
 
-- 
2.51.0

