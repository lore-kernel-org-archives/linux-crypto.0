Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A6A69D3C
	for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 15:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718637122; cv=none; b=GrpbARtYxu26i5qa5GBfGyxKp5X5cr4toQO+NryF7EBGlPc6KBxblnMBI+qMGceMp9I+PyrDhJWAOCsMiwwGtrq7Deh9r8m2xp+u7SESBchkRStveQ53nOdqrY1ReMvUQHCeV7JbqA+GHHT39n6oFt1VY6/Oi1lq8LcDIxiKFvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718637122; c=relaxed/simple;
	bh=BcHcXCkSiQi1C8vQWPOP5NNBCTJKNLS1M1cgQxV//GI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ph/qy//E2eht5GTcYs/u3OVLYmKwaoG7hLtO4V02eXvvDpQStgsiIwaYVyIw1UKxyW/7zRvyZpL7mvAwOUsLw64IDUeWUTxPS9xL3/kiiRq4bSGHQS2myrc3XJ60GEk26A1oR4XyP2etHERC4Jk+0WSadAZxeRe+DPwWt6Ftogs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L3gFMkro; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L3gFMkro"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718637121; x=1750173121;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BcHcXCkSiQi1C8vQWPOP5NNBCTJKNLS1M1cgQxV//GI=;
  b=L3gFMkrosfusUC93gRgKXKwOJlfyVdJeMuTmByxhiITnFrrzSqgPMhR6
   Ceql9fe5o97eUjtJ9KsPeUCOEvecS4sCKVGeZk+1iFRX+7cyYnhcm0Yf0
   dQjJbFwShUf+Ht8BQ2l5BaM6tHQaitWqkVbXHnW9YWoTEGXEKIG60Fnmy
   Lfn+LRVpHqjAEOA5f2SLjOadq1pgGgI+2RlIbWIznle6YM1tHHYp67bUm
   MDMZ+6VoDOKmzxirGyuxTRGY2FBoc8fVgRfsbpH1apuBUAlAPsZtICCCV
   v63M4+PXGtW7fwh8YLwbGq9POzkilFrBUOUliFS5TYZChM68XGt0HznEr
   Q==;
X-CSE-ConnectionGUID: y5J/pzd4RDGH6mNyulsnOQ==
X-CSE-MsgGUID: mWp9/s6ASJ6+qs/z8F4r4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11106"; a="15433253"
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="15433253"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 08:12:01 -0700
X-CSE-ConnectionGUID: t7X8qAP0QiCKSU5/XB536w==
X-CSE-MsgGUID: rkoBvtj5SKGyBMDfOTX0ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="78691128"
Received: from unknown (HELO localhost.igk.intel.com) ([10.211.127.84])
  by orviesa001.jf.intel.com with ESMTP; 17 Jun 2024 08:12:00 -0700
From: Sergey Portnoy <sergey.portnoy@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH v4] crypto: tcrypt - add skcipher speed for given alg
Date: Mon, 17 Jun 2024 17:08:29 +0100
Message-ID: <20240617161048.3480877-1-sergey.portnoy@intel.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow to run skcipher speed for given algorithm.
Case 600 is modified to cover ENCRYPT and DECRYPT
directions.

Example:
   modprobe tcrypt mode=600 alg="qat_aes_xts" klen=32

If succeed, the performance numbers will be printed in dmesg:
   testing speed of multibuffer qat_aes_xts (qat_aes_xts) encryption
   test 0 (256 bit key, 16 byte blocks): 1 operation in 14596 cycles (16 bytes)
   ...
   test 6 (256 bit key, 4096 byte blocks): 1 operation in 8053 cycles (4096 bytes)

Signed-off-by: Sergey Portnoy <sergey.portnoy@intel.com>
---

v3 -> v4

- moving speed_template declaration to case section.

 crypto/tcrypt.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 8aea416f6480..e9e7dceb606e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2613,6 +2613,15 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		break;
 
 	case 600:
+		if (alg) {
+			u8 speed_template[2] = {klen, 0};
+			test_mb_skcipher_speed(alg, ENCRYPT, sec, NULL, 0,
+					       speed_template, num_mb);
+			test_mb_skcipher_speed(alg, DECRYPT, sec, NULL, 0,
+					       speed_template, num_mb);
+			break;
+		}
+
 		test_mb_skcipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
 		test_mb_skcipher_speed("ecb(aes)", DECRYPT, sec, NULL, 0,
-- 
2.44.0

