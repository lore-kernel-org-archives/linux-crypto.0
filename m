Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC5C28DB5E;
	Mon, 30 Jun 2025 18:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751306597; cv=none; b=oRY42/eXREgibcDhvz3MNNCJvzMxjQtSW0CJRBbplJkd0yvWbxl5eaiz994kPLqI9V2+WnLNopqqBN0NRjrNSFze1KizotnUCRhCRC9r8ZLs3BWLJ8G0UPvPrzdN9MA53616xZZwdOYZsOnRodhkKKhsgQMMSf4h5UcYBjXX7vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751306597; c=relaxed/simple;
	bh=3fu6WHoX0URGY060hxVBPeAEeK1Opps1K0U3986os9E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VzASvXKBgFDASc0dg48LJV7iIi21kTGT6azawqHYspoEq7TO9bCxBUzbbdl8v2SqYOT53GSxvGcNieHG5TLZo3/ar0cGZqMRZNcJoAWxtH/q1jNaJ6nMPU1qukuRQunIzUbD0tCeJ8lbAM7+L+JkZzWBFF09bW/JJ0Xsxm9nfCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=fj7C9eSa; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="fj7C9eSa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1751306595; x=1782842595;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H4Oh57q6DX394QB4dtEUvzbAUew4Ut8DiElWzbBJVH4=;
  b=fj7C9eSayRMdkjcMA/7MlcFIwjk7/pUgeAzmUkroING2qV3cyBVx5JRk
   vm+b5p2RjVRu6Q/w1ooJ2+hiQ5F5uaCwV6GmuDmyCAR79ou6sgUUyfYU9
   BmqXB5g3PA2eSi4TmWX0mpOTlnzLehWpDsoHqjKj5mqQ9PNaR6SNNi3mB
   1zVtkxDRzL53f80qYOlwBF/1K2rnWK/ZYvY1MyhKotdOnfaeaeSw9aDB2
   JgbtPkc6MKsI3xz+ZRQnH00H3g/SqsrBLAVwTIGCdea7GA4X1MaRecGZY
   k6f9W8uadajA7C1l8j/1utw1Hb/0hEh2FYG3C44c40LIsA+rt3iqahflj
   g==;
X-IronPort-AV: E=Sophos;i="6.16,278,1744070400"; 
   d="scan'208";a="211778402"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 18:03:15 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.38.20:44973]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.23.203:2525] with esmtp (Farcaster)
 id aad0ec3f-3683-4e36-92eb-f7304bea6135; Mon, 30 Jun 2025 18:03:15 +0000 (UTC)
X-Farcaster-Flow-ID: aad0ec3f-3683-4e36-92eb-f7304bea6135
Received: from EX19D004UWA004.ant.amazon.com (10.13.138.200) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 30 Jun 2025 18:03:14 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D004UWA004.ant.amazon.com (10.13.138.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 30 Jun 2025 18:03:14 +0000
From: Jay Wang <wanjay@amazon.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wanjay@amazon.com>
Subject: [PATCH v6.12 0/2] crypto: rng - FIPS 140-3 compliance for random number generation
Date: Mon, 30 Jun 2025 18:03:10 +0000
Message-ID: <20250630180312.24627-1-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWA001.ant.amazon.com (10.13.139.100) To
 EX19D004UWA004.ant.amazon.com (10.13.138.200)

This patch series implements FIPS 140-3 compliance requirements for random
number generation in the Linux kernel 6.12 stable. The changes ensure that
when the kernel is operating in FIPS mode, FIPS-compliant random number
generators from the Crypto API are used to override the default
/dev/random implementation.

The series consists of two patches:

1. "random: Add hook to override device reads and getrandom(2)" - This patch
   introduces the infrastructure to allow external RNGs to override the
   default random number generation. Originally authored by Herbert Xu, this has
   been adapted for kernel 6.12.

2. "crypto: rng - Override drivers/char/random only after FIPS RNGs available" -
   This patch implements the actual FIPS mode override using a workqueue-based
   approach to ensure proper initialization timing. It addresses timing issues
   in a previous commit "crypto: rng - Override drivers/char/random only after
   FIPS RNGs available" where the crypto RNG would attempt to override before
   dependencies were ready, preventing potential boot failures.

These patches are required for FIPS 140-3 certification and compliance in
government and enterprise environments where cryptographic standards must
be strictly enforced.

Herbert Xu (1):
  random: Add hook to override device reads and getrandom(2)

Jay Wang (1):
  crypto: rng - Override drivers/char/random only after FIPS RNGs
    available

 crypto/rng.c           |  92 +++++++++++++++++++++++++++++++++
 drivers/char/random.c  | 114 +++++++++++++++++++++++++++++++++++++++++
 include/linux/random.h |   7 +++
 3 files changed, 213 insertions(+)

--
2.47.1

