Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4666D25EF97
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 13:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752154445; cv=none; b=s1lGV+E/Z7YOf4kveBEoLyFjo1KGyYMdlnCG6hi69Ap5YFcTFsTedYkCDgXX2RIvLg7+++ZjUrhnKWU5dc02zLzttr6FZnKC2wFI6qot8rSxS4jiAAr04JHsiYAe6uNRJ0+bnZskyTV/ax5VfK9oFJtWVRCdk/BHwhP0wtNz8fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752154445; c=relaxed/simple;
	bh=ZnGuNIPNb+Et8mehJ7ITXWTQ/FLSRU/Weh4m5YQ9fpQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NH783rst1pS+MBRQ6ygyHGW7f7MwskGVQo2yManDtOStYq4bslVmSjx6sxTvwIp42+9dmxesiJPtNke75Api2SbHYWlqb002COnFAD5xzZJinzdqqFM92L9Bry6IUBdKV4tsQIzCYjEAdRI5eU0OVVattUHQz/i2GI0fGvQ7u4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SqXHIya/; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SqXHIya/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752154444; x=1783690444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZnGuNIPNb+Et8mehJ7ITXWTQ/FLSRU/Weh4m5YQ9fpQ=;
  b=SqXHIya/UOFz/r3eldEajKAzUKp0pASdeQvVmkEHRh7+bK482ant+fwe
   czgf0AWi2DtYbV5ov3GvEqgQZzmx7m43lobJ8DFKQh0vayH1dvL9DoSiL
   kGJqgE3AJwGuJxcvKrzukZFkMJoJqTjKwy7zaxt2JZbST0OD/3aGOg/pN
   jw7psU+VeuUqHD8WMYMzhc/wOdpFY2pjSNquSsv1czdH2qD0+D3OnkkHn
   3nKxC12fCRjwNIYnRdpL6S4Qe+pjy9UpB0vKdSIiYtg/5W7PvNzmDxMlX
   Y0H1md8sUn5sWwkekNLBeRauB8QioIV65iXQuZhI6b7m018sf2dabdXtC
   g==;
X-CSE-ConnectionGUID: YyLu7ue3TUKKZiJs3bSYjw==
X-CSE-MsgGUID: 2IdrDEFOR+2qFUyyzzOtOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="58241849"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="58241849"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 06:34:04 -0700
X-CSE-ConnectionGUID: lncoDEWkSmaWj2Y3EoJk6Q==
X-CSE-MsgGUID: rdMTqgFvSCSwxcvpYKcmkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="155494664"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa006.jf.intel.com with ESMTP; 10 Jul 2025 06:34:03 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 7/8] crypto: qat - add compression slice count for rate limiting
Date: Thu, 10 Jul 2025 14:33:46 +0100
Message-Id: <20250710133347.566310-8-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250710133347.566310-1-suman.kumar.chakraborty@intel.com>
References: <20250710133347.566310-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In QAT GEN4 devices, the compression slice count was tracked using the
dcpr_cnt field.

Introduce a new cpr_cnt field in the rate limiting (RL) infrastructure to
track the compression (CPR) slice count independently. The cpr_cnt value is
populated via the RL_INIT admin message.

The existing dcpr_cnt field will now be used exclusively to cache the
decompression slice count, ensuring a clear separation between compression
and decompression tracking.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.h       | 1 +
 drivers/crypto/intel/qat/qat_common/adf_rl_admin.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.h b/drivers/crypto/intel/qat/qat_common/adf_rl.h
index 59f885916157..c1f3f9a51195 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.h
@@ -68,6 +68,7 @@ struct rl_slice_cnt {
 	u8 dcpr_cnt;
 	u8 pke_cnt;
 	u8 cph_cnt;
+	u8 cpr_cnt;
 };
 
 struct adf_rl_interface_data {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl_admin.c b/drivers/crypto/intel/qat/qat_common/adf_rl_admin.c
index 698a14f4ce66..4a3e0591fdba 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl_admin.c
@@ -63,6 +63,7 @@ int adf_rl_send_admin_init_msg(struct adf_accel_dev *accel_dev,
 	slices_int->pke_cnt = slices_resp.pke_cnt;
 	/* For symmetric crypto, slice tokens are relative to the UCS slice */
 	slices_int->cph_cnt = slices_resp.ucs_cnt;
+	slices_int->cpr_cnt = slices_resp.cpr_cnt;
 
 	return 0;
 }
-- 
2.40.1

