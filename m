Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787835;
	b=3hbqYcm0JQPzjyfYTh/prG7rs++/MGZFUFedvU+U4EZS+r74alz1fPxm7nP55QGPAdBB
	 29qodpi8txgaprwyQ4ZkdIevy/d0IOWeuhdhCcVo+/M3m4MsNZyi/FN8pgG+7I25HoxD2
	 QwXR92aM09J2ECyfRZYNeoYu0rwoGi+XY2m94XsA0dTL39rfOPvpVYOpNk+zyIhBPMIZv
	 TvSb8ADrtucE6t/YVJfKB6L5uAnWQ01qTow+rHNEYydreZhZKP7+P8vTRfX47heHwz5DN
	 DS04ELlc9150IvCk1lYXkYxUXqBgua2e833X6jfzeHP9fYGabFLiJCSVlbbzyO7JV5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787835;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Organization:
	 Content-Transfer-Encoding;
	bh=n8dFcRs7N96xz4NwwyTPTMPJ8QLXU7zrTYpusF9ZuWc=;
	b=FEgFlPH8b33+9KKjkpr+voUqWma4kc3VM/CnRkTfCG7yvHVElbm5/kxd0Er39TVItkqb
	 Br99J1onHRLhZG8pHVHTEQ24U+b3on7v7dLfdnbANhXYCIAY2CZL9TAuvuKizBwn0Azsz
	 BhBfttBCEcmlQ76myd5LzFDGXW1JuYbAMKD/lEOKukD5pD4Ww4mUApmX0ybLY5gPoa4yR
	 KKQvJTIiGhB2TbUGPQ0GV0dvlcXrUCdqh2ZqDk6zwAiIp0sTqfbcafa0WtQNvkkju99ki
	 5xj61tLfNEstPo/3PRm8HOoggBv83rD1HWYDygagqwpcKOjXnO96GFhkUQyjjBZnNtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="bcnZ/ZHm";
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCDD606D838
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 10:23:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CCDD606D838
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bcnZ/ZHm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793787834; x=1825323834;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rXMYiDLKye9gu1XcAqd4hTkqS2ouzL3J5p66xyBj7Xs=;
  b=bcnZ/ZHm8/bA03IEixXdOETqXIJRNuHHN7tR0Yui/nJ54cEMuw9sCNWL
   0IJ6unh8lyEWqnOXAiVe/hKPhW0pytmjfEs9piHaoF8s3y3QvGzGVM9oJ
   cD5hQoyE+OIniKeIqI0AxxCxYzNkGbu7s+9UdJe3UEX2C6v883BGIt1M/
   mFI+j/ZN+bMYtJKfY3gcOdmaPIk8+WDkQDWpCmDgUi8JFG8BOCuexSf6t
   PTay1JsumhizvZNCCDhiKit33lEMfTnqAszxElIEr9pMHcupCZs0skk75
   VIyoHBZSbwJco51ac/+EgxaZ4rulmhro1rgvMmCed06XoMLooqsXVTlKx
   Q==;
X-CSE-ConnectionGUID: 4DuPf6LiSQ+Mb6Dp9Tv4rg==
X-CSE-MsgGUID: HHDg7Nw6RSmlJtYtg/LMIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2411937"
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="2411937"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 02:23:54 -0800
X-CSE-ConnectionGUID: qUCoLS7VSiy5ufWOafdXUg==
X-CSE-MsgGUID: X/06Gz10QSeWJ0Rt2ie1kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="6540325"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa005.jf.intel.com with ESMTP; 04 Nov 2026 02:23:52 -0800
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - avoid double free of authentication descriptor
Date: Wed,  4 Nov 2026 10:23:45 +0000
Message-ID: <20261104102345.543725-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>

qat_uclo_wr_suof_img() reuses a single struct icp_qat_fw_auth_desc
pointer across all signed images. At the end of every loop iteration
qat_uclo_ummap_auth_fw() releases the DMA buffer backing the
descriptor, but leaves the caller's pointer untouched.

If qat_uclo_map_auth_fw() then fails for a subsequent image before it
assigns a new descriptor, for example when qat_uclo_simg_alloc()
cannot allocate the DMA region, the error path jumps to wr_err and
calls qat_uclo_ummap_auth_fw() again on the stale pointer. This reads
chunk_bus_addr and chunk_size from already freed coherent memory and
passes them to dma_free_coherent(), resulting in a use-after-free and
a double free.

Clear the descriptor pointer in qat_uclo_ummap_auth_fw() after the
buffer is released so that it is unmapped at most once.

Fixes: b0272276d903 ("crypto: qat - add support for new devices to FW loader")
Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_uclo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index a00ca2a0900f..e0ff6b232e91 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1398,6 +1398,7 @@ static void qat_uclo_ummap_auth_fw(struct icp_qat_fw_loader_handle *handle,
 		dram_desc.dram_size = ((struct icp_qat_auth_chunk *)
 				       (*desc))->chunk_size;
 		qat_uclo_simg_free(handle, &dram_desc);
+		*desc = NULL;
 	}
 }
 
-- 
2.50.1

