Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5544B1E51E7;
	Tue,  1 Apr 2025 11:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743508701; cv=none; b=DBTMOcPCBzIRNct6F+519GN5DlJ+APFqrjTSmc7NABf1cyfi9JrF36pEwiwsjLukexgyIMXEiifZlpSpcSvusBVazeCVCLJNxUc3gBmn4JrkioHLdUxGl8WzlMALMmEuOjRHgnjvG5KVB6vfbiXvcMzKFujmHuG4q8nZWGO0zZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743508701; c=relaxed/simple;
	bh=7jGgpK8qQ9n6fLGlDYchkwfaXEMrN1dXXUgorto3Ylc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cuhcjq0Qu08PlrDQINsa/GoYYbOEe8DprL2piQW5F7dDiBdrZWRGUssorudUUPZBuCPqQiz9GaF09TgvajwdSTz9NDbe0bat5hn+7sb70NXlvmfbH2Jot/Ej9DQ//IghldJ3T2l401q/tH0KAXI35uZfpd9StGC0co3b1Bf0VeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UCJRBMoc; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UCJRBMoc"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43d0782d787so36200375e9.0;
        Tue, 01 Apr 2025 04:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743508698; x=1744113498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KanvA1m7FW/GqYde50MUMIMfUtRewOSi+lWetCQJygM=;
        b=UCJRBMocR/5KQQUa8CMgVEiQist6dKsu+I2Yv+v2TEb33+pwJvcyk068N7bh3XtAx3
         k2/qI/1IwIydcKvzWy2rtAhKz06jS4Z3JS+7+VsQv/TbPATLhyWDQFI7xFlNHRT/TEfj
         iJzPGKKXslAE1NwOO6Wi5lJkIUhwnICYd5HgGQq/okGdikz34vHNn0UvqqlWqy8xfKAq
         yoRmTHW2F6UeUQtDtPhd1q4nBmdNyqtTdWhFcl6Nxcs0SN388vcNkoukupnZFtCumqq+
         d5E1nvNWpdlcfzeuGzOYGiIj942MI2DxIVdWKOIIDtrq/djkSDRQLrM0IztFEUivL3/9
         oUrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743508698; x=1744113498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KanvA1m7FW/GqYde50MUMIMfUtRewOSi+lWetCQJygM=;
        b=T4ClJgadLZ1bJNnGQi7im+CtP/Q9PS5ywE9lhI+xRhKMp/0E0FiSuQPK0iPs+yXTJT
         cFUSXE96SQmgAhCAmwuAtX2gYn+2ZkHXhw0JlCYkGODp9sQN3eIzrL9v4471aUjEiut0
         PlGGijHOsoYsxVhKTQKG+Hs3uSUclS9R2m/p3kZmKXgZ95rYTzqLUMgWooW8IN/Zw+bG
         EYeBlkLvoD/X4NpUdevmgaFrTbYUhgQc4RiHS+3lwFLlZMnufU9qcKy1cQcJGz4yyjEJ
         Irokj4QVg3/jftsQpNFxIBT7ogVCBwoQyHZi49j57UT4p7pTQl/YyXD5eP537uhquGod
         pxXg==
X-Forwarded-Encrypted: i=1; AJvYcCWiD7G25Mqe+l4JmibDPEvDIyH+cW9rQNrByOlLtPZy0LydOdwV9Jc7bIxtF5b2G75bOEOWKzOZL5pdykWN@vger.kernel.org, AJvYcCX8zCsMg5kFSm8pGDve3wvguRle0D93e12TL/VEifA1nNBigeMFrE9LAc56AJdJU/kBMp/7UfBF+KtSVFE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSrtikY58nq3Sxpww7x2OR5O8CJTyEvJ3qNEmmsXIiGv+65YKo
	X+q4y0m+wys8C1UMlt2A339SZFgCdxINJvWrmSWwuZs660sUtbHY
X-Gm-Gg: ASbGncvFooq1+KAK9UdoZ1FX4HjBItNJvHb76j1LP433BzEVddd4qxAigIKUrhVuc5j
	kjhn01EAWQfsW3LXStrgl3zgpm4vdu5b/BWKzzHr8eQNKkwf5UYkxB4Mk7mUrauwImeTlCV0lp0
	YIbQGgxkZhNoQHS00pw/zKY9TiIZ+UlNMgYX8SI346cmcmSJ6XSGb0ijdElkUysffzTwAMPJGzJ
	BX0tY4nze36IknUI1HKyZkRvpr4UZVMbLsNq+YJp97zJUgxB61ezYrv/akfZv6KF4DnbgMS+spv
	6uRkIk8+PAzFUj1rL/SquuuzQbkwTAxdAZN7LMaXdT0+fKqff/ZF85wUxJCYjhqXy6V4tkrWLfD
	hLVC4GdIaGtHnRQrtxukX7P31
X-Google-Smtp-Source: AGHT+IECBNFX7PtxksIsQVDrR2DK+8zzgrgJQHq8DTNdbyhMlqJF7qUTFeCUtlbUOTo6/APJ7Ut5Ag==
X-Received: by 2002:a05:600c:3489:b0:43d:aed:f7de with SMTP id 5b1f17b1804b1-43db62b7a0cmr109300545e9.21.1743508698338;
        Tue, 01 Apr 2025 04:58:18 -0700 (PDT)
Received: from localhost.localdomain (93-34-88-225.ip49.fastwebnet.it. [93.34.88.225])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43d82efeacasm197565095e9.23.2025.04.01.04.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 04:58:18 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] crypto: inside-secure/eip93 - acquire lock on eip93_put_descriptor hash
Date: Tue,  1 Apr 2025 13:57:30 +0200
Message-ID: <20250401115735.11726-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the EIP93 HASH functions, the eip93_put_descriptor is called without
acquiring lock. This is problematic when multiple thread execute hash
operations.

Correctly acquire ring write lock on calling eip93_put_descriptor to
prevent concurrent access and mess with the ring pointers.

Cc: stable@vger.kernel.org
Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/crypto/inside-secure/eip93/eip93-hash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
index 5e9627467a42..df1b05ac5a57 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
@@ -260,7 +260,8 @@ static int eip93_send_hash_req(struct crypto_async_request *async, u8 *data,
 	}
 
 again:
-	ret = eip93_put_descriptor(eip93, &cdesc);
+	scoped_guard(spinlock_irqsave, &eip93->ring->write_lock)
+		ret = eip93_put_descriptor(eip93, &cdesc);
 	if (ret) {
 		usleep_range(EIP93_RING_BUSY_DELAY,
 			     EIP93_RING_BUSY_DELAY * 2);
-- 
2.48.1

