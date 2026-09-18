Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A150A3B83FB
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 12:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789735249; cv=none; b=s8GzwbCn3inD4QAbK6qDmrEmL0kc0RNaQj9IA9SAkWK26Q2bx0LMuw0wleNhqMNIp/8d+ICI9Nkv2lgyxjSWyi8Um5vy6zB0DD7K61vPNDNxvvLgTtP5ur+B9HBC7V7LXVarokhr1FVhx+lGR8sgiZgtOboRRqsjMzX7QqyRIBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789735249; c=relaxed/simple;
	bh=YfeNS9a+NQ1L4KnstnOYZqwDRmELpoa5hFVnofRnkDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QNdxcjtRu6C4ZjsCWOoL9QBDecp8UMdl0LMaTl6gx0op1CzZKgTNDaX1k8Od94Z7psv/xRBKKt1CgEzVR5DLfcsGQSNi3uREXQ8gd4Qs+p8XI+1g7sARUmseC1QGYnXX+tqDzwd2E/NUbjQBcKRi7+mSGaM8UTaIHReIybT2y5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KjMw60Gf; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KjMw60Gf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789735248; x=1821271248;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YfeNS9a+NQ1L4KnstnOYZqwDRmELpoa5hFVnofRnkDQ=;
  b=KjMw60GfpoyekcxegstNuw5LUacw2q9TvmKLYyG6/4F2decUanmBE6KM
   shn1cQGH3QAt9UIHaEv4/ltdEJ/sof4JjHrpUHMW1ruE6up7bLaWapP4r
   xcA8suSAQ0iCNqUSFEfos5iB/OTpebKdRFFxYJgWf/u29QtFSn+6ViMw7
   jcEIfv8oZwSKW9gP3GWYIho0qDJd9K1jP4AZa3C+k9xFa+Yzg2dhQaO5U
   30DA3FhtlYDLRUj5tgzTggoBi/Qye7qn5Q21SkhT5n0nkf26VyEBf1mCs
   lyKVnMNAFseG4CKWVYh9k2tXOs7gJ//hQdHSgrxDL8wzi/MLlpSdByM87
   g==;
X-CSE-ConnectionGUID: zBtKHEBgRfm/yQBQNj/Jaw==
X-CSE-MsgGUID: yf7IaZN+RNedOnAYAsy5bA==
X-IronPort-AV: E=McAfee;i="6800,10657,11908"; a="115769163"
X-IronPort-AV: E=Sophos;i="6.27,108,1787036400"; 
   d="scan'208";a="115769163"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 05:40:47 -0700
X-CSE-ConnectionGUID: 335yAncWTX6fR39r3hv0lg==
X-CSE-MsgGUID: rnAPz4y7RW+ctNFQQRQn9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,108,1787036400"; 
   d="scan'208";a="2810409"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa013.fm.intel.com with ESMTP; 18 Sep 2026 05:40:46 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 0/2] crypto: qat - fix config table locking
Date: Fri, 18 Sep 2026 13:41:10 +0100
Message-ID: <20260918124112.537571-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The per-device configuration table is protected by cfg->lock, but not
every access to it takes that lock. adf_cfg_sec_find() walks the section
list unlocked and returns a pointer that its callers then dereference
under cfg->lock, so the section can be freed between the lookup and the
use. The dev_cfg debugfs reader walks both the section list and each
section's key-value list under a driver-global mutex that none of the
writers take, so it does not serialise against config writes, device down
or device removal, any of which can free the entry it is walking. This
series moves these accesses under the per-device cfg->lock and then drops
the redundant list walks that are no longer needed once the section is
resolved under that lock.

Note on the debugfs lock change:
The dev_cfg reader now takes a lock that lives inside the structure freed
by adf_cfg_dev_remove(). This is safe because every cleanup path calls
adf_dbgfs_exit(), which removes the dev_cfg file, before
adf_cfg_dev_remove() frees the table, and debugfs_remove() waits for
in-flight file operations to complete.

In summary:
Patch #1: Take cfg->lock around the config section lookups and switch the
dev_cfg debugfs reader to the same per-device lock. This closes the
use-after-free windows against section deletion and key updates, makes the
lookup and insert in adf_cfg_section_add() atomic so that a section can no
longer be created twice, and removes the now unused global
qat_cfg_read_lock.

Patch #2: Look up an existing key-value entry once in
adf_cfg_add_key_value_param() and act on that pointer directly. With the
section already resolved under cfg->lock, the list walks done by
adf_cfg_key_val_get() and adf_cfg_keyval_remove() are redundant, so both
those calls and the on-stack value copy are dropped. No functional change.

Ahsan Atta (2):
  crypto: qat - hold cfg->lock when accessing config sections
  crypto: qat - avoid redundant config list walks when adding a key

 drivers/crypto/intel/qat/qat_common/adf_cfg.c | 84 +++++++++----------
 1 file changed, 38 insertions(+), 46 deletions(-)


base-commit: c72ab95b5aae0f0412dc1d3284ec446ad1b315e2
-- 
2.50.1

