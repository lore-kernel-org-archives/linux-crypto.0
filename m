Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00150388885
	for <linux-crypto@vger.kernel.org>; Wed, 13 May 2026 15:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685612; cv=none; b=Mkd67GxEoD9X66M0b35LiofT3B9dUyXnw3ODTSqoZlLm7JGLBjbTuWB1qOYHULuEzvq3j6W7MhsAIk6SjGzObxj9EWhUWymRk1C3CfHe4z43HvcmQC2h7BILab9hJu8DnkvQhicH7Z3Him+PyQXZswBNOpKX3S5D78cubyUovyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685612; c=relaxed/simple;
	bh=RXCgi3fjy7X1m7ZufJkdeqV+iv4VinzzShIwdfuTs5k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AVbyoMWzeXVJ8zv1bVkTqgE3AKP1Zpumq3cIYtwgSM6cS842JrsrJWnLW1T9B72pcrm9Ciy2n+DeyULjmMLcrBgNDwNwlHaWcbEnjna+rN2xFxmJrqU4Yup+Miw9rr8SMgzRP7gxgk2f06of7DS3eNQWl7Wh7KDhGcdWtPYn7eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J6OyFchO; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J6OyFchO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778685611; x=1810221611;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RXCgi3fjy7X1m7ZufJkdeqV+iv4VinzzShIwdfuTs5k=;
  b=J6OyFchOH17MKTaLtVm8ZvL7UcJZltWOB6DzYGkg9wquAOX+QVoGH9RA
   Dtcg05Z9VJn8s9ixDL0NifxnJ69GNPFhWHK/pQLtt6/EsCVXv7njx1B4W
   Bxwk6AZG40QRuxKDVa5KXsCmbOZsv/HQiu5TyKchQvnzLTPaoDVPrMtx2
   GG55iC1yjJVa4BDElS8WJvyQlQoSvwll2gLztlMoBEb6PS9GWwxJ7mjb6
   PmEkHS4tN5f16EK1DolGLqs7PoLfIT34QMNynS6qjyTda5fbNqscYm51h
   gaKatldOi7wogHj9dFyVlG7pKKr3mBMlE915N/7fO5BNuWb7nRvhZXoqu
   g==;
X-CSE-ConnectionGUID: EOJSC2OITSe+SHqdXxBriw==
X-CSE-MsgGUID: 4KBhWWBvSB+c7mkyqW41Xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="83489431"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="83489431"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 08:20:10 -0700
X-CSE-ConnectionGUID: nfwATzVdTB68qPi+uTvrQw==
X-CSE-MsgGUID: fbfEojUNShGlK4XWMUQ07A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="239931428"
Received: from zp3110c001s1504.deacluster.intel.com ([10.219.161.39])
  by fmviesa004.fm.intel.com with ESMTP; 13 May 2026 08:20:09 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 0/6] crypto: qat - add sysfs PCI reset support for QAT devices
Date: Wed, 13 May 2026 17:16:53 +0200
Message-ID: <cover.1778685152.git.ahsan.atta@intel.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A PCI reset triggered through sysfs (/sys/bus/pci/devices/.../reset)
leaves QAT devices in an unusable state because the driver has never
implemented the reset_prepare() and reset_done() callbacks. The reset
proceeds without quiescing the device or restoring it afterward. This
series adds the missing sysfs reset support and fixes the deadlocks,
state-management issues, and corner cases that surface when the reset
path is actually exercised.

Note on stable backport:
Since this support was entirely absent rather than broken by a specific
commit, there is no individual Fixes tag that can be cited. We believe
this series warrants inclusion in stable to allow users to perform
standard PCI resets on QAT devices without rendering them
non-functional. We will need to revisit/retest when doing the backport
as the PCI core may have changed.

In summary:
Patch #1: Skip VF disable and enable during device restart when the VF
topology is already present. This avoids lock-order issues in PCI
reset callbacks while keeping VF quiesce notification intact.

Patch #2: Move fatal error notification earlier in the AER path. This
ensures subsystems and VFs are informed as soon as fatal error handling
begins.

Patch #3: Centralize PCI bus-master enable into a single init path.
Remove scattered pci_set_master()/pci_clear_master() calls so BME
state is deterministic across reset flows.

Patch #4: Skip the shutdown and restart flow for devices that were
already administratively down before PCI reset. PCI state is still
restored, but the device remains down as expected.

Patch #5: Factor the common AER shutdown and recovery sequences into
reset_prepare() and reset_done() helpers to simplify the reset path
and prepare it for reuse.

Patch #6: Hook reset_prepare() and reset_done() into the QAT PCI error
handler. This makes sysfs-triggered PCI reset follow the same quiesce
and recovery flow as AER reset.

Ahsan Atta (6):
  crypto: qat - keep VFs enabled during reset
  crypto: qat - notify fatal error before AER reset preparation
  crypto: qat - centralize bus master enable
  crypto: qat - skip restart for down devices
  crypto: qat - factor out AER reset helpers
  crypto: qat - handle sysfs-triggered reset callbacks

 drivers/crypto/intel/qat/qat_420xx/adf_drv.c  |   2 -
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |   2 -
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c   |   2 -
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c  |   1 -
 .../crypto/intel/qat/qat_c3xxxvf/adf_drv.c    |   1 -
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c   |   1 -
 drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c |   1 -
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 102 +++++++++++++-----
 .../intel/qat/qat_common/adf_common_drv.h     |   1 +
 .../crypto/intel/qat/qat_common/adf_init.c    |   2 +
 .../crypto/intel/qat/qat_common/adf_sriov.c   |  12 ++-
 .../crypto/intel/qat/qat_dh895xcc/adf_drv.c   |   1 -
 .../crypto/intel/qat/qat_dh895xccvf/adf_drv.c |   1 -
 13 files changed, 87 insertions(+), 42 deletions(-)


base-commit: 6a69430dcc874c47fe5a25b70d87861c1cc9c0d8
-- 
2.45.0

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

