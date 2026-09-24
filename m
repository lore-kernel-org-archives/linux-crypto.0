Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC66A43F4A9;
	Thu, 24 Sep 2026 07:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236742; cv=none; b=tNw5aqUn1fdJk/EDQRkBf3Mrt1rIL4pJ20dMCw1KpcR9XMAqOm3EkHWfN+GqJL5QgSP+gxQhtJUKaj2NBkerR2hRCkUwpIoMW2LvcW6n2iE4uOgiqpAC3iEMBuwUzKWosC41VxR1C4u2VCOIxJyXoJyO/zd3GTJGbPupwMamLqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236742; c=relaxed/simple;
	bh=dLU021jZO83OkhPh3al7j7elX0OHMX6tDi+7AO+04XM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YtZAq+uYBHdflbeSB2hU8HtnvXLBGP4+PmFir4zj5hTQfGxqHHXq2XBd0uWBfbeDm8v9iHq71cCbTfCnIzH15F0gjRRdZ6zO2vBTWdJXvQFw2wBB8n4nk7IH6ZEBVzC7JWJFAe7Hw3pm/UQOhWtQeAv9tfgEnVxzwwGyEzphkQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=BdgXubRK; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="BdgXubRK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790236740; x=1821772740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OvOvPDn/0aC+MRRS9yXhpVAo5rrw/Rz0Ky+brwv+uMw=;
  b=BdgXubRKAVMJdcbPjWrgpm+fJ3CV6uvLFfeC1kgA16TYpxkrMWtsf6RW
   zyr+wIJG0SZqdSn96p8AJB1XZkFJQFjHvuOa7NvYI6IjtCDW3Q1pvajFD
   PBwkHw7POyUzdtQ0YE7GE2BOMGR+9kb/odUBPfQKP1YW28kjUMW1naGzT
   Wk73hSxOn8yVLF0TfZtZg2c/8ZpHqCRjS0+z+DcBIoiS/lkh75tBg7YVw
   1vxO5em26WP7I1cIkxw/WlQ6IXDs7Xy4RdtNxTC/x0BVb88esBMk+WNNG
   njFiUpJuGybzhREDLJQRkH/1aC/kqRZTlbO+IH43I1yGBU6tChKAkNeJf
   Q==;
X-CSE-ConnectionGUID: asVA47ilRCW10AvV4nfqXQ==
X-CSE-MsgGUID: XmBqy+pwQCq82ExdEvBs2Q==
X-IronPort-AV: E=Sophos;i="6.27,120,1787011200"; 
   d="scan'208";a="29302663"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 07:58:57 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:23556]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.237:2525] with esmtp (Farcaster)
 id a42c9bb3-f593-4707-8eff-48313dc89cf5; Thu, 24 Sep 2026 07:58:57 +0000 (UTC)
X-Farcaster-Flow-ID: a42c9bb3-f593-4707-8eff-48313dc89cf5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:58:56 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:58:55 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ebiggers@kernel.org>, <agk@redhat.com>, <snitzer@kernel.org>,
	<mpatocka@redhat.com>, <bmarzins@redhat.com>, <linux-kernel@vger.kernel.org>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: [PATCH v6 2/6] crypto: acomp - Add bit to indicate segmentation support
Date: Thu, 24 Sep 2026 07:58:42 +0000
Message-ID: <20260924075846.28203-3-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260924075846.28203-1-lravich@amazon.com>
References: <20260924075846.28203-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D040UWB002.ant.amazon.com (10.13.138.89) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

This patch adds segmentation support for compression.

Add a bit to the crypto_alg flags to indicate support for segmentation.
Also add a helper for acomp to test whether a given tfm supports
segmentation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
(cherry picked from commit 9c16129795e20b055d5fa8ea7e3fdd35cf6a9a1a)
Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 include/crypto/algapi.h             | 5 +++++
 include/crypto/internal/acompress.h | 5 +++++
 include/linux/crypto.h              | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 05deea9dac5e..7d406cfe5751 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -280,6 +280,11 @@ static inline bool crypto_tfm_req_virt(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_VIRT;
 }
 
+static inline bool crypto_tfm_req_seg(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_SEG;
+}
+
 static inline u32 crypto_request_flags(struct crypto_async_request *req)
 {
 	return req->flags & ~CRYPTO_TFM_REQ_ON_STACK;
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 9cd37df32dc4..93ae59623f13 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -189,6 +189,11 @@ static inline bool crypto_acomp_req_virt(struct crypto_acomp *tfm)
 	return crypto_tfm_req_virt(&tfm->base);
 }
 
+static inline bool crypto_acomp_req_seg(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_req_seg(&tfm->base);
+}
+
 void crypto_acomp_free_streams(struct crypto_acomp_streams *s);
 int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index a2137e19be7d..89b9c3f87f4d 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -139,6 +139,9 @@
 /* Set if the algorithm cannot have a fallback (e.g., phmac). */
 #define CRYPTO_ALG_NO_FALLBACK		0x00080000
 
+/* Set if the algorithm supports segmentation. */
+#define CRYPTO_ALG_REQ_SEG		0x00100000
+
 /* The high bits 0xff000000 are reserved for type-specific flags. */
 
 /*
-- 
2.47.3

