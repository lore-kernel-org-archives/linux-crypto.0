Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793370628;
	b=e2QAYd3tBs6GAxwOj8vsL9stOfITz02M2S/k+U94P/pGl0BMccXhA5gqUjQ3XabpAfv8
	 lrVCcArVSbzgaQKyI6G96Z3OKbCD/VltGPyG4z8lX09OOoVkK1tQxtpAVFJLh3/m0U3/5
	 fE4uUFSJt8XbMji104MgDDoEf3p+0Yh6YrT3AO6CqVZ9C2/jF3yIE0RETUHCd0H5zD4EH
	 0FGhzNNO607+C+LHCIxZWEJx9rKyr+WecFjaonItSQhtvl37DGGNZih+MUBi5nO/ZeYGc
	 Rs5ctfenjPISc/X5IBXa0lBbxeXa/6izfqaJJqZBilh2xAV6JypZf7b5rt8ds90BYRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793370628;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Organization:Content-Transfer-Encoding;
	bh=qHVaCrbZVV/aL8obwXxHOaq/3zcOfPB+i++209LsGG8=;
	b=KC8vKnMQ202OVtKMnY4Vy6It5DrNMguzAfbJH0pBqa9xheMW2cBmyjvizL7EYSSgAQIH
	 U5kFIKE3hRSOJcnjhgX3lYrtNAWEc9z2X2ZVTqfsb545lUSRU/ya5iVWHtsK1GI1VI0Lh
	 hm/r7QqgYC3LTBjA2AHFFtwNlTFF1MxtHk8xrR8RJIHJcdWo8MTTGSVytCy3sa8E5lyfj
	 Vo7kGc+a3tIUzrhnR35s8UoEbjbZcuEoyfbGbJZrCnIuUAHGciN95gUyks4nAYqTpIp80
	 OS//YH1PBcSi3Zg7LrSbIWv1d/e8diYZDuUkCXNEKcmXMHMKBZOhLkvSuKj5Bpmr1xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iAYZ92oZ;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F68606A323
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 14:30:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84F68606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iAYZ92oZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793370627; x=1824906627;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hgamFFdtwFhF7P0xfkrYYUXesUQtJNAznKhQkw8jUU4=;
  b=iAYZ92oZYmNwU1EnqxlyLMA9CbhBUAg2F9ikPAzfKLpzeRte5zVWactz
   kbBs4maaaxIm/yAfh+v5TTGurjNFRDSPKm8ozoIzd9ibEwojR4QsRoww+
   W6eQ8rMdQFD+b9e2xWqHeyzQh6vgjrwjcaLxxMdVtzClIiUYSSQg8dGjJ
   LsmJeF2Owi8vrXzS4hz9BPIiboMoCtpGv/7tIvrUUzpbB3SPARba8JPo6
   B0zL8+0bDFlrtLKh3nrKVOgwa/bTypl13f1lPxYz0YPx5CzT8eVLcygXW
   AfyWW/V+MRFzwduq1NUedMMdwXVedD3e8b12tDp/21d7bJ6YhAN5Q0mnp
   w==;
X-CSE-ConnectionGUID: O5619iJpSAW+z4eW4mHTHQ==
X-CSE-MsgGUID: FCv4q0wkTA2/cB/yu0NykA==
X-IronPort-AV: E=McAfee;i="6800,10657,11951"; a="2167051"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2167051"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 07:30:27 -0700
X-CSE-ConnectionGUID: 5zXA0MXlTkWULwqZvTEl9g==
X-CSE-MsgGUID: f2KCP7NvQj+DYGrURyT/Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5417533"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa001.jf.intel.com with ESMTP; 30 Oct 2026 07:30:26 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 2/2] Documentation: qat: document three-service mode for QAT GEN5 devices
Date: Fri, 30 Oct 2026 14:30:19 +0000
Message-ID: <20261030143019.484280-3-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261030143019.484280-1-ahsan.atta@intel.com>
References: <20261030143019.484280-1-ahsan.atta@intel.com>
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

From: Bairavi Alagappan <bairavix.alagappan@intel.com>

Update the cfg_services sysfs attribute documentation to describe
support for concurrent symmetric crypto, asymmetric crypto, and
compression services on QAT GEN5 devices.

Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
index b0561b9fc4eb..48e17de3e0fd 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat
+++ b/Documentation/ABI/testing/sysfs-driver-qat
@@ -41,8 +41,8 @@ Description:	(RW) Reports the current configuration of the QAT device.
 
 		Service combinations are permitted for all services except dcc.
 		On QAT GEN4 devices (qat_4xxx driver) a maximum of two services can be
-		combined and on QAT GEN6 devices (qat_6xxx driver ) a maximum of three
-		services can be combined.
+		combined. On QAT GEN5 devices (qat_420xx driver) and GEN6 devices
+		(qat_6xxx driver) a maximum of three services can be combined.
 		The order of services is not significant. For instance, sym;asym is
 		functionally equivalent to asym;sym.
 
-- 
2.50.1

