Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE75374E40
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 21:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776893661; cv=none; b=DKmOlEkbCuw6eWXNANInxKSqomGOx7dcrff8S3GcbLUFfyNsOMQ+3WhvjyWMGpyXZWUh5MASnHOk1bu8k9Y/46GpiGB4Lzbg6PmVgpqZlUqEzHZDmPXjr0kdQMbAmM3MY7eeNgKCkp/CTCRi1fdjsdWdc2KzCcv7NZlYFGajOMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776893661; c=relaxed/simple;
	bh=u03zceiMBD8ZhrGPsxTutINU5prgwCZvEu2eM4b8oAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIRP1AKfTzWBefjjmtkzRCQ5ToEDrprhGSlZbagvdvQ4XuBw+OyRAlDPXx6W2BouDuGhnIkBr+HnS5BgwQ7vlyJN8do2hf4Wzk1Ck4Z8RS7JvcFIuDLlD6uvAWFrOeUxlk8jwP89PdvVgepVWWOLJKaHHqxDP9PMnH9W4lyz2PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q2RNvvoy; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q2RNvvoy"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a402b2d102so6826813e87.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 14:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776893657; x=1777498457; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TzWMajBXvkLZjAEK67wsPjVPED1S/mYSZin3Li/Mn0k=;
        b=Q2RNvvoynDSPvu8xOWL1R9w9Bm6o59Wq7rtZMzeUbUR+Old+QkaF5VStcPJfmfR9J8
         dZ39ljZrTP9+Uc+qHjpqFAGw3izigxevglRbDRcsnDIUS9lLVLh9NkMhdbbnvq8tQZmK
         9rEdRF22prPXlUZOjIxdfl6MeSp4kLRy1NFmy7Uyf8A+KIt9gDRApVMJHvuWp2OppWp6
         2NL+56s8RAzwVqZlyF0heoHFs4slNR54StsIgaQPpkgmCQ7q0ixHJiFuk3AeDaEV37rb
         T35r/J0vLIHce/w44Yil0pQn30E00yzQ3ykQFUS8LD8S6lc8ykWvJun3oLblHKZKGch7
         YFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776893657; x=1777498457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TzWMajBXvkLZjAEK67wsPjVPED1S/mYSZin3Li/Mn0k=;
        b=Oh9Rs0ecsqXjzJULrZ7Nv8BpZrxAYl24Uy8nShuVa1aBirM9glTyUl33H+oTutn7PJ
         foyiW5whb/sPSZj8cK1mU7v4eAt5CgeUVCwGQDzC+VMdZMh2buy/JMj8646hqbBbdgXm
         LydTGvcGRTErsAvV8C3SZeruo4N0fvJduyzA5bxOEdIGYpvZhxnoOEEP7zimfMjHRFbe
         JIQg9hDAJoJRm0b+c8aukhxC10W+gjcEBI0jG1+n1DQ54yOoE43Bc65CR0oyE8ceFWGK
         SsIxTfvDDjS1I2P0jI8u3+k97JY+9wWLBtRPWsAKc6fGO28RyvDBAmUnK9ib4mNWVnE3
         mSbg==
X-Forwarded-Encrypted: i=1; AFNElJ9ZrYIlvKxCPrunDWe62OP1S1X6JIFEkpoMcAQW/QodowqBink+oDi+dGtFVQUKJ3ga1FBUbPl/irtUcQ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+mDR5QTx4+SOgP3H+knAnGHtYNjljmotAs2zNOqklil7aXdPL
	AmLrK1gp4jptvMLs3xKfRfP+jnj/BHKwjdNWyBmtpYB9HdxDYKmN8V9m
X-Gm-Gg: AeBDietPrD+07fGmTUPafxIJVWtj51hwjMk6EtCpwxHzJyBiRPKuH6DLTeMzU/gg1hu
	q/+3WitVYC942CsCe26OsKAsJlZk6R5AeAfS/bkJt6+gNiEVKm1dZdsmwyW94alwrjxziYzWARm
	GjDg9Fa5c01asctBQASWM4Lh4Fr8dzR3DEBxxP7UlF4NcHGJ8IQuxhqB3Pqp7mCmesLVmsHUnDI
	ZCoQXkFMBRb+NC6Y5Eah+eIr6CzbJYiHq3RZvROuecnmjygTIk6QtnEGI3RN3nceAnsu6kdiE/B
	OGlRWYgla6iQV0dbDXbsxmZZ0ePHdGZOpuG8dPhCz2ybrfl3s2O4ZuSrl5ldUvAroXvCo3kvNxw
	fPwoBKi4X4SU7WyZ0hKw9TR9qO2Zynw7qRA+j6lAj6jwBo0154nYfKuJhGNFMTH8HlxQ9GNOT0b
	F/Kxdc5yV3NRG0pZww0WKlMkcESqjOmGd7sBVwiW4kxbL7
X-Received: by 2002:a05:6512:40c3:b0:5a3:e5d7:e37f with SMTP id 2adb3069b0e04-5a4172ebe6cmr6504298e87.41.1776893656564;
        Wed, 22 Apr 2026 14:34:16 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4185ad343sm4697828e87.2.2026.04.22.14.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 14:34:15 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH 1/1] rhashtable: drop ht->mutex in rhashtable_free_and_destroy()
Date: Thu, 23 Apr 2026 02:33:49 +0500
Message-ID: <20260422213349.1345098-2-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260422213349.1345098-1-mikhail.v.gavrilov@gmail.com>
References: <20260422213349.1345098-1-mikhail.v.gavrilov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rhashtable_free_and_destroy() is a single-shot teardown routine:
cancel_work_sync() has already quiesced the deferred rehash worker, and
the function's documented contract requires the caller to guarantee no
other concurrent access to the rhashtable. Under those conditions
ht->mutex is not protecting anything -- taking it is a leftover from
the original teardown path.

That leftover is actively harmful: it closes a circular lock-class
dependency with fs_reclaim. The deferred rehash worker takes ht->mutex
and then allocates GFP_KERNEL memory in bucket_table_alloc(),
establishing

    &ht->mutex  ->  fs_reclaim

After commit b32c4a213698 ("xattr: add rhashtable-based simple_xattr
infrastructure") introduced simple_xattr_ht_free(), which calls
rhashtable_free_and_destroy(), the simple_xattrs teardown became
reachable from evict() under the dcache shrinker. The subsequent
per-subsystem adaptations made the reverse edge concrete in three
independent code paths:

  * commit 52b364fed6e1 ("shmem: adapt to rhashtable-based simple_xattrs with lazy allocation")
  * commit 5bd97f5c5f24 ("kernfs: adapt to rhashtable-based simple_xattrs with lazy allocation")
  * commit 50704c391fbf ("pidfs: adapt to rhashtable-based simple_xattrs")

Any of the three closes the cycle

    fs_reclaim  ->  &ht->mutex

which lockdep reports as follows. This particular splat was observed
organically on a workstation kernel built from vfs-7.1-rc1.xattr at
~35h uptime under normal mixed workload, with CONFIG_PROVE_LOCKING=y.
The path happens to go through kernfs:

  WARNING: possible circular locking dependency detected
  7.0.0-faeab166167f-with-fixes-v1+ #191 Tainted: G     U
  kswapd0/243 is trying to acquire lock:
  ffff8882e475c0f8 (&ht->mutex){+.+.}-{4:4},
    at: rhashtable_free_and_destroy+0x36/0x740
  but task is already holding lock:
  ffffffffa8ad1d00 (fs_reclaim){+.+.}-{0:0},
    at: balance_pgdat+0x995/0x1600

  the existing dependency chain (in reverse order) is:

  -> #1 (fs_reclaim){+.+.}-{0:0}:
         __lock_acquire+0x506/0xbf0
         lock_acquire.part.0+0xc7/0x280
         fs_reclaim_acquire+0xd9/0x130
         __kvmalloc_node_noprof+0xcd/0xb40
         bucket_table_alloc.isra.0+0x5a/0x440
         rhashtable_rehash_alloc+0x4e/0xd0
         rht_deferred_worker+0x14b/0x440
         process_one_work+0x8fd/0x16a0
         worker_thread+0x601/0xff0
         kthread+0x36b/0x470
         ret_from_fork+0x5bf/0x910
         ret_from_fork_asm+0x1a/0x30

  -> #0 (&ht->mutex){+.+.}-{4:4}:
         check_prev_add+0xdb/0xce0
         validate_chain+0x554/0x780
         __lock_acquire+0x506/0xbf0
         lock_acquire.part.0+0xc7/0x280
         __mutex_lock+0x1b2/0x2550
         rhashtable_free_and_destroy+0x36/0x740
         kernfs_put.part.0+0x119/0x570
         evict+0x3b6/0x9c0
         __dentry_kill+0x181/0x540
         shrink_dentry_list+0x135/0x440
         prune_dcache_sb+0xdb/0x150
         super_cache_scan+0x2ff/0x520
         do_shrink_slab+0x35a/0xee0
         shrink_slab_memcg+0x457/0x950
         shrink_slab+0x43b/0x550
         shrink_one+0x31a/0x6f0
         shrink_many+0x31e/0xc80
         shrink_node+0xeb3/0x14a0
         balance_pgdat+0x8ed/0x1600
         kswapd+0x2f3/0x530
         kthread+0x36b/0x470
         ret_from_fork+0x5bf/0x910
         ret_from_fork_asm+0x1a/0x30

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(fs_reclaim);
                                 lock(&ht->mutex);
                                 lock(fs_reclaim);
    lock(&ht->mutex);

Note that lockdep tracks lock classes, not instances: the two
&ht->mutex sites are on different rhashtable objects (the deferred
worker was triggered by some unrelated rhashtable growth), but because
rhashtable_init() uses a single static lockdep key for all rhashtables,
this is a real class-level cycle. Once reported, lockdep disables
itself for the remainder of the boot, masking any subsequent locking
bugs.

Drop the mutex. After cancel_work_sync() the rehash worker is quiesced
and, per this function's contract, no other concurrent access is
possible; the tables are therefore owned exclusively by this function
and can be walked without any lock held.

Switch the table walks from rht_dereference() (which requires
ht->mutex to be held under CONFIG_PROVE_RCU) to rcu_dereference_raw(),
which has no lockdep annotation. rht_ptr_exclusive() already uses
rcu_dereference_protected(p, 1) and needs no change.

This is the only place in lib/rhashtable.c where &ht->mutex is
acquired from a path reachable under fs_reclaim; the deferred worker
is the only other site and it is the forward edge. Removing the
acquisition here therefore eliminates the class cycle for all three
subsystems that use simple_xattrs, not just the one in the splat
above. No locking-semantics change is introduced for correct users;
incorrect users would already be racing with rehash worker completion
regardless of the mutex.

Synthetic reproduction of the splat within a few-minute window was
unsuccessful across several attempts (tmpfs and kernfs zombies via
cgroupfs with open-fd-through-rmdir, with and without swap, up to
~60k reclaim-path executions of simple_xattr_ht_free() in a single
run), consistent with the rare coincidence-of-edges profile of the
bug: the forward edge is already registered in /proc/lockdep on any
idle system via rht_deferred_worker, but the reverse edge requires
evict() to complete kernfs_put()'s final release inside the fs_reclaim
critical section, which in my attempts was ordered against rather than
interleaved with the worker.

Fixes: b32c4a213698 ("xattr: add rhashtable-based simple_xattr infrastructure")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
---
 lib/rhashtable.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6074ed5f66f3..81de7a274b43 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -1141,6 +1141,11 @@ static void rhashtable_free_one(struct rhashtable *ht, struct rhash_head *obj,
  * This function will eventually sleep to wait for an async resize
  * to complete. The caller is responsible that no further write operations
  * occurs in parallel.
+ *
+ * After cancel_work_sync() has returned, the deferred rehash worker is
+ * quiesced and, per the contract above, no other concurrent access to the
+ * rhashtable is possible. The tables are therefore owned exclusively by
+ * this function and can be walked without ht->mutex held.
  */
 void rhashtable_free_and_destroy(struct rhashtable *ht,
 				 void (*free_fn)(void *ptr, void *arg),
@@ -1151,8 +1156,15 @@ void rhashtable_free_and_destroy(struct rhashtable *ht,
 
 	cancel_work_sync(&ht->run_work);
 
-	mutex_lock(&ht->mutex);
-	tbl = rht_dereference(ht->tbl, ht);
+	/*
+	 * Do NOT take ht->mutex here. The rehash worker establishes
+	 * ht->mutex -> fs_reclaim via GFP_KERNEL bucket allocation under
+	 * the mutex; callers on the reclaim path (e.g. simple_xattr_ht_free()
+	 * from evict() under the dcache shrinker for shmem/kernfs/pidfs
+	 * inodes) would otherwise close a circular dependency
+	 * fs_reclaim -> ht->mutex.
+	 */
+	tbl = rcu_dereference_raw(ht->tbl);
 restart:
 	if (free_fn) {
 		for (i = 0; i < tbl->size; i++) {
@@ -1161,22 +1173,21 @@ void rhashtable_free_and_destroy(struct rhashtable *ht,
 			cond_resched();
 			for (pos = rht_ptr_exclusive(rht_bucket(tbl, i)),
 			     next = !rht_is_a_nulls(pos) ?
-					rht_dereference(pos->next, ht) : NULL;
+					rcu_dereference_raw(pos->next) : NULL;
 			     !rht_is_a_nulls(pos);
 			     pos = next,
 			     next = !rht_is_a_nulls(pos) ?
-					rht_dereference(pos->next, ht) : NULL)
+					rcu_dereference_raw(pos->next) : NULL)
 				rhashtable_free_one(ht, pos, free_fn, arg);
 		}
 	}
 
-	next_tbl = rht_dereference(tbl->future_tbl, ht);
+	next_tbl = rcu_dereference_raw(tbl->future_tbl);
 	bucket_table_free(tbl);
 	if (next_tbl) {
 		tbl = next_tbl;
 		goto restart;
 	}
-	mutex_unlock(&ht->mutex);
 }
 EXPORT_SYMBOL_GPL(rhashtable_free_and_destroy);
 
-- 
2.54.0

