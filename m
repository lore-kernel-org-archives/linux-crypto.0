Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795393526;
	b=n1ncrVN/VKuCTDBi/Dpqqt2qOD+o0ifimgo610KE2IFM2cTRgSlpESiJMMPMoUQ7EBn7
	 iX8h0uuBN67PVuO7fte54PXT6CSaLhVXlTNpQQ5cLWiD46icQe4z3lYl5arIcZXTvvmKI
	 WMFI2Z9O/Ahdf+FtLWhMFB/6Uz4yiUR4gC1EVrGHf8FWALodoArnclE16v1/kt1ZzT3lY
	 ugFXBAtiE2cAM5y7mVrLwGLLe0egFVIYEDsnWoiDprjqNgmpAhJfr/B7tlcgkMm/ey6GC
	 toNL2zeHQF0ShJzAFsKrCHVyh6JWKyaBPGEfDlVk+Cqi6Y8wvQXT2bMnls+JzMxDgwQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393526;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Irzkq77Pr8kf24YKj+uCb9Rmuf9gvIeScfYJS6RK5kQ=;
	b=EPYp3ssj/RayMX6lNq2NW1IOSCULA2eCuSQG/no0p3284+etZ7Y0P9y0bmzYeazOYpq3
	 VNLZny81tGJ7XtwLIuqM9N6FZ1lpt6MIeBrve/Hn6KnoE/9odeTx8hwU8XznHYIiuDeqh
	 1IZFmD0giTSa1+hzZ2qahilcRDSwAM68i0ZcknlsktHWeJh0RAG/QKcLl7Ty/Ke+P8zzF
	 8F5PFDP3FA1Od/bz1v3EziyfxnRBOlU/kAvbV5QTT0iFk+NhMIIGIgyzqhZg2/y9r+FPJ
	 PZ2e1p3ntKjMLiiAbV+hHIycw76SvBOg8m952BvUCgsPblt2YZWbKDWb9Ow09XwAF0w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XAbHJrRl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66EC606A31E;
	Mon, 23 Nov 2026 00:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XAbHJrRl
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795393524;
	b=YfgKASvnnEj+D1tDwJGF0njWrb/En7Ed30dxcxulEgeLw4hUzAvCrV+CP6c8SfxUypCQ
	 i+ugATxSD6ko3ZRGF9C4Vt1MkxhhmKDIZNlBm1rictm1YPiKDMjt3NuojL4GTpDcLkEJD
	 pN3g9TFxIfN4VXyQ6sAogk+SIwqMYP6qdxtG0oZiuaJ1ibjx2GpUNw40Uyo6f2xigs9h/
	 kD3Ipex66Qp4LUVt38nl63+aGV8XbPPQaQnFWbSZq9hsmto7bZX81HvoR7fyIX8Xuiygt
	 eyFOiZjBBV2YvHy0KIMtvE/Tf6bOUkP1mo+ARr5HuiZ8PbM8ILd/KVW0Ae+N/g+4KVw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795393524;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Irzkq77Pr8kf24YKj+uCb9Rmuf9gvIeScfYJS6RK5kQ=;
	b=LaZ789JWodUG6AupKKxhsMQcUSt8eUwtPOMBQFBMKFu1Rat7ZA7kA4VarvWuUZ4Bl9W8
	 PGkNr+f3ckY+PNehJBvJtt9xgm0OxIiPPsMRY2msDIIFUd9MAMqBF5xqpZB6LVkPxnJLU
	 h3VrTWHUhKtttoylVPDjo5cJhWeGt46tze4wR1E+wah7QnoQQzJSA3Q/QQGSiwZK8Xne/
	 cnXGB0ZbvRYTaQZAZXxpXxqYhInjOSYjUvUfhqdB1yvq90tYfWUZGqvrtjsQ4kqCQ6mjW
	 Tl+aG6Dk3t0njdNMdMdDoMb8YKILva7Rh/KGqpMelBDC1MRSFhDW9c/Tvp7GvGLkJ9Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6A9D71F000C4;
	Mon, 23 Nov 2026 00:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795393524;
	bh=Irzkq77Pr8kf24YKj+uCb9Rmuf9gvIeScfYJS6RK5kQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=XAbHJrRleoY3lEvnENesJNQt98bYwztiKUEpzBEBXToLsFf4zCz4q61UkVKWVvfJx
	 ujaU8TMKV6EWwfAA1YFb04FknSLkIj5rxkXqknmGPgYP3LvR3mJYKktR390TGyx63g
	 kthBiFbCN/CIDpeNGCsYxKFIbW2A6B0F+4LvAFFz9Jm9TCGgxR31XthG5KvTAinWBP
	 P3w3jjiCxw2MpHqTqWQZHrbM4nkNb/W/WUqE70hp4yrVTEchv616M0C/fMsDOMsonA
	 HeQdVR/XYzgXQtFN4XozMVYjEaoDt1K5N51Hr7A2as5rvkWGkqEkULem6J6davBtaX
	 kUzHlpkjTkMfQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EBE3C4C259;
	Mon, 23 Nov 2026 00:25:12 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Sun, 22 Nov 2026 19:25:14 -0500
Subject: [PATCH bpf v2 3/4] bpf: Don't spin on rhtab bucket locks with IRQs
 disabled
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261122-bpf-rhtab-irqs-disabled-v2-3-207aedcc2215@columbia.edu>
References: <20261122-bpf-rhtab-irqs-disabled-v2-0-207aedcc2215@columbia.edu>
In-Reply-To: <20261122-bpf-rhtab-irqs-disabled-v2-0-207aedcc2215@columbia.edu>
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Mykyta Yatsenko <yatsenko@meta.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, bpf@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, tz2294@columbia.edu, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795393512; l=4196;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=H73UDxYxp4OhP3+zFdd1A4c8OBOGQZtNrFaT0BtiC3E=;
 b=RXk+Of9llLWxtSZjxODvOgb4cxu8nS1YoBFvaKijLsrrO9fNhSoo+nZHBWKIwA1eeKChG0Z9Z
 hKrDCwzMJd3AHHJVbB3NhuLqijg7wZSNZbt7+ZgmTHu2v/C0Jt10bV4
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit

From: Mani Tofigh <mt4022@columbia.edu>

A BPF program can spin forever on a resizable hash map's bucket lock
that its own CPU already holds.  Inserts and deletes take the rhashtable
bucket lock, a bit spinlock that can't detect re-entry.
bpf_disable_instrumentation() keeps kprobe and perf_event programs out
of rhtab's own inserts and deletes, but the resize worker calls the hash
function with that lock held, so a kprobe program on the hash function
that deletes a key of the same bucket never gets the lock:

  rht_deferred_worker()
    rht_lock(old_tbl, bkt)
    rhashtable_jhash2()
      kprobe program
        bpf_map_delete_elem()
          rht_lock(old_tbl, bkt)
            /* spins with IRQs disabled */

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  ...
  NMI backtrace for cpu 0
  Workqueue: events rht_deferred_worker
  RIP: 0010:rhtab_delete_elem+0x15f9/0x1c80
  ...
  Call Trace:
   <TASK>
   rhtab_map_delete_elem+0x61/0x120
   bpf_prog_12e9295082de5b34+0xa0/0xee
   trace_call_bpf+0x2ca/0x930
   kprobe_perf_func+0x106/0x700
   aggr_pre_handler+0x8f/0x110
   kprobe_int3_handler+0x335/0x750
   do_int3+0xd/0x50
   exc_int3+0x165/0x340
   asm_exc_int3+0x39/0x40
  RIP: 0010:rhashtable_jhash2+0x5/0x360
  ...

Set trylock_irqsoff in both rhtab params.  Only a program with IRQs
disabled can run inside a locked section of its own CPU, so its inserts
and deletes now fail with -EBUSY when the bucket is locked, by this CPU
or another one, and work as before otherwise.  This also covers programs
in NMI, so bpf_disable_instrumentation() isn't needed anymore.  With the
fix, the delete fails with -EBUSY and the resize finishes.

Fixes: 16b4d3e2fb24 ("bpf: Implement resizable hashmap basic functions")
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
 kernel/bpf/hashtab.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 6e2115477cb9..edc7572a641e 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2983,6 +2983,7 @@ struct bpf_rhtab {
 static const struct rhashtable_params rhtab_params = {
 	.head_offset = offsetof(struct rhtab_elem, node),
 	.key_offset  = offsetof(struct rhtab_elem, data),
+	.trylock_irqsoff = true,
 };
 
 static inline void *rhtab_elem_value(struct rhtab_elem *l, u32 key_size)
@@ -3011,6 +3012,7 @@ static const struct rhashtable_params rhtab_params_long = {
 	.head_offset = offsetof(struct rhtab_elem, node),
 	.key_offset  = offsetof(struct rhtab_elem, data),
 	.key_len     = sizeof(long),
+	.trylock_irqsoff = true,
 	.hashfn      = rhtab_hashfn_long,
 	.obj_cmpfn   = rhtab_key_cmp_long,
 };
@@ -3143,21 +3145,11 @@ static int rhtab_delete_elem(struct bpf_rhtab *rhtab, struct rhtab_elem *elem, v
 {
 	int err;
 
-	/*
-	 * disable_instrumentation() mitigates the deadlock for programs running in NMI context.
-	 * rhashtable locks bucket with local_irq_save(). Only NMI programs may reenter
-	 * rhashtable code, bpf_disable_instrumentation() disables programs running in NMI, except
-	 * raw tracepoints, which we don't have in rhashtable.
-	 */
-	bpf_disable_instrumentation();
-
 	if (rhtab->map.key_size == sizeof(long))
 		err = rhashtable_remove_fast(&rhtab->ht, &elem->node, rhtab_params_long);
 	else
 		err = rhashtable_remove_fast(&rhtab->ht, &elem->node, rhtab_params);
 
-	bpf_enable_instrumentation();
-
 	if (err)
 		return err;
 
@@ -3268,16 +3260,11 @@ static long rhtab_map_update_elem(struct bpf_map *map, void *key, void *value, u
 	memcpy(elem->data, key, map->key_size);
 	copy_map_value(map, rhtab_elem_value(elem, map->key_size), value);
 
-	/* Prevent deadlock for NMI programs attempting to take bucket lock */
-	bpf_disable_instrumentation();
-
 	if (map->key_size == sizeof(long))
 		tmp = rhashtable_lookup_get_insert_fast(&rhtab->ht, &elem->node, rhtab_params_long);
 	else
 		tmp = rhashtable_lookup_get_insert_fast(&rhtab->ht, &elem->node, rhtab_params);
 
-	bpf_enable_instrumentation();
-
 	if (tmp) {
 		bpf_mem_cache_free(&rhtab->ma, elem);
 		if (IS_ERR(tmp))

-- 
2.53.0


