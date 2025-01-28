Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9D65672;
	Tue, 28 Jan 2025 23:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738108676; cv=none; b=anAJuhrEWPAvWcbziQslnLCOzjppUfbfjPgS+5oricHWgCIYZllVlqfOAjUEdtb06OfyHfx9NNV3FEgRnvIs4uLVXoTU/vAPifQrMtPCZOxxunvBtF2k8fMklLohsbM1t97CwfEwRJyztawiFPbf6Qz+IwnUZEUww+mpHobLbqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738108676; c=relaxed/simple;
	bh=OKEgbhkRVn9ZHOykHhQBJ8okG75os49PVvyj7W589Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ewWWujjiKsatHRJ1v6ZFDH3g34Ayp9nvc4dBRX/590zwTln11pjyY9CR/TpuGMnC1BGxa0m36kcXGw7gm6wCcBBHadDXv8W+PHsg1i7CevklLt0pmMJbKh/nzp1JFc+LIEA61LbQ3eZWDYSI0CQZJxcz5sh1fmnAu8rGQkw5/f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LY2iE47i; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LY2iE47i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738108674; x=1769644674;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OKEgbhkRVn9ZHOykHhQBJ8okG75os49PVvyj7W589Ms=;
  b=LY2iE47ijN1KhvblG5phfgCERWTwpgl/aVdRYvSaIc+4j+4n9z6UIvm5
   iPNNCUAWvVVZsBBf5VE2wQWo6sYuObGgKmkB1ZkpYzIw0pwxAMzuKFDJ9
   zTPd3uN1hb/MNjittkaOlqS+1i9Vuhp9jhaE079KzVe6lhnXh67YO4F21
   3cGMiwBmVWMcxXyr5JmEeB2YLGuBb/54hb735AX8Q4tCz7DD4DrTj00KR
   ne7mmlENIPManAYh2/75rSoDXSaQbTt640N2xymRAzsGLjQQjOr5aIcmE
   PmGtSZYqBrBjgWV7JWlvSc+LgtkPTOY0nPm/fDggNWI6aE/cUVnEzZNrg
   w==;
X-CSE-ConnectionGUID: Hpi+zfhUR+2j/o9S3c4KOA==
X-CSE-MsgGUID: C0sO5rPKRPmHp/2jKts3EQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11329"; a="38519666"
X-IronPort-AV: E=Sophos;i="6.13,242,1732608000"; 
   d="scan'208";a="38519666"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2025 15:57:52 -0800
X-CSE-ConnectionGUID: 0I8aW8OtSnamjXmG2661og==
X-CSE-MsgGUID: Ej4ZoAsXSHSxEjhg7wbmmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="109799711"
Received: from kcaccard-desk.amr.corp.intel.com (HELO kcaccard-desk.intel.com) ([10.125.108.68])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2025 15:57:52 -0800
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: vinicius.gomes@intel.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Add Vinicius Gomes to MAINTAINERS for IAA Crypto
Date: Tue, 28 Jan 2025 15:57:43 -0800
Message-ID: <20250128235744.1369399-1-kristen@linux.intel.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Vinicius Gomes to the MAINTAINERS list for the IAA Crypto driver.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 936e80f2c9ce..5cd2560e044d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11655,6 +11655,7 @@ F:	drivers/dma/ioat*
 
 INTEL IAA CRYPTO DRIVER
 M:	Kristen Accardi <kristen.c.accardi@intel.com>
+M:	Vinicius Costa Gomes <vinicius.gomes@intel.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	Documentation/driver-api/crypto/iaa/iaa-crypto.rst
-- 
2.47.1

