Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BA12BD030;
	Thu, 11 Dec 2025 21:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765488537; cv=none; b=c1mgrKiGTvv1y84v+bRGzYEpWyxAGsdia52+p7oo1pZzGxmS4LI8/4I5DveaQn2u05eHDUkHYeMliZb4fnfefdEjMJPw3cF8FI0d/X+08Al6c+UjYwQIQbS1xHZKQHm+Ei1tg8vYMx7bOURfeaDoir0SKCF+ax3u/CmHNcBGExg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765488537; c=relaxed/simple;
	bh=aMdZ9DS9EXaP7Y6D1yQnm2mXoFWrcI9G/7OtRgg9MnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMQYq0CZ/8IVhWc7VA2xxPg9tEl4UUNIJxudBwl9X5yiiPRpuRiFwrXjpjcxNs7C8J0ajV0K0IuCPjtzYFq6qUOci3bPlQjxmTyaO9R1ttNFZkuUqHOPx7GEH65CqCB0Y4g52BGAvJv8v+l4llwfyrA7pTvdRJ4dwczofDIGlC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WhdvRt69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WhdvRt69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7746C116B1;
	Thu, 11 Dec 2025 21:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765488536;
	bh=aMdZ9DS9EXaP7Y6D1yQnm2mXoFWrcI9G/7OtRgg9MnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhdvRt694FEJ3nBIeBrvHfaF+MzhUX2KcLuCsMheeavKERqhmg7cIlNxDT9OQyYqN
	 aSid7P2wysQO3f8Ymy628tM/V5OtkpkLKomC/BS0N1WvxudCUL999P1t+Wq8VJYX7m
	 7kt8xcIBMRyj1eVirJ87QyvE+1+rK/ZoZjgaME4ABw2E0bhINtAuGq4L/g7AvvaVOI
	 0gLMO9hebvi+SyAHBYQT4IzjpmjBuHpPk4X5+2xLFkEKQHwn9rt6tYmxw+t8p+QMG2
	 /BlLLzyGx+4ySg+b1QykqknnmneNbrkq4/9zHRyNVSZeiuTjdfGN93nSyc4BgrXw9+
	 V8VCcAvCxwBuQ==
From: "Mario Limonciello (AMD)" <superm1@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Hans de Goede <hansg@kernel.org>,
	linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER),
	platform-driver-x86@vger.kernel.org (open list:AMD PMF DRIVER),
	Lars Francke <lars.francke@gmail.com>,
	Mario Limonciello <superm1@kernel.org>
Subject: [PATCH v2 4/4] crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT fails
Date: Thu, 11 Dec 2025 15:28:47 -0600
Message-ID: <20251211212847.11980-5-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251211212847.11980-1-superm1@kernel.org>
References: <20251211212847.11980-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hibernate resume sequence involves loading a resume kernel that is
just used for loading the hibernate image before shifting back to the
existing kernel.

During that hibernate resume sequence the resume kernel may have loaded
the ccp driver.  If this happens the resume kernel will also have called
PSP_CMD_TEE_RING_INIT but it will never have called
PSP_CMD_TEE_RING_DESTROY.

This is problematic because the existing kernel needs to re-initialize the
ring.  One could argue that the existing kernel should call destroy
as part of restore() but there is no guarantee that the resume kernel did
or didn't load the ccp driver.  There is also no callback opportunity for
the resume kernel to destroy before handing back control to the existing
kernel.

Similar problems could potentially exist with the use of kdump and
crash handling. I actually reproduced this issue like this:

1) rmmod ccp
2) hibernate the system
3) resume the system
4) modprobe ccp

The resume kernel will have loaded ccp but never destroyed and then when
I try to modprobe it fails.

Because of these possible cases add a flow that checks the error code from
the PSP_CMD_TEE_RING_INIT call and tries to call PSP_CMD_TEE_RING_DESTROY
if it failed.  If this succeeds then call PSP_CMD_TEE_RING_INIT again.

Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
---
 drivers/crypto/ccp/tee-dev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 11c4b05e2f3a..34096cb6ebdc 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -90,6 +90,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
 {
 	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
 	struct tee_init_ring_cmd *cmd;
+	bool retry = false;
 	unsigned int reg;
 	int ret;
 
@@ -112,6 +113,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
 	/* Send command buffer details to Trusted OS by writing to
 	 * CPU-PSP message registers
 	 */
+init:
 	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_INIT, cmd,
 				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
 	if (ret) {
@@ -122,6 +124,15 @@ static int tee_init_ring(struct psp_tee_device *tee)
 	}
 
 	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
+		if (!retry && FIELD_GET(PSP_CMDRESP_STS, reg) == 0x0000000d) {
+			dev_dbg(tee->dev, "tee: ring init command failed with busy status, retrying\n");
+			ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
+						TEE_DEFAULT_CMD_TIMEOUT, &reg);
+			if (!ret) {
+				retry = true;
+				goto init;
+			}
+		}
 		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
 			FIELD_GET(PSP_CMDRESP_STS, reg));
 		tee_free_ring(tee);
-- 
2.51.2

