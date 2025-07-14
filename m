Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1664B1F3BA2
	for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 07:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752477104; cv=none; b=r0bM1iuatihcqZ97mpzHVCDacODCXhSouITWT9cw/UmMwqguUxFJzrxVkUDwIV0Q/7aau4m+g6TC6HTFzHhm8QUk4Ht2gY8jfAcXQgy8mSrnqLaEBZ5LOvbYtldmTT8cO2fJZ0b9zPrTu3gJ/Iovm5sBN3jeywg3xftix1r7iL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752477104; c=relaxed/simple;
	bh=WiCqNrO6sYeVkIjZXSSMOzDlOwiLHRpKYJBUIPTkcGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Igmq3JdoGG8rEDVifK7f20a92Ef4069ypco1YtLcuPGqO0AQu+iomNeAs8qOIypFWLIy547gDNzAeGeRQrX3PhjPLAYZMmcoBFSjZLZa/c1ji82vwAsUWicJcP/zCLrsqz3FpdWvcke4mcLuP9XEjpubH1jj1FUgaorCOXoA3H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f5siFMr2; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f5siFMr2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752477103; x=1784013103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WiCqNrO6sYeVkIjZXSSMOzDlOwiLHRpKYJBUIPTkcGA=;
  b=f5siFMr2k16QpaPeJoMhlMUMwe64kTHWpdTzGnQor/tSyRHFXbEjtfSi
   mkJgUiMbYQ6SPY7GV09GXpdl7Makci2P24n3dkkikcUZB9Ro2+ZxMyoEt
   HnJMhR8IyNIwVnJ66SS5VTKIDKIJnly+FHr8b4fhp9NFGK69I7ZYhIAQ5
   y/8I0BK4rep5Vh/fBMpbno5EEL8QO6AgGNh1wBCOL8Fha8Lwk7nuCB5sq
   beh4VF0Qq55CuC4f5X07PeFpP7K79/XhNMafCICOm1GWOA1KCLotZ2YAC
   BZoC+/GsX9QvrwPS04mGZ8FP+6C21pqaJJwKPLFPyyQsKOh2yKj1ELRdl
   g==;
X-CSE-ConnectionGUID: bWSiffF9SpuBGJw/Y9TLEA==
X-CSE-MsgGUID: FncL5NApTzyvyXeMaK8djw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54519384"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="54519384"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 00:11:43 -0700
X-CSE-ConnectionGUID: bm9shfl5SLmtdfDTnbU8VA==
X-CSE-MsgGUID: FhulCvywTFKmTgK8uMLRbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="187862446"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by orviesa002.jf.intel.com with ESMTP; 14 Jul 2025 00:11:42 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 2/2] crypto: qat - refactor ring-related debug functions
Date: Mon, 14 Jul 2025 08:10:30 +0100
Message-ID: <20250714071135.6037-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250714071135.6037-1-giovanni.cabiddu@intel.com>
References: <20250714071135.6037-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Refactor the functions `adf_ring_start()` and `adf_ring_next()` to
improve readability.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 .../qat/qat_common/adf_transport_debug.c      | 23 +++++++++++--------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
index 621b5d3dfcef..6c22bc9b28e4 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
@@ -10,16 +10,21 @@
 static DEFINE_MUTEX(ring_read_lock);
 static DEFINE_MUTEX(bank_read_lock);
 
+#define ADF_RING_NUM_MSGS(ring)					\
+	(ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size) /	\
+	ADF_MSG_SIZE_TO_BYTES(ring->msg_size))
+
 static void *adf_ring_start(struct seq_file *sfile, loff_t *pos)
 {
 	struct adf_etr_ring_data *ring = sfile->private;
+	unsigned int num_msg = ADF_RING_NUM_MSGS(ring);
+	loff_t val = *pos;
 
 	mutex_lock(&ring_read_lock);
-	if (*pos == 0)
+	if (val == 0)
 		return SEQ_START_TOKEN;
 
-	if (*pos >= (ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size) /
-		     ADF_MSG_SIZE_TO_BYTES(ring->msg_size)))
+	if (val >= num_msg)
 		return NULL;
 
 	return ring->base_addr +
@@ -29,15 +34,15 @@ static void *adf_ring_start(struct seq_file *sfile, loff_t *pos)
 static void *adf_ring_next(struct seq_file *sfile, void *v, loff_t *pos)
 {
 	struct adf_etr_ring_data *ring = sfile->private;
+	unsigned int num_msg = ADF_RING_NUM_MSGS(ring);
+	loff_t val = *pos;
+
+	(*pos)++;
 
-	if (*pos >= (ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size) /
-		     ADF_MSG_SIZE_TO_BYTES(ring->msg_size))) {
-		(*pos)++;
+	if (val >= num_msg)
 		return NULL;
-	}
 
-	return ring->base_addr +
-		(ADF_MSG_SIZE_TO_BYTES(ring->msg_size) * (*pos)++);
+	return ring->base_addr + (ADF_MSG_SIZE_TO_BYTES(ring->msg_size) * val);
 }
 
 static int adf_ring_show(struct seq_file *sfile, void *v)
-- 
2.50.0

