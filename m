Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675750;
	b=lGoJP/TTfyCs0lcWWjNIt12VEaKtqTMOmrmgtgCWGLCdreVCE8+pOg/BquhKPjPpgya4
	 7pFkHkv/2TTIv67taPMjj7CcCO/pNORFfSKR+UDtUGFfUgVga9MVjI9Eneu1teVLiIWqj
	 vFRkkICt5Sa2lM2Ck4Qz87tl3xtdHQyqYUi+fsHR4b3gOu0rSfep+JbP5SZIlgEfYUEpk
	 40WNhsDJF6XZCvHavvKq35ElDsERNGc6spWgRIlot7anICs5sIIhN2hUPH5FI6pwx6ogz
	 4H5th9CCeelWFu2pIy3r6xKTWI1crIrX6ICIlJ+cM0Hl/nZVDFlmo1XxRv6+CdkVeWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675750;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=MEkfduRuxEwqk5nLpLbvUlTtIBBaXB2Udv/zTBYNtus=;
	b=5H4FAbwNexMIsLdHjfCZ5c8dBJD6o8hsnDtnltu012m6SLeah1UonyD0uuYP1rpC91Fw
	 Q7zYeitnAwmqCxFCC4486RhfTIuvpkfPLoRgE0a3XjgfSz/vZsLbpX61OaWjFrzzoKbSW
	 N3jOg//uE5TItVqRHshA0YHXHtjGqsRdb6qfa+1pYxjM7ZVYbj5dOn7hegiDYQtEnpU9H
	 3TK+fCqSqCXdVwn2YGeGf3yew6t9zcDvbbkA86sfra/IM3HKlW6adG2fbDw5TNOz5R+0o
	 EfYN55opWPBX24OalpKHyr4/dZF6owKeyF/8vSKxFN3UFketpk6p5ZJ6sVakQ2iyjgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=sRR+9dZH;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9983C606A324;
	Tue,  3 Nov 2026 03:15:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9983C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=sRR+9dZH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=MEkfduRuxEwqk5nLpLbvUlTtIBBaXB2Udv/zTBYNtus=; b=sRR+9dZHtcHS9adHo3SLSc8wDg
	21sYYXhRYjwR6NhshG4rt0L2MjyLOcIzpbUJ/FMquzKmr+9yK3Bt+F4mCULSjxWc2BxI/73fY1O/x
	Pqy1uOe7HEXN2ZVIl9K1QNMrtNjhHGhxTlJ1xjP+AwSmUmWbL+GFH+dgzvEuStIBmehTMLs3aEiku
	eFwpl2xK9tnVC1Izch0cu9dW4vWRHB460VkItv8NE9J0WX6/XwsyEVn00MBaAoflamthvDLLPKEr0
	Q8vkw+YYXUISGkCoPNVtwbmjedqKtIn2L67FRWdJj6leAxKx6Rn7smO3sveOlHkEFMM/uWWQ2hXnu
	teemDDGQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xO500-00000000vdF-3hB2;
	Tue, 03 Nov 2026 03:15:48 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] rhashtable: headers: add missing members, remove excess ones
Date: Mon,  2 Nov 2026 19:15:47 -0800
Message-ID: <20261103031547.2662864-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
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

Add or remove kernel-doc comments for missing or excess struct members
and function (or macro) parameters to prevent these kernel-doc warnings:

Warning: include/linux/rhashtable-types.h:108 struct member 'alloc_tag' not described in 'rhashtable'
Warning: include/linux/rhashtable-types.h:108 struct member 'lockdep_key' not described in 'rhashtable'
Warning: include/linux/rhashtable-types.h:145 struct member 'end_of_table' not described in 'rhashtable_iter'
Warning: include/linux/rhashtable-types.h:199 Excess function parameter 'ht' description in 'rhashtable_init'
Warning: include/linux/rhashtable-types.h:199 Excess function parameter 'params' description in 'rhashtable_init'
Warning: include/linux/rhashtable-types.h:220 Excess function parameter 'hlt' description in 'rhltable_init'
Warning: include/linux/rhashtable-types.h:220 Excess function parameter 'params' description in 'rhltable_init'

Warning: include/linux/rhashtable.h:87 struct member 'dep_map' not described in 'bucket_table'
Warning: include/linux/rhashtable.h:87 Excess struct member 'rehash' description in 'bucket_table'
Warning: include/linux/rhashtable.h:87 Excess struct member 'ntbl' description in 'bucket_table'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org

 include/linux/rhashtable-types.h |   11 +++++++----
 include/linux/rhashtable.h       |    3 +--
 2 files changed, 8 insertions(+), 6 deletions(-)

--- linux-next-20261102.orig/include/linux/rhashtable.h
+++ linux-next-20261102/include/linux/rhashtable.h
@@ -65,12 +65,11 @@ struct rhash_lock_head {};
  * struct bucket_table - Table of hash buckets
  * @size: Number of hash buckets
  * @nest: Number of bits of first-level nested table.
- * @rehash: Current bucket being rehashed
  * @hash_rnd: Random seed to fold into hash
  * @walkers: List of active walkers
  * @rcu: RCU structure for freeing the table
  * @future_tbl: Table under construction during rehashing
- * @ntbl: Nested table used when out of memory.
+ * @dep_map: Lockdep tracking map
  * @buckets: size * hash buckets
  */
 struct bucket_table {
--- linux-next-20261102.orig/include/linux/rhashtable-types.h
+++ linux-next-20261102/include/linux/rhashtable-types.h
@@ -88,6 +88,8 @@ struct rhashtable_lockdep_keys {
  * @mutex: Mutex to protect current/future table swapping
  * @lock: Spin lock to protect walker list
  * @nelems: Number of elements in table
+ * @alloc_tag: Allocation codetag and percpu counters
+ * @lockdep_key: Lockdep keys for each lock
  */
 struct rhashtable {
 	struct bucket_table __rcu	*tbl;
@@ -134,6 +136,7 @@ struct rhashtable_walker {
  * @walker: Associated rhashtable walker
  * @slot: Current slot
  * @skip: Number of entries to skip in slot
+ * @end_of_table: End of table walk has been reached
  */
 struct rhashtable_iter {
 	struct rhashtable *ht;
@@ -157,8 +160,8 @@ int __rhashtable_init_noprof(struct rhas
 
 /**
  * rhashtable_init - initialize a new hash table
- * @ht:		hash table to be initialized
- * @params:	configuration parameters
+ * @...:	variable args list: hash table to be initialized and
+ *              configuration parameters
  *
  * Initializes a new hash table based on the provided configuration
  * parameters. A table can be configured either with a variable or
@@ -211,8 +214,8 @@ int __rhltable_init_noprof(struct rhltab
 
 /**
  * rhltable_init - initialize a new hash list table
- * @hlt:	hash list table to be initialized
- * @params:	configuration parameters
+ * @...:	variable args list: hash list table to be initialized and
+ *              configuration parameters
  *
  * Initializes a new hash list table.
  *
