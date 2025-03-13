Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC26268FD2;
	Thu, 13 Mar 2025 15:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741879784; cv=none; b=mzpc2F5XtWdwH93LayQIjhhK1OIot7utApn/zF8xk3HfgKWKryGk+MSVnFnrWrEFA/LJTaI+tS4ZyTZa2QXz4JuW4GLSM+oVSZi9o8tTufvHw3Z2hMWiX1VR4+mK7QrUx3+jyXDJpUUj9db8uNMjmul93PIksAh/Q0d882QxPTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741879784; c=relaxed/simple;
	bh=p8oj2k04SR0Y4Adn+a0Scom7cwlrttmkdwEQiX14sqA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=k8VnqVArJbxtp77vWjvCpmt/OOGFT27oWYc7jVqtYzhf2rkWZLmzCa4w6Pe6KNmyGN+imTznn2MQuoQ6xyxIiHQcraOIh+EB/rs1tbhxVs8idNbRs/zJwcs00NWAvdEXO3FPCTSomWPcrpDU0cR84YqUC+2QPEju8avHddMzCsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lXO9s5IA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lXO9s5IA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A42C4CEDD;
	Thu, 13 Mar 2025 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741879782;
	bh=p8oj2k04SR0Y4Adn+a0Scom7cwlrttmkdwEQiX14sqA=;
	h=From:Date:Subject:To:Cc:From;
	b=lXO9s5IArrkSjpRoMHcC9AIMA/uVv8qTkrE3sC5fWdjFDFGDh/te3HcZLIha4Qbu9
	 s4Qo2FCTvpDxt81rkSBoN6FnSHhKys1R4R2LS0NIyA1mmSkNKVQg5TEzDKs+7CM2LL
	 Wb98ZG8CDZtsPPjdtxnUUXvoFTGT83jYZm+EQ6dIzRBX+b9qGnnjPTjp2o7kiL3m0H
	 pFA6BdgZLCek+lBRzv3+ZCeTwaVlLsjOFVS8JL1ohzA+AWXcRyIRswl8VoEFl9xSOm
	 dr54bmng/pBjHtgSN/AhgsxpmEdvXMK177krQmusJuasVdyZdxWamJrHs8IjwaE/WB
	 uTzE7MNNp5yOg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 13 Mar 2025 16:29:31 +0100
Subject: [PATCH] crypto: tegra - Fix format specifier in
 tegra_sha_prep_cmd()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-crypto-tegra-fix-format-specifier-for-size_t-v1-1-0b957726c9e5@kernel.org>
X-B4-Tracking: v=1; b=H4sIANr50mcC/x2N0QrCMAxFf2Xk2UDbKTp/RWSELp15cC1JEd3Yv
 1t9PBfOPRsYq7DBtdtA+SUmeWngDx3EBy0zo0yNIbhwcr3vMeqn1IyVZyVM8saU9UkVrXCUJKy
 /AU1WHisGPxBdBpqOZwftsig35Z+73ff9C7lHKjp+AAAA
X-Change-ID: 20250313-crypto-tegra-fix-format-specifier-for-size_t-219aa89ad470
To: Akhil R <akhilrajeev@nvidia.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2429; i=nathan@kernel.org;
 h=from:subject:message-id; bh=p8oj2k04SR0Y4Adn+a0Scom7cwlrttmkdwEQiX14sqA=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOmXfj5lXHuTb8EXPdeYZcbsjh+mzNr2vq0vTkHt6ucdP
 MLsu3VjO0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEnJQZGVZs/Lrw29+o+2mH
 pA9wr8zv53draj+x4GzULeOzUlJH/A4wMsyQfiXx0e8nj52W+f3jEbsVxb8diDT/L7A3R3XhwWf
 Zj7kB
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building for 32-bit targets, for which ssize_t is 'int' instead of
'long', there is a warning due to an incorrect format specifier:

  In file included from include/linux/printk.h:610,
                   from include/linux/kernel.h:31,
                   from include/linux/clk.h:13,
                   from drivers/crypto/tegra/tegra-se-hash.c:7:
  drivers/crypto/tegra/tegra-se-hash.c: In function 'tegra_sha_prep_cmd':
  drivers/crypto/tegra/tegra-se-hash.c:343:26: error: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'ssize_t' {aka 'int'} [-Werror=format=]
    343 |         dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
        |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ...
  drivers/crypto/tegra/tegra-se-hash.c:343:59: note: format string is defined here
    343 |         dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
        |                                                         ~~^
        |                                                           |
        |                                                           long unsigned int
        |                                                         %u
  cc1: all warnings being treated as errors

Use '%zd', the proper specifier for ssize_t, to resolve the warning.

Fixes: ff4b7df0b511 ("crypto: tegra - Fix HASH intermediate result handling")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/crypto/tegra/tegra-se-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 65a50f29bd7e..42d007b7af45 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -340,7 +340,7 @@ static int tegra_sha_prep_cmd(struct tegra_sha_ctx *ctx, u32 *cpuvaddr,
 	cpuvaddr[i++] = host1x_uclass_incr_syncpt_cond_f(1) |
 			host1x_uclass_incr_syncpt_indx_f(se->syncpt_id);
 
-	dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
+	dev_dbg(se->dev, "msg len %llu msg left %llu sz %zd cfg %#x",
 		msg_len, msg_left, rctx->datbuf.size, rctx->config);
 
 	return i;

---
base-commit: eca6828403b80343647de39d4782ee56cc9e36dd
change-id: 20250313-crypto-tegra-fix-format-specifier-for-size_t-219aa89ad470

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

