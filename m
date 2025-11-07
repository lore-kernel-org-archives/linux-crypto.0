Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936EC29AB05
	for <linux-crypto@vger.kernel.org>; Fri,  7 Nov 2025 11:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762514645; cv=none; b=W9IIljKVmeNJbI0oOELGjoidwTAceYP2c0bkWlgDqUy7k5+NvIQYVmO1yYRjgB5qwCwLPFYSOOx7+mw0O2O/7/Tcn0scxC8UhlH/gGFjiS9MJgHsMwOp+7J21hAPdv3ZydyEqNWA/VhBWzPp4/dIZm5PtGo1XAr/Hqm4wgyGo90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762514645; c=relaxed/simple;
	bh=9qvKFyWCzhaawn1KuJuE+xpn/FGFoohIYfFNP0qIMWk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=q6iJCnwBhlyRkNAnQTY9+4BkxM/6tD4FMr+5kO2QAgzp6Vt3F3IpwSBHrdGB+oYMvmKXyF58tcIrtSUlfhVeAkjaV4Ueas63RbhrAKv635TqNsRCKnZB1KjQ89mFnC6EtKsJolmQHw3YbJ+vzluZYXSPbpun0C75Tic6nbpqpBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KsGaLRUg; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KsGaLRUg"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477619f8ae5so5109125e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2025 03:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762514642; x=1763119442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f241uCY+pmrH1f0NrM2ehLiNX5bhGdKZqui5I9vth0o=;
        b=KsGaLRUg6TSie64qV6TZqlHQBhpvfJAITdSEpfnICgDzQW2wpgojOEQDXLR2J1qSNF
         fCI5xHDDvwnX8YyX61+OoEbQklvEVoF2gQSZirrAVT4NBwoF56LGco3Z4v/wIKSk2eg1
         KhHvAX2kfHDVAgfh0Dx+rTelugsQMPCHKanXqjwW/Mye5fcfuIr6c1tRsLjd5ssPj9Dx
         NG86LMyy2Qb15CuOO7+lupQFdEs6cjCeHRP9sBsK4mHKaFILiopuT6jVorzJsL9uCU/b
         z7pttL0DdlZg5JvZh0iSlWAQjYYYfQw/xTKv8BaFrzJ0g/CkP+ja+NL3ixo8D67Dwsr/
         vv+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762514642; x=1763119442;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f241uCY+pmrH1f0NrM2ehLiNX5bhGdKZqui5I9vth0o=;
        b=K6Y+OZzxjsNVgXlTX1hCIhJhWl2sgB8sdl4r3+NTeCJUJWFSvcVFWW4czKNNXIUMU8
         1R0ughrEtlltze2jOmQHAPLpYfco+JnhdvUTyFpnzp5Ky6Sk2BFx2HD3JVcbJXaC0FJv
         RLAO/dClp4LyiGVig+va0L/tCJCjZS49P8TYorqosL+FILNEuU0k0DCyEKQQ1XjNSg1T
         7qfL31ZgpsdiY63a6t9brAsqjIHJvEJbyfefj1Fij1WfFkblVYNXVMdEDpFp9F1saB5c
         MRD8Q6PvOWV3Rg94p55afYXk4/gF2IAKjsfRv7jj7VmhpfmtCWL7Taua7v61wsCTXiW1
         Zilg==
X-Forwarded-Encrypted: i=1; AJvYcCU1U7MWFOehVBflizSitDD1A2+u5ExBCEBP9LxL6hAbW6+g0a3G7okeu5F4Y0DF6GUHHt9xh2o8jWMlwHU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxoc3KiluGM8r/je5E8eGLX4DUvDPEF+ScXh1ZYGpVjJGbo19Hp
	0MQ4UcxtdG31ki0hRf6Aa/n+rs96QYxpQ7Ln2y6Pehzmi+CcK8UBqNp99uU6GbmeZes=
X-Gm-Gg: ASbGncvQYAcJTBJo6rBeSO1jbORBe+spIDt7Kij4n0PkstWMTEw2xlS0r86oqEnhFVe
	G4aNFcLjGBPym7FGgl+0IawJn0rvpcWFf9eD2zmOTArbCym665xEJr3h08JoOGpjShUnPJtCwJq
	J6ftelLH+WlGIm1I4shtfH0gm5gmu9QWEKj9KVx7yod/J1u+5xn4bSdT/SAZX5JsRDM9JFXiiZj
	mYGGnIs0uvZa3gw2BZVcAUX333h5oSDgAc+4vLSfNRaJyvXfWP5lV586WVaWu+DTjMR/Ff2Ri97
	3wRwIsWZnf6ZYW+uJsAxlWm8sqnl8pEZq7OWTJy/J9BobUYH+x616PMr3cglRvuiaFj4FX0eS6k
	WXrY/eZu8B0a4Mj2+W6Gd5ofBlk3ghGctNs5TgKV7NgttRqeRYFh8XHss47mhafu4fLubn5mFGW
	ZlvoyUA7FMzKLZtZ3sxe7NWlxA7yI5m0HgBrE=
X-Google-Smtp-Source: AGHT+IEgrc0DHLVfayeak/o3tbBp6AOETc/w2hdnSCkhCEY7583sQoY+NixM9DDmkWzAVLWh7Q7ymg==
X-Received: by 2002:a05:600c:630d:b0:477:54b3:3484 with SMTP id 5b1f17b1804b1-4776bcff5b4mr22968565e9.37.1762514641875;
        Fri, 07 Nov 2025 03:24:01 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47763eb362bsm40540675e9.4.2025.11.07.03.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 03:24:01 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - add WQ_PERCPU to alloc_workqueue users
Date: Fri,  7 Nov 2025 12:23:54 +0100
Message-ID: <20251107112354.144707-1-marco.crivellari@suse.com>
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
 drivers/crypto/intel/qat/qat_common/adf_aer.c    | 4 ++--
 drivers/crypto/intel/qat/qat_common/adf_isr.c    | 3 ++-
 drivers/crypto/intel/qat/qat_common/adf_sriov.c  | 3 ++-
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c | 3 ++-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 35679b21ff63..667d5e320f50 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -276,11 +276,11 @@ int adf_notify_fatal_error(struct adf_accel_dev *accel_dev)
 int adf_init_aer(void)
 {
 	device_reset_wq = alloc_workqueue("qat_device_reset_wq",
-					  WQ_MEM_RECLAIM, 0);
+					  WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!device_reset_wq)
 		return -EFAULT;
 
-	device_sriov_wq = alloc_workqueue("qat_device_sriov_wq", 0, 0);
+	device_sriov_wq = alloc_workqueue("qat_device_sriov_wq", WQ_PERCPU, 0);
 	if (!device_sriov_wq) {
 		destroy_workqueue(device_reset_wq);
 		device_reset_wq = NULL;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_isr.c
index 12e565613661..4639d7fd93e6 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_isr.c
@@ -384,7 +384,8 @@ EXPORT_SYMBOL_GPL(adf_isr_resource_alloc);
  */
 int __init adf_init_misc_wq(void)
 {
-	adf_misc_wq = alloc_workqueue("qat_misc_wq", WQ_MEM_RECLAIM, 0);
+	adf_misc_wq = alloc_workqueue("qat_misc_wq",
+				      WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 
 	return !adf_misc_wq ? -ENOMEM : 0;
 }
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
index 31d1ef0cb1f5..bb904ba4bf84 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -299,7 +299,8 @@ EXPORT_SYMBOL_GPL(adf_sriov_configure);
 int __init adf_init_pf_wq(void)
 {
 	/* Workqueue for PF2VF responses */
-	pf2vf_resp_wq = alloc_workqueue("qat_pf2vf_resp_wq", WQ_MEM_RECLAIM, 0);
+	pf2vf_resp_wq = alloc_workqueue("qat_pf2vf_resp_wq",
+					WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 
 	return !pf2vf_resp_wq ? -ENOMEM : 0;
 }
diff --git a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
index a4636ec9f9ca..d0fef20a3df4 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
@@ -299,7 +299,8 @@ EXPORT_SYMBOL_GPL(adf_flush_vf_wq);
  */
 int __init adf_init_vf_wq(void)
 {
-	adf_vf_stop_wq = alloc_workqueue("adf_vf_stop_wq", WQ_MEM_RECLAIM, 0);
+	adf_vf_stop_wq = alloc_workqueue("adf_vf_stop_wq",
+					 WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 
 	return !adf_vf_stop_wq ? -EFAULT : 0;
 }
-- 
2.51.1

