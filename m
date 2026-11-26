Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795672564;
	b=4UFavqXqC2asWhWrqERhD2RKlYpfmWr9Wzm3AyZT9PTWNhcsPBeW58QyBaekSBOyHnLI
	 xSeE+hLMQMTWWMf3qBiFtRLyDbjz1o6+cahRgzOhB70D1kq5k2TSuOlEKI1Dl7SU5aMvI
	 EouZaD4I3Pe5dkv3XMt7NIsxccOJK1p9Q+bTvOvGWwlcGAuRhOgKDoyUnd/4o9U+Sgal/
	 KWB75i4YVuIHuW3M6Qc/la4OyIIDRE4PbqZyNeswABW7mbhVcI5AorMzZSVQJpWYWjm6P
	 c1Dqdn+XS9hNzHzMoXAK3ml6skuqtS/f8c+CaYFrQ6bGv3bzCIz2Otq0jtt8r5pJZXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795672564;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=f9W/X3ZSGPrXignHGoNXmPj3EgNkTGQgkxY9HizUk10=;
	b=0i7UrZmuUgdmPnlexTfb+3ZeVdRKBziZckV4bxNYnccE9ulNWnh/Zlr0TblHxtx5gmzQ
	 tk25A9PJ9b6k/xVItCcZ8iKjzGlZhOsfAhaZL9y88XxGe7KLRN2OXMedUUr7DHfws/yu0
	 BJ/ZwRkdhNKHWtlA2y3N3J2ZxM//qIaWgJhGCCuZ/j7Z7rX5naAxT6gnNOMqcErLOVht/
	 lM2akPRGNno1l3BkIL3jZkLhQhZVnm7t5wthD+c2xoLMQBCWHKt/uo8aUFSgn5cr0qu/g
	 SMDtVULGHpP+jP8hYQ+XnVv6PNq86yp6lVGqqQB8re6RYwMbXTlO6mxwJTlB6WMblZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FG7buiis;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C054606A31E
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 05:56:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C054606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FG7buiis
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b405d8f1cfso3345749a91.3
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 21:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795672564; x=1796277364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f9W/X3ZSGPrXignHGoNXmPj3EgNkTGQgkxY9HizUk10=;
        b=FG7buiisxYEulSoe5M2X3xjYextDw1OYO1+X5KmGszrbI37LvW5D07w8n+bLsGW7gt
         4rlNqEcBrnPBma4oBOENKENfKWv7oxElu9Aau0onjsMPsqVcRqldA6FeeyfZRw754GCR
         OcolyDEpVjr57AAjMJdUqPT4SVbiSRIX8xuURu3O0Ju0/YWnO/SX31fVtpFCCzyaxWLf
         DfKEQ8BFCK0AdpsccnD7cfiCkEtl961oRBW4voZ21WPK+PAc57f3mZufvcRjJoI1Pp0Z
         f0Tl3iQhOIc4JwYJA7gQEKa97J08fTdlnvpvHVZLPbn32wJcoP7h4nrqaofWdfmrq/ks
         e1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795672564; x=1796277364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f9W/X3ZSGPrXignHGoNXmPj3EgNkTGQgkxY9HizUk10=;
        b=CcIWb0kdD7TmJnrqLLDE0lkO9gLUZBOJhADnbs0quq48IyAsqNHy4BRCjdViFe0ecQ
         3O63bdvO/auciLISkw39hmgh4hFQEtHbqdVHv7yCzLZMJEyf/bli1Qw3QAkctkH+4+Ad
         CD56XOEwmU6lODH7xgeRz+jIjBoe7iVNVjPT7J9f2tAf9ZMnpUrzOMrp2nuhQN7IU1iL
         fgGQWwAEnh+23FamEbxUICIt6uIE8cMNkljS70urjDZ4N4nFanBFIzu9XBWTp1VwiKli
         +Cg588Ya0fWEXhDahkUMUFuHKD/PEEqe+Raj19BnBANtiOrWT+F6Z8oLEAzGAK9Yp9dw
         nY3g==
X-Forwarded-Encrypted: i=1; AL+hErEFzOQZ+TYv5py0mWyAlh+63oh4LZgqIr7fCVmVviDu7Yixdu8OJfxnKUJ95VYfj98cCW3UpjY53vXrGJU=@vger.kernel.org
X-Gm-Message-State: APuU4Z92Nz1nCG77QB3jMzfjRZBXONt7hkX2WQu1U2CEv6g4qRAPT0BK
	Yo0QOVYnrRNYOdr9DRTnCFAk17WybScOnnohDppIpS/Gc2jwcAtfZFry
X-Gm-Gg: AZFdTZfzwbs2/Vnt+shzbuwyR1n33tDg5wie2D3f02ZCXiKF0gFf+yQj1XcmWx5icFU
	sAHZbXL9wS1VqW59x4+V4CObAa5PTaSmljlBtBQBxoAYiQlJQ7XRzwveqIT9m6ILX/RhWJAeQ0F
	h3RstMTUa5sN3ERvmujz8wjMHFDrWD381x7Zgjm/aFzP8KvG7yhKcdSqr/zAPsxYVD0vfmBhNJi
	fDcNx5sJouGBvYsYSQd904fWuzXjnULr62eiPlRVafYV1AHA2+PwwuQadNagBCyINI5AJoV3bOW
	uqi7vvbewG0iJeleeETGlByKdX8EiSzExX64Cdwsyu76xrHs/MJ7nW0zAE2cSauIR/uXWfCE2UG
	G+g0Nz2NLRR2ioWciEu5X080hhvMGLWf8hF5dD5FIcJFsq1eZ7TRMm/srhL/Uq+oTKedz9yQpoy
	nU+bVmXnOIAH6snY+pKZ7x51DLSlSm/Odq7TZkMsOyBR6VOVYt0OPYj6LMCm5jnzUX3SFNjg8it
	SRw40PxtZEg5B6Qih/31Xy/Y75XvSDO8DBR53kXq8aA07pihhg993TThEPpXgkmTjs1RKlKBvUg
	1NznLf5RuhjOIqvxzGFE8+M1bcL8sXqCt/WM/Am7OI8M37bNFQ==
X-Received: by 2002:a17:90b:3843:b0:3b5:29e:11b3 with SMTP id 98e67ed59e1d1-3b5029e144emr2879706a91.61.1795672563597;
        Wed, 25 Nov 2026 21:56:03 -0800 (PST)
Received: from fedora.tailc1fb0a.ts.net ([172.219.65.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad8e93asm30760213a91.11.2026.11.25.21.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 21:56:03 -0800 (PST)
From: Artem Novak <artem122novak@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: anirudh.venkataramanan@intel.com,
	mark.d.rustad@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Artem Novak <artem122novak@gmail.com>
Subject: [PATCH] crypto: tcrypt: avoid 32-bit overflow in throughput calculation
Date: Wed, 25 Nov 2026 23:56:00 -0600
Message-ID: <20261126055600.23172-1-artem122novak@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cast bcount to u64 before multiplying by blen to prevent 32-bit
overflow when calculating throughput on 32-bit architectures.

Fixes: fdaeb224e2bf ("crypto: tcrypt - Use pr_cont to print test results")
Fixes: 3e3dc25fe7d5 ("crypto: Resolve shadow warnings")

Signed-off-by: Artem Novak <artem122novak@gmail.com>
---
 crypto/tcrypt.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index e6834bdde9b9..1e6132045c24 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -28,6 +28,7 @@
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
@@ -734,6 +735,7 @@ static int test_ahash_jiffies_digest(struct tcrypt_ahash_request *treq,
 {
 	struct ahash_request *req = treq->req;
 	unsigned long start, end;
+	u64 bytes;
 	int bcount;
 	int ret;
 
@@ -744,8 +746,9 @@ static int test_ahash_jiffies_digest(struct tcrypt_ahash_request *treq,
 			return ret;
 	}
 
-	pr_cont("%6u opers/sec, %9lu bytes/sec\n",
-		bcount / secs, ((long)bcount * blen) / secs);
+	bytes = div_u64((u64)bcount * blen, secs);
+	pr_cont("%6u opers/sec, %9llu bytes/sec\n",
+		bcount / secs, (unsigned long long)bytes);
 
 	return 0;
 }
@@ -755,6 +758,7 @@ static int test_ahash_jiffies(struct tcrypt_ahash_request *treq, int blen,
 {
 	struct ahash_request *req = treq->req;
 	unsigned long start, end;
+	u64 bytes;
 	int bcount, pcount;
 	int ret;
 
@@ -777,8 +781,9 @@ static int test_ahash_jiffies(struct tcrypt_ahash_request *treq, int blen,
 			return ret;
 	}
 
-	pr_cont("%6u opers/sec, %9lu bytes/sec\n",
-		bcount / secs, ((long)bcount * blen) / secs);
+	bytes = div_u64((u64)bcount * blen, secs);
+	pr_cont("%6u opers/sec, %9llu bytes/sec\n",
+		bcount / secs, (unsigned long long)bytes);
 
 	return 0;
 }
-- 
2.56.1

