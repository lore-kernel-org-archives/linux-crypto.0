Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A907171C4;
	Tue, 11 Jun 2024 21:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718141773; cv=none; b=pTS4e4Memxver3qQt3NGtEN7r4LHoQaVnUKYWBzvU0dISiooMI6e+kt+uNx/bfEpjSzxszItol6ddcCEkygOK1Ebdg/P8EDPR4N96VCxyymLotLzLq75Kpx3NGgRgVfh7Wq+Ijx4yUitHp1Wmnx0c5HMmGm+vK4t/FQ4iuJPkvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718141773; c=relaxed/simple;
	bh=mK7u4g6d/FI3I+GEvjf9//kaQbqPpB8MdX7WJi8RqPU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sBIYrYYIRM6gkHK6zr3jB6Qu1OME58b5nVeoyfLIdFKzoUTM9J1vJJEcyqMKEWW6B4OR4nN6kIxdn9ycuz9LIFrnnlGT4l4hKfJ8oLh9lSvAEo2TmXNzGyepb6rCEbC2hxjNgwIfBqyAa6mSBuUhivft0YYk4ie63W26pvKtnqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ilJ4Ps5L; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ilJ4Ps5L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718141772; x=1749677772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mK7u4g6d/FI3I+GEvjf9//kaQbqPpB8MdX7WJi8RqPU=;
  b=ilJ4Ps5LxZVtRFV2eIcql0keGyLajegz2XyHporx8/FzjNOKdwA4nHa3
   2r+KCUlbGAlnCWmhcO2lvR+XgDbp9QG+kJlxYJsgaI43Io5AvLcN2aUna
   riNnquya+PyunOTywyXOcbbT9MZnapNAPJAuqrHYmFw1EokvfK+WwE3ka
   h9MskPsMwMSiYG5Q/7dOAtm7KHkrlckWJRJxVqiA8K3HGBQMoi5DbaGdQ
   dsoAQhaS6I2peFOMCAU88QJe7/AZDVNxfxYYlPkhP/A2rL5mR2qnIdt2e
   M9KlookXYbr2/zsq6wv3k+MCvZSAHuBuXPODRaPxc8QBJC1QHu3+QZDgW
   w==;
X-CSE-ConnectionGUID: oUTCdiiBSOuiMX3knd/6SA==
X-CSE-MsgGUID: A0P77sSXTsCoCP6nb8J4yA==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="32418501"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="32418501"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 14:36:11 -0700
X-CSE-ConnectionGUID: FGVX40QAQWq/aqGRgohnqA==
X-CSE-MsgGUID: aDbVzrA0Txqqvl36OVnTIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="62744724"
Received: from cbae1-mobl.amr.corp.intel.com (HELO cbae1-mobl.intel.com) ([10.124.132.58])
  by fmviesa002.fm.intel.com with ESMTP; 11 Jun 2024 14:36:10 -0700
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: ebiggers@kernel.org,
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	bernie.keany@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v9b 12/14] x86/Kconfig: Add symbols for Key Locker
Date: Tue, 11 Jun 2024 14:36:09 -0700
Message-Id: <20240611213609.253115-1-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240329015346.635933-13-chang.seok.bae@intel.com>
References: <20240329015346.635933-13-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add CONFIG_X86_KEYLOCKER to control whether Key Locker is initialized at
boot. Additionally, add the AS_KEYLOCKER config symbol to indicate
whether the assembler supports Key Locker.

The former will be selected, and the latter will be referenced by the Key
Locker cipher module CRYPTO_AES_KL, to be added in a later patch.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
Changes from v9:
* Include AS_KEYLOCKER symbol (Eric Biggers).
* Revoke the earlier tag.
---
 arch/x86/Kconfig           | 3 +++
 arch/x86/Kconfig.assembler | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d7122a1883e..ce4e4c1641da 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1881,6 +1881,9 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
 	  If unsure, say y.
 
+config X86_KEYLOCKER
+	bool
+
 choice
 	prompt "TSX enable mode"
 	depends on CPU_SUP_INTEL
diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
index 59aedf32c4ea..e6ce80d23113 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -35,6 +35,11 @@ config AS_VPCLMULQDQ
 	help
 	  Supported by binutils >= 2.30 and LLVM integrated assembler
 
+config AS_KEYLOCKER
+	def_bool $(as-instr,encodekey256 %eax$(comma)%eax)
+	help
+	  Supported by binutils >= 2.36 and LLVM integrated assembler >= V12
+
 config AS_WRUSS
 	def_bool $(as-instr,wrussq %rax$(comma)(%rbx))
 	help
-- 
2.34.1

