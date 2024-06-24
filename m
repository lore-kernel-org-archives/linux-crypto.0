Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624A71A08DF;
	Mon, 24 Jun 2024 23:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271379; cv=none; b=RHNaWutjx6iS2G2ytMBKvLVCzFcQDO0dRAn26yyoU9wz77QUN1j/hESXTHM6S5Ck/72VtUe04D0My8OOyZPh3+5zFMNyLQ+xKJYOObu3Acl7hndTcq2He0PgBWzQ8ueY7yh4WECVbR4FIo72KyvfilmTfwfWfZpT21aWklynO3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271379; c=relaxed/simple;
	bh=gx8lPkWP+9JgErCy4sCFE3lnCJKIhgwZvD53YmMj9Lc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DwCtw696OrizHqaFixCQHPEj1y168X+ILA/RBXBfXQoAuIVSCiRtRcNK0CnYH666iPcayJqkiuwE/1T3nqi/KF7+BHU7tVPR1AvGaraY9C0WRy/IXSldQID1E2ioPVKMuxTaZVhvzkJXu46JhCFg3SKosXZV7+hMxIcQzR/Ykqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 565C8339;
	Mon, 24 Jun 2024 16:23:20 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 760F33F766;
	Mon, 24 Jun 2024 16:22:53 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Ryan Walklin <ryan@testtoast.com>,
	Philippe Simons <simons.philippe@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	devicetree@vger.kernel.org
Subject: [PATCH v2 0/4] crypto: sun8i-ce: add Allwinner H616 support
Date: Tue, 25 Jun 2024 00:21:06 +0100
Message-Id: <20240624232110.9817-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.39.4
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an update to the H616 crypto engine support, with the sparse
warning fixed and the accrued tags added.
========================

This series adds support for the crypto engine in the Allwinner H616
SoC. The IP and its capabilities are very similar to the H6, with the
major difference of the DMA engine supporting 34 bit wide addresses.
This is achieved by just shifting every address by 2 bits in the DMA
descriptors; Allwinner calls this "word addresses".
Patch 2/4 adds support for this by wrapping every address access in a
function that does the shift as needed. Patch 1/4 adds the new
compatible string to the binding, patch 3/4 adds that string to the
driver and enables the address shift for it. The final patch 4/4 adds
the DT node to the SoC .dtsi. Since this is an internal peripheral,
it's always enabled.

Corentin's cryptotest passed for me, though I haven't checked how fast
it is and if it really brings an advantage performance-wise, but maybe
people find it useful to offload that from the CPU cores.
One immediate advantage is the availability of the TRNG device, which
helps to feed the kernel's entropy pool much faster - typically before
we reach userland. Without the driver this sometimes takes minutes, and
delays workloads that rely on the entropy pool.

Please have a look and comment!

Cheers,
Andre

Changelog v1 ... v2:
- fix sparse warning by treating writel() call differently (2/4)
- add Acks, R-b and Tested-by: tags

Andre Przywara (4):
  dt-bindings: crypto: sun8i-ce: Add compatible for H616
  crypto: sun8i-ce - wrap accesses to descriptor address fields
  crypto: sun8i-ce - add Allwinner H616 support
  arm64: dts: allwinner: h616: add crypto engine node

 .../bindings/crypto/allwinner,sun8i-ce.yaml   |  2 ++
 .../arm64/boot/dts/allwinner/sun50i-h616.dtsi | 10 +++++++
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |  8 +++---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 28 ++++++++++++++++++-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c |  6 ++--
 .../crypto/allwinner/sun8i-ce/sun8i-ce-prng.c |  6 ++--
 .../crypto/allwinner/sun8i-ce/sun8i-ce-trng.c |  2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 15 ++++++++++
 8 files changed, 65 insertions(+), 12 deletions(-)

-- 
2.39.4

