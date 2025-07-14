Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD6B1F4E34
	for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 07:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752477103; cv=none; b=ejrtgtMELxn3WrqXps39ZcoclfEud4suWW1AfwUif2e/ED8L2bWNilBfVfvXk6CMtwP/nKPO4X6NEIP86o++ZeRlQiAVXhXEXOHIqjLzFhw/a+XmSwHcYrPW2/E8SEOQ1cJXKdARcHYPqUbt0zyJhPp5p7Ic2P+cALmESEsaI8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752477103; c=relaxed/simple;
	bh=xe3Aqp8UvqdajvJsdpuRlCf71/eAzzat11fWJhToU+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpEmFRq4WyKh3VMXLFvbQRlCpUaaTMgcbRxTugedMYwqCWaWnk32nT6DyugfFdeUu68e9rEsLAB0FJqSzYwsGN3Dp8Oy6fAWN0jLRkg5IfQ0CVK+dHPrPTNy2wfwPC/VfOX7axsxIoPt96pvUajy3ZTvdBvaVXesVSCmGt1mREI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fxRpYOPy; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fxRpYOPy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752477102; x=1784013102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xe3Aqp8UvqdajvJsdpuRlCf71/eAzzat11fWJhToU+Q=;
  b=fxRpYOPy6F2uQY8WmxLrBbpr8jAxNgbqtVrc7o7BLz1X5LDcqgBigmGQ
   pWqMZJKyUoeDIYXDFnFYIXe60xZsFDzS/c+MhlGQkz04JtM8nuuwUxSPr
   GbY+s4IMbYibi5asXJpEDkkzsZ0bqTuk1/9Cso3C73A1haSYtcCNBUfVx
   JkpzLGXdfeCgLCqmx8kVmg3l6B27zblj8qn2C4tC/+iukXuwgobretgnd
   B7/Njb9Oe7RFm+XBiRYiDsHqiUQ/432GjDsyVS4q3EKwjq8xgtWJQst5m
   R6geK4YVvuv9+zkgBJd1vSvmRvMBHGmmXyR9xnQ7z3+EPz2OdjU6W4OXk
   g==;
X-CSE-ConnectionGUID: iMYW4aKlRyexBuQN4QI+Yw==
X-CSE-MsgGUID: N4v2l9NFT2STn6PYUISkHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54519376"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="54519376"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 00:11:41 -0700
X-CSE-ConnectionGUID: +c66qZFWQo2pDTJhiUmh3g==
X-CSE-MsgGUID: pPDH0VQlSXms5+yfDClogA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="187862429"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by orviesa002.jf.intel.com with ESMTP; 14 Jul 2025 00:11:40 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 1/2] crypto: qat - fix seq_file position update in adf_ring_next()
Date: Mon, 14 Jul 2025 08:10:29 +0100
Message-ID: <20250714071135.6037-2-giovanni.cabiddu@intel.com>
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

The `adf_ring_next()` function in the QAT debug transport interface
fails to correctly update the position index when reaching the end of
the ring elements. This triggers the following kernel warning when
reading ring files, such as
/sys/kernel/debug/qat_c6xx_<D:B:D:F>/transport/bank_00/ring_00:

   [27725.022965] seq_file: buggy .next function adf_ring_next [intel_qat] did not update position index

Ensure that the `*pos` index is incremented before returning NULL when
after the last element in the ring is found, satisfying the seq_file API
requirements and preventing the warning.

Fixes: a672a9dc872e ("crypto: qat - Intel(R) QAT transport code")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_transport_debug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
index e2dd568b87b5..621b5d3dfcef 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
@@ -31,8 +31,10 @@ static void *adf_ring_next(struct seq_file *sfile, void *v, loff_t *pos)
 	struct adf_etr_ring_data *ring = sfile->private;
 
 	if (*pos >= (ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size) /
-		     ADF_MSG_SIZE_TO_BYTES(ring->msg_size)))
+		     ADF_MSG_SIZE_TO_BYTES(ring->msg_size))) {
+		(*pos)++;
 		return NULL;
+	}
 
 	return ring->base_addr +
 		(ADF_MSG_SIZE_TO_BYTES(ring->msg_size) * (*pos)++);
-- 
2.50.0

