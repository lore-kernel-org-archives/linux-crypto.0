Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F280C33F386;
	Fri, 16 Jan 2026 04:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768536710; cv=none; b=HG9PhB5RYXwrzBGrFxI/o7/yhbRe0hr9OBTN3zhBweGOpftkdykxKB5/gEMM6AtlUMY72j87R1GDSjWpHILsXuDbZOvgLpeLEyQCijUIBS9PLRwhuGQugzehPws+wVI88/Qs5hZ0ghLlkszT8CCxf9Ms/ShL7L9mYJS+RODgCE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768536710; c=relaxed/simple;
	bh=Hh5waHPwNk1sRu4s4FEAwm1VSrHS3qZRw6FAv1Jzalk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJtto2Cv+5VoULmkavfPTSICK9zN0KwcMjDJJk07Cgxa64d74PGobbgHcCGrqcaWtaeHbR+szuyF3Gp5xBJlbQxjO7m1v/B7OE+txsoZ0rm40kxBvezkgDkEOHMGH3jhnB0EELf6Hm4aOCy9xd/Lf/NGahYKGh/pv2sUX7EKBy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8fHH1x5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8fHH1x5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9CCC19421;
	Fri, 16 Jan 2026 04:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768536709;
	bh=Hh5waHPwNk1sRu4s4FEAwm1VSrHS3qZRw6FAv1Jzalk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8fHH1x5c3bTgrkHaoxpGayDwc9DFu/u/BL0uLYMxqIE+coRt8fZHIl2Jb+THh+vE
	 AV0iTp+p4pDD9Je9WmABJ07LGBjnI0OzQtAiolnIqvwWJslrqpoO7qvaNxIx0+W3cN
	 8d8FV9wFTTb6ic5Qfq0n7YmMKqAlUrMxOIA9GkVugyXbAnXqz3+fgc/3tKNiFub/jq
	 KdRQWrSLghdJQWtbOEaBqFRdcIjoSk1qVu/hNAVjRHFA0zReQKSfbcHai1irmBi8YP
	 VC1q9HdhzA35WVR9T3vkPVnZivDhYnDA8ATlOOavE2YJgU++FD45aHt6c9nux0Us4w
	 nkWPfFpYhkVGQ==
From: "Mario Limonciello (AMD)" <superm1@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Hans de Goede <hansg@kernel.org>,
	linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER),
	platform-driver-x86@vger.kernel.org (open list:AMD PMF DRIVER),
	Lars Francke <lars.francke@gmail.com>,
	Yijun Shen <Yijun.Shen@dell.com>,
	Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Yijun Shen <Yijun.Shen@Dell.com>
Subject: [PATCH v6 5/5] crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT fails
Date: Thu, 15 Jan 2026 22:11:32 -0600
Message-ID: <20260116041132.153674-6-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260116041132.153674-1-superm1@kernel.org>
References: <20260116041132.153674-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hibernate resume sequence involves loading a resume kernel that is just
used for loading the hibernate image before shifting back to the existing
kernel.

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

Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
Reported-by: Lars Francke <lars.francke@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
---
v5:
 * Add retry=true for the retry case (Shyam)
v4:
 * Add tag (Yijun)
 * Move and rename PSP_TEE_STS_RING_BUSY (Ilpo)
v3:
 * Add a comment (Tom)
 * Add a define for busy condition (Shyam)
 * Rename label (Shyam)
 * Upgrade message to info (Shyam)
 * Use a helper that validates result for destroy command (Shyam)
---
 drivers/crypto/ccp/tee-dev.c | 14 ++++++++++++++
 include/linux/psp.h          |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index ef1430f86ad62..92ffa412622a2 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -113,6 +113,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
 {
 	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
 	struct tee_init_ring_cmd *cmd;
+	bool retry = false;
 	unsigned int reg;
 	int ret;
 
@@ -135,6 +136,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
 	/* Send command buffer details to Trusted OS by writing to
 	 * CPU-PSP message registers
 	 */
+retry_init:
 	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_INIT, cmd,
 				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
 	if (ret) {
@@ -145,6 +147,18 @@ static int tee_init_ring(struct psp_tee_device *tee)
 	}
 
 	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
+		/*
+		 * During the hibernate resume sequence driver may have gotten loaded
+		 * but the ring not properly destroyed. If the ring doesn't work, try
+		 * to destroy and re-init once.
+		 */
+		if (!retry && FIELD_GET(PSP_CMDRESP_STS, reg) == PSP_TEE_STS_RING_BUSY) {
+			dev_info(tee->dev, "tee: ring init command failed with busy status, retrying\n");
+			if (tee_send_destroy_cmd(tee)) {
+				retry = true;
+				goto retry_init;
+			}
+		}
 		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
 			FIELD_GET(PSP_CMDRESP_STS, reg));
 		tee_free_ring(tee);
diff --git a/include/linux/psp.h b/include/linux/psp.h
index 92e60aeef21e1..b337dcce1e991 100644
--- a/include/linux/psp.h
+++ b/include/linux/psp.h
@@ -18,6 +18,7 @@
  * and should include an appropriate local definition in their source file.
  */
 #define PSP_CMDRESP_STS		GENMASK(15, 0)
+#define  PSP_TEE_STS_RING_BUSY 0x0000000d  /* Ring already initialized */
 #define PSP_CMDRESP_CMD		GENMASK(23, 16)
 #define PSP_CMDRESP_RESERVED	GENMASK(29, 24)
 #define PSP_CMDRESP_RECOVERY	BIT(30)
-- 
2.43.0

