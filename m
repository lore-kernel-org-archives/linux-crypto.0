Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795393520;
	b=Nw/M7qcXx+8CDfvdH+br1vgvTkwbBJ+tp3+hxhy2YKgn/eFCpTsm4l6yKfo+crEQHaR8
	 37ieDi4gmACUB7l0GSH4y/jePKAtnLPoeC+1fVw9fIJNvoNvlIszD6D+EmQD+ts5ksas+
	 oXRM2rrlOEP+cfkdjEJaysCT1fBnFllGD9LoaTkFDMr9MfbBpkuKF+AbBaYYIRyFRLhiN
	 Ne28t4nmyROzBpeEkMCPptkybzy32Lb2Nyg1thEMTX+g/O2zSyBR2ObZO9kEab8lrCXAV
	 GGIUdR71miVU4h9BAtU/F6d98XqJ00wZ2r/dAxJdq35N4BAFdbUO26nI1WP4BI3BLYA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393520;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=3T5GLWa8dCPbOmNTE2SZI39/qBRH3q4tYwhAWlV4JWw=;
	b=oH1hyP/ksLxI36yXukrIQlpjaobJ0OMCbIiwpEujPIhuOxLKQD/iiu5enilHXkKkeOs6
	 +aYV3mOMvmrM2ptHogkyJtSdGwFNkjL/JdB+7CJ3dVfHAk3UIuFs1Esy26MBGtfCRL7vy
	 vo6VNfwNz/NTd2hYrWsWkTCnlClVanWRipaqvZU7p+VUBwFqiLMC2mzRVEANqh1BQhfG4
	 Yhj1AzYZziRDVdMbrnmWFnkulZlOYEIiFnJJfgCwFHMkKQ68cvesaLk958Hpei/4sIj56
	 kSAURCwyRwFw6e3FRGC6X5CK6qjE0WCIRyLNsbXy6lELhxe99eJVSEMMXsDmSjLqwwQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W75Gy2L+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8143606A334;
	Mon, 23 Nov 2026 00:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W75Gy2L+
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795393519;
	b=wZUQP9yvFhQUz+m/jrUpIQ3+1zZB/3LLMkKYYN3qgmtK0ABergt4p8jORDMe8GZ5p6ZA
	 LBecW34oIV6LoWMnWd2sA4I9fLIRioTpc4feMTLSkAh9KluQuAbHq3ufeiy/oNq7nATfJ
	 H4j3RLidJMk1JF0117K4Nmkrc8uiBUeyJlPiNIcr7MZgBg9r5VVjsGTVQU3jxovmWwmsT
	 kcWBqz3ybMcd6WdqoFPWx46tkmk5ftqAYTbcBTY+W0L3tY1zCAj77YqVQyy3u42wXSqx/
	 wQdUzy51yK1mXw7cr/xwkwfK9oFvaKQ0chIiViwHsG3G8sFOu9pciAQiDZs5GHHDkag==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795393519;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=3T5GLWa8dCPbOmNTE2SZI39/qBRH3q4tYwhAWlV4JWw=;
	b=lt471bin2BjQzfFCs6oX5lgMRMp6EV2HCrYhqLqPpirG8DMD/UqK9FpNg4wYrZuXyRaA
	 QhKJIxEgWHvlM6/Grsebq5AfY2lHO2xy2nRsX3p9/gUBoqJZ9eCmJPipX4n+480Eqe49b
	 m6uSll/8hR3bWIA6XrXXj3x7uNGUgDTxXHMiz4EtVUFfHlvC3UgE2HfiOMXgwq5zBYxq0
	 J6oDqmoPlAwaaybp6sssbHH2RLmUXHQSYMoei0UsmpByoBy+G9evRCKWokdgcKXcDZX9W
	 4MoGljjCPnNf08e46gTlbt+E7Bf/OrpnCktOHpmrFw2I46pEfZScdzg0GO7s/KGtzAw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4E4F61F000CF;
	Mon, 23 Nov 2026 00:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795393519;
	bh=3T5GLWa8dCPbOmNTE2SZI39/qBRH3q4tYwhAWlV4JWw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=W75Gy2L+m+CfNIQ/f1olI1YcrS0X+0vui8kTjfLSyAUYxfE5FOKzAHdpp7t244rBR
	 rPpPcDk6NH63vLEnICBvRQtvOl3/gu3GVmMzqNYn33VisxY57lHhVapbPjkyuVtGCz
	 kLwOwdgu9TW98n4uHuzlUeTtTGuLGVCH2Ijr1qO/0wzxldRfvQAi+6Uc+b/Z5D8OWa
	 eq0hNwaPbh7ATZRz4AtlLsPeZI+YIapxLLM60E/EAgFNHq/LX6Mun2aFSjdgvjCvBd
	 faJPFxBYvAZp+l8pBBQ431PJ0ezEXITA4ZubpTh97MjBfrpb+L3tCBhBJK+7g8WQvg
	 chUiIsuUirXpg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D03284C255;
	Mon, 23 Nov 2026 00:25:12 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Sun, 22 Nov 2026 19:25:13 -0500
Subject: [PATCH bpf v2 2/4] rhashtable: Don't retry trylock_irqsoff lookups
 with IRQs disabled
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
Message-Id: <20261122-bpf-rhtab-irqs-disabled-v2-2-207aedcc2215@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795393512; l=2660;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=kYjGbBhSshdQz8OUIPJYVvaaWEVOrBeao9CRlWi5/+Y=;
 b=K7vDg+c6ADcr1YLDf5uftT+mGwZRE6ClJ6kJzmqtbZGr8phM5RTNzqKJMhozRN9Bz+E+yMhZv
 WTl/Ficbw5CBH2yoVhIPFFfMBaZE6dtoxASM7EzA+uTaHwHAsrTddvN
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit

From: Mani Tofigh <mt4022@columbia.edu>

The rehash links the last entry of a chain into the future table and
then unlinks it from the old chain.  A lookup that walks the old chain in
between ends in the new chain and retries.  A caller with IRQs disabled
can run inside that window on its own CPU, e.g., in NMI or in a kprobe,
and then the rehash never moves on and the retry never ends.

Don't retry for trylock_irqsoff callers with IRQs disabled.  The lookup
moves on to the future table, which has the moved entry and all entries
moved before it.  The rehash now stores entry->next with
rcu_assign_pointer(), so a lookup that walks into the new chain also
sees those earlier moves.

Suggested-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
 include/linux/rhashtable.h | 11 ++++++++++-
 lib/rhashtable.c           |  6 +++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index e5f5b9385cc3..746d62978215 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -638,6 +638,15 @@ static __always_inline int rhashtable_compare(struct rhashtable_compare_arg *arg
 		      params.key_len ? : ht->p.key_len);
 }
 
+/*
+ * A caller with irqs disabled may have interrupted the rehash on this cpu, so
+ * its retry would never end. It finds the moved entries in the future table.
+ */
+static __always_inline bool rht_lookup_retry(const struct rhashtable_params params)
+{
+	return !params.trylock_irqsoff || !irqs_disabled();
+}
+
 /* Internal function, do not use. */
 static __always_inline struct rhash_head *__rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
@@ -670,7 +679,7 @@ static __always_inline struct rhash_head *__rhashtable_lookup(
 		/* An object might have been moved to a different hash chain,
 		 * while we walk along it - better check and retry.
 		 */
-	} while (he != RHT_NULLS_MARKER(bkt));
+	} while (he != RHT_NULLS_MARKER(bkt) && rht_lookup_retry(params));
 
 	/* Ensure we see any new tables. */
 	smp_rmb();
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 2dc13f0e2549..619609037051 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -274,7 +274,11 @@ static int rhashtable_rehash_one(struct rhashtable *ht,
 
 	head = rht_ptr(new_tbl->buckets + new_hash, new_tbl, new_hash);
 
-	RCU_INIT_POINTER(entry->next, head);
+	/*
+	 * Pairs with smp_rmb() in __rhashtable_lookup() for lookups that
+	 * don't retry.
+	 */
+	rcu_assign_pointer(entry->next, head);
 
 	rht_assign_unlock(new_tbl, &new_tbl->buckets[new_hash], entry, flags);
 

-- 
2.53.0


