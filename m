Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9672212C539
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 14:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715352301; cv=none; b=QKPlrTE5miN4vyotEN+ZEZrQxBcCT609x+IkYyZoGpr7/sszHxKJ9sHhUv0DAToQJfDYbxQJMm93Wzwu13nKUMwpNNa5R9KfC8ikymQpGUcENG/vX9LwNBgcsFwS315ynkEgp1yUYTFNzKyEDNxbe/wKMZNnPb+45ROGZskXYNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715352301; c=relaxed/simple;
	bh=0uo2J02qIGGU5nGLsi3zRsVi58wep11XymEUFmga7nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fKjNxKsoXFmDxuKXordUFfRrZp/iQIgW3CDQovpXST1yY5Fmuc1h4yadIsFKyKk9x/qyjvwDYAFQQC9C63ohS8+vSQDbomEp36GUUbe0bqTeYf0uudxFHtp1CWssyDSg27e1dMWaJxHx+FyxDwA7ZdSlk9HRVXTCXlbtmHNNaWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f2mWsqVC; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f2mWsqVC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715352300; x=1746888300;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0uo2J02qIGGU5nGLsi3zRsVi58wep11XymEUFmga7nQ=;
  b=f2mWsqVC+bM51A8MSXOOvSJrZ9IurddG3ddXHIxtL4qO3cN3cch06dcd
   bTHcxpSXhkLLXm4XiVIqGY12caO9YMvfpIJPcQ857qtQeQ+AsCvuGcx8l
   VcyiPOOb1Fsdx0WueMf0dzgOeAGu/AeEOLQBrB8yWSeRo1jW8r4V7exhg
   YvnNeYmjK4j3SzjdCKwOnFa4jveEbHRAMfkMHpN+NK5Lg/vEpsWW664Pw
   C0UofZFeVnqyAy4WMsAuc02/Qd2ZwxSU4ZPTS0o+4AAxuulzU2uuxmS18
   Ye0TQFeXDSOdMJJ02omC3yCgZclYpgaxsrWVYGJJMuRY0hZlwAbC4qDqg
   g==;
X-CSE-ConnectionGUID: FtCenkYlTgSi3w1pMQY8jw==
X-CSE-MsgGUID: AmwLPNAHQdaf+K6aBP/AjA==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="11268207"
X-IronPort-AV: E=Sophos;i="6.08,151,1712646000"; 
   d="scan'208";a="11268207"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2024 07:44:57 -0700
X-CSE-ConnectionGUID: 9q/3B8iSTXu2Vac4O5FGgg==
X-CSE-MsgGUID: w238oIl7ShiXg8PrMwOKtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,151,1712646000"; 
   d="scan'208";a="60486871"
Received: from unknown (HELO localhost.igk.intel.com) ([10.211.127.84])
  by orviesa002.jf.intel.com with ESMTP; 10 May 2024 07:44:56 -0700
From: Sergey Portnoy <sergey.portnoy@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH v2] crypto: tcrypt - add skcipher speed for given alg
Date: Fri, 10 May 2024 16:33:15 +0100
Message-ID: <20240510154405.664598-1-sergey.portnoy@intel.com>
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
v1 -> v2

- speed_template is moved to be on-stack and type was corrected to u8

 crypto/tcrypt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 8aea416f6480..ffd94a0972ca 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1454,6 +1454,8 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 	int i;
 	int ret = 0;
 
+	u8 speed_template[2] = {klen, 0};
+
 	switch (m) {
 	case 0:
 		if (alg) {
@@ -2807,6 +2809,16 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				       speed_template_16_32, num_mb);
 		break;
 
+	case 611:
+		if (alg)
+			test_mb_skcipher_speed(alg, ENCRYPT, sec, NULL, 0,
+					       speed_template, num_mb);
+		break;
+	case 612:
+		if (alg)
+			test_mb_skcipher_speed(alg, DECRYPT, sec, NULL, 0,
+					       speed_template, num_mb);
+		break;
 	}
 
 	return ret;
-- 
2.44.0

