Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDC915746E;
	Fri,  2 Jan 2026 07:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767339129; cv=none; b=TAA9Hm7FJr9T2cQ/hngCWQN+qpGJyZfoRbwPgg0AZB27Unl8VbA9MoLv5gSricUf178XD9zBRI6uT41/KxkQrm0lhTDIDGQdk6wAtwM5POdmlkhmct37o/fgv6vdhKYVzGZuQ+MoD+OjJI/jSoe4he0XlV2tb5CDe6qBKEecQU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767339129; c=relaxed/simple;
	bh=dLGtrV8CGpvPR2dh638xUO2D7i6xFqkRp07EoA96iDo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=jrHuv6AU4gx6p6g7eHzo6ov6waYIlnTHJ9L9rBQQvVCaZVw8JbOuKp3wW484if6e4dTm7ZRdFcu3pRhm2ksHRM8PghxMDB2RfdZT/E1SiwhFbR5itFrMZt4LyHADbgFyz5J+4QwfD1WCY0UMOXt8waRXswWglvc4dNF8T3kevYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=SAJlC1NO; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=zmX3shBE; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="SAJlC1NO";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zmX3shBE"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1767339125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tIeGu7Pj9VWmsXD8Zwc+QOWYBlZbXmchYh8XcXs1PY8=;
	b=SAJlC1NO5mDgzhBkjzijfLwIx9u0mIWDlpozKMq3oDOU88bik2pqFRuql3zrAmmmd2ef8P
	nL9/oNdOOxP1RI5haJMHXk74gs19JMAnbM8QxC4GoVHRLZtbpxvOPYnBoURpFgQmQbdgFu
	ioaJ7FL87Lojwr6YU982IxvwtEbeNYj13t8EaAp71o6Ogyuifh5TJOk+uO3KXgab+pTZOV
	xZfs+1v0ldfPO37qT4He8JWH8oQ4jBd+3Mv1+zWrhaz9AUEr5sEa60NySqDUBfYuOX8Jrx
	I1exf5+iLOfFAd3gX7flMoqciNDFMi3ZmOPjzCjDKnqD6SmUGhqiVyFwGzUm/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1767339125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tIeGu7Pj9VWmsXD8Zwc+QOWYBlZbXmchYh8XcXs1PY8=;
	b=zmX3shBEPFV3jIwbABHvsngab359RlPWl6jYyz71Yoq59ba/5BdrXFipaF5fIgWaL3yOfy
	9XWs5uvJqbbBJrAw==
Date: Fri, 02 Jan 2026 08:32:03 +0100
Subject: [PATCH] lib/crypto: tests: polyval_kunit: Increase iterations for
 preparekey in IRQs
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260102-kunit-polyval-fix-v1-1-5313b5a65f35@linutronix.de>
X-B4-Tracking: v=1; b=H4sIAHJ0V2kC/x2MQQqAIBAAvxJ7bkGNIPpKdNhyq6Ww0JIi/HvSc
 QZmXgjshQO0xQueowTZXQZdFjAu5GZGsZnBKFNrUylcLycnHvv2RNpwkhtHq3RDRANPGnJ3eM7
 6f3Z9Sh9GyPQlYwAAAA==
X-Change-ID: 20251230-kunit-polyval-fix-cd018aaabef1
To: Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767339125; l=1310;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=dLGtrV8CGpvPR2dh638xUO2D7i6xFqkRp07EoA96iDo=;
 b=/adsqzk8PjVdaUCZelaHH+lX38OGnWbBQ3xG0C084vOi0Kfs6WNObgpBSm3S4ILiAGWtUeJw6
 24beLdeGTFPCOf9BhnaqsreksuKhtROPfaVCi44gEU0iZwcG4tnJzVL
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

On my development machine the generic, memcpy()-only implementation of
polyval_preparekey() is too fast for the IRQ workers to actually fire.
The test fails.

Increase the iterations to make the test more robust.
The test will run for a maximum of one second in any case.

Fixes: b3aed551b3fc ("lib/crypto: tests: Add KUnit tests for POLYVAL")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 lib/crypto/tests/polyval_kunit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/tests/polyval_kunit.c b/lib/crypto/tests/polyval_kunit.c
index e59f598c1572..f47f41a39a41 100644
--- a/lib/crypto/tests/polyval_kunit.c
+++ b/lib/crypto/tests/polyval_kunit.c
@@ -183,7 +183,7 @@ static void test_polyval_preparekey_in_irqs(struct kunit *test)
 
 	rand_bytes(state.raw_key, sizeof(state.raw_key));
 	polyval_preparekey(&state.expected_key, state.raw_key);
-	kunit_run_irq_test(test, polyval_irq_test_func, 20000, &state);
+	kunit_run_irq_test(test, polyval_irq_test_func, 200000, &state);
 }
 
 static int polyval_suite_init(struct kunit_suite *suite)

---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20251230-kunit-polyval-fix-cd018aaabef1

Best regards,
-- 
Thomas Weißschuh <thomas.weissschuh@linutronix.de>

