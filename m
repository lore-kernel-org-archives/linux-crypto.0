Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3AC3FBEDF
	for <linux-crypto@vger.kernel.org>; Thu,  7 May 2026 14:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778164931; cv=none; b=FdKmFmgVC8M1WopuN1/M4AZiudjaLO3c9DUDZpU3439cL6RmbB6z/VkkoZeXIkca3kNVaKdMySpYcKbISespMXZG298HlLvM/PbcWVBjo8hIyfxQMG6SC4uL5LzNGUSkllnlpoauSy+466erjezlKEYDQoZheoXFxInC1XNw+VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778164931; c=relaxed/simple;
	bh=9Eak+YglawM8cPq8178zvvzVDVrslvUVqxz64pCqWgE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Ob7cTc1PfvmVEroit5t59Wd264HM5PGvrZ1n6lH0cg4EWBtMQv1otCpHGjnY53njereD63xU1VuK3YmPSnWLrn5UGu1qg9T0K5FaEKmRd3PMh9Sdt7m33UisCM2HA7vSmiAx7siJ2OZ6TWFZ2mNjeysduhcyh0y71UXOTLgKeVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=yqZuiKUP; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="yqZuiKUP"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 9BE361A3563;
	Thu,  7 May 2026 14:42:06 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 68E8960495;
	Thu,  7 May 2026 14:42:06 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 59ACB108194E6;
	Thu,  7 May 2026 16:42:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778164925; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=RLLdVihD7IU7ZrOJ+km4l+TBku/rkV+jUntAo18lNDQ=;
	b=yqZuiKUP8gdjQKu/gxkNNJW6z0tmLW2Sd1FPfL2Qh9LmgkX2loBwsHzfeym5NFSyHjp3SM
	FrdQJ4t81xx40ZXhM4H1bA8NiP7B2ImwY8pKZUhdW+e+JJ+wSR9grjDMeoRuwlUaBJ5Rd8
	OzkxsilHLIhw2+w21I0HOo0NenNGBQggD/2D0tQDv6sMSrCjodzyKdpe4vAGcDr2Z+4yAT
	J58dAhVw4Es5fedCgHnWBJWpE+BfPx+YEFE8+eb2miHJ0Gc+XzlMjKi0/vgbaIxi3/i6e2
	J4g88RTno+FYiKQQXp+UFt5oEtsnMwHghYhtk3DtcDU1bPAgJ6P2t9oCG3Pvrw==
From: Paul Louvel <paul.louvel@bootlin.com>
Subject: [PATCH v3 00/11] crypto: talitos - fix several issues in the
 Freescale talitos crypto driver
Date: Thu, 07 May 2026 16:41:46 +0200
Message-Id: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42OQQ6CMBBFr0K6tqYDtIAr72EMkXaAGqWmLURDu
 LstutCVLt/k//dnJg6tRkd2yUwsTtppMwTINgmR/WnokGoVmKQsFYyznDbG+Iseao/O04ICtRJ
 qh7Juxq7VdwoZiAoVK5SSJFhuFsN5XTgcX+zG5ozSR21M9Np5Yx/rCxPE3P9rE1BGZVVIkUNVi
 Jbv342tNFcS96b008h/G9Ng5CWUTOSNgop9G5dleQJxPAz1NAEAAA==
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
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778164923; l=5149;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=9Eak+YglawM8cPq8178zvvzVDVrslvUVqxz64pCqWgE=;
 b=IsLpbyCO4EzUWrV6Z8GPwGaNZY13v5ZKjxcgSXHav/t55RXiRTbcXpy8wWJ6kJVkvSfHz3kX8
 ZuMbWUoxkFDBu5iMrtR9QqxMDyvnxGXY7VQwBzUsytFTeRMTnrVEg0k
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

This series fixes several issues in the Freescale talitos crypto driver.

Patch 1 fixes a missing dma_sync_single_for_cpu() before reading a
descriptor header.

Patches 2-5 add support for chaining an arbitrary number of descriptors
in the driver for the SEC1 hardware.

Patches 6-8 rework the SEC1 hash implementation to build descriptor
chains instead of submitting one descriptor at a time via a workqueue.

Patches 9-10 are cleanups: rename first_desc/last_desc to
first_request/last_request, and remove a useless wrapper function.

Patch 11 fixes the same ahash request size limitation on SEC2 (64k - 1
bytes), by splitting ahash_done() into SEC1 and SEC2 paths so that SEC2
iterates through descriptors sequentially.

Tested on an MPC885 SoC (SEC1 Lite), and on an MPC8321EMP SoC (SEC2)
with CRYPTO_SELFTESTS_FULL=y.
For the SEC1 Lite, some tests are failing due to a timeout waiting for
request completion. These failed tests existed prior to this series.
On SEC2, there is no failed tests.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
Changes in v3:
- Patch 1 was reading the next chained descriptor header
  unconditionally. Fixed it by checking if a request actually contained
  a chained descriptor before deferencing it.
- For descriptor chaining introduced in patch 2, use a next pointer
  embedded inside struct talitos_edesc instead of the kernel's struct
  list_node. This removes the necessity for a desc_chain member in
  struct talitos_request. A dirty hack was previously used to assign a
  request->desc_chain to the current request by taking edesc->prev,
  assuming that the descriptor was added to a list before calling
  talitos_submit(). Not only was this non-idiomatic, but it also broke
  the skcipher and aead implementations because they do not use the
  descriptor chaining feature at all. The descriptor chaining mechanism
  does not need a doubly circular linked list; this change makes the
  code more readable than sticking with the kernel linked list
  implementation.
- Updated the performance measurement in patch 6.
- Drop patch 12, which was a revert of commit 4b24ea971a93 ("crypto:
  talitos - Preempt overflow interrupts off-by-one fix"). This patch was
  primarily motivated because the SEC1 has a Fetch Register rather than
  a Fetch FIFO per channel. As a result, having a value of 24 in the
  device tree node for the channel-fifo-len property does not make
  sense, as the hardware does not have a Fetch FIFO. Setting this value
  to 1 (which should be the correct value for SoCs featuring the SEC1
  engine family) breaks the driver because no descriptor can be
  submitted due to commit 4b24ea971a93, and the patch was primarily
  intended to fix this issue. As this issue is too deep to be addressed
  in this patch series, it has been dropped.
- Link to v2: https://patch.msgid.link/20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com

Changes in v2:
- Split the first patch into smaller, logically separated patches for
  easier review.
- Added more context on testing on the cover letter.
- Introduce a fix to correctly read hardware descriptor header. This fix
  was motivated by a remark of Sashiko on the v1:
  https://sashiko.dev/#/patchset/20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5%40bootlin.com
- Separate SEC2 64k-1 ahash limitation fix into its own patch.
- Link to v1: https://patch.msgid.link/20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5@bootlin.com

To: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>
To: Christophe Leroy <chleroy@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
Paul Louvel (11):
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

 drivers/crypto/talitos.c | 549 ++++++++++++++++++++++++-----------------------
 drivers/crypto/talitos.h |  12 ++
 2 files changed, 287 insertions(+), 274 deletions(-)
---
base-commit: db8b9f227833e729faf44a512aa1e88a625b5ad8
change-id: 20260504-bootlin_test-7-1-rc1_sec_bugfix-13169ed07ddc

Best regards,
--  
Paul Louvel <paul.louvel@bootlin.com>

