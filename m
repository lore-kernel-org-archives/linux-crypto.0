Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB7B35B645;
	Mon, 23 Feb 2026 15:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771859203; cv=none; b=XhCu2PgzaM2h6ExBfyx5//sYs0Cy9AfrCHodDCerZODPr+9IIeGtnt8ie7M/KkT/9+4AYf19v1WUle3KfmEzY/LYqMlvbruxtjtrSL70HDd1FZb6Ut5XGKmiFCow30Zo8XvMpY6B20JTEH0+gf+vIik7rXs57poE7X3Nq6CWir8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771859203; c=relaxed/simple;
	bh=CKrHYBD8suFxrxSi9DamntzJhthvYGfiYJJVSaOhJic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KQBx1c32YLqyVts4AGp+t4DbWj5X5eb1VYpQTkvrB5Zl5jLwhbcMaWKXAIUjs9iiUw3Za5ZGBh+KsGrqo4ykUR0+HfHTl7XwLmXVUk6ak2S0Z3EKr+t07+DNlD7ZMn/d7ySXOipilt+615LDx3bONjzjw1kNPQXqxokPdaccaCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dG48SW0b; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dG48SW0b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771859201; x=1803395201;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CKrHYBD8suFxrxSi9DamntzJhthvYGfiYJJVSaOhJic=;
  b=dG48SW0bgcDuczFGciYPI/aNA7e+rdc7ipn+PbVu6/pVylzQon1TjKJG
   /dLccXsxJbCJdHiTsNtJ6p4Qi6EiBTdoUgsbT/1+sdRM5wS6rtYvnUAnk
   NERmZc3lyZU9RBLQ3G+GVNlWkqAM9E3RvSGCO+dl4zdjtbg7pxYaYYPTT
   pU4J7HaObJUhHBf5YVyHq7Xguefh4VLRQGFaO+/5znZKtXXM8XGo9baRi
   BBwUFL1L7S056hJnrDJKAWB12y0edb4kMUJdjmTLG3jMiGXPArGpyreI8
   JSMTqBD2EShL+w5cqbDCPZY8deQQkXjlN1GwwENO+q1pcCiXlBJAX84/3
   A==;
X-CSE-ConnectionGUID: LDOr3VLfQb2VWq67G9dosg==
X-CSE-MsgGUID: 58oEsijzSz+jqipoyKgOUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="90263263"
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="90263263"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 07:06:40 -0800
X-CSE-ConnectionGUID: y6aS34q/S6Cz/VjDvrGEtA==
X-CSE-MsgGUID: P2bUdkHQRrmrY2LAah1T6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="253313289"
Received: from dalessan-mobl3.ger.corp.intel.com (HELO dalessan-mobl3.intel.com) ([10.245.244.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 07:06:37 -0800
From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
To: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Paul J . Murphy" <paul.j.murphy@intel.com>,
	"Paul J . Murphy" <paul.j.murphy@linux.intel.com>,
	Prabhjot Khurana <prabhjot.khurana@intel.com>,
	Mark Gross <mgross@linux.intel.com>,
	Declan Murphy <declan.murphy@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	Daniele Alessandrelli <daniele.alessandrelli@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: [PATCH] MAINTAINERS: Remove Daniele Alessandrelli as Keem Bay maintainer
Date: Mon, 23 Feb 2026 15:06:22 +0000
Message-ID: <20260223150622.268245-1-daniele.alessandrelli@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I'm leaving Intel soon. Remove myself as maintainer of Keem Bay
architecture and related crypto drivers.

The INTEL KEEM BAY OCS AES/SM4 CRYPTO DRIVER has no replacement
maintainer available, so mark it as Orphan.

Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
---

This patch involves two subsystems (ARM and Crypto). Not sure
who should pick it up; should I split it into two separate patches
instead?

 MAINTAINERS | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b8d8a5c41597..d82693faa94b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2913,7 +2913,6 @@ F:	include/linux/soc/ixp4xx/qmgr.h
 
 ARM/INTEL KEEMBAY ARCHITECTURE
 M:	Paul J. Murphy <paul.j.murphy@intel.com>
-M:	Daniele Alessandrelli <daniele.alessandrelli@intel.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/arm/intel,keembay.yaml
 F:	arch/arm64/boot/dts/intel/keembay-evm.dts
@@ -12984,8 +12983,7 @@ F:	Documentation/devicetree/bindings/display/intel,keembay-display.yaml
 F:	drivers/gpu/drm/kmb/
 
 INTEL KEEM BAY OCS AES/SM4 CRYPTO DRIVER
-M:	Daniele Alessandrelli <daniele.alessandrelli@intel.com>
-S:	Maintained
+S:	Orphan
 F:	Documentation/devicetree/bindings/crypto/intel,keembay-ocs-aes.yaml
 F:	drivers/crypto/intel/keembay/Kconfig
 F:	drivers/crypto/intel/keembay/Makefile
@@ -12994,7 +12992,6 @@ F:	drivers/crypto/intel/keembay/ocs-aes.c
 F:	drivers/crypto/intel/keembay/ocs-aes.h
 
 INTEL KEEM BAY OCS ECC CRYPTO DRIVER
-M:	Daniele Alessandrelli <daniele.alessandrelli@intel.com>
 M:	Prabhjot Khurana <prabhjot.khurana@intel.com>
 M:	Mark Gross <mgross@linux.intel.com>
 S:	Maintained
@@ -13004,7 +13001,6 @@ F:	drivers/crypto/intel/keembay/Makefile
 F:	drivers/crypto/intel/keembay/keembay-ocs-ecc.c
 
 INTEL KEEM BAY OCS HCU CRYPTO DRIVER
-M:	Daniele Alessandrelli <daniele.alessandrelli@intel.com>
 M:	Declan Murphy <declan.murphy@intel.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
-- 
2.52.0

