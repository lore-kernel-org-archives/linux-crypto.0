Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C3034B426
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 08:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773388995; cv=none; b=P9dzJ7PPHCCmJ9Zi+JTKpHkEOU3dtjqbrD11uuxnOwTRjDB1ElIP+HGggm8FpPabw+CVX0YLVCCKWM5FxwmW3CHcevjUkwgPBiWVwkmU0h2GmJVf3eiFGxyy7GRYeBFA09BYe4vQArZPi1XPAdGnzaCJXDqUcz54ppYRAxzi2vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773388995; c=relaxed/simple;
	bh=pNhBiBnGlsup2xZ7gmRzMFRIGL8CZdq7C81+s6XAZm4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VgAzBqKg0niJSkPWEm4hwlBZGzDojHBNOQShsnVqZW7nfqzCf+GOe96UMZwvehbE95blMMUnL87xGUojrBrO7PoqxcQhCnQ+ReBWstMSuqcvGIExLlGasVsqOQBWcLosYPybbA/tABvLsg8FXM3PO95/Y9Jq5IFXiAZi3bL6xWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1773388987-1eb14e06ea0ffb0001-Xm9f1P
Received: from zhaoxin.com (zxmail.zhaoxin.com [10.28.208.166]) by mx2.zhaoxin.com with ESMTP id 31EK1NL8U9RBNbeI; Fri, 13 Mar 2026 16:03:07 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.208.166
Received: from desktop-a4i8d8t.zhaoxin.com (desktop-a4i8d8t.zhaoxin.com [10.32.65.156])
	by zhaoxin.com (f222c4) with ESMTPf8480048f9d7ab25467bd880f05d502d
	Fri, 13 Mar 2026 16:03:06 +0800
X-Eyou-Smtpauth: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.32.65.156
X-Eyou-EnvelopeSender: AlanSong-oc@zhaoxin.com
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	ebiggers@kernel.org,
	Jason@zx2c4.com,
	ardb@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: CobeChen@zhaoxin.com,
	TonyWWang-oc@zhaoxin.com,
	YunShen@zhaoxin.com,
	GeorgeXue@zhaoxin.com,
	LeoLiu@zhaoxin.com,
	HansHu@zhaoxin.com,
	AlanSong-oc <AlanSong-oc@zhaoxin.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 1/2] crypto: padlock-sha - Disable for Zhaoxin processor
Date: Fri, 13 Mar 2026 16:01:49 +0800
X-ASG-Orig-Subj: [PATCH v4 1/2] crypto: padlock-sha - Disable for Zhaoxin processor
Message-Id: <20260313080150.9393-2-AlanSong-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260313080150.9393-1-AlanSong-oc@zhaoxin.com>
References: <20260313080150.9393-1-AlanSong-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Eyou-Sender: <alansong-oc@zhaoxin.com>
X-Barracuda-Connect: zxmail.zhaoxin.com[10.28.208.166]
X-Barracuda-Start-Time: 1773388987
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2511
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.62
X-Barracuda-Spam-Status: No, SCORE=-1.62 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 tests=BSF_SC0_SA085b
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.155781
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.40 BSF_SC0_SA085b         Custom Rule SA085b

For Zhaoxin processors, the XSHA1 instruction requires the total memory
allocated at %rdi register must be 32 bytes, while the XSHA1 and
XSHA256 instruction doesn't perform any operation when %ecx is zero.

Due to these requirements, the current padlock-sha driver does not work
correctly with Zhaoxin processors. It cannot pass the self-tests and
therefore does not activate the driver on Zhaoxin processors. This issue
has been reported in Debian [1]. The self-tests fail with the
following messages [2]:

alg: shash: sha1-padlock-nano test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
alg: self-tests for sha1 using sha1-padlock-nano failed (rc=-22)
------------[ cut here ]------------

alg: shash: sha256-padlock-nano test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
alg: self-tests for sha256 using sha256-padlock-nano failed (rc=-22)
------------[ cut here ]------------

Disable the padlock-sha driver on Zhaoxin processors with the CPU family
0x07 and newer. Following the suggestion in [3], add support for the PHE
extensions to lib/crypto. Only XSHA256 support for SHA-256 is included,
since SHA-1 has been cryptographically broken, as recommended in [4].

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1103397
[2] https://linux-hardware.org/?probe=271fabb7a4&log=dmesg
[3] https://lore.kernel.org/linux-crypto/aUI4CGp6kK7mxgEr@gondor.apana.org.au/
[4] https://lore.kernel.org/linux-crypto/20260116071513.12134-1-AlanSong-oc@zhaoxin.com/T/#m49436c4849dd64454b3554c105197ef9c61db23e

Fixes: 63dc06cd12f9 ("crypto: padlock-sha - Use API partial block handling")
Cc: stable@vger.kernel.org
Signed-off-by: AlanSong-oc <AlanSong-oc@zhaoxin.com>
---
 drivers/crypto/padlock-sha.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index 329f60ad4..9214bbfc8 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -332,6 +332,13 @@ static int __init padlock_init(void)
 	if (!x86_match_cpu(padlock_sha_ids) || !boot_cpu_has(X86_FEATURE_PHE_EN))
 		return -ENODEV;
 
+	/*
+	 * Skip family 0x07 and newer used by Zhaoxin processors,
+	 * as the driver's self-tests fail on these CPUs.
+	 */
+	if (c->x86 >= 0x07)
+		return -ENODEV;
+
 	/* Register the newly added algorithm module if on *
 	* VIA Nano processor, or else just do as before */
 	if (c->x86_model < 0x0f) {
-- 
2.34.1

