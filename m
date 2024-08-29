Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A321946BA;
	Thu, 29 Aug 2024 10:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724926844; cv=none; b=L7OBDLioeYMTL8yFgChN8G1xnjIEWvAnVe4hT7CG4RVyb7Ehdw3UtiuRmN5OQg5nmJ0V+UH3FS9jNNeoprxADhHvWlIiJsjpoO9eViM0qN531fbw3eiCPZf1cHgYV3QI6UMGHqsgpwJJuR2Jpop3p2bR00tcITgJ1jGR/56xnzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724926844; c=relaxed/simple;
	bh=zSfbnEvAJQ+8+99lFeLACQv0eQOuY8TPDkGfaHoxOwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mBAdNwg+V6OxAUdDlKwwiejBo8Q9u+/7qONWynj8WKIak52Q71CLX2MAGGlN+DLQSVhngRyCgWJxkuG9TzXHgIXF7uW7hx7I+wK853KOG7rnpm7gqrGWXkDyIw+Na8CrHag93ft2TiAdXPusilq95mcVnZHlAjTZTCwHOphMmnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=poXy7rjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="poXy7rjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D535DC4CECB;
	Thu, 29 Aug 2024 10:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724926844;
	bh=zSfbnEvAJQ+8+99lFeLACQv0eQOuY8TPDkGfaHoxOwg=;
	h=From:To:Cc:Subject:Date:From;
	b=poXy7rjqpb3ZgZjOPXX92l9M+WoiyZomfCRC3YGg1YIf+j5qh+nsPpk1MOMzpNxs8
	 ubvw3m8gqr0nn0Z5j/kuH82fXcqTIEahDZYWVGzmE7eMaVFYpGejJdm2WnSQJsntFj
	 MvGx+ie7ptatcTU/9qipwCaJa4MLbp8gW5p6juVJV5dTRc+4PD1opgmYQvPbge9tUF
	 mwg4ddoef6lNkIEsUSXYoA0sHyG3X5mP8ZkEdq2P5TXwxndq6yIOUePRwE0EkIn41a
	 bXz2YIUr8L/eTVo+KNtNuA+glfTcf8Ql3dmNYb8fCtHWscxbI8tnkS2zthHr4on1tM
	 No9rY9HGTcSzg==
From: Amit Shah <amit@kernel.org>
To: ashish.kalra@amd.com,
	thomas.lendacky@amd.com,
	bp@alien8.de,
	john.allen@amd.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	michael.roth@amd.com,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: amit.shah@amd.com
Subject: [PATCH] crypto: ccp: do not request interrupt on cmd completion when irqs disabled
Date: Thu, 29 Aug 2024 12:20:07 +0200
Message-ID: <20240829102007.34355-1-amit@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amit Shah <amit.shah@amd.com>

While sending a command to the PSP, we always requested an interrupt
from the PSP after command completion.  This worked for most cases.  For
the special case of irqs being disabled -- e.g. when running within
crashdump or kexec contexts, we should not set the SEV_CMDRESP_IOC flag,
so the PSP knows to not attempt interrupt delivery.

Fixes: 8ef979584ea8 ("crypto: ccp: Add panic notifier for SEV/SNP firmware shutdown on kdump")

Based-on-patch-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Amit Shah <amit.shah@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9810edbb272d..1775bac7f597 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -910,7 +910,18 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 
 	sev->int_rcvd = 0;
 
-	reg = FIELD_PREP(SEV_CMDRESP_CMD, cmd) | SEV_CMDRESP_IOC;
+	reg = FIELD_PREP(SEV_CMDRESP_CMD, cmd);
+
+	/*
+	 * If invoked during panic handling, local interrupts are disabled so
+	 * the PSP command completion interrupt can't be used.
+	 * sev_wait_cmd_ioc() already checks for interrupts disabled and
+	 * polls for PSP command completion.  Ensure we do not request an
+	 * interrupt from the PSP if irqs disabled.
+	 */
+	if (!irqs_disabled())
+		reg |= SEV_CMDRESP_IOC;
+
 	iowrite32(reg, sev->io_regs + sev->vdata->cmdresp_reg);
 
 	/* wait for command completion */
-- 
2.46.0

