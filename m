Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2E23CEBBD
	for <linux-crypto@vger.kernel.org>; Fri,  5 Jun 2026 23:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780701097; cv=none; b=R/9D3fILNtZEFuvAxc+NnjWjIv4ZTOnGD3XCqP6y5JZvma4KD4Y+k2GVVGwy2i4oMi5YGRZ5b7uWRMiXyKBorzkRA9npfNml9+ILHzXKw5bX43xl6KJsyUc/sON+co23RYd6No7jn7u3YwnWApnHax7LiiYzuu80PucuAFqWe/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780701097; c=relaxed/simple;
	bh=+4chx+89sCzn8YVK4C6WsZ0njPgb2TVXUzrloe3rllE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D/GxRloB3xOwV+RH0HPsFJWeoQuuZAhksv14Vt76J8RBBvzlbcEUJ3xbMiZfQcZ9QtpdOiP/5+YcPVIpBRc1tM06HVnBiLqTOBcAzreK7X+gPbPVphUneu5ohbStPEW8byv6mNM4KVM8GfwN5aHjOzfl5/68sNnlelJe3dhFAxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CxI6pKDN; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CxI6pKDN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780701092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xWb98quGkvQRlToghauQ2vsO7iXHqiRepXbqdpzYiJ8=;
	b=CxI6pKDN4vB4ZOd7oASJ2+THtpscFtqLevT3sZkrNsJK8UXoP94bA8+IlO5znpBuiFYGYR
	nP0XhsCcqDZ7TFDX0f4HReS+120kkk4X7+GCCiQsqLi76ZlNqBDLJa3gKY2iSeS4qzi/mU
	Z7biIHz+sHCbt5w+YFngMAJBccCiOF0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qat-linux@intel.com,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH v2 0/6] crypto: use 2-arg strscpy where destination size is known
Date: Sat,  6 Jun 2026 01:10:57 +0200
Message-ID: <20260605231056.1622060-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1943; i=thorsten.blum@linux.dev; h=from:subject; bh=+4chx+89sCzn8YVK4C6WsZ0njPgb2TVXUzrloe3rllE=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnK4Q3GW760fUw8z8obOXe24FYrj6xJe2KPrV+6N/Cfg rVeic/LjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZiIxgeG/yVbZp1LuP05Yr+q /tT1lnl7H/HOuK4jcJ9t9RuHr5OF2VgY/lnfvXjVZNU+Rf3Axy08F5ptpdls3s141ni+TYG/Mmc tOyMA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To simplify the code, drop explicit and hard-coded size arguments from
strscpy() where the destination buffer has a fixed size and strscpy()
can automatically determine it using sizeof().

Changes in v2:
- Rebase and split up
- v1: https://lore.kernel.org/r/20260525103038.825690-4-thorsten.blum@linux.dev/

Thorsten Blum (6):
  crypto: use 2-arg strscpy where destination size is known
  crypto: cavium - use 2-arg strscpy where destination size is known
  crypto: ccp - use 2-arg strscpy where destination size is known
  crypto: hisilicon - use 2-arg strscpy where destination size is known
  crypto: qat - use 2-arg strscpy where destination size is known
  crypto: octeontx - use 2-arg strscpy where destination size is known

 crypto/api.c                                             | 2 +-
 crypto/crypto_user.c                                     | 9 ++++-----
 crypto/hctr2.c                                           | 3 +--
 crypto/lrw.c                                             | 2 +-
 crypto/lskcipher.c                                       | 3 +--
 crypto/xts.c                                             | 3 ++-
 drivers/crypto/cavium/nitrox/nitrox_hal.c                | 3 ++-
 drivers/crypto/ccp/ccp-crypto-sha.c                      | 2 +-
 drivers/crypto/hisilicon/qm.c                            | 5 +----
 drivers/crypto/intel/qat/qat_common/adf_cfg.c            | 7 ++++---
 drivers/crypto/intel/qat/qat_common/adf_cfg_services.c   | 2 +-
 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c     | 3 ++-
 .../crypto/intel/qat/qat_common/adf_transport_debug.c    | 3 ++-
 drivers/crypto/intel/qat/qat_common/qat_compression.c    | 3 ++-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c        | 4 ++--
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c      | 4 ++--
 16 files changed, 29 insertions(+), 29 deletions(-)


base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
