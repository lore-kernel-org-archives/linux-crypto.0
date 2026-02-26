Received: from sg-1-103.ptr.blmpb.com (sg-1-103.ptr.blmpb.com [118.26.132.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23D518DF9D
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 08:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772093249; cv=none; b=OhY2XA0/usbENOVocTsnaW2ilUvrtCwC/9/IQzSGvpO6HCNsNIvfO9hRHJLBH+tAwGxZPbOq8CuuDav2VWHkgmV77feqHfoMcEntTO1hEEd5zubqhQQan/CpP93vIb72IDVsg3VlYOoiHamCP6pRrLFUHCOgS93N+urccYFEQZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772093249; c=relaxed/simple;
	bh=XcL9pmAEfGRCN/6Z6lSkX9ogPH00OwuPMDnW23l8+yQ=;
	h=Cc:From:Subject:Mime-Version:Message-Id:To:Date:Content-Type; b=A0ahCRG5UFmSyiGqmAdOuQKso7pPAvqkzrP50AfaRZkHX6fiS+zwabMnAiMOrbSWuCKDedLTzzEpWgZtqVlbmRrtIC3PIivES+BEG6ZmLMO/dEJw6GeE7XutdrAX8x8DKPd94BeueXTL88Hq0ms05GreX4LJ/PaxIN+PqUsZ/uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=ch/vhgji; arc=none smtp.client-ip=118.26.132.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="ch/vhgji"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1772093241; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=vJSuFht6RGC0nbWiuHrS0TWGPPOqhhbCvK2ylT/s2oo=;
 b=ch/vhgjionf34lxOXzy+MFR+5+mY9H0+ZZe782PeTPnpWVgfSAiHDdB4+6C1QO0J1ind0W
 +c1khqIJ08TUGMzGoXsH5Ef+q/Zwa1XhvR3v2mbh15uoFPkm6PF4LRls2teNuvmR74ILVD
 8f/CRSL3+9zxXO1EcXXZrcbEWNBR3PYwmisq9xjSAE3pjJSrIn0cHRHLShiAIU3h9JBNon
 ksgtc5Mh2Tk+S3HAmq3cEzvdHkvfQULbOwaTFtLz4m933OeDTdIanlzLLAtiQmaro4a8z5
 MLVXn8CixVhvu4mz6AYv6Sj60F+22s5BjtxaVk3OCIs3A2AtpbmL9SEhrhUdIw==
X-Lms-Return-Path: <lba+2699fff37+e0b9d7+vger.kernel.org+zhouchuyi@bytedance.com>
Cc: <linux-crypto@vger.kernel.org>, "Chuyi Zhou" <zhouchuyi@bytedance.com>
From: "Chuyi Zhou" <zhouchuyi@bytedance.com>
Subject: [PATCH v2] padata: Remove cpu online check from cpu add and removal
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <20260226080703.3157990-1-zhouchuyi@bytedance.com>
Content-Transfer-Encoding: 7bit
To: <herbert@gondor.apana.org.au>, <steffen.klassert@secunet.com>, 
	<daniel.m.jordan@oracle.com>
Date: Thu, 26 Feb 2026 16:07:03 +0800
X-Original-From: Chuyi Zhou <zhouchuyi@bytedance.com>
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=UTF-8

During the CPU offline process, the dying CPU is cleared from the
cpu_online_mask in takedown_cpu(). After this step, various CPUHP_*_DEAD
callbacks are executed to perform cleanup jobs for the dead CPU, so this
cpu online check in padata_cpu_dead() is unnecessary.

Similarly, when executing padata_cpu_online() during the
CPUHP_AP_ONLINE_DYN phase, the CPU has already been set in the
cpu_online_mask, the action even occurs earlier than the
CPUHP_AP_ONLINE_IDLE stage.

Remove this unnecessary cpu online check in __padata_add_cpu() and
__padata_remove_cpu().

Signed-off-by: Chuyi Zhou <zhouchuyi@bytedance.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/padata.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index aa66d91e20f9..53460f714065 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -732,32 +732,22 @@ EXPORT_SYMBOL(padata_set_cpumask);
 
 static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 {
-	int err = 0;
-
-	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
-		err = padata_replace(pinst);
+	int err = padata_replace(pinst);
 
-		if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
-		    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
-			__padata_start(pinst);
-	}
+	if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
+	    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
+		__padata_start(pinst);
 
 	return err;
 }
 
 static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 {
-	int err = 0;
-
-	if (!cpumask_test_cpu(cpu, cpu_online_mask)) {
-		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
-		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
-			__padata_stop(pinst);
-
-		err = padata_replace(pinst);
-	}
+	if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
+	    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
+		__padata_stop(pinst);
 
-	return err;
+	return padata_replace(pinst);
 }
 
 static inline int pinst_has_cpu(struct padata_instance *pinst, int cpu)
-- 
2.20.1
