Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CD517D346;
	Sat, 23 Nov 2024 07:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732345294; cv=none; b=AKJZ5YJEYlSjmY4pHqpb8LPiGRPdhS+sbfxys3tgc6RXIOJycVptjnM1/YRcznuhYtaFsxq6IJwTNuQsHEQs7fb7qtC7/A0Qmdf/bwH5u7zAgENfIL21MxTGtJd0Pu0dU58UIZ3bK415qk6pfB5bgOumt4fU2CgzlNQVQUTFemM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732345294; c=relaxed/simple;
	bh=sUaKs4IKHRtAS2VJ+T+gUebh7+S3mchKFlm9dP1TtUQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fn+3r9TCzm7ksM3MMYhcnHxU9GpRBHg2fHOvzdTxqBJXbFT8FrwW8CHtj3SQwQ3pOwOZfzN+yMJjFf061DpJ1qceJkRNrolm405oK4Eb5kuoJy0b7olWI/OiS8PfsS4LoRkjItsm4kinqBTNTkVP2VixdWPGFPEWDdGY2YLsjrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NfTUBiT/; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NfTUBiT/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732345294; x=1763881294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sUaKs4IKHRtAS2VJ+T+gUebh7+S3mchKFlm9dP1TtUQ=;
  b=NfTUBiT/Raa4VwYnW4PaeZlBjO6ZbQig6kKLtlg+DIey+0OQpmtHcqe8
   hw9PHQTY2L91h7pLCRk0/q2H+tbrwdNq0dHaUAqnOJRj4vVs7d8McNfKw
   QW7w5FPoBho6CfX/VHKKO/JpSlSRETJj7RiHiwZx7s2kLuxqXYR5+qCI2
   p+AUEuNgv5X4lDcwrCJn1P6HyG92Kx1T3nGQNYN/kMkzOAtBg8VRkWPfm
   o+N7t57Vw1Wo0XQuBWFLEk8Jbg4EIAw0zkCYwkhXcsv2Rjqe851God76r
   9/sGiso+C9CivZkX7Grx5EsALDsxKr+OUkWrJUxBos4/8eTIUd43W47fl
   g==;
X-CSE-ConnectionGUID: /KJu0QlcTy+m/zm/0XfbRw==
X-CSE-MsgGUID: osC9gKo7TIa8WDui7bZebQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32435508"
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="32435508"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 23:01:29 -0800
X-CSE-ConnectionGUID: X3bP/RyIT4erTLLHM7SmIw==
X-CSE-MsgGUID: JCLeK2TqTU2sZVaYYC8rcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="91573559"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 22 Nov 2024 23:01:28 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	ying.huang@intel.com,
	21cnbao@gmail.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v4 05/10] crypto: iaa - Disable iaa_verify_compress by default.
Date: Fri, 22 Nov 2024 23:01:22 -0800
Message-Id: <20241123070127.332773-6-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch makes it easier for IAA hardware acceleration in the iaa_crypto
driver to be loaded by default with "iaa_verify_compress" disabled, to
facilitate performance comparisons with software compressors (which also
do not run compress verification by default). Earlier, iaa_crypto compress
verification used to be enabled by default.

With this patch, if users want to enable compress verification, they can do
so with these steps:

  1) disable all the IAA device/wq bindings that happen at boot time
  2) rmmod iaa_crypto
  3) modprobe iaa_crypto
  4) echo 1 > /sys/bus/dsa/drivers/crypto/verify_compress
  5) re-run initialization of the IAA devices and wqs

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index bd2db0b6f145..a572803a53d0 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -94,7 +94,7 @@ static bool iaa_crypto_enabled;
 static bool iaa_crypto_registered;
 
 /* Verify results of IAA compress or not */
-static bool iaa_verify_compress = true;
+static bool iaa_verify_compress = false;
 
 static ssize_t verify_compress_show(struct device_driver *driver, char *buf)
 {
-- 
2.27.0

