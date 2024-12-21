Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AA61D7E57;
	Sat, 21 Dec 2024 22:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734818830; cv=none; b=PjaOcUMbF4fTPLE7Sd5OONKYNnoRIKYm2KCrm1wylygBx5FAxt8JVA1hsbamhdoy1/CQNLrP39xj+ZjYI/c324DOy+zf2XXvfFpw/WXui3AyAeq4YWcuxP+EPzYyB89wNm1LkmOBvn6mlGvef86H4P0mXPLm2hMbcMZv6hjSDFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734818830; c=relaxed/simple;
	bh=qBpqDxtQZmWTwsyge+1MB2GaW3j+inOdG1CYjVrmhyI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FzIuKO3Ub1EvpGAfr7KLC4MFXD1e4Cm2RmHUYUjPRFdAWmzHTL4/uEW5b3211zAKHHBUwJiMwN/TsEsk5QAL4qZcjMRQ3761UTcP15GAfqUGa1sU7if75IWDy42w9YVFwguUk6W/y3ttb9PnKxtT2wu0zKsLDjQO9xqxd2LG3FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MPYqiszB; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MPYqiszB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734818828; x=1766354828;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qBpqDxtQZmWTwsyge+1MB2GaW3j+inOdG1CYjVrmhyI=;
  b=MPYqiszBKEmg1dg03nShgyyc7vh9dDVCNymT9UOgQ1omoLnGeJDV2wmO
   cx7A8zVcXNgOCWXSFoh6QLsdtnVUMVirKB9i1w5nWS62jaapnNS70lVQE
   Fr5eKdQkjUoUop4zvJ/IVYldcfniEl/QfZ1uYp8aV7qxnk0QJa9ZbczQ0
   +P5koYaf8GhLQCge69fxmYIySqXmwwLxiPk5MFBaUzM1mfhpwgwnuRJin
   fQkzTzOMNbMPRQ89wKvbHhS7q0ed8Cvop9hi+OmmB+CrES4u3JW9xSk4R
   xR85/vFwd3s4INC8SlLcRUEq9jsyXW80lj1hG3oMtPEHJqPo9c8vva500
   A==;
X-CSE-ConnectionGUID: f+2pzi0bSPaQboyhdOuvSw==
X-CSE-MsgGUID: KSZfsmnETGe5GGN9GT/TAA==
X-IronPort-AV: E=McAfee;i="6700,10204,11293"; a="34610607"
X-IronPort-AV: E=Sophos;i="6.12,254,1728975600"; 
   d="scan'208";a="34610607"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2024 14:07:07 -0800
X-CSE-ConnectionGUID: Th2+ROGySKSpWL+iLdgN4Q==
X-CSE-MsgGUID: KSMy3ubyRI6+LFwilYiqXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="98683889"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa010.jf.intel.com with ESMTP; 21 Dec 2024 14:07:07 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v1] crypto: iaa - Fix IAA disabling that occurs when sync_mode is set to 'async'.
Date: Sat, 21 Dec 2024 14:07:07 -0800
Message-Id: <20241221220707.7050-1-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the latest mm-unstable, setting the iaa_crypto sync_mode to 'async'
causes crypto testmgr.c test_acomp() failure and dmesg call traces, and
zswap being unable to use 'deflate-iaa' as a compressor:

echo async > /sys/bus/dsa/drivers/crypto/sync_mode

[  255.271030] zswap: compressor deflate-iaa not available
[  369.960673] INFO: task cryptomgr_test:4889 blocked for more than 122 seconds.
[  369.970127]       Not tainted 6.13.0-rc1-mm-unstable-12-16-2024+ #324
[  369.977411] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  369.986246] task:cryptomgr_test  state:D stack:0     pid:4889  tgid:4889  ppid:2      flags:0x00004000
[  369.986253] Call Trace:
[  369.986256]  <TASK>
[  369.986260]  __schedule+0x45c/0xfa0
[  369.986273]  schedule+0x2e/0xb0
[  369.986277]  schedule_timeout+0xe7/0x100
[  369.986284]  ? __prepare_to_swait+0x4e/0x70
[  369.986290]  wait_for_completion+0x8d/0x120
[  369.986293]  test_acomp+0x284/0x670
[  369.986305]  ? __pfx_cryptomgr_test+0x10/0x10
[  369.986312]  alg_test_comp+0x263/0x440
[  369.986315]  ? sched_balance_newidle+0x259/0x430
[  369.986320]  ? __pfx_cryptomgr_test+0x10/0x10
[  369.986323]  alg_test.part.27+0x103/0x410
[  369.986326]  ? __schedule+0x464/0xfa0
[  369.986330]  ? __pfx_cryptomgr_test+0x10/0x10
[  369.986333]  cryptomgr_test+0x20/0x40
[  369.986336]  kthread+0xda/0x110
[  369.986344]  ? __pfx_kthread+0x10/0x10
[  369.986346]  ret_from_fork+0x2d/0x40
[  369.986355]  ? __pfx_kthread+0x10/0x10
[  369.986358]  ret_from_fork_asm+0x1a/0x30
[  369.986365]  </TASK>

This happens because the only async polling without interrupts that
iaa_crypto currently implements is with the 'sync' mode. With 'async',
iaa_crypto calls to compress/decompress submit the descriptor and return
-EINPROGRESS, without any mechanism in the driver to poll for
completions. Hence callers such as test_acomp() in crypto/testmgr.c or
zswap, that wrap the calls to crypto_acomp_compress() and
crypto_acomp_decompress() in synchronous wrappers, will block
indefinitely. Even before zswap can notice this problem, the crypto
testmgr.c's test_acomp() will fail and prevent registration of
"deflate-iaa" as a valid crypto acomp algorithm, thereby disallowing the
use of "deflate-iaa" as a zswap compress (zswap will fall-back to the
default compressor in this case).

To fix this issue, this patch modifies the iaa_crypto sync_mode set
function to treat 'async' equivalent to 'sync', so that the correct and
only supported driver async polling without interrupts implementation is
enabled, and zswap can use 'deflate-iaa' as the compressor.

Hence, with this patch, this is what will happen:

echo async > /sys/bus/dsa/drivers/crypto/sync_mode
cat /sys/bus/dsa/drivers/crypto/sync_mode
sync

There are no crypto/testmgr.c test_acomp() errors, no call traces and zswap
can use 'deflate-iaa' without any errors. The iaa_crypto documentation has
also been updated to mention this caveat with 'async' and what to expect
with this fix.

True iaa_crypto async polling without interrupts is enabled in patch
"crypto: iaa - Implement batch_compress(), batch_decompress() API in
iaa_crypto." [1] which is under review as part of the "zswap IAA compress
batching" patch-series [2]. Until this is merged, we would appreciate it if
this current patch can be considered for a hotfix.

[1]: https://patchwork.kernel.org/project/linux-mm/patch/20241221063119.29140-5-kanchana.p.sridhar@intel.com/
[2]: https://patchwork.kernel.org/project/linux-mm/list/?series=920084

Fixes: 09646c98d ("crypto: iaa - Add irq support for the crypto async interface")
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst | 9 ++++++++-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         | 2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
index bba40158dd5c..8e50b900d51c 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -272,7 +272,7 @@ The available attributes are:
       echo async_irq > /sys/bus/dsa/drivers/crypto/sync_mode
 
     Async mode without interrupts (caller must poll) can be enabled by
-    writing 'async' to it::
+    writing 'async' to it (please see Caveat)::
 
       echo async > /sys/bus/dsa/drivers/crypto/sync_mode
 
@@ -283,6 +283,13 @@ The available attributes are:
 
     The default mode is 'sync'.
 
+    Caveat: since the only mechanism that iaa_crypto currently implements
+    for async polling without interrupts is via the 'sync' mode as
+    described earlier, writing 'async' to
+    '/sys/bus/dsa/drivers/crypto/sync_mode' will internally enable the
+    'sync' mode. This is to ensure correct iaa_crypto behavior until true
+    async polling without interrupts is enabled in iaa_crypto.
+
 .. _iaa_default_config:
 
 IAA Default Configuration
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 9e557649e5d0..c3776b0de51d 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -173,7 +173,7 @@ static int set_iaa_sync_mode(const char *name)
 		async_mode = false;
 		use_irq = false;
 	} else if (sysfs_streq(name, "async")) {
-		async_mode = true;
+		async_mode = false;
 		use_irq = false;
 	} else if (sysfs_streq(name, "async_irq")) {
 		async_mode = true;

base-commit: 13d127a82b5c70061560c65fb083e30e79363874
-- 
2.27.0

