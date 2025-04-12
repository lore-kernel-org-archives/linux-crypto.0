Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E31194A65
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744455444; cv=none; b=eylOE0S08z+Hu/eyaAWC4sqIAIgPoGI1B7YmHqZFwMcDtJ+s85dt0aOVg8K/BQSfuA/0hjF3Bsrec78+OIABL+hv/EUnBXuwGFGhZftsAdyUyrldA0Ttb6yJmxa7Glnc/r/J/xUqRrNj5Boms9Ov7oVWHozVQMzZ6lQNoXIjC/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744455444; c=relaxed/simple;
	bh=rXUXTXl36PenVmjooLP7Dt4gzVOLGWUpvqcuy/rOWnc=;
	h=Date:Message-Id:From:Subject:To; b=ZN6i6swYHEcDNXlB3ckbySw1Dgz2k6nY4GlwBQvBjBQXe31xMXu8mT5DxSeb8GeRFqUq7iXEuzXMsANjfk60MmOwlJCEp3SIP5He3RUxm73zr1HpmNfLYJa5uaKR776bMNE64VeZW/4zAXUL+wNmvnedLV14x0oKH7ngun7Yhok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Kv4alNbR; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Kv4alNbR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xiaYLAK9SQKWGq4wseCnennusxveQV/NvnBoBi+GkA4=; b=Kv4alNbRYpzCjgBoar+SVl7ul8
	uq4MnjRuDllCpd2QuyweiNKyZlFDr6OwfOQXFuLW4srC6dF5H147OyuV+8fwfyZD1rVIQh3YS24Bv
	HJSR6hJ9CL+UNw/oZteMmZqzgJ7BKFgOTLJHRdoLqXYX6StSCL79R/OXpl2qVc0aVfQwKNoVIJco7
	JsqqfAI7aJ4QCuhm3W1+cX/Ye1RIZBNGSk+rO9zLwOeWokY8hne4t4LR4FGn7qXov3HzP9Hd+67D7
	+V69AIw/ShuIpnD7LqH+2Rm9jxW5tp1e5xsla7ughA4+Y/tr4AxbGge9TvRpNGUpk02uMeuSfVX7R
	UfXpDsbg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YY1-00F5JO-2D;
	Sat, 12 Apr 2025 18:57:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:57:17 +0800
Date: Sat, 12 Apr 2025 18:57:17 +0800
Message-Id: <cover.1744455146.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/8] crypto: hash - Preparation for block-only shash
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This series is based on

	https://lore.kernel.org/linux-crypto/cover.1744454589.git.herbert@gondor.apana.org.au

Add helpers to use stack requests with any ahash algorithm, with
optional dynamic allocation when required for async.

THe rest of the series are miscellaneous fixes in preparation for
the next series which will introduce block-only shash.

Herbert Xu (8):
  crypto: hash - Add HASH_REQUEST_ON_STACK
  crypto: zynqmp-sha - Add locking
  crypto: arm64/sha512 - Fix header inclusions
  crypto: hash - Update HASH_MAX_DESCSIZE comment
  crypto: lib/sm3 - Move sm3 library into lib/crypto
  crypto: lib/sm3 - Export generic block function
  crypto: sm3-base - Use sm3_init
  crypto: cbcmac - Set block size properly

 arch/arm64/crypto/Kconfig                    |   4 +-
 arch/arm64/crypto/aes-glue.c                 |   2 +-
 arch/arm64/crypto/sha512-glue.c              |   5 +-
 arch/arm64/crypto/sm4-ce-glue.c              |   2 +-
 arch/riscv/crypto/Kconfig                    |   2 +-
 arch/x86/crypto/Kconfig                      |   2 +-
 crypto/Kconfig                               |   5 +-
 crypto/Makefile                              |   1 -
 crypto/ahash.c                               | 106 ++++++++++++++++++-
 crypto/ccm.c                                 |   2 +-
 drivers/crypto/inside-secure/safexcel_hash.c |   2 +-
 drivers/crypto/xilinx/zynqmp-sha.c           |  18 +++-
 include/crypto/hash.h                        |  58 +++++++---
 include/crypto/internal/hash.h               |  26 ++++-
 include/crypto/sm3.h                         |   1 +
 include/crypto/sm3_base.h                    |  13 +--
 lib/crypto/Kconfig                           |   3 +
 lib/crypto/Makefile                          |   3 +
 {crypto => lib/crypto}/sm3.c                 |  25 +++--
 19 files changed, 218 insertions(+), 62 deletions(-)
 rename {crypto => lib/crypto}/sm3.c (96%)

-- 
2.39.5

