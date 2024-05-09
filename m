Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D91412F596
	for <linux-crypto@vger.kernel.org>; Thu,  9 May 2024 10:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715251101; cv=none; b=Oe1YhV/QkrLRqNlRWcIeU5XgAkVLEgZ2o2TIOFsV9q4sPOoQR4ifdr3Qmlf5V14NWsjgSGJFFgiEmgyxlnhERsHFqRgrDzpclDvjSaNsFt4YkoUB8KI1y7FsOu2cLhjxb6tS5tPfZrBXteLoS7kcH51hHAoBRCM24QrW5akYWoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715251101; c=relaxed/simple;
	bh=+QCqHMt3FD72adGPPew9x7Adq3BNAcbJrbljLlE88tw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QT08NwEIvPu14GJBb88zG0NNf10BRuaVPnMX2xkzW5OUwCDwWmn0Eia6vnYlrqoXvviRrEIfLcfhyJBLU+AUhUJ7z+2J2bJGgLebLlsWBcOXbuKjQSNrx7LOlogCG8SrW19Fyd0prOtbIjuPZwbWEsO7xaMchi/D/So4i56z4mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ck+6qJOA; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ck+6qJOA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715251096; x=1746787096;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+QCqHMt3FD72adGPPew9x7Adq3BNAcbJrbljLlE88tw=;
  b=ck+6qJOA0bGn5f0zlzDm7q010I97W3Ki65Esa9KVjtZsMwRViBeBmElk
   olN45n99/6a7ZDf7jm5VDG3OOV32pRHk82i6QTFMnWu22QW4q0XtEhX1i
   8dI629Mx0zMAY8mipEbI/libyWtRiJL29yaVBSpCG8Xq4y2ynCpj4WXYA
   9PUpMEURkgMIM36rEIj/IUTpygRdZhk9a49QLsIVXS7RZb+nF3tIggeO4
   h+puv1CNyH29XpVfMoe7xm1ygLI78brDHaGWOjR10arGbuBe453RG04HB
   7zZJWA91eNnVw49ccQcWU0Jyfc4hAucSLpR4t6Y7c9mda210arxXucaEC
   w==;
X-CSE-ConnectionGUID: Do8uIbf4REuf6BmXr59zrA==
X-CSE-MsgGUID: tcG/ziv6RaWF2QrGbnPULg==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="11292173"
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="11292173"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 03:38:15 -0700
X-CSE-ConnectionGUID: ttBo06wNR22T0aGPmB33jA==
X-CSE-MsgGUID: iiswObXkTEqy6ZYpT9Dwzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="33759113"
Received: from unknown (HELO localhost.igk.intel.com) ([10.211.127.84])
  by fmviesa004.fm.intel.com with ESMTP; 09 May 2024 03:38:13 -0700
From: Sergey Portnoy <sergey.portnoy@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH] crypto: tcrypt - add skcipher speed for given alg
Date: Thu,  9 May 2024 12:36:11 +0100
Message-ID: <20240509113703.578583-1-sergey.portnoy@intel.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow to run skcipher speed for given algorithm.
Two separate cases are added to cover ENCRYPT and DECRYPT
directions.

Example:
   modprobe tcrypt mode=611 alg="qat_aes_xts" klen=32

If succeed, the performance numbers will be printed in dmesg:
   testing speed of multibuffer qat_aes_xts (qat_aes_xts) encryption
   test 0 (256 bit key, 16 byte blocks): 1 operation in 14596 cycles (16 bytes)
   ...
   test 6 (256 bit key, 4096 byte blocks): 1 operation in 8053 cycles (4096 bytes)

Signed-off-by: Sergey Portnoy <sergey.portnoy@intel.com>
---
 crypto/tcrypt.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 8aea416f6480..73bea38c8112 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -68,6 +68,7 @@ static int mode;
 static u32 num_mb = 8;
 static unsigned int klen;
 static char *tvmem[TVMEMSIZE];
+static char speed_template[2];
 
 static const int block_sizes[] = { 16, 64, 128, 256, 1024, 1420, 4096, 0 };
 static const int aead_sizes[] = { 16, 64, 256, 512, 1024, 1420, 4096, 8192, 0 };
@@ -2807,6 +2808,18 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				       speed_template_16_32, num_mb);
 		break;
 
+	case 611:
+		speed_template[0] = klen;
+		if (alg)
+			test_mb_skcipher_speed(alg, ENCRYPT, sec, NULL, 0,
+					       speed_template, num_mb);
+		break;
+	case 612:
+		speed_template[0] = klen;
+		if (alg)
+			test_mb_skcipher_speed(alg, DECRYPT, sec, NULL, 0,
+					       speed_template, num_mb);
+		break;
 	}
 
 	return ret;
-- 
2.44.0

