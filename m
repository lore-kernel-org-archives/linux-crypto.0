Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9EA3D3311;
	Mon, 15 Jun 2026 09:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781514689; cv=none; b=ntK8KarC7qMVVWKVCc963XMm8773LX+dooePTwWrHy1QqpZZGjo2Vl8HNYtmKL1lJYfB5epWbdor6CrHVt+iGCwYcNbcc5TW2HRtQiineo1Kgkjjm8rY96406X03CDgr72XZqjpN2+l9WI1on644Y8dzuxRYf8//ehxohveLXDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781514689; c=relaxed/simple;
	bh=NOZlCSEv3F8FwatBQ8BSA4difxWE5jFw5B7XM5Jh0/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LRHoYLoZnHsG3nG0YkN31B+1ELcLpBtgY5PiaGSRxlJpkE6bK+S5N2KAEHCCA12Zd5HV7i2UAOQuFhMdB0GnXoOg/TvMjUQ9Y5bJ0Ea89gRLlgq8hRJ1esUSRjTHi0Nad1JVV99usIJ8j1D+Tmtbf3DRK/BV2VnmHd1lhSD3tBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-03 (Coremail) with SMTP id rQCowACXt96zwS9qdl7LFA--.28827S2;
	Mon, 15 Jun 2026 17:11:16 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] crypto: sun4i-ss: remove debugfs directory on teardown
Date: Mon, 15 Jun 2026 17:11:13 +0800
Message-ID: <20260615091114.97190-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACXt96zwS9qdl7LFA--.28827S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw4xCFW3Kry5WFWUCw1xZrb_yoWkWrc_ur
	WrWrn7JrW8Ar90va4fXry3ZFW0qrWrJry8u3WIvFW3ta47ZrWrWF1xur4ku345AF4DCF98
	Z3yqvrsxZayj9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUQZ2fUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

sun4i_ss_probe() creates a debugfs directory and a stats file with struct
sun4i_ss_ctx as private data. The remove path unregisters the crypto
algorithms and tears down runtime PM but leaves the debugfs entries
published.

Remove the debugfs subtree before tearing down the driver state used by
the stats show callback.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
index 58a76e2ba64e..bcaddf1b83ca 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
@@ -512,6 +512,8 @@ static void sun4i_ss_remove(struct platform_device *pdev)
 	int i;
 	struct sun4i_ss_ctx *ss = platform_get_drvdata(pdev);
 
+	debugfs_remove_recursive(ss->dbgfs_dir);
+
 	for (i = 0; i < ARRAY_SIZE(ss_algs); i++) {
 		switch (ss_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
-- 
2.50.1 (Apple Git-155)

