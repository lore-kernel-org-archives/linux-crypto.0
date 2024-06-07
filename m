Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE35194A7E
	for <linux-crypto@vger.kernel.org>; Fri,  7 Jun 2024 13:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717767151; cv=none; b=Rs8fG4+huzdp8XeP+BokeI93dYtEsZim6jWnuZRahgTLbGXKzUSIkysI6lQKrl00sQfPaJeYH0lA584a53ryof7t8uAIdzIWh1CbFl5J82rIMFX/1fhGuivqvjZt6ypKzHBPhX1lQP9m24ibNZOcGoj4GpXohNaLuL1FeE5KuT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717767151; c=relaxed/simple;
	bh=KQpggs8NDgJ+mb9O9ix2E/67PIYIJ/6NySQNXSXn/nI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UanPsX5Ft50vNncIyWHIH6zT18ZzeC5oLYT9MDkq+/p13BJ+W+S8m54JoqnKg4vWHa27EHRZTeHVTzEa/NlPHnx8w8cRetCjfDCmAl3kXbHEB84EKIsUrQ5ETAxwJbZUEIJKwFSeycdOBi6eZ+UEDaiNXip+rPIvMLRY+7bKB3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gkufRuea; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gkufRuea"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717767149; x=1749303149;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KQpggs8NDgJ+mb9O9ix2E/67PIYIJ/6NySQNXSXn/nI=;
  b=gkufRueafF1U+YP1GDJ24dZ1mIvqxyMn8vmPYzLsc7nJDMoI9annDjO+
   fywJUu4rVVn3nXEBBrhZdBw9lMsoneGmc5WmFJ8MOI5IsyQ179sH3NDHk
   iTHxyuHQNgTGWBbbW03c9KPnRp8NXjZBM0Yb/+tqJlb3dEK0v1kbPE7Qa
   ji5cP8aB5AfucF/jIJ/m3gZnuWHTKo4EENBS8eLk/ulG8FGOpjztDLfiM
   fVaIfxshl6SS5OoBMa5xrZJY1rYEWWWga24ETH6a3+AGFXQtVhstktiIy
   xx+DmGgbs/8ORiC7WczvBFKvRMJJew6ITRGSgnEmWAIJIfhPmhORb2tmv
   A==;
X-CSE-ConnectionGUID: liux9/UQQUuSRrc/w79PeQ==
X-CSE-MsgGUID: 5ly8ocV7QXaN0rIOhYvfIg==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="14321856"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="14321856"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 06:32:29 -0700
X-CSE-ConnectionGUID: qejFeIgbTwCgWtibUSmh7g==
X-CSE-MsgGUID: IEAu/LgJSdCreQ12JzXycA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="38902816"
Received: from unknown (HELO localhost.igk.intel.com) ([10.211.127.84])
  by orviesa008.jf.intel.com with ESMTP; 07 Jun 2024 06:32:28 -0700
From: Sergey Portnoy <sergey.portnoy@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH v3] crypto: tcrypt - add skcipher speed for given alg
Date: Fri,  7 Jun 2024 15:30:48 +0100
Message-ID: <20240607143128.2740633-1-sergey.portnoy@intel.com>
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

v2->v3

- modifying case 600, instead of using separate cases for
  encrypt/decrypt

 crypto/tcrypt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 8aea416f6480..880d427bdb3f 100644
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
@@ -2613,6 +2615,14 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		break;
 
 	case 600:
+		if (alg) {
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

