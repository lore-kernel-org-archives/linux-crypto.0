Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B7A322DA8;
	Mon, 18 Aug 2025 13:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523767; cv=none; b=qJY1FXmx0DIfEgAP0QdvIYm3ggjp+QTt9yGGx0fDj3pLt6D9wslWrQbK5IN3W3dK3sju+4sN6gADPB48g/ZP3sWf92zS0R+BrflzgI0TCvYH6H/t5wk5CSAE4JeFbOBRFT9DZq5uu3FpSi958ww/D5JsisdGPYfRCpJ/RZlZdlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523767; c=relaxed/simple;
	bh=IHPCL9NciFRTPjsEAA6jgQki23Pf5YryMMxNG/u9Jvc=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=eb54wiGzXs+TH3w7aFxsIJGG5e7hetQPWoggRu3GSwV9BNKTOpq7EE5HezTLjJPeY4G6LZes8k4Qcpfp7X7z2JDC2m3+IBItVzKchLlcuIuXILH/gvY7C1US1QUC9cLQDK9xy94OP+cul9z6E1yhKC0sZpufUMCAIJuaBok+h6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=ys3fxudx; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="ys3fxudx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1755523459; bh=YFDrAEjU3496y8AhHqyJeA7JDgzWZh949O3UUTcG2ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ys3fxudxqdvyILTat3pR0jxauYiH+2NmXda33oH37gjyvbixDCX85OCwblMmKKCbg
	 iEMRSFbAbqwN8qMdK3ifQI8zW4gmKGlgjegRJ5D5QYsXbB825k4ng9fvM1GVvBPu77
	 qGSSV+AhkjUDebKwMyfch+6P1o3gETPtnpovotNE=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.230.220])
	by newxmesmtplogicsvrsza56-0.qq.com (NewEsmtp) with SMTP
	id 610A60F3; Mon, 18 Aug 2025 21:24:16 +0800
X-QQ-mid: xmsmtpt1755523456tagj73z4m
Message-ID: <tencent_65C6578989EEED6EE78C8B67E586DE92EB06@qq.com>
X-QQ-XMAILINFO: N7h1OCCDntuja/RQqnIxE4tzzwahIh0BXszjdCKfCd3rEGinhnU9oeCSPeZuA9
	 R9foEhMJCmZmVvDIjG/Vuf2OLC+3cO4c/qdCr2C3QaPH+jDjaRPFIT10R/iZogNXo28utE9SdpBz
	 87OIo+thwO87OL0sIyelAn67IM2J7VXuxwz1uoXfLuRD540CjO4bo3SsTVDzGXNI87Z+RCH25g28
	 evM82xJMcA3S5GDuC1AQH7XhpBFHSePmx14AEc4jwZEDoWQXHM6gAEt8MSX7H/vWLBJj/z0ewMHl
	 9/5u6DX2hyvGGm87t4ryqZI55RK2vEnmRIHnB2rS6a2FL36oVj1HU0t6awJTJ55xDKvgbYcu/LPM
	 vTEzpLEh0c7/GsDinNravA7FYAOFFX/J8xxuvNBW42Q1qRYAEBgpGSZD0kqYOAyV7fv25D1g6cEm
	 +IBPPsGodjw8avpNyZfFYikMyHLO3LGpVr6GxQThevcErQvBCfLtvpwSCheNp37Ri2Fprga4FL/K
	 ix1qJcPLDpcgM6qouS7hLBB5cqIn2LzL87jhJPbAF+ojNVBOSB0ho3j12vfMeOgnjP1cVhB9QeEO
	 s/IPdjEW7r2sm0kxAsYStLRKLnUjzjQddFg1eH6jl/kHLYiMO7mTV6Z0KHa+gd8P1PauCIdgVrli
	 BRt4FCapk0H6jQDzv+hC2DCsiZbKcCDrNX7s2+k8+TmXCYQU6SGMgKmR3ZErPY+uEg67qW8xzsDR
	 kznyGpAJBNs5yHHWdH5mgXXnWj+0RzvciJmf6e4xuCcQKK7+N8AuK+Nfc6J+Hf5iztk/z8HKc2IB
	 Ne8Q7fGTNxC30zu1ouwV+av/C1DiuRbX6VvpP9mEBiG3XhCNAkhnc0Y7vHm7/QDMjoeGbqObLeLJ
	 NvHLL5XtHmXWDCW0YD9p818Fvf7rAvcxVXxyjrDoQ1+XPzV3g3RFnkFhYGDFfLCS20W6AQwTEYTR
	 rl2jeFhJ2SdAQ72k+kS3s8N3KWDkj2yLHRa7PUzfd/Cwa/7YFiQdR8GRZsI8bEQ3HbuGAdBU7PgE
	 PfSSgYSmby83jV5HwZh0E7PSg42ihgeZqtKz2XmLvIyeEN8Hb7
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Edward Adam Davis <eadavis@qq.com>
To: smueller@chronox.de
Cc: davem@davemloft.net,
	eadavis@qq.com,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH V3] crypto: Mark intermediary memory as clean
Date: Mon, 18 Aug 2025 21:24:17 +0800
X-OQ-MSGID: <20250818132416.506338-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <7740195.jRhZ6ZUK3Y@tauon>
References: <7740195.jRhZ6ZUK3Y@tauon>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is not a leak! The stack memroy is hashed and fed into the
entropy pool. We can't recover the original kernel memory from it.

Reported-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e8bcd7ee3db6cb5cb875
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
V1 -> V2: mark it as unpoison
V2 -> V3: replace to sizeof, minimize the possibilities where inconsistencies can occur

 crypto/jitterentropy-kcapi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 1266eb790708..4020a6e41b0e 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -117,6 +117,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 		pr_warn_ratelimited("Unexpected digest size\n");
 		return -EINVAL;
 	}
+	kmsan_unpoison_memory(intermediary, sizeof(intermediary));
 
 	/*
 	 * This loop fills a buffer which is injected into the entropy pool.
-- 
2.43.0

