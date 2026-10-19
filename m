Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422874;
	b=g/40bU4wUVHgdvU71Y9LVMenIqldFb3jBa5AX0H4iBWfirXWolJmwIieumiGEqdCit34
	 8lYlHw43xfM+0ET0Fi1CXi1AYA3NKh5W/73/tGMQRksHiJw15tN+o1ub1zDqt/bs6E47e
	 D6TIvp2XvMgySP1iX9AXaPlLAqDeb0wcMOJHGeXiTfqhQpdL0uWQ85K1wHqRwcB8zpbHH
	 bgFg1pgoHCxH3jp9B1AI45a2DkGltR31FhWtv5c9A5uh/bPBLQHoJLvl/Yk+U3pIB0XnP
	 vGlplEIglfbuhTSfSq+T56sQyM66fOfV0fqqi62pRZEbMpev6jiC/438vQoQGVqpkxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422874;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VV2/QhBOfjkXhzTFYdvHLRCxj0TZoUqZU1Dd4NeRj4E=;
	b=NBQbQXIhYnSAs7zfAuaDJtlqw00rBa9Hp3lzM5BR+F+qvXLmwqwQOgTv7LzRGM9vyFu4
	 q9mxhh807AWp9suI/D5mG5JV6OnJ9tNSBzg5kcRSX11QYjV5aMgMWiGl/9vh1pI7yCcUQ
	 nTORE/qjlZWX0A5n04l/kOmDqERLE55u9ifc+xG9/n5v0A+XZVrKXRwVhZKECoFu1Pcic
	 6pgDo7A5SwYy1Xol0SmA0FvCCBvijKjM9vBRPxbmA/LD/Pnb5W8wAfSMq5mZfB6z+8Tjf
	 x1mZUp1ZUU1k1J3T8GUySGOh/7DHVE4krD2HTyHlPnfHTPTNNbqvl5aSrh/I+j6AUFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=LJbxSRj0;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE59609CEC9;
	Mon, 19 Oct 2026 15:14:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DE59609CEC9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=LJbxSRj0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422875; x=1823958875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bs5aDyWkm0aROlwJOumVLELpoO93dWXLFgzgkbfgsm8=;
  b=LJbxSRj0S/6s7dZJYW6iSfDE1e5vkP1c0KNvc9quUdQGA4MJpAudtJ6B
   8uQjk4MlvrAoqdbXPm7shftF/4QDtsOw1LIzuBNZASjCG1mrJ5LUNeHFS
   VLnMpDVSBGjp5TKyLSwHv8epuH9gF1HbT4pC8KW4cdKU3uGUnYg75nfu/
   RNTAzOl4I+Ee8SanikFk2X/KI36QE9AUvU8NiIH9EkgRZo78EXF0Bp92j
   Qgsr66kGOMLIwH4xTS3SynGjld60BxgalZW11luRAS6Ha/ZOj2ssEAH+g
   wakq51zODA0bNmBLMOnUJbmjcLy4ush4pa10tJgYHSaMozwCV0shFAo9f
   Q==;
X-CSE-ConnectionGUID: FUjKxnKpTWijJg15stWL5g==
X-CSE-MsgGUID: hZZf3F2eQiCRRdtSHtUhRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986894"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986894"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:33 -0700
X-CSE-ConnectionGUID: gCT8dYYBQg2iUthQ9K4TgA==
X-CSE-MsgGUID: ucvG9Ox2RHe41cQ8n/qqJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536942"
Received: from jf5300-15a101203tc.jf.intel.com (HELO meta-crater2c.jf.intel.com) ([10.54.113.49])
  by orviesa003.jf.intel.com with ESMTP; 19 Oct 2026 08:14:33 -0700
From: Daniel Byrne <daniel1.byrne@intel.com>
To: Vinod Koul <vkoul@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Frank Li <Frank.Li@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Kristen Accardi <kristen.c.accardi@intel.com>,
	dmaengine@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 01/17] dmaengine: idxd: don't queue EVL fault work for kernel WQs
Date: Mon, 19 Oct 2026 08:06:14 -0700
Message-ID: <20261019150630.4026341-2-daniel1.byrne@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261019150630.4026341-1-daniel1.byrne@intel.com>
References: <20261019150630.4026341-1-daniel1.byrne@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The event log fault path queues work on wq->wq, the workqueue that
only the user (cdev) driver creates for its work queues. A completion
record fault logged for a kernel work queue, as a dmaengine or
iaa_crypto queue is, finds that pointer NULL and queue_work()
dereferences it.

The fault worker only serves user contexts: it copies the completion
record through the PASID xarray that cdev opens populate. On a kernel
work queue there is nothing to do, so log the entry ratelimited and
drop it. Test the queue's type and not the pointer alone, since a user
probe that failed leaves the pointer dangling.

Fixes: c40bd7d9737b ("dmaengine: idxd: process user page faults for completion record")
Cc: stable@vger.kernel.org # 6.4+
Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/irq.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 6a25e1fd0e62..820b1ff69fb6 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -331,10 +331,25 @@ static void process_evl_entry(struct idxd_device *idxd,
 			if (!entry_head->rcr && status == DSA_COMP_DRAIN_EVL)
 				return;
 
+			struct idxd_wq *wq = idxd->wqs[entry_head->wq_idx];
+
+			/*
+			 * The fault worker only does user-context work,
+			 * copying the completion record through the wq's
+			 * PASID xarray, which is populated by cdev opens
+			 * alone. A kernel WQ has no cdev workqueue and no
+			 * user contexts, so queueing could only warn and
+			 * drop the record. Note it and move on.
+			 */
+			if (!is_idxd_wq_user(wq) || !wq->wq) {
+				dev_warn_ratelimited(dev,
+					"EVL fault on kernel wq %d, status %#x\n",
+					wq->id, status);
+				return;
+			}
+
 			fault = kmem_cache_alloc(idxd->evl_cache, GFP_ATOMIC);
 			if (fault) {
-				struct idxd_wq *wq = idxd->wqs[entry_head->wq_idx];
-
 				fault->wq = wq;
 				fault->status = status;
 				memcpy(&fault->entry, entry_head, ent_size);
-- 
2.43.0

