Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792766919;
	b=46+1okodfCffydnj88kPDouoezzQnfO4PfrY5nccbZsbXlFWcdzlg/1b6aoR3q5QfVrO
	 hL5hRp6GWWWaEj3b5Dq8JDXgSR3PSgOcqP+ulmAsKr+Am5GH//Q7QbSzBjOwLaEadmB4r
	 8RSrRUbwyjxIPKyw3G+rCiWR4iQbzPh/zRbmFU3N/QK2J8W2rJAYM6TLylwnsTShefuKj
	 2XMl4cFqckTfoqddjetnmW6TtYqPmvJ/o0P0qsdDjZGoSamhWvc2DnzN1WCo99rlvwGtR
	 dsuXuR+nbRuzwjcfdyTg7g7UUPD6b9nEPGhRkVq+IaxGCX32XaxJwuRtTf9UhiPCYjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792766919;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Organization:
	 Content-Transfer-Encoding;
	bh=bMeySpEPb22l4d5VGO7QmbYpr5kSv1kxpgmKPnqQcI0=;
	b=ij6IWx1Zt4vKwdP3LCyEOkvXUdVD8ftZNo/2KMowexZD36+lmw5jjQ/8lXkIczahXBg/
	 bS5tUsPOFI8OerWR3Y/pVUSA+DmjQ9oMyFZOKDtrSxTQUwoC2K5OdiyqJGxAhPp4QKsPp
	 dgAtC88WQYqEyIPjTwBtspOeunYldGIJ6NG7zqJ4/826u/q0kggwP9l14bgVCjxnq/kfe
	 3ITY13GoFPcrwKZ1hB0IMy7KHx0m9TP5IaQ3cBrTG3wXYCHDufYATRrBnMy5exUGbJq+T
	 sNTTONhr9rnii4bGYHAGgpDrG3H12Oc88vZAyU6ZPumrhwY6yDxyBBP6Sfua3gPK3wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EKr3u3q+;
	arc=none smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FABE606A31D
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 14:48:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FABE606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EKr3u3q+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792766918; x=1824302918;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9wJwIUZ4C97ka/aFr0xCn3mCKp3dCwDTqRHk8hQWqco=;
  b=EKr3u3q+OMbvT8QBHwbs5T6qVMv3gumw5QzsohMbL6xip7MnxxDnZPva
   +JCnIEYtlILFna1cqZKnmv4rAFNZ4NGM1jekyhuXIxmNXgfeD0kdRuiz6
   FvCPLPx35yLVB8+AlfH9qI2aJTeSv5mEPYhfOtT+eh8G3UrlEeYW5wuNa
   DSVa0znGER4C9EaeMeAb4w5vd7GeNtIkxZ4OlCtj8zeiMUFb4dIMXz8N9
   53MPCAYToIzuab4/PPzNEJ1Z0u7g4Ex6hQwZ2jrDwa7J690QjZZfhLy7V
   M6/1555Kq9G86c6xCMwQtPiZrm/EHx3FFRxY5JSNjNAFurUYPB33VCR6O
   w==;
X-CSE-ConnectionGUID: pvrlDuiJRnGZBQl085Zhow==
X-CSE-MsgGUID: ioWeltkqRQmvrfvlFW1B/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1534161"
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="1534161"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 07:48:38 -0700
X-CSE-ConnectionGUID: woF8Wv1KRM2CN99AagXOKQ==
X-CSE-MsgGUID: IrpzZElJSK++caLkxFyrnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="3598338"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa005.jf.intel.com with ESMTP; 23 Oct 2026 07:48:37 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH RESEND 0/2] crypto: qat - enable three-service mode for QAT GEN5
Date: Fri, 23 Oct 2026 15:48:33 +0100
Message-ID: <20261023144835.170453-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Resending and we can ignore the feedback from Sashiko review because we
do not have QAT GEN5 SKUs that have some of the AEs fused off.

QAT GEN5 devices (qat_420xx) have enough accelerator engines to run
three services concurrently, but the driver currently only allows a
maximum of two to be configured at a time, matching the GEN4 limit.

This series lifts that restriction so that symmetric crypto, asymmetric
crypto and compression can be enabled together on GEN5, as is already
possible on GEN6 (qat_6xxx).

In summary:
Patch #1: Define the firmware object layout, ring-to-service mapping,
thread-to-arbiter mapping and service-to-accelerator-engine accounting
required for the sym;asym;dc configuration on GEN5, and register the
new service combination in adf_cfg_services so that it can be selected
through the cfg_services sysfs attribute.

Patch #2: Update the cfg_services ABI documentation to state that GEN5
devices (qat_420xx) support a maximum of three combined services,
alongside the existing GEN6 entry. Documentation only, no functional
change.

Bairavi Alagappan (2):
  crypto: qat - enable three-service mode for QAT GEN5 devices
  Documentation: qat: document three-service mode for QAT GEN5 devices

 Documentation/ABI/testing/sysfs-driver-qat    |   4 +-
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 104 +++++++++++++++++-
 .../intel/qat/qat_420xx/adf_420xx_hw_data.h   |   6 +
 .../intel/qat/qat_common/adf_cfg_services.c   |   3 +
 .../intel/qat/qat_common/adf_cfg_services.h   |   1 +
 5 files changed, 113 insertions(+), 5 deletions(-)


base-commit: 9c5d66e1ea78912b8a43ce16a1c14db1357e0ae0
-- 
2.50.1

