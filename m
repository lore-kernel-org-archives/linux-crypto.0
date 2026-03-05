Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0BD347FC3
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 08:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772701200; cv=none; b=D5SggUiZxc+JKJsd51fkwMTqcDK7gYNeZIgFVj20DdRb+aibJ/1KpggiEc9Xbpu4U9k3y72pRa0s/JWyy4R5IrNWwKUwm6Aji8lShZig1f3LSeQrhc8wcdfVS2XGxTg/wGmGtA+n2ueh9fzZnofYpCcAGNaN2ke3Qeyz6jT99jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772701200; c=relaxed/simple;
	bh=MoQR5SZzileP5H5OUuxLsWg8LIxOpFib4mAhRL509b8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ajX4TWpTaY8hiP56XEcPypQZR9giXamv+1ff8P29XDr830foJeXoC+GnbVOHx5gmnaDa8z0nNx5pFt8obsDVVy3ixNUpmGFIRzwAn+8dy94XDhVFwSg6u/PzqHpuo/aQZKsIGfZxBF5tjjM6SJXBrhAYVUKwKMrLZxnz2CdlMyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LmRRs2bB; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LmRRs2bB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772701199; x=1804237199;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MoQR5SZzileP5H5OUuxLsWg8LIxOpFib4mAhRL509b8=;
  b=LmRRs2bBMxDlbNZaSgk0WAPLnHBKpqh60h5vnF/4QuzE9+nyvWJhhJuz
   4PlLcAQdcCc4lhH+hjnZhzfK20ecCbLE/KA3YA/dkrQhABT8b9fz0F1lv
   YgCHCjmwKwDzqrdZ7ZTrdqM+JOSaMQcsJFsrTjQ0yMTxEfj3YW56dnccC
   /twUm1dmN3Tbq27QHNjOydkhxw8M4ohPki+03dVLV1aYR4mhKsSE/BU4A
   TNvdddkMhRvz1JBNCQulm2MHoJitaFLPlIzWy2KsJVIzauNw/wfmUPrdI
   BOWE1Fo7VXJnxnovkorW6ApY8eF9w0HN7d5ECws4FTcwiE154SQv9wVSF
   w==;
X-CSE-ConnectionGUID: 05e+CXl/SeyCEak+9/cdDg==
X-CSE-MsgGUID: nTjXOTuRTMO7IDSYREUghw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="61354505"
X-IronPort-AV: E=Sophos;i="6.23,325,1770624000"; 
   d="scan'208";a="61354505"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 00:59:58 -0800
X-CSE-ConnectionGUID: SZuJXBXlS1O9b73LOe4lTg==
X-CSE-MsgGUID: /+zQB0edTkCPx1lPO1Yg/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,325,1770624000"; 
   d="scan'208";a="215451022"
Received: from dmr-bkc.iind.intel.com ([10.49.14.189])
  by fmviesa006.fm.intel.com with ESMTP; 05 Mar 2026 00:59:56 -0800
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 0/2] crypto: qat - GEN6 firmware loading fixes
Date: Thu,  5 Mar 2026 08:58:57 +0000
Message-ID: <20260305085955.66293-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This small series addresses firmware loading reliability on QAT GEN6
devices.

The first patch fixes inconsistent whitespace in the macro definitions
in qat_hal.c, switching from mixed tabs and spaces to tabs throughout.

The second patch adds a hardware-required minimum 3 us delay during
the acceleration engine reset sequence for GEN6 devices. Without this
delay, firmware loading may fail intermittently. Earlier generations
are unaffected.

Suman Kumar Chakraborty (2):
  crypto: qat - fix indentation of macros in qat_hal.c
  crypto: qat - fix firmware loading failure for GEN6 devices

 .../intel/qat/qat_common/adf_accel_engine.c   |  7 +++++
 .../qat/qat_common/icp_qat_fw_loader_handle.h |  1 +
 drivers/crypto/intel/qat/qat_common/qat_hal.c | 27 ++++++++++---------
 3 files changed, 23 insertions(+), 12 deletions(-)


base-commit: 3f61a0a3491596d6973e132848fead2dc5fa7ad1
-- 
2.52.0

