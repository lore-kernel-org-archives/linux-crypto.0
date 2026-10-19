Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422875;
	b=0aDoASZUX9N8q8uz7jvKpbX3tlVBs/JZAwTgnI87XDldcA7GheS1Zua1zPShfwF+O7qV
	 6K5aBDOO7jOr6k11rOKKZ0wTRiy0TOvFCujKU4mmOaBDsXf1KLAITwglBYXDOy0zvZL5R
	 NhrJOijUPmgroSSGAyW5L1u/kvcjJv/POj0pMVMqcbvjYZAR+OngdVHAsu0MfYn5Zs9gH
	 Clr37Yr/AeGpyqqzhAVLoLvGYl6E6w5fg7gv26GgqhCAEUyXraYl0LoeyniYg/1IiKv+M
	 u5PTVjO32hGrG6wyj+AE2vgMQ/tEoiwngLum+/tteE66mt+U803bHZufSiyH5zZt2qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422875;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xIJeajS9jjtNcUTuok39zQGD54vxXLVdXbql+UaLazs=;
	b=a8Br/XZ4FgvHqgeETPyZgGbIoykrHRGim5hiOqmyZnoLtPdTbmQZdZFaM7dJOjn+G60P
	 aG/rKcTyP3EQCQc7Pp07/DwuqeJY05WrcGPVhOrifuiDpNEncBvw+OS4un6SLlcc4KvhF
	 Q7Jp3FxNqWDVl3YWCVNdab4aexsS245kT0H/V4hstdvbDlSzPKnJZYps1Hur2IG+2I0vt
	 LyCC/C/Domx6NTm6o9vtN8kjagIrcEAVyTNR3CaLnFBwDzT5l8iwBx6QKOZ53MdtEJElu
	 oS6SOdk6ZXkAqCp1V7Eaeutsb2Wze12BDJeLj+m7VP/FX+vqM09wTP3dphHTb9sL9cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dLK2KVCg;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54D7609CECD;
	Mon, 19 Oct 2026 15:14:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E54D7609CECD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dLK2KVCg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422875; x=1823958875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G5nEe1IhmdwwprxW4cb6uNZ0ux+LJmOrwz33ArBAsZY=;
  b=dLK2KVCg9bgIc9cHErUP5Opk+ZZOChtQF4kDZFNZzqU3V5nJAhGxxDba
   qqYqbxSKKlhrM8Zr/djBS4WyyYw/3Yrhw95Rgq+55ThfYK0jJ6Uy/DOEj
   rSi0OP65EW1pyqaO57prv71etxQvnidcF6kQAxjASsnGkbMae2ff5TrkW
   2EcqVWKNEfE0YxpLq8RVrJ9EzpdV0j1alPwAdGP0B83Hu8dui3gZVsg1E
   CzBb6iEZ/4nFV2TU2C3omxdZHG2wUDbGSCJEBe1YnLHBID4wnlTzEU1X0
   MmBz1IAY/k95viB6K7U3iixjYt6uxsCEU+ogGGBNUyvv9J2ycWQRjj+ua
   Q==;
X-CSE-ConnectionGUID: 3DSCbVpVRkGmEL4m+Oc3kg==
X-CSE-MsgGUID: Dn9TagwpSqmLGNdmxJFbWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986900"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986900"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:34 -0700
X-CSE-ConnectionGUID: rF/5olWiQqmz3RTMepllKA==
X-CSE-MsgGUID: 1OhYzD1fQjiHK/xv6WrXSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536950"
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
Subject: [PATCH 03/17] dmaengine: idxd: refuse a memcpy longer than the WQ max transfer size
Date: Mon, 19 Oct 2026 08:06:16 -0700
Message-ID: <20261019150630.4026341-4-daniel1.byrne@intel.com>
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

idxd_dma_submit_memcpy() checks the length only against the device
limit from GENCAP. Since commit d7aad5550eca ("dmaengine: idxd: add
support for configurable max wq xfer size"), WQCFG is programmed with
the work queue's own max_transfer_size instead, and that is the limit
the hardware enforces. Since commit 92452a72ebdf ("dmaengine: idxd: set
defaults for wq configs"), that limit defaults to 2 MiB.

A copy longer than the work queue's limit is therefore accepted at prep
time and then fails in hardware with DSA_COMP_XFER_ERANGE. A client that
sets only tx->callback cannot see that error, so the copy looks
complete. Also check the work queue's limit, so that prep returns NULL
and the caller can fall back.

On a Granite Rapids DSA with the default 2 MiB work queue limit and a
device limit of 2 GiB, dmatest with norandom=1 and test_buf_size=4194304
reports a data error for every copy on v7.2: the destination is never
written, yet each copy completes. With this change the same test fails
at prep, and copies of 1 MiB and 2 MiB pass as before.

Fixes: d7aad5550eca ("dmaengine: idxd: add support for configurable max wq xfer size")
Cc: stable@vger.kernel.org # 5.10+
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
index 9937b671f637..c116416e10e5 100644
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -115,7 +115,8 @@ idxd_dma_submit_memcpy(struct dma_chan *c, dma_addr_t dma_dest,
 	if (wq->state != IDXD_WQ_ENABLED)
 		return NULL;
 
-	if (len > idxd->max_xfer_bytes)
+	/* The work queue's configured limit is what the hardware enforces. */
+	if (len > idxd->max_xfer_bytes || len > wq->max_xfer_bytes)
 		return NULL;
 
 	op_flag_setup(flags, &desc_flags);
-- 
2.43.0

