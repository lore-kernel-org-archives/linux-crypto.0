Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B042C43F8A1;
	Thu, 24 Sep 2026 07:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236743; cv=none; b=DF6YXb70Krb6PqZFi7SL+f/MNwx6MqyvtOoAjQS7X3ho/kVA2o/8WUeNgXMgd1yD4gQXJsvFIYqtfCXej3FUYilrDdgw8EnDFOXhXms9SMREQ1bnBtwXAsN0XXAIFHEKF1sKstixYDRszJdytradRF1n/OY9qaKdVjn+R88+Wg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236743; c=relaxed/simple;
	bh=fdiZHr1WzWC8owD6HFDgNp2ni3RXDVaDb840dbxOpcQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hsr3nF6XZQc7YoIZJmK1aIiLWMg0PUKIAdQ3Kg+Bac0xUbrgRl4FjQSd7vxEi7yWknNcs505c+YOSy75ilRC95VTne45m9hA5438f7jVMcMmxfTsskevs4Pv393l2E53XRknrRxF/2YGK1j2HwbLD5liWRXVy86ZWRgPqurf8yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=DyBBh3b7; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="DyBBh3b7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790236741; x=1821772741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uCiR4m3gEDIjBUSHTt1ExAl7BOUXXUa0MIVN5VZyFxQ=;
  b=DyBBh3b7sa+xQwc4TbhSHTGACw1DcLxal5zUm0hoD0rhT4zdu56NGWZF
   KMDlgqaPuHlS33JHyOAehIosITYY9QfEqw8lCRNqLZ5AqU3sa0TjZWcDx
   uYZPHd4WzhiXwHM3HUJey9CkgO/CRVQ/n/u1Kazw7KimUDy9tRJgX/5rY
   xQ8KyPAcfWMgsmV+L9sUQk2c+B1i7ZNbQsmmN2Mwx4vl+n06mRPtZqg4z
   bJ1W/aJAz3maLlnGbN+MomDQ7uOwK/9JHtwa8cq1+t9DnJldku2bzvLFO
   3hN2Hd5Y6sR7zMygeNl5GCTwU2PXD3hTFZN3OBGPalr1L2+WvgRMXTQfn
   g==;
X-CSE-ConnectionGUID: FaRZ70wiRzGLoMhx86vGSw==
X-CSE-MsgGUID: tSPBc/H8SamLpMk8Bm/wsw==
X-IronPort-AV: E=Sophos;i="6.27,120,1787011200"; 
   d="scan'208";a="29295289"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 07:58:59 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:7317]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.27:2525] with esmtp (Farcaster)
 id 6e27a216-6ae1-48a6-9653-f87c6e32dfc9; Thu, 24 Sep 2026 07:58:59 +0000 (UTC)
X-Farcaster-Flow-ID: 6e27a216-6ae1-48a6-9653-f87c6e32dfc9
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:58:58 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:58:56 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ebiggers@kernel.org>, <agk@redhat.com>, <snitzer@kernel.org>,
	<mpatocka@redhat.com>, <bmarzins@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 3/6] crypto: skcipher - add crypto_skcipher_req_seg() helper
Date: Thu, 24 Sep 2026 07:58:43 +0000
Message-ID: <20260924075846.28203-4-lravich@amazon.com>
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

Thin skcipher wrapper over crypto_tfm_req_seg() (mirroring
crypto_acomp_req_seg()), so the skcipher mid-layer can ask whether an
algorithm advertises native multi-unit (CRYPTO_ALG_REQ_SEG) support.

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 include/crypto/internal/skcipher.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index a965b6aabf61..8e9353f4252e 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -249,6 +249,11 @@ static inline bool crypto_skcipher_tested(struct crypto_skcipher *tfm)
 	return tfm_base->__crt_alg->cra_flags & CRYPTO_ALG_TESTED;
 }
 
+static inline bool crypto_skcipher_req_seg(struct crypto_skcipher *tfm)
+{
+	return crypto_tfm_req_seg(&tfm->base);
+}
+
 static inline void *skcipher_request_ctx(struct skcipher_request *req)
 {
 	return req->__ctx;
-- 
2.47.3

