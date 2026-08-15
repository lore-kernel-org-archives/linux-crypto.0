Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460A0361976;
	Sat, 15 Aug 2026 06:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786775056; cv=none; b=f9b/m6baRjcSblUeW/pHdoqdQEryyLWOSzPyCz0ASJdElBrOvYnWg/9yFkhJn7zh2o1G34eQFYBauvhkS2MA+W7RWFHTT8dJHyWyZd3yh1RQgI2Dk786SaeL3/cGFHR5dzUaV7a9hfpnfBFrndR4tCCvdKZ8LWMG7w9ivbnsQlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786775056; c=relaxed/simple;
	bh=Zc/gP89bo5PWtNpdz40BdQns+8bAGkJdJQrBbFkUOsE=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:Date:Message-id; b=f+RRylx5TCXKyEpawP6wReP+zUh8AzckGcF0sezpMw5WPMENtfXoG4IfaBgkfNhoLMsX0uNojpuSMdZW1tsWtZPhvrb3otCAga1vPeQYz7+2DJuwIxOUrvh856Sn1W1FDyD2uoRe7fidBXZRdY7gUYYdlv4qThk+C3DkT+DcDaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=GBcGg8fm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VLJ+kX44; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="GBcGg8fm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VLJ+kX44"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 7262D1D00066;
	Sat, 15 Aug 2026 02:24:14 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sat, 15 Aug 2026 02:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:reply-to:subject:subject:to:to; s=fm3; t=1786775054; x=
	1786861454; bh=jKvxr63tWeJ1GLbaD7d6MjJ3As5YYyxyA2IvzkPjdPw=; b=G
	BcGg8fmGrJ37t/sje3M1e8P2n9tvQO9fK2B1wY1FWXmPRs4diHYDjZ6JRsgvb6bB
	a7nhu7Qi5uy05WW0UcjJf6o1WpVrVdXit98KXWfbzvBrjWLpXsXxQ6+MVsSBEvqY
	gBQB2Vu7eHTngWfi0eX4a1dKTugmrdSUtuLflz5WdW13iEbrYkYiHTPsIwRv0W7x
	vsrxqhUBHSp22Osz9pzWDIUWLMX7cYvYReQDWg3QeMjZc8x5t9bxHU+X1dj1otWP
	HtkrlPGpTpzxNb9DGA7NDR/Nc9g1sypjyDjEPHYZhE1gcBITKelCgWKROnIThF5q
	MT5ctHCX9Ng+YzrUCJ1Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:reply-to
	:subject:subject:to:to:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1786775054; x=1786861454; bh=jKvxr63tWeJ1G
	LbaD7d6MjJ3As5YYyxyA2IvzkPjdPw=; b=VLJ+kX44KatXyAy1hM0K490deGWBl
	R5q57x5T1vd8rqezCgXj/N3KHaN5p0860DgOqhAzc/KPc7xrM++jzVOFAKGbORM3
	YH9zgP1ioMrzElNWlvSvfWRLUjn6uN39YpAQnM89R+9VbIyaIt0PzhuemkziWjlq
	MHOq0rsXR6tbpiTFkPZ8kx8rI+/0aNaNdYBwvJqX9tzc2UzB5KXyHGqw8wx0FIud
	2lWkteNcBxQIRjBttG0yzzMgaQRDDLa1RXysQ9LGe9dEcJhL2xDI9gil3K1JgEiA
	1CZ4xUIlBw7ntli0NPhzMizuuV9mo4Ae+kiV5EIYbZB0hUW4RO/j6dBXw==
X-ME-Sender: <xms:DQaAai-GwED0qe7QG7fnbL3y6ZLHlr38UFSCoxtqw14c_XvAQ3LmNg>
    <xme:DQaAajbKio7QPORqrD-LNq8p-f6WfRAb-OtuIAUHQT6g66aAbth2VkcXnAb6KSKyF
    yXepH_ld-S3mkXkkmQh--dJbtRPyjpfHYk1yEctvJp4qpvIRA>
X-ME-Received: <xmr:DQaAamNxQej5yCVR9NjhcoHCVXIf1YJEKyjaH2vCEO5QcHGsYVCOvEqo_4sw_K8he0FDKyUBsKx4HbY5pemG4sqS8-dV_8s>
X-ME-Proxy-Cause: dmFkZTF6xAgtxGa0A94kixAwV2NxRaNDNU0m2ArwWEUTy51H6Ps+uiqIi8uun6P3o1qru7
    LJ7hNT7IbOmbI99TxVh3nytbmGhGbhK/fFZ/0ukmBfaDoFkh9xeO3Gd3Zbwtt5CEO3wZy7
    C1KmuaQZy1IMOBqW4Z4V1tC3lMwVRBCCwrzo3Bu0pRCLHCCkp5VmLqR1LUTXZQWUCyIhdT
    34/G1fxvydMO7v/QK8u1m+0jdmQtDBdJZVlCcsZ9aHMNkW17kklvXu234akvV7lrJ+/Y9h
    2NkHYkqg2Kgy51MkKG0uHffNoFnQzG2Qj8BlcJepNa9cdg/isIicofq+DgIBPD2e3SxuCk
    tFPbEWH8p4HIH+y8Tqiok02JwqycQYKSepXxgiWSI2vuQEzwwOJ4AxXsDSq5zm+4kbKwBK
    MCnM/Auz1rT+VaEoRjcK2IxeJ77ToXLOBt8AbP3abQfJ/leaW1o9l7IVS4hbk8FyCvaiq/
    6B4UFxnlCpip2x3xL/xbsa9TFWDiBAmVOhtcI7SAqwgo+2Vz3lcCt3QyYj4ObD3WeUuUe3
    WCRImxZnti1ycf2dikApopwPOP0LuBSCux+bMH82kIkGq8phonXnuP85TNnpSLdmhDKB6H
    wkz4loC/Ls9S6CiU9Fie49tDjMAFL36YWqF0FSnCnFg2ynxSHewZqAdG19Og
X-ME-Proxy: <xmx:DQaAavCYTWPvBBXvUP2XkT3f3Kk2YYPyjWqyI3rTvLY7x_k081UMig>
    <xmx:DQaAatIZjJASaPp82Hj5m7bxLgOoQWtON77ArIqRqwtrfbI5IOCyIQ>
    <xmx:DQaAaoOl2uKg4CnT1HHkFv-foOqGizApZXMOIspHUu_Y6tBYCp0szw>
    <xmx:DQaAar7oHMokVQXh9zdLtYaSwhYWE3OWDVkfY8Jz4p6U5DZSx7j2XQ>
    <xmx:DgaAanVGz-YU9dLmytUGXRHc33JL2JW_I88cs77iGeReYKGej_rYjrms>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 15 Aug 2026 02:24:11 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
 "quanyeyang" <quanyemostima@gmail.com>
Cc: "Thomas Graf" <tgraf@suug.ch>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com
Subject: [PATCH v2] rhashtable: use private lockdep class for all locks.
Date: Sat, 15 Aug 2026 16:24:07 +1000
Message-id: <178677504716.2852630.10509837046652973246@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>


This patch builds on
 Commit: 060d4e94b8d4 ("rhashtable: give each instance its own lockdep class")

to allow lockdep to see each rhashtable as unique with respect to all of
the locks, not just the ht->mutex.

This is needed if rhashtable is to be used tracepoint BPF which could
run while an rhashtable lock (in a different table) is held - see Link
below.

Rather then adding extra keys for the other locks, we use distinct
sub-classes for the different locks.
rhashtable->lock uses class 0
rhashtable->mutex uses class 1
bucket bitlocks, which are the only ones that are ever nested, use
 classes 2 and 3.

Currently rht_lock() and rht_lock_nested() are quite separate code
despite the near-identical function.  This patch moves rht_lock() to
after rht_lock_nested(), and simply calls that other function with a
nesting level of zero.

Link: https://lore.kernel.org/all/20260801-fix-rhashtable-bucket-lockdep-v1-1=
-15a0f8ae094c@gmail.com/
Closes: https://syzkaller.appspot.com/bug?extid=3Def8d17bae14efb960935
Tested-by: quanyeyang <quanyeyang@proton.me>
Signed-off-by: NeilBrown <neil@brown.name>
---

v2 includes a change to test_rhashtable.c as advised by sashiko.dev
NeilBrown


 include/linux/rhashtable-types.h |  3 +++
 include/linux/rhashtable.h       | 22 +++++++++-------------
 lib/rhashtable.c                 | 14 +++++++++++---
 lib/test_rhashtable.c            |  2 +-
 4 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-type=
s.h
index 57c11ec9dc64..0e1b172a4f6c 100644
--- a/include/linux/rhashtable-types.h
+++ b/include/linux/rhashtable-types.h
@@ -97,6 +97,9 @@ struct rhashtable {
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 	struct alloc_tag		*alloc_tag;
 #endif
+#ifdef CONFIG_LOCKDEP
+	struct lock_class_key		*lockdep_key;
+#endif
 };
=20
 /**
diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 79f83b6eec27..f8358d43691b 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -320,18 +320,6 @@ static inline struct rhash_lock_head __rcu **rht_bucket_=
insert(
  * When we write to a bucket without unlocking, we use rht_assign_locked().
  */
=20
-static inline unsigned long rht_lock(struct bucket_table *tbl,
-				     struct rhash_lock_head __rcu **bkt)
-	__acquires(__bitlock(0, bkt))
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	bit_spin_lock(0, (unsigned long *)bkt);
-	lock_map_acquire(&tbl->dep_map);
-	return flags;
-}
-
 static inline unsigned long rht_lock_nested(struct bucket_table *tbl,
 					struct rhash_lock_head __rcu **bucket,
 					unsigned int subclass)
@@ -341,10 +329,18 @@ static inline unsigned long rht_lock_nested(struct buck=
et_table *tbl,
=20
 	local_irq_save(flags);
 	bit_spin_lock(0, (unsigned long *)bucket);
-	lock_acquire_exclusive(&tbl->dep_map, subclass, 0, NULL, _THIS_IP_);
+	/* subclass 0 is used for ->lock and 1 for ->mutex. 2+ for bitlocks */
+	lock_acquire_exclusive(&tbl->dep_map, subclass+2, 0, NULL, _THIS_IP_);
 	return flags;
 }
=20
+static inline unsigned long rht_lock(struct bucket_table *tbl,
+				     struct rhash_lock_head __rcu **bkt)
+	__acquires(__bitlock(0, bkt))
+{
+	return rht_lock_nested(tbl, bkt, 0);
+}
+
 static inline void rht_unlock(struct bucket_table *tbl,
 			      struct rhash_lock_head __rcu **bkt,
 			      unsigned long flags)
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 8b2c405e7a66..a99283a887ea 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -189,7 +189,6 @@ static struct bucket_table *bucket_table_alloc(struct rha=
shtable *ht,
 	struct bucket_table *tbl =3D NULL;
 	size_t size;
 	int i;
-	static struct lock_class_key __key;
=20
 	tbl =3D alloc_hooks_tag(ht->alloc_tag,
 			kvmalloc_node_align_noprof(struct_size(tbl, buckets, nbuckets),
@@ -205,7 +204,10 @@ static struct bucket_table *bucket_table_alloc(struct rh=
ashtable *ht,
 	if (tbl =3D=3D NULL)
 		return NULL;
=20
-	lockdep_init_map(&tbl->dep_map, "rhashtable_bucket", &__key, 0);
+#ifdef CONFIG_LOCKDEP
+	/* bitlocks must use nesting level 2 or more */
+	lockdep_init_map(&tbl->dep_map, "rhashtable_bucket", ht->lockdep_key, 0);
+#endif
=20
 	tbl->size =3D size;
=20
@@ -428,7 +430,7 @@ static void rht_deferred_worker(struct work_struct *work)
 	int err =3D 0;
=20
 	ht =3D container_of(work, struct rhashtable, run_work);
-	mutex_lock(&ht->mutex);
+	mutex_lock_nested(&ht->mutex, 1);
=20
 	tbl =3D rht_dereference(ht->tbl, ht);
 	tbl =3D rhashtable_last_table(ht, tbl);
@@ -1172,8 +1174,14 @@ int __rhashtable_init_noprof(struct rhashtable *ht,
 		return -EINVAL;
=20
 	memset(ht, 0, sizeof(*ht));
+	/* mutex_lock must use nesting level 1 */
 	mutex_init_with_key(&ht->mutex, key);
 	spin_lock_init(&ht->lock);
+	/* spin_lock can use nesting level 0 */
+	lockdep_set_class(&ht->lock, key);
+#ifdef CONFIG_LOCKDEP
+	ht->lockdep_key =3D key;
+#endif
 	memcpy(&ht->p, params, sizeof(*params));
=20
 	alloc_tag_record(ht->alloc_tag);
diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
index b767a38a74f9..85a615e74591 100644
--- a/lib/test_rhashtable.c
+++ b/lib/test_rhashtable.c
@@ -477,7 +477,7 @@ static unsigned int __init print_ht(struct rhltable *rhlt)
=20
 	ht =3D &rhlt->ht;
 	/* Take the mutex to avoid RCU warning */
-	mutex_lock(&ht->mutex);
+	mutex_lock_nested(&ht->mutex, 1);
 	tbl =3D rht_dereference(ht->tbl, ht);
 	for (i =3D 0; i < tbl->size; i++) {
 		struct rhash_head *pos, *next;

base-commit: dac3e89a2c90c2feeb471e1f22a2512ad424b792
--=20
2.50.0.107.gf914562f5916.dirty

