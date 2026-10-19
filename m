Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422878;
	b=Tsf+n352ZH5Xm0ZbaJxUKvTmmB8SXm5cfIgT5hU60P29Yu8ZYMQS2H9N9ncqTGGbKFn5
	 k6F1yfVZL57eGLuDWDaotSnBdPPYK0Tn1852JZ2Qg8n4CNvXhN3ei1G/XUrFj8oDUYtlX
	 goeqXP3QeRiQ6bhOvto1mmZu9X9WT1ZXe51SQmpTqlMBAGiu79r7U8f8TZpQlK8OmOdQA
	 hSu2vVJeLSgTFwmE6QYZiRSQE0S3VhBQaABzVC4a0R6xlRbj08iico72Z2bQvJFdn1Bue
	 X9mxhlH7tYKra/id+M1FXX9wmCX91qjUWThZ6OcYzXScjMLrVn5tRBt1xgJ2GK90THA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422878;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zcxxhcXJhcDcXdtYXJYhKWLsPyE/epxBeluTCvmeyJs=;
	b=Y5qsxw3+NnSNgqJAH/5Qab+ZzZV44Hm9KE4WOSiy3Vvb5LQK4Bed1GOEtwjC5BxJXcx2
	 fsLrzvdm9IoyZ3HtwuO9l/ReOz/EdmnkkxeFweDmoKnZibNhopGQm8d7OYaIKsPoXEnEz
	 NaBC3bVRxGg+S2EVUT0O2NwSRe80VhgZs6HpZKoXGWIiU6sbhjPmALmTIlnoLrdYMlVhY
	 GwbJJRNFrzoZAi7k2+EE6xGplisR01pPMq5g8GnxGM+CnZF/Lat7zES+SlZELv++dVlFd
	 /vKxKrcwApUTEZMmRJn1L+vDeCr037/gyNYDi6hh6LKqUP5WldIfjJOtvR0r2u78XHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FTNa7F+3;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38CF609CEDC;
	Mon, 19 Oct 2026 15:14:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F38CF609CEDC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FTNa7F+3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422877; x=1823958877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dVDIQXlh36GTlWUkVsVPgEltTI3U6SNtoUvGqwX6zp4=;
  b=FTNa7F+3Thxjs7PDfvEnV41SzX+RVq3m9TXx6Xl5deh28iNx3rrP34Cf
   4o3NHuj5+8y56dU1awobBo4Qbk3hbko/hJCgXEXr7omYt4fv/1xm33J9q
   qTIVCs//8RK6EL7SLrD6nQinadx2eAMB8bRGHwqhgWWPdsPoWuMliX03I
   eEtWgx47LXuv5OPH9Xep0L97fyvQJT6TjWwVv7Jib5Mpz4TQ7oQG7YR9H
   AM2imyzMuyXjOYtTwJLmQgQQpUQgsDiO5JJlLovkoZSFuAKo2rVJl5Npb
   Difbn569uuOdMZByKgl8nHkv78t4CblR/+alZ5jo68OPVuXlBC5hzrxvH
   w==;
X-CSE-ConnectionGUID: F9d/7HK3TgqLCy23lezjYg==
X-CSE-MsgGUID: 6VhEIeI6S2u45YX7sWft6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986915"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986915"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:34 -0700
X-CSE-ConnectionGUID: dpwFed42TMyNI1Kh/zPkSA==
X-CSE-MsgGUID: A4zHIWydTZGvmJiNotbxZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536970"
Received: from jf5300-15a101203tc.jf.intel.com (HELO meta-crater2c.jf.intel.com) ([10.54.113.49])
  by orviesa003.jf.intel.com with ESMTP; 19 Oct 2026 08:14:34 -0700
From: Daniel Byrne <daniel1.byrne@intel.com>
To: Vinod Koul <vkoul@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Frank Li <Frank.Li@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Kristen Accardi <kristen.c.accardi@intel.com>,
	dmaengine@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 08/17] dmaengine: idxd: compare the device disable status code whole
Date: Mon, 19 Oct 2026 08:06:21 -0700
Message-ID: <20261019150630.4026341-9-daniel1.byrne@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261019150630.4026341-1-daniel1.byrne@intel.com>
References: <20261019150630.4026341-1-daniel1.byrne@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

idxd_device_disable() accepts the command's status when it is success
or when `status & IDXD_CMDSTS_ERR_DIS_DEV_EN` is non-zero. The error
code is a value, not a bit mask, so that test accepts every code that
has bit 0 or bits 4-5 set, and IDXD_CMDSTS_HW_ERR (0x3), the code a
refused or timed-out command reports, is one of them. A disable that
the device refused then read as a device already disabled, after which
the device-level remove cleared the software state and freed memory
that the still-enabled device writes.

Compare the error code whole against the already-disabled code.

Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/device.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 5ebc2c1a3859..41223d2e20af 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -704,9 +704,16 @@ int idxd_device_disable(struct idxd_device *idxd)
 
 	idxd_cmd_exec(idxd, IDXD_CMD_DISABLE_DEVICE, 0, &status);
 
-	/* If the command is successful or if the device was disabled */
+	/*
+	 * The command succeeded, or the device was already disabled. The
+	 * error code is a value, not a bit mask, so compare it whole. A
+	 * refused command reports IDXD_CMDSTS_HW_ERR, which shares a bit
+	 * with the already-disabled code but leaves the device enabled,
+	 * and clearing the software state of an enabled device lets a
+	 * later teardown free memory the device still writes.
+	 */
 	if (status != IDXD_CMDSTS_SUCCESS &&
-	    !(status & IDXD_CMDSTS_ERR_DIS_DEV_EN)) {
+	    (status & IDXD_CMDSTS_ERR_MASK) != IDXD_CMDSTS_ERR_DIS_DEV_EN) {
 		dev_dbg(dev, "%s: err_code: %#x\n", __func__, status);
 		return -ENXIO;
 	}
-- 
2.43.0

