Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0FE270ECC;
	Wed, 14 May 2025 11:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747220880; cv=none; b=IPmCl2m5aC7o7HW8fR8Euu0293TJbf/8aNCApSon8pJBQgtUU0fkMoJti9J/KUEtEtnbuWtQyZvZi07PwP2iGcDvbKOzRuqn7cLdRwApk0pUEX+GNUKpfCoaMDbzUIicuwdMG/MMVq5ocEiraZSuZIPZIKn8zhdo4TqOepEmjy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747220880; c=relaxed/simple;
	bh=73MAWfA/IcO6qc1HMLCTk5s8ngwMfvoWX72M1v6KFDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLdFXmFWsgYx3IcuHR40+bAMDMenYDus1031tSFdkz5rz1vp0w8pyMkZjkzVe9BE02/zAndT9Sut5BLnE7PqOQ6mf2kIcssuAHGWcAHSAqNVUKICw8zNXQKqqYEEznkN2Qy9z0CEJhDz9HYJ6PrnKp/OIYqaEMAtsikLe/ARxYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=GrHGV44E; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Qgl4x/BN; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="GrHGV44E";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Qgl4x/BN"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1747220877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MzP2WP1u1oln3HgOxIAj7QaI8u7I75pQZbUSzwXdfFg=;
	b=GrHGV44Eza4WsQIBCBpGNdb2Wq/OjAWa2FWavMwvcw42nJF/R15l+o6MT5yJn3Sz8obpYw
	YNCF7NibSW6BaG4lmAJ6s1/3XBlTDQZGAJUV1zpm6Dvs5NVfo8d8IBmBUosJde69wfi1Ct
	sNmG2kpvvbGhi43QEgg0sIj7n2W81pqVkIzY9/wqbx7MVnPxc3fr5j0jeqOxtz/nMyIn0i
	5p5vd1INlQdoaMFJiUTZ/4h+Ndc7D2fXFxJv59G0W5AjdUKJgI0fjParIemr3sc0MhcN5R
	cMk7iJ4FCOoalMWB6bv+i0eyypRqaXDf9z9ehuDRIvmaDIoWQiOQnGbCJJghMQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1747220877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MzP2WP1u1oln3HgOxIAj7QaI8u7I75pQZbUSzwXdfFg=;
	b=Qgl4x/BNFjj1kLLG9C280mmnRC+Ietv66Yro7W7v49W+jD+R35AMc0ctXLFaa4bXnRcx5b
	vEE8YkFmsu+R/yCg==
To: linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: tglx@linutronix.de,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Subject: [PATCH 2/2] cryptd: Use nested-BH locking for cryptd_cpu_queue
Date: Wed, 14 May 2025 13:07:50 +0200
Message-ID: <20250514110750.852919-3-bigeasy@linutronix.de>
In-Reply-To: <20250514110750.852919-1-bigeasy@linutronix.de>
References: <20250514110750.852919-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

cryptd_queue::cryptd_cpu_queue is a per-CPU variable and relies on
disabled BH for its locking. Without per-CPU locking in
local_bh_disable() on PREEMPT_RT this data structure requires explicit
locking.

Add a local_lock_t to the struct cryptd_cpu_queue and use
local_lock_nested_bh() for locking. This change adds only lockdep
coverage and does not alter the functional behaviour for !PREEMPT_RT.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 crypto/cryptd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 31d022d47f7a0..39c9e83a3a5b8 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -34,6 +34,7 @@ MODULE_PARM_DESC(cryptd_max_cpu_qlen, "Set cryptd Max que=
ue depth");
 static struct workqueue_struct *cryptd_wq;
=20
 struct cryptd_cpu_queue {
+	local_lock_t bh_lock;
 	struct crypto_queue queue;
 	struct work_struct work;
 };
@@ -110,6 +111,7 @@ static int cryptd_init_queue(struct cryptd_queue *queue,
 		cpu_queue =3D per_cpu_ptr(queue->cpu_queue, cpu);
 		crypto_init_queue(&cpu_queue->queue, max_cpu_qlen);
 		INIT_WORK(&cpu_queue->work, cryptd_queue_worker);
+		local_lock_init(&cpu_queue->bh_lock);
 	}
 	pr_info("cryptd: max_cpu_qlen set to %d\n", max_cpu_qlen);
 	return 0;
@@ -135,6 +137,7 @@ static int cryptd_enqueue_request(struct cryptd_queue *=
queue,
 	refcount_t *refcnt;
=20
 	local_bh_disable();
+	local_lock_nested_bh(&queue->cpu_queue->bh_lock);
 	cpu_queue =3D this_cpu_ptr(queue->cpu_queue);
 	err =3D crypto_enqueue_request(&cpu_queue->queue, request);
=20
@@ -151,6 +154,7 @@ static int cryptd_enqueue_request(struct cryptd_queue *=
queue,
 	refcount_inc(refcnt);
=20
 out:
+	local_unlock_nested_bh(&queue->cpu_queue->bh_lock);
 	local_bh_enable();
=20
 	return err;
@@ -169,8 +173,10 @@ static void cryptd_queue_worker(struct work_struct *wo=
rk)
 	 * Only handle one request at a time to avoid hogging crypto workqueue.
 	 */
 	local_bh_disable();
+	__local_lock_nested_bh(&cpu_queue->bh_lock);
 	backlog =3D crypto_get_backlog(&cpu_queue->queue);
 	req =3D crypto_dequeue_request(&cpu_queue->queue);
+	__local_unlock_nested_bh(&cpu_queue->bh_lock);
 	local_bh_enable();
=20
 	if (!req)
--=20
2.49.0

