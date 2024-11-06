Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298EB20ADE4;
	Wed,  6 Nov 2024 19:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920872; cv=none; b=WEMo3LmEoeX5D7svmBMsohGtUd9WsY4HDFsuX24xuFSO2AcKPgxLEKsjVBRFJ5ODoixQEi0caG0YSXXczKNn+dex1iqM8fD5MVLMGtXtYdAbWjc0z+rE8HkGWF7h5TNVLTBhKyTflyGtJ22dtFsbKaNYq0QEBhh0fLBPWpXogHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920872; c=relaxed/simple;
	bh=pX2jvauw5wJ2+nUrjP9yXpyaB7Rg+Ni/oUTJYJHTKmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VfYo5nFrNU+l0mqftL4hG1Lwee5Vmq5PFjZ+YixEhL0mCqlg0RTjM8b1bHurRNHqe2jCX2J5X4DMA/ZAskjRCChju3+pls0jf7DLQWj9HlG2fxs9JJo6gRiS2kB0Ba2sH3z7izoK/mBo4+03GOwriDshd20OMMT/ZWDQqIoCi4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PRiLw4eo; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PRiLw4eo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730920871; x=1762456871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pX2jvauw5wJ2+nUrjP9yXpyaB7Rg+Ni/oUTJYJHTKmc=;
  b=PRiLw4eoxhjJeMEzhT4J6G862R2wHiGomwlwDvCZ5AtWv5upxV4JuOPi
   IyXvyp2b+eayhORz87MrQVogjHkOpdmG/PyGSinGlZjRAPjGiBLs/KxhT
   0PQLdG6uL9jMP/fidTIpmlCMeOF47B0t5mlC0cL1Q6+UwM62h1BWaivL6
   qfHBdSvhlWab8+eYD/NJnxCpwFcA1w6P4uqkCepeuxHVSzagGHbywrLUh
   PMerJRdFKu4UnUwGwBOu/sMYV1hply0gu1i+TgWVhrpvhT2Rt4I8T+aux
   QZT0bnhprs4TqfposUQcG0hEOXkUPAYxKklOhU5OtnbRcb+I+5c6spH35
   A==;
X-CSE-ConnectionGUID: Y24l1BrURzqQsB8W4pN4wg==
X-CSE-MsgGUID: GEjgotpfTmiu5YlZfoWbrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41291972"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41291972"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 11:21:09 -0800
X-CSE-ConnectionGUID: npxTDlYWQ0e93T1biJ33MA==
X-CSE-MsgGUID: tQcgnDEyR0mPpreuHOVDRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="88695381"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 06 Nov 2024 11:21:08 -0800
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
	kristen.c.accardi@intel.com,
	zanussi@kernel.org
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v3 04/13] crypto: iaa - Make async mode the default.
Date: Wed,  6 Nov 2024 11:20:56 -0800
Message-Id: <20241106192105.6731-5-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch makes it easier for IAA hardware acceleration in the iaa_crypto
driver to be loaded by default in the most efficient/recommended "async"
mode for parallel compressions/decompressions, namely, asynchronous
submission of descriptors, followed by polling for job completions.
Earlier, the "sync" mode used to be the default.

This way, anyone that wants to use IAA can do so after building the kernel,
and without having to go through these steps to use async poll:

  1) disable all the IAA device/wq bindings that happen at boot time
  2) rmmod iaa_crypto
  3) modprobe iaa_crypto
  4) echo async > /sys/bus/dsa/drivers/crypto/sync_mode
  5) re-run initialization of the IAA devices and wqs

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 3ac3a37fd2e6..13f9d22811ff 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -153,7 +153,7 @@ static DRIVER_ATTR_RW(verify_compress);
  */
 
 /* Use async mode */
-static bool async_mode;
+static bool async_mode = true;
 /* Use interrupts */
 static bool use_irq;
 
-- 
2.27.0

