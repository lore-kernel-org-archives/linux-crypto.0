Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73525760B8;
	Mon, 18 Dec 2023 20:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q0b0Jcxh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702932445; x=1734468445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H3CG4H1LUs2Woscc050DD/D/Uqec+fLNo2IJXSopJ5k=;
  b=Q0b0Jcxh9qdIk2DdiP1G/KKjs1rBKHgwDhPCfEIdN7B/aXRWXXvyg8yW
   k04XRVIMq5t8iB1jr+lYjqsYwEHPf2rfFzJ4MblnGpvHqZz7EWnLrjLPo
   zeftC2TFEXHRwpHhuh6/UQ4PBvylXWozsY133IEgYAaC77SqF7AHBLOrV
   ufURkTm2h3sNe1PPqlWjAKDNpfMvbkbk+y52zYLo70SCMb3JTUpyPxqcr
   OcyJUGJrWARz4SUtPt+jJPdwHr57yLPZ0AlhYXgud3pHYCLiFIpgCOjQs
   fSbFyFSu899nXThrfr7UPtO7TNpINDI6NpIORhx8IvBKafJDi4zflYouT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="462015894"
X-IronPort-AV: E=Sophos;i="6.04,286,1695711600"; 
   d="scan'208";a="462015894"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 12:47:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="899101534"
X-IronPort-AV: E=Sophos;i="6.04,286,1695711600"; 
   d="scan'208";a="899101534"
Received: from ssomasun-mobl1.amr.corp.intel.com (HELO tzanussi-mobl1.hsd1.il.comcast.net) ([10.212.116.107])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 12:47:24 -0800
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	fenghua.yu@intel.com
Cc: dave.jiang@intel.com,
	tony.luck@intel.com,
	jacob.jun.pan@intel.com,
	christophe.jaillet@wanadoo.fr,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org
Subject: [PATCH 2/2] crypto: iaa - Remove unneeded newline in update_max_adecomp_delay_ns()
Date: Mon, 18 Dec 2023 14:47:15 -0600
Message-Id: <20231218204715.220299-3-tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231218204715.220299-1-tom.zanussi@linux.intel.com>
References: <20231218204715.220299-1-tom.zanussi@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove a stray newline in update_max_adecomp_delay_ns().

Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_stats.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_stats.c b/drivers/crypto/intel/iaa/iaa_crypto_stats.c
index 0279edc6194e..2e3b7b73af20 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_stats.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_stats.c
@@ -109,7 +109,6 @@ void update_max_adecomp_delay_ns(u64 start_time_ns)
 	time_diff = ktime_get_ns() - start_time_ns;
 
 	if (time_diff > max_adecomp_delay_ns)
-
 		max_adecomp_delay_ns = time_diff;
 }
 
-- 
2.34.1

