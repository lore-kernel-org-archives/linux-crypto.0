Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32963E0C44;
	Mon,  4 May 2026 15:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777909181; cv=none; b=fCDhKKpNA2jb2maZuQ71pGPOk4nYilBFYD3W1QmkMvTFaIh2kr/9I/YfAMVZuqvghn8FxfRRfO0DUMK4vhvPyAEsTTJQVUGtvJuyuoW/BW4XwgfqY4KuKcAW2JFz/LV0T9SXW2WjSOFKSCHzHWzFI9YMQT1d4iaf/whTnXFoIow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777909181; c=relaxed/simple;
	bh=7q+ppFzUqLufjlt6Ao3zIFeLSBsOqhdmSr3mRmuaO0E=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Ekz8iF+HJLQGB+fMyu9tOEnnLKEuB4/RlYPvwQL6SQXxOhflLRN9ZU648OsSEgisj5zEj8JI/m+OhwyIOD/4EzRFaPsjT0QLf/yJi+F1MkcUgS/rl9+Hdet1z6XReYWdY0yZ2UimR4CfGQP1T78qArpASJs7lN+nzwYzmYmOdWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=R/GKTJEb; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="R/GKTJEb"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 6539D1A350A;
	Mon,  4 May 2026 15:39:37 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 3932F5FD9D;
	Mon,  4 May 2026 15:39:37 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 18D2A11AD2BA5;
	Mon,  4 May 2026 17:39:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1777909176; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=1q+EFtgKl2JQLRRcxwrMscFheukzSFWL2HmsLMt1JaA=;
	b=R/GKTJEb7L0a0tMwGVVd90gsa/8ppQOE9fqsgG2S2Y4zx5hlGbEveIJFyKrndhXgG8u58K
	S7NOuukEc44TzBkh3+rFQaT1ODr0urjffOa8+TKRS+oG6/8Kr0EiCN4TV/uDtlfzGnqtGo
	kTwgdVLbiatW8drIRHVSICKPHe/TDR/TDoAYfOCixpSojv+Ca22qfVv7diR7OoXoiJrmZY
	tA7r+0yck4t4t4aNz2ERuLXJh0RJhWyand/RgpeQh3DdTSfM5lQAbQhlZV9FkFl/fLcIaM
	0AoXMxbYjA4Umm39oTGYvtZYN2tT8r5FobC2AsmW5l/aHaMOoK6xUpccZmYcmw==
From: Paul Louvel <paul.louvel@bootlin.com>
Subject: [PATCH 0/4] crypto: talitos - fix several issues in the Freescale
 talitos crypto driver
Date: Mon, 04 May 2026 17:38:26 +0200
Message-Id: <20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXN0QrCMAyF4VcZuTbQTN3QVxEpNo0zIq00nQhj7
 27Vy+9c/GcBk6JicOwWKPJS05waaNMB3y5pEtTYDL3rB7d3Oww514cmX8UqjkhYmLwJ+zBPV30
 jbWk4SHRjjAyt8izS5t/D6fy3zeEuXL9ZWNcPrk4TToMAAAA=
X-Change-ID: 20260504-bootlin_test-7-1-rc1_sec_bugfix-13169ed07ddc
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777909177; l=1643;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=7q+ppFzUqLufjlt6Ao3zIFeLSBsOqhdmSr3mRmuaO0E=;
 b=QoBoXQeWRwjfkLSpA8u4tiDJ7hgCgT/vvxSeKySJ0pbRKyn7vcW+EfuZx9dNrPnB5nVU+KM0M
 ij2KhRxJ/drCw+H8z0i9JMsbA3ik04GmtOIxdKAw8jj5L9H84n6boer
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

This series fixes several issues in the Freescale talitos crypto driver.

The first patch replaces the software workqueue approach introduced by
commit 655ef638a2bc ("crypto: talitos - fix SEC1 32k ahash request
limitation") to handle large requests. Depending on the SEC hardware
version, replace this approach by using facilities provided by the
hardware itself:

- On SEC1, descriptors can be chained with the Next Descriptor field.

- On SEC2, the per-channel fetch FIFO is used to submit multiple
  descriptors.

This removes the workqueue-based splitting entirely and fix the (64k -
1) byte ahash request limit on SEC2.

Patches 2-3 are cleanups that follow the first patch: a field rename for
clarity and folding a trivial wrapper function.

Patch 4 fixes an off-by-one in the submit_count initialisation that
wastes one FIFO slot.

Tested on an MPC885 SoC (SEC1 Lite), and on an MPC8321EMP SoC (SEC2).

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
Paul Louvel (4):
      crypto: talitos - use hardware facilities for large ahash requests
      crypto: talitos - rename first_desc/last_desc to first_request/last_request
      crypto: talitos - remove useless wrapper
      crypto: talitos - fix invalid submit_count initial value

 drivers/crypto/talitos.c | 583 +++++++++++++++++++++++++----------------------
 drivers/crypto/talitos.h |  14 ++
 2 files changed, 322 insertions(+), 275 deletions(-)
---
base-commit: db8b9f227833e729faf44a512aa1e88a625b5ad8
change-id: 20260504-bootlin_test-7-1-rc1_sec_bugfix-13169ed07ddc

Best regards,
--  
Paul Louvel <paul.louvel@bootlin.com>

