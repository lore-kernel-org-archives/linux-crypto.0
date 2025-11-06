Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306042C08CA
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 16:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447367; cv=none; b=A4d1ExVVFT5i+bus1IBPTunLmUtDijOhqMzmuQwqJ38aL0zoA59YazH5hZJZXor/viGFeiwp/2IsuIXf3cu4guM4HMBqa0Uxzq0VNkmEF8iJoPLYCo2to+AuF4QftxtnKboglKedycwHwUb5Lwp/Yk5i88awTijZIausKoF94i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447367; c=relaxed/simple;
	bh=dWua4jrZl0r37ywkIwIo1mbydYSjyvb6Mj4LORQIgS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qE2bVaIRgCW16h83GoVPit/rfk2J9D51eb+L1xwF6zf90MayJbrw62mp5x9jlXEk2H9tIHHSDPzjSQfkno2SF5dF50nBsHfXGfvw04j+oOy27w/S2ZPj2HYKn4IX8sZl/3zanZ3PK0mOWcx1DmA7TjN3OPEBjlSDbJObGfolHJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IusIFD+P; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IusIFD+P"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4710665e7deso5410595e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 08:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762447363; x=1763052163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5bWVfG3C8DSuF6D5kXiUtuvNzIgvYK/pa4hX5McjgVk=;
        b=IusIFD+P84syu65y/9cYP/jr+NUA/whUPyzdEWdNhCY4ydeduGTGcWsrLolUSFBbbh
         Nywa2anM0hvGkjv9PIjvcAM4D+/CkU0/1QotZ41j/PDg4YhZENQe644MNSOiU6JXrdNQ
         LF/csdbGrRGcgUbyTkXzUPD9b6VPhT3+hlt6U+/7e9/mpc7c+XUtV/oX9MeJwU53hmv/
         hcWFtI+SExtBED/G0uEr8wvAa8YsqWVNioEeUJO6NXThC2zJMoYQmK0T/7VLZS7wOcMq
         cGXFET/Y1C8HTN3AzR0mFvu6SPZXIBLTu/vI6gdQkzmRc/mg4OiiPg/Mnh16J1srlJ9B
         jSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447363; x=1763052163;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5bWVfG3C8DSuF6D5kXiUtuvNzIgvYK/pa4hX5McjgVk=;
        b=XCxJ6Bx+vilLLRe/cjzlFAdXhmA0KhNWhQFILgezbUWFFg1kAr5x2dk8B8b/QeS41c
         odm8yPrC8e16Zuo33CIhVNjbIULSunh+Y327GgmXvgylSBVmBmjF3V3N+sVke5xOAXwC
         qlzzHebDdCoVIwvaGpeGdNsyT73qFYFLr/0eVPRbrdmBYUMDrq8xRA8uDkyv9dY6chlH
         32oRv1U4+CiLaaABArNZFGifGGRtkFN4f+/uPbjcWl/kE1keWCM0cmot+DVskr2QWesH
         LA4nA7tVsy7AB+aFwhfsgmxIGpy4B8ysm8bBH3Hv8737UHM3U69DgtfPcGkAu8LVfkdF
         pOIg==
X-Forwarded-Encrypted: i=1; AJvYcCU+BlputZdzMCj1BoqBcPPgYlc7dYj34BMctuyYbR8AGvu9ukEIogEnyZ0joa9uKMSHNGGrMzVBW85WoCo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG1aRMaZva+Ezk+bnkZOKC7p6Wq76X4DU0EZceiUBw4+EyX7cm
	tqseQ8aZpFDSnwzJFeXYJ3RC17ObzlVs3MVlzvhdahHVvRkqBN+T68r3xadHQUuBQ0E=
X-Gm-Gg: ASbGncvcOHWLUavvufusoKrv2CL0Z8WR5hgf4YlYcIgmrqb79MOSyan+A6n44W/N9O9
	eOMmvyfjbfG84Ck4pca2n3gl86q1YiC2zQyaJHfBQG7p9PxK7k9hhOGVswSxcTw+9sqBFcreWgs
	RqtmZTPvaSSAP4shKCPy64LLRsI1uFufzkQSsWnYdBQEFiuPHlIKu6RlkfxPHGrRPKNqe5F/BK2
	cxAchewbDGBSSk/ICj9vVu8Q3ALONFCFl4IGoAD5jxqTGljpNNmBR7VfsVrpYAD46m/Ijnh268p
	7sGSHrj74tNzN8gfqnfM/wquIHgKH7s/Wlv+GnxAAx0gvbgRYcV1EK766Q8L1bojTwtkBo0tK0K
	8ztWPJfRp76Y0Z9e1RB0yJW0NBHU6ZbjjIc2MtdpyZHRVwOPxIarCdjUT5GcYWYhOdqwaEHiw93
	gMazltdg/NZ+VYNZDdjdvZto3IpCZoIq3vhg==
X-Google-Smtp-Source: AGHT+IF+PBs1j5FzTL4nTtbZy9S8jQx0oyM0Yw6fciG0T5QoS4kG8UPHtVSxZJs1keD6X3tfzWTt3w==
X-Received: by 2002:a05:600c:8216:b0:471:1716:11c4 with SMTP id 5b1f17b1804b1-4775ce20dcemr92100835e9.34.1762447363317;
        Thu, 06 Nov 2025 08:42:43 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42abe62b28asm75115f8f.6.2025.11.06.08.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:42:42 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: cavium/nitrox - add WQ_PERCPU to alloc_workqueue users
Date: Thu,  6 Nov 2025 17:42:36 +0100
Message-ID: <20251106164236.344954-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if a user enqueues a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistency cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

This change adds a new WQ_PERCPU flag to explicitly request alloc_workqueue()
to be per-cpu when WQ_UNBOUND has not been specified.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/crypto/cavium/nitrox/nitrox_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_mbx.c b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
index d4e06999af9b..a6a76e50ba84 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_mbx.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
@@ -192,7 +192,7 @@ int nitrox_mbox_init(struct nitrox_device *ndev)
 	}
 
 	/* allocate pf2vf response workqueue */
-	ndev->iov.pf2vf_wq = alloc_workqueue("nitrox_pf2vf", 0, 0);
+	ndev->iov.pf2vf_wq = alloc_workqueue("nitrox_pf2vf", WQ_PERCPU, 0);
 	if (!ndev->iov.pf2vf_wq) {
 		kfree(ndev->iov.vfdev);
 		ndev->iov.vfdev = NULL;
-- 
2.51.1

