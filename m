Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840B7405A;
	Wed, 21 Aug 2024 21:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724274188; cv=none; b=iMVDD7XDF8kKjZl1Wk9vVlpD+xMFy2pxtNJSkcXTwJfWRZhHSfak6B9w/1ntGiuW/kcwb8HIviOW7GpvQJ5ZQehrEatDz6vK8/eTH8lSjrqGuA2vfYt5WmYjx6uxecnr/cIGd50HeaxZLYrwjUN1hRsVZTjlDz7nHvHy8yHrz5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724274188; c=relaxed/simple;
	bh=/GMFIGWeHHhEWXOIb0ZzB+KN4MeNBoHs3oVGJ4/DFNc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=mtMKldua08a9yG3bzXvka4HzOzj3ZL/d30Vo2Pf27beMP1rAwgHpxOuBcUP+LHB5WOzudezyhqDnjO2dhXr9UaqRPPCBvZk0QDLmE389njKbbOIbUmKZlcgZEktTw8mkI8ckkH52BQru+D3NwT5YmVdzubpp40yoCYWZS9APz2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=TuoiVM5x; arc=none smtp.client-ip=198.47.23.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="TuoiVM5x"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 47LL2tqI126792;
	Wed, 21 Aug 2024 16:02:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1724274175;
	bh=5hiCgT+v1rhcN8zv0z+6t3xtFJcR5frTWIea1HBXQ+8=;
	h=From:Date:Subject:To:CC;
	b=TuoiVM5xRb9qRYPqTAgWgi7TIoAnO10YxpRNqaMCikU8CWneSrPAer9zfdJE913RG
	 HfZFsG7lN2KdHnUm4a3a4IHJeJ6aRWsrTPZebpL/+VRhljvcqWf5ogPOE+DGkBvDTg
	 ERphAvXJo5DsN2ZaWBHvoNGlj6sKc7Y7lyFxdm9w=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 47LL2tAj036486
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 21 Aug 2024 16:02:55 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 21
 Aug 2024 16:02:55 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 21 Aug 2024 16:02:55 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 47LL2sPw049542;
	Wed, 21 Aug 2024 16:02:55 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
Date: Thu, 22 Aug 2024 02:32:52 +0530
Subject: [PATCH] padata: Honor the caller's alignment in case of chunk_size
 0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240822-max-v1-1-cb4bc5b1c101@ti.com>
X-B4-Tracking: v=1; b=H4sIAPtVxmYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDCyMj3dzECl1L42RD88SUZDMTU3MloMqCotS0zAqwKdGxtbUAbEwYElU
 AAAA=
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan
	<daniel.m.jordan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Waiman Long <longman@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1724274174; l=1962;
 i=kamlesh@ti.com; s=20230614; h=from:subject:message-id;
 bh=/GMFIGWeHHhEWXOIb0ZzB+KN4MeNBoHs3oVGJ4/DFNc=;
 b=rjnYyhhy2lFhS5+5NyncaigHAjEnjQd07yOWlI/TUsBF0rxsi1GNJJV3DZOtQvJRVsW97Ig23
 HDt9JfSDgweCdNVbZYFXk4NsBMyJb3HklbjS1CxNOEfuHVfyhpsGLfG
X-Developer-Key: i=kamlesh@ti.com; a=ed25519;
 pk=db9XKPVWDGJVqj2jDqgnPQd6uQf3GZ3oaQa4bq1odGo=
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

In the case where we are forcing the ps.chunk_size to be at least 1,
we are ignoring the caller's alignment.

Move the forcing of ps.chunk_size to be at least 1 before rounding it
up to caller's alignment, so that caller's alignment is honored.

While at it, use max() to force the ps.chunk_size to be at least 1 to
improve readability.

Fixes: 6d45e1c948a8 ("padata: Fix possible divide-by-0 panic in padata_mt_helper()")
Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
---
 kernel/padata.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 0fa6c2895460..d8a51eff1581 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -509,21 +509,17 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
 
 	/*
 	 * Chunk size is the amount of work a helper does per call to the
-	 * thread function.  Load balance large jobs between threads by
+	 * thread function. Load balance large jobs between threads by
 	 * increasing the number of chunks, guarantee at least the minimum
 	 * chunk size from the caller, and honor the caller's alignment.
+	 * Ensure chunk_size is at least 1 to prevent divide-by-0
+	 * panic in padata_mt_helper().
 	 */
 	ps.chunk_size = job->size / (ps.nworks * load_balance_factor);
 	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
+	ps.chunk_size = max(ps.chunk_size, 1ul);
 	ps.chunk_size = roundup(ps.chunk_size, job->align);
 
-	/*
-	 * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
-	 * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
-	 */
-	if (!ps.chunk_size)
-		ps.chunk_size = 1U;
-
 	list_for_each_entry(pw, &works, pw_list)
 		if (job->numa_aware) {
 			int old_node = atomic_read(&last_used_nid);

---
base-commit: b311c1b497e51a628aa89e7cb954481e5f9dced2
change-id: 20240822-max-93c17adc6457

Best regards,
-- 
Kamlesh Gurudasani <kamlesh@ti.com>

