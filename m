Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB684964F;
	Sat, 15 Aug 2026 04:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786769829; cv=none; b=A3Oz3sOeY6IqgKufnz6dD3dM+BIvlh7wA0JEr+iz6bVQKHy9zn5J1csbrBfSPiQeFf74imca/H1jmffULtmgfQRkHoOG8+RVvmKtWZqXIs9EbA3jU0nxTpPmYeaOAgIgaU48rVhjdkWsAvqiOpWODjMBqT9vPbCBRoK4ftF2klk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786769829; c=relaxed/simple;
	bh=4T0ix+q8kznq+1wwuJATrtbN/PAw3QOdUwC3wGX7jWs=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:Date:Message-id; b=fMpATTL6I62BNWdqo0reoXVSjvcWyPZ8MawNF0es/47bbTRZAqYBIGU1hXM2gpyv8dy45vJag+jSqtSEEYh+epjLBToz7aSBOYrU3nP8WtG8uCsw5ELQbgM5P93KgSi0U662azhw5DrYfWCqwW6fsyJOIySaoRTzZ5o1r2CU82g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=UAgzn17w; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=agrWfoPI; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="UAgzn17w";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="agrWfoPI"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D70501400155;
	Sat, 15 Aug 2026 00:57:06 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sat, 15 Aug 2026 00:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:reply-to:subject:subject:to:to; s=fm3; t=1786769826; x=
	1786856226; bh=wVmXDmHcEURTsEPo2xr5FvYCGQo/GWBjjbW9Do4jviU=; b=U
	Agzn17wOgbFZrRy+wqHLbcd1gmGEcUAq6yN1rjK3eyQ8kMy9KGLVvCUTPABVHubR
	GEdFs3g5s+DWAlIG57e4M62Jm7KwWw8JD7UwWCMijkmysONI12eW0wqOf2YqT9vs
	8O97uUmTAtNHj6iW+xGcVrPOkjk2iwBPRsnLCRcKw3Fj7WgEc6c3xCjNALTgpZAp
	NFiXL+ytvjvSDXpNBTYHyUliqG1D2knPj9xXI8lSQEnPyICQiyb/p/IYVFgv+HD6
	thn6KrZNYaUcv5DK0h2mxTUY0kdfl60jU4lT3L/7I50eeXQ8zZG0OZYdl06/2eT+
	MbcLxW/DWJdVc76scaogw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:reply-to
	:subject:subject:to:to:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1786769826; x=1786856226; bh=wVmXDmHcEURTs
	EPo2xr5FvYCGQo/GWBjjbW9Do4jviU=; b=agrWfoPIFMheXSDmsGS6ghNNvRpo1
	RSca4r6+GT1jHQWssqJn9VwLeUy0wUJX9LRfJ1oBHCdlLriV3PxifE6w+blJdDj2
	1XPxCSp4umiS/qeEktP7U8jBYK+en3+CUAPc/AjWmY+XBZNyFO0WLJZE7EvG2Kj9
	0hXWIV++fFogRkT7asY0NhtLf/cq5SsErxONOnZQSz0iYHRS7S9qaSd6WOzkgDNS
	7ByGrn1Wgdpo5EwC2flH1+IrnlYadqlUz4ACpPLfQNzo6QGnS2qEnVe45tePTtuo
	wA9ihmxbnn9akHZmGLTqtB2znZ+8j7v6UvOfvvFWMb0Yyp7kInOMdStYQ==
X-ME-Sender: <xms:ovF_ahfPWAXzohQJkPcIUNtUVF82VoABORfFX1ZoBcuj2pT-HaL8Yw>
    <xme:ovF_av5Ewnr-GtOlHB1yZBsGcDlhV2i0jy894VYK5OGlNaRoegp9j02aP0DbSV-Hq
    dJ6veM50k5aXhZJODCYf0bmW3wBmWaq0zEpCZ_XfUNb57nDmw>
X-ME-Received: <xmr:ovF_aotokPTCqed6PCusDTCs7IetGHLc1aUTjPv-yigVM4ocAaS9DzEVJGfcjdJbXmVAIjMkDHbzZijlp4P_yheaoj8EsnI>
X-ME-Proxy-Cause: dmFkZTFRcu+UscIoleLUHOjuMYizrHRkJ1zFpOCYh4VXHVhdWJn6XCZ5fIFXiZ+RKU6dG8
    FdPCRW02Qgp0SiyI4iWTJDqq/OH7h7fPr8nAlAEljYAf6oznZUFT41wpPKzrfSk/71Azv3
    rd7XWRsllbR3Tua1jiUG5x7V5w3k8VJGLT0bXY4UQ/YFAzepL1AmBQK4fuCzTY8vPEpo2N
    yEW8NphB91/BXvi1aDFO4YaZpATxSfCDHChQbrT12fQMWdzyFy11D+h78Plw+rUDHhkYiI
    Q3CmSg4caTugqG7fPogzvJK/b70bhKNXaeMxb2MkWyIl+DE39yUS5yX0TQWC+swcFY4QNz
    iLY4UfZ67vnxJXpUoPnYsTmiU2w+NPLnhwonS+8W/j2N71qp4Iuo3rn8z0g9/vdbwcTqev
    BSMapiEhid8yfBwCj0Y+HWQycPs1r85sPpuYa5jFCN3FMk/AT6aOrlgbnZOlbwRJvu1Iwa
    55YbjQk59bjEc4Qwavt7uMc5f8+KNspzrvq34vz/O7B4oiUsyvBc5GjJNHZNiiG16ZUZh5
    QrMIIb+I3Kexjk97wfKrVfm29pmZ65FvhmupNDJyYGPpeeuIdrVn2pL2ycrwzS7H5CWiFt
    XkjjHNxhsKSVUqQG6yMVvWRNv9BQ8UK4ikeT8UIvyfj8+m1cF5Tf0xH/cckw
X-ME-Proxy: <xmx:ovF_avjE2htRuO2ubRUpBMTvlhHjbUeR4abUqx8rLojjvYnGsVKTrA>
    <xmx:ovF_ajoJl4EBpgBfE-m4uG1pjbx465MPtEt-WUezEqMKycGLI7PcSg>
    <xmx:ovF_assEejuniuAtkmfC-AnHvQgnhgSfSZ4otA-EeiMUbEvZj0Xh5Q>
    <xmx:ovF_amYq8_suce9TVe2xpIO2nXjOVEo6IfG_u_O1KOzx2Agwuit7Pg>
    <xmx:ovF_avyRPPA-vFEI3OHOQyRAcLM-rbrqFAN8OVLMTh3N9BGB2ef4Z_b6>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 15 Aug 2026 00:57:04 -0400 (EDT)
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
Cc: Thomas Graf <tgraf@suug.ch>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com
Subject: [PATCH] rhashtable: use private lockdep class for all locks.
Date: Sat, 15 Aug 2026 14:57:00 +1000
Message-id: <178676982027.2852630.3806887491595359260@noble.neil.brown.name>
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
 include/linux/rhashtable-types.h |  3 +++
 include/linux/rhashtable.h       | 22 +++++++++-------------
 lib/rhashtable.c                 | 14 +++++++++++---
 3 files changed, 23 insertions(+), 16 deletions(-)

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

base-commit: dac3e89a2c90c2feeb471e1f22a2512ad424b792
--=20
2.50.0.107.gf914562f5916.dirty

