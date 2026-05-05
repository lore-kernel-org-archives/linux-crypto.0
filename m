Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441693BFE41;
	Tue,  5 May 2026 17:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778003633; cv=none; b=kW5/5MUQ7Gmzm2/xOLgEuJm7PD8gYSlA2bzSabdd1FaMw6nF/zsv7c6w8lXF0Kj1CJVlpZiHdIzP7rZo5dVOKilz+X1o3oCVfsY9Ob73oYfgqxAIGewTpllZUF7MnuZUKnFDxbc8zB3DbuaNByt3fGbIm6qWzjwhF01/O7OMFLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778003633; c=relaxed/simple;
	bh=/ZwYAFOgpr580SLonx52kNZvN6n6G6iXNHavjQmQkvU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=nyqowLiTuVw9NQfAnT5zVcojV1PhbLRpO/D+L4e2e7yYvX8Oc+Z61zdgeDfU2e45duT+2WyF+0Z/LbrpFlSOpC+Mmj4jbKdxGM7CHkaJVn8RW2cHZaTlm7iJsDlJLS4GZpc8oKlvS7Hp/11wLw6XqhRnsxAawXLyhjIx3Fh2dCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=dN0Dkf2U; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="dN0Dkf2U"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 8D4611A3527;
	Tue,  5 May 2026 17:53:49 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 509D26053C;
	Tue,  5 May 2026 17:53:49 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C879C11AD03AB;
	Tue,  5 May 2026 19:53:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778003628; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=XV1OdeCX9xDnn/rhTj26ZmuHnNt77lFZvDkYyzRHd3g=;
	b=dN0Dkf2Ub0lj5w5RGwysDpZEXkIO2Y222K9mtylG0WyBhdwUa1N6/Iyebxt+rMVcWqpfHS
	pM2B+HKCqaL4Tws5IPGiv9KZ02xTgUrY2esZifgnQNdHjYmKJoTa9m4taN/FfEFv/zdH12
	01mkx8vb7sg7JUVHr6MImDoaFdonvdkptyMus4mGgkBuf1oHXPZzAHUqJDclEuTx5eptxj
	fg+KiBVEq+0rAGUOQnTqkh+LpzCxXWPq3ytE3gHhRW+wL6+t54JLUaoj1pwW8ovP7/VAsA
	xG8rqOczd7nIyCFTRmrPPhezCZwdizdKKG/gcVzH9XUBQ7dUQ1gxLtQicEar6A==
From: Paul Louvel <paul.louvel@bootlin.com>
Subject: [PATCH v2 00/12] crypto: talitos - fix several issues in the
 Freescale talitos crypto driver
Date: Tue, 05 May 2026 19:53:01 +0200
Message-Id: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42OTQ6CMBCFr2K6dkwHoQ2uvIchRKYD1Cg1bSEaw
 t0t6AFcfi/vbxaBveUgTrtZeJ5ssG5IkO13gvrr0DFYk1hkMlOykDk0zsW7HerIIYIGBE9YB6a
 6GbvWvgCPqEo2UhtDIrU8PSd5W7hUXw5jc2OKa+3q6G2Izr+3CxOuvv/XJgQJVGpSOZZatcX5l
 ziQe4hqWZYPU3io3+IAAAA=
X-Change-ID: 20260504-bootlin_test-7-1-rc1_sec_bugfix-13169ed07ddc
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>, 
 Christophe Leroy <chleroy@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, stable@vger.kernel.org
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778003630; l=3004;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=/ZwYAFOgpr580SLonx52kNZvN6n6G6iXNHavjQmQkvU=;
 b=bM46caqSWwBzKkM9YbUmVsSlN4EcHTQMCLGYpJ1XZBcbKfqnFNoO5QDFBSd+wkdHNUAzV6xQQ
 u1HoyQrFyPXDeaZLYb/s8qnNnBv5VKyJsTm8UuH1e5FyZg2o8v12Ugz
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

This series fixes several issues in the Freescale talitos crypto driver.

Patch 1 fixes a missing dma_sync_single_for_cpu() before reading a
descriptor header.

Patches 2-5 add support for chaining an arbitrary number of descriptors
in the driver for the SEC1 hardware.

Patches 6-9 rework the SEC1 hash implementation to build descriptor
chains instead of submitting one descriptor at a time via a workqueue.

Patch 10 fixes the same ahash request size limitation on SEC2 (64k - 1
bytes), by splitting ahash_done() into SEC1 and SEC2 paths so that SEC2
iterates through descriptors sequentially.

Patch 11 fixes an off-by-one in the submit_count initialisation that
wastes one FIFO slot.

Tested on an MPC885 SoC (SEC1 Lite), and on an MPC8321EMP SoC (SEC2)
with CRYPTO_SELFTESTS_FULL=y.
For the SEC1 Lite, some tests are failing due to a timeout waiting for
request completion. These failed tests existed prior to this series.
On SEC2, there is no failed tests.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
Changes in v2:
- Split the first patch into smaller, logically separated patches for
  easier review.
- Added more context on testing on the cover letter.
- Introduce a fix to correctly read hardware descriptor header. This fix
  was motivated by a remark of Sashiko on the v1:
  https://sashiko.dev/#/patchset/20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5%40bootlin.com
- Separate SEC2 64k-1 ahash limitation fix into its own patch.
- Link to v1: https://patch.msgid.link/20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5@bootlin.com

---
Paul Louvel (12):
      crypto: talitos - use dma_sync_single_for_cpu() before reading descriptor header
      crypto: talitos - add chaining of arbitrary number of descriptor for the SEC1
      crypto: talitos - move dma unmapping code in flush_channel() into a standalone dma_unmap_request() function
      crypto: talitos - move dma mapping code in talitos_submit() into a standalone dma_map_request() function
      crypto: talitos - move code in current_desc_hdr() into a standalone function
      crypto: talitos/hash - prepare SEC1 descriptor chaining, remove additional descriptor
      crypto: talitos/hash - use descriptor chaining for SEC1 instead of workqueue
      crypto: talitos/hash - drop workqueue mechanism for SEC1
      crypto: talitos/hash - rename first_desc/last_desc to first_request/last_request
      crypto: talitos/hash - remove useless wrapper
      crypto: talitos/hash - fix SEC2 64k - 1 ahash request limitation
      crypto: talitos - fix invalid submit_count initial value

 drivers/crypto/talitos.c | 578 ++++++++++++++++++++++++-----------------------
 drivers/crypto/talitos.h |  14 ++
 2 files changed, 315 insertions(+), 277 deletions(-)
---
base-commit: db8b9f227833e729faf44a512aa1e88a625b5ad8
change-id: 20260504-bootlin_test-7-1-rc1_sec_bugfix-13169ed07ddc

Best regards,
--  
Paul Louvel <paul.louvel@bootlin.com>

