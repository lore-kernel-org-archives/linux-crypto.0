Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF9B201004;
	Sat, 28 Jun 2025 04:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751084983; cv=none; b=qxSUPAMIzEr/Cd+wY7Nz52yDqBL5krMzKtpQl75fP4Y4jBj8zd2GjzhdIAt4Prth6+qUVm1TxJiWnvmXbMMOooCQmVQUT2Ko+WOHx1Grqd5yFpEqV7DChxvcP9pnxrA4ZVqaBgMLu1x1bVy0oau5deEt58oWXmW3MbvT9uHA+J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751084983; c=relaxed/simple;
	bh=taC9hon3bDTBuuAy0dARZsbyWtMMkCuQPatt36E4I3E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nf4LAd/Wb+zdYYiNldHrdGRm9Yfl3u5t/bfyXpmwK+GP1qspIkBHCEdxrnfpdENosMFmEPJ+aZqweAj9BU9X2L2abxh2lJ/X9WQ/9xJpqwHYFkY+FenUaybgd63G3lcEwhD+cDARmeKqGF5JYIcojdk6BdWQjS/VttW9S8yRVPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=VUGO1BBc; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="VUGO1BBc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1751084983; x=1782620983;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hHmPuGQCB3KGympCntQggZl2JEHigV4ddJQ1RX+Qq18=;
  b=VUGO1BBcXTeYBPsLMErhv8rwEHNw0uHdDnO7Tpip/MTo1Y8JM0Fo5Udq
   hLyIGqb0beJsArbbGBomIe6gmuDdS/i7zq6/6ZojsP6e+8xdPcWu8oW7C
   Tf8ZOc0Vdb4rM7hA3u3nlWi+foiZ2nU8UO12GbwzRY2J0JRcrWniy6oJm
   AJ5XgKClC8s54B6sMkqgINwUH0ibjZoVOZV3Juzx6m5EJJFx3e0XvPH2s
   UjLXBD5YbocMmFIc8osiH8ZjQMFYlG3sDWXg6u8M+qz1VxVQv5DMevazF
   ev5ZXVbMbTwTks8REchZZlpmOR703Eqoc5G2DnD6pzqkNCd3ZoDLeAXdV
   w==;
X-IronPort-AV: E=Sophos;i="6.16,272,1744070400"; 
   d="scan'208";a="420316607"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2025 04:29:42 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.7.35:40800]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.23.203:2525] with esmtp (Farcaster)
 id ceed166a-f5ec-4b38-9922-e2fd0a632860; Sat, 28 Jun 2025 04:29:41 +0000 (UTC)
X-Farcaster-Flow-ID: ceed166a-f5ec-4b38-9922-e2fd0a632860
Received: from EX19D004UWA004.ant.amazon.com (10.13.138.200) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sat, 28 Jun 2025 04:29:41 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D004UWA004.ant.amazon.com (10.13.138.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sat, 28 Jun 2025 04:29:40 +0000
From: Jay Wang <wanjay@amazon.com>
To: <stable@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <wanjay@amazon.com>
Subject: [PATCH 6.12.y 0/2] crypto: rng - FIPS 140-3 compliance for random number generation
Date: Sat, 28 Jun 2025 04:29:16 +0000
Message-ID: <20250628042918.32253-1-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D037UWC001.ant.amazon.com (10.13.139.197) To
 EX19D004UWA004.ant.amazon.com (10.13.138.200)

This patch series implements FIPS 140-3 compliance requirements for random
number generation in the Linux kernel 6.12. The changes ensure that when the
kernel is operating in FIPS mode, FIPS-compliant random number
generators are used instead of the default /dev/random implementation.

IMPORTANT: These two patches must be applied together as a series. Applying
only the first patch without the second will cause a deadlock during boot
in FIPS-enabled environments. The second patch fixes a critical timing issue
introduced by the first patch where the crypto RNG attempts to override the
drivers/char/random interface before the default RNG becomes available.

The series consists of two patches:
1. Initial implementation to override drivers/char/random in FIPS mode
2. Refinement to ensure override only occurs after FIPS-mode RNGs are available

These 2 patches are required for FIPS 140-3 certification
and compliance in government and enterprise environments.

Herbert Xu (1):
  crypto: rng - Override drivers/char/random in FIPS mode

Jay Wang (1):
  Override drivers/char/random only after FIPS-mode RNGs become
    available

 crypto/rng.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

-- 
2.47.1

