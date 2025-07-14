Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B261F3BA2
	for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 07:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752477101; cv=none; b=J5rz5s7m9Oiy3LZPKNIWEa3RNx5lL5wU6fOLhFsOguKE4YnrPMrjOrADBlkMioekY+pwSJjgdunE4w4RuP/fwiqXVlSNYJJwiQQV/2ScpzNNtUqEvYQdDf25ydaP4tRnKO6HBsRajrsTIzRGyd3UXEo9rt0x1VUomHzAPZY60Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752477101; c=relaxed/simple;
	bh=bdVBeDkjvwimITdOFBsefSDUDAwF+T3TG1BrN6YNnCk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hxu/OX82ruPl38i42myofsrqz3SnFZTbl3hQCRJK0d6k5QBg5LVhhhMDploHdpmmUqwUevcnyOSPtUFm9IhHDtWLcZQeOplyuz7ry3pdUfOKEKL/QmGpWtezvu8x0amBO7PHNGMimUV5Z9kFOZFT3F/xtXD1B3x4JHZ5sONFv+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k4P92q8D; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k4P92q8D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752477100; x=1784013100;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bdVBeDkjvwimITdOFBsefSDUDAwF+T3TG1BrN6YNnCk=;
  b=k4P92q8Dy15tovpwGBy75DFyB8JiC5ClFuIDLYkbxD59oh2QpJ99G6+8
   eiJ1Q0BlMCMJIM+hnW1q3istLFhEG6B7822PxgDTj+xuizTkxa4NEihfe
   H5eq+9JFj5fHKhwgEdJtWH2It1AhOAs1JWy2wubsYmzlDTgVHrySAoIEO
   vDPUUL/FV1MS9GhRm6epI4TsydnQyYcez9TRWWSvpxPorkAcvLF/jseAK
   aGaeKNUEcXkZg+IhzQEVIP9ZsyzNe5oR9UJ1UdASpc0K9eTPSG+DpkQgz
   JLZ4R4350fw8WcMjUvjrzYSZPMKc4ho2wzVasvqZ2cO5bWizP+Y2GUDoA
   A==;
X-CSE-ConnectionGUID: HtFRheuNR7mYNT44SZPv+w==
X-CSE-MsgGUID: cK6E98R2Qw6rfCr+u/xsPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54519374"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="54519374"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 00:11:40 -0700
X-CSE-ConnectionGUID: +er4iB1jS8mfeN0ATqahPA==
X-CSE-MsgGUID: De82z8dEQnSIoh4gHCDptQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="187862425"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by orviesa002.jf.intel.com with ESMTP; 14 Jul 2025 00:11:39 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/2] crypto: qat - fix and improve ring related debugfs functions
Date: Mon, 14 Jul 2025 08:10:28 +0100
Message-ID: <20250714071135.6037-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

This small patchset addresses a bug in the seq_file implementation for
ring-related debugfs functions in the QAT driver and introduces a simple
refactor.

Giovanni Cabiddu (2):
  crypto: qat - fix seq_file position update in adf_ring_next()
  crypto: qat - refactor ring-related debug functions

 .../qat/qat_common/adf_transport_debug.c      | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)


base-commit: 60a2ff0c7e1bc0615558a4f4c65f031bcd00200d
-- 
2.50.0

