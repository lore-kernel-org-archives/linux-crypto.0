Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA7732E697;
	Mon, 26 Jan 2026 10:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769422287; cv=none; b=n6ck2NNGsDxpno4ET0t2PIl1CERMJFiBzWRdXozp/q1t+e5WmF9SmqUuFLGAJ+MToAuQyoxzzbH1t0Uszs6AB//pwLzxmXXK3fA6Mda+F0Lyc3+fwXQ0xDqvhiBPTbKnGIEzTSSnN2DbnhVtKTEnPCRSW+VbJYerQLMqYfSqirM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769422287; c=relaxed/simple;
	bh=fBZcq8cvRjheDHCvLXxrccPqA24+Mola9mvDT4gcPLU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q9VwMyjbclSO3/lCGPNwvs5tHevwPwIPgiSoAl8hHq2Ci3ZmbhBzjRD0HLznwPyANYacf+M1a/jx7vqcFYgLG84vu1e+p14n0fo5oSxjZXP86tzqiiLtePfaC6bskGmQPA1gXcWj12fJDe2ZoxgP0ozAVAV0V5WnCmJ7Ctk89J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7dAxoKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7dAxoKr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E179C2BC9E;
	Mon, 26 Jan 2026 10:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769422287;
	bh=fBZcq8cvRjheDHCvLXxrccPqA24+Mola9mvDT4gcPLU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=H7dAxoKrWDx/HdgM+UecgdSNqUzTLvhYkqidiceXqRYRaRhvMvIo0rJRR+buw45cc
	 3sht/20iEKBI3IT8JAYmXfHbshRl13FdO/KCXRQVF+Aq21f3/ybE9D0RgpsBa8hebJ
	 Fgimn0F2UJzo/hCEOgqsh8vi17Kh9nvVbWDjqT9WQwFnQuhnYKPSZKWUgZaSbjeOiH
	 RcXwTRSwPHn3UGHx7SD8aum7ueTjgZS75ar32/6iQGY5eI3wOhbzd1mlE5QlWCZC/s
	 O59pC5JdRPdVH/M0hZia7Rmca29prhqeTQUGUdOBZZX96/dQ1JLFKRCTiBJLTNaWLY
	 gPaSXrVwjZATg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570C9CF65D2;
	Mon, 26 Jan 2026 10:11:27 +0000 (UTC)
From: Rouven Czerwinski via B4 Relay <devnull+rouven.czerwinski.linaro.org@kernel.org>
Date: Mon, 26 Jan 2026 11:11:26 +0100
Subject: [PATCH 3/3] rtc: optee: simplify OP-TEE context match
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-optee-simplify-context-match-v1-3-d4104e526cb6@linaro.org>
References: <20260126-optee-simplify-context-match-v1-0-d4104e526cb6@linaro.org>
In-Reply-To: <20260126-optee-simplify-context-match-v1-0-d4104e526cb6@linaro.org>
To: Jens Wiklander <jens.wiklander@linaro.org>, 
 Sumit Garg <sumit.garg@kernel.org>, Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 =?utf-8?q?Cl=C3=A9ment_L=C3=A9ger?= <clement.leger@bootlin.com>, 
 Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-rtc@vger.kernel.org, 
 Rouven Czerwinski <rouven.czerwinski@linaro.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769422286; l=831;
 i=rouven.czerwinski@linaro.org; s=20260126; h=from:subject:message-id;
 bh=QLdJDajsDAHZ5Jp/WvnfqKpNSpcj2i8eHxM4elD1BXk=;
 b=hUChSt/PerjC7blQ6RZipCBKxqnlwex+ECe8CfZ0Wb6SYUNshrn+Zn+ndFsgEjw9ve3jh9TQk
 BW08OOTuUhyCZjXixJ0Uk91h8vNM070X6eNfQyVTmMuXGcKhVgSHyg8
X-Developer-Key: i=rouven.czerwinski@linaro.org; a=ed25519;
 pk=/5pmUK/XIAIIo8JA0axgfy1k8NRhRTQkxVwZYa1ga7U=
X-Endpoint-Received: by B4 Relay for rouven.czerwinski@linaro.org/20260126
 with auth_id=616
X-Original-From: Rouven Czerwinski <rouven.czerwinski@linaro.org>
Reply-To: rouven.czerwinski@linaro.org

From: Rouven Czerwinski <rouven.czerwinski@linaro.org>

Simplify the TEE implementor ID match by returning the boolean
expression directly instead of going through an if/else.

Signed-off-by: Rouven Czerwinski <rouven.czerwinski@linaro.org>
---
 drivers/rtc/rtc-optee.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-optee.c b/drivers/rtc/rtc-optee.c
index 184c6d142801..2f18be3de684 100644
--- a/drivers/rtc/rtc-optee.c
+++ b/drivers/rtc/rtc-optee.c
@@ -541,10 +541,7 @@ static int optee_rtc_read_info(struct device *dev, struct rtc_device *rtc,
 
 static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
 {
-	if (ver->impl_id == TEE_IMPL_ID_OPTEE)
-		return 1;
-	else
-		return 0;
+	return (ver->impl_id == TEE_IMPL_ID_OPTEE);
 }
 
 static int optee_rtc_probe(struct device *dev)

-- 
2.52.0


