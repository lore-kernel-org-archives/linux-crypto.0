Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EA12D73A9;
	Thu, 20 Nov 2025 11:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763637951; cv=none; b=ko+pldT9xL3/523kx1I/c+Mm9TZ22Ay/s9M9RIx2HM1PTfKt5tftoRcyhLC6P5vLbKn81IunHG65+IsmdDUnp+fnBkNt1Jbzl34UohRPWgd4P3bWjzEKZLV9IJCjqUZOE/xvSQxDlnEZURHCmrMZVysFAaFpZCX/xuPSJ1rGLCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763637951; c=relaxed/simple;
	bh=6lhy61yEQdoxLIAUxppc8VupcYfNM/lvDshSkiHU7sA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ipeu1NUFvhcoCFC7ml9hIwaUbwjtWBNn+xiBCU3MaK3hFTHEAmd6g7RNwOuuzXkbVKWR5ktaVBdVT9lljvr4SVfjvOUGnQKpdyxl9w0VvCQKwGv+NwXQuDOtEQ/s/TSNemn+fuTKSo16NeMpKlG9hHKHQsbWmaS7qh+DweK+TpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CSH33hcd; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CSH33hcd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763637950; x=1795173950;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6lhy61yEQdoxLIAUxppc8VupcYfNM/lvDshSkiHU7sA=;
  b=CSH33hcd2qcPfQCRIhktak/zNR7z+1jhQeitNtaTO9IZfUMBXlE5qHFm
   VfDgCKfe73c1xkxYfccR1y8NUDYdBaq8zyzQMRz3zFDM/vN9BoHs292Lq
   QGh66/VmDAWGaEScyDbguvj8F5s0bxVFtAQw5nK/3iPtteVbZ0DxBvC14
   E2yw/ETRtkiqsCpzefq1wxjcf1QWfz6o4N+yjQyFSA+3eruVUjL3qA5LE
   vOA00IkjvCsIhEppw9EExfIqi2rUAl3BYZXT5QWl1lbvKxP58IdLi7i9U
   aMJR57vA5ggOfnelf5eyCZdU0y9GIvdwZeTBrbJVXlQj6bF/ta/aChWUv
   w==;
X-CSE-ConnectionGUID: ETszqCGOSg2oAOwIMMnuUw==
X-CSE-MsgGUID: A29kfv95SQ6VLEt+8upjhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65865814"
X-IronPort-AV: E=Sophos;i="6.20,317,1758610800"; 
   d="scan'208";a="65865814"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 03:25:49 -0800
X-CSE-ConnectionGUID: 0/fgOdezRqOVJWGbmFGDbA==
X-CSE-MsgGUID: CvOkr+8uQIijz5Vmrcq/8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,317,1758610800"; 
   d="scan'208";a="191145130"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by fmviesa006.fm.intel.com with ESMTP; 20 Nov 2025 03:25:47 -0800
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	stable@vger.kernel.org,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Subject: [PATCH] crypto: zstd - fix double-free in per-CPU stream cleanup
Date: Thu, 20 Nov 2025 16:26:09 +0000
Message-ID: <20251120162619.28686-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The crypto/zstd module has a double-free bug that occurs when multiple
tfms are allocated and freed.

The issue happens because zstd_streams (per-CPU contexts) are freed in
zstd_exit() during every tfm destruction, rather than being managed at
the module level.  When multiple tfms exist, each tfm exit attempts to
free the same shared per-CPU streams, resulting in a double-free.

This leads to a stack trace similar to:

  BUG: Bad page state in process kworker/u16:1  pfn:106fd93
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x106fd93
  flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
  page_type: 0xffffffff()
  raw: 0017ffffc0000000 dead000000000100 dead000000000122 0000000000000000
  raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
  page dumped because: nonzero entire_mapcount
  Modules linked in: ...
  CPU: 3 UID: 0 PID: 2506 Comm: kworker/u16:1 Kdump: loaded Tainted: G    B
  Hardware name: ...
  Workqueue: btrfs-delalloc btrfs_work_helper
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   bad_page+0x71/0xd0
   free_unref_page_prepare+0x24e/0x490
   free_unref_page+0x60/0x170
   crypto_acomp_free_streams+0x5d/0xc0
   crypto_acomp_exit_tfm+0x23/0x50
   crypto_destroy_tfm+0x60/0xc0
   ...

Change the lifecycle management of zstd_streams to free the streams only
once during module cleanup.

Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
---
 crypto/zstd.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index dc5b36141ff8..cbbd0413751a 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -75,11 +75,6 @@ static int zstd_init(struct crypto_acomp *acomp_tfm)
 	return ret;
 }
 
-static void zstd_exit(struct crypto_acomp *acomp_tfm)
-{
-	crypto_acomp_free_streams(&zstd_streams);
-}
-
 static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
 			     const void *src, void *dst, unsigned int *dlen)
 {
@@ -297,7 +292,6 @@ static struct acomp_alg zstd_acomp = {
 		.cra_module = THIS_MODULE,
 	},
 	.init = zstd_init,
-	.exit = zstd_exit,
 	.compress = zstd_compress,
 	.decompress = zstd_decompress,
 };
@@ -310,6 +304,7 @@ static int __init zstd_mod_init(void)
 static void __exit zstd_mod_fini(void)
 {
 	crypto_unregister_acomp(&zstd_acomp);
+	crypto_acomp_free_streams(&zstd_streams);
 }
 
 module_init(zstd_mod_init);

base-commit: 8faa5c4b47998c5930314a3bb8ee53534cfdc1ce
-- 
2.51.1

