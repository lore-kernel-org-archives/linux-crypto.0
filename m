Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795245907;
	b=Yyesy82ZrkKoSnqH1vpTch3HGKhathgDgKm5Ebvcgia+sXedBHo+9mMrsvJCyPYu6SHa
	 iclbu3bFm2/VjcI3EclYpt/SYwVXDMxQCZZgn4hn2/CStcuH177tkA0QjyqwI/sKYYZNB
	 LbG2cP6SdD/YrRrgs0EVPnCxZu5SnpGKEsMXme/JY8oH5k1iJx3+Rd+Us8i6rGYhPYlaV
	 ZVxbhcTsdxiOSK7+BLMs1m2SxJnx9U1M0vI6hkRBM9eefCz9hiVKCBWz7bzHtxslIFYVM
	 /K+d/K8DFn+2DiV+eS4nGvOQuNpks0QRYoCAJ288VKMK/SXoGYL7Lo4yGswZ7Iu0a4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795245907;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Z119tV49AGed5svygKCjCjXGTDE4UiODXvdPXR9OWtc=;
	b=NqnUeS/Jgs2h2pa6day1M4KJppox2NhZuM/XAv7+AzYOW56uwB+g4IsdwIErUn3sRIBa
	 w4A4xS3fnHyt3Yx1Fl09JgRrOeC9MsfIerVk4ZJzgdAr5kKLwbg/OKAphhIyuRtdhwl4h
	 vPrW2zOEMMXSBOFqIqx1rHt0SJk+XJU30/h+2zUkqsMwHTZQCSxaTcNGA4ikFMLF8V5dt
	 Y8/hyAsfzK51GekkuGhYupa31kZtEz3Gh7pv/EGTEZFER0H3iknW0dHyGqRvyHq5w+bgP
	 F3MLkvuvsjmytmHwQ0yKECT4jKT417TrtJmy2MslE4L644q13ZX6/H8X+oMCBJhJVGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mK5zUrAm;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87805606A320
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 07:25:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87805606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mK5zUrAm
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-49d64a88222so1731937f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 23:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795245905; x=1795850705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z119tV49AGed5svygKCjCjXGTDE4UiODXvdPXR9OWtc=;
        b=mK5zUrAmi4oxZhPINbfWwooDw1m1k//i/vGJSgmth9G0BPWxUcRhJ4JbwEydewp3O7
         bAMVxB0UWZU3u3rxmuV4f+0zlC930bhW1g2CPqaaiQZUd3QPn7GIpNNsz+CGW6LTw5eB
         J+r79zXT5lgVza9RxNAZfiJel+mntWx/zX6RyQhm/yveMcu1BepKP/TZdbuyp6NRh3X8
         vsj7l0kzzZIJkD1MuF6qTWbLA5IRGcQz8Qu6B0igk6ZOsRnuNg25F2/EgZ9tBx39iSTU
         UjnNwZfRotZ41+rRp4pJ52D6GEzNydVzG9QE+I7wcY+42AzmFdakJJAdHN1odW18u9QS
         92nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795245905; x=1795850705;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z119tV49AGed5svygKCjCjXGTDE4UiODXvdPXR9OWtc=;
        b=VswwO+4A7PXPg6QEevWuI2QZAJM5YM2wT1XhYbIdkj/GSEIzoXE31Q0OQr5oFukcys
         lGmvAOr844da4bXNDxvMMPsPAy61O654OkvATVqLnsafNDdbXu6YKOKQ1xNsyyCumUnQ
         jenu4JQecm5784HubKh64HEqhXCfgH5FJfy8xnEPGwYiisbge0BPUtysPes3/Hm2nAw1
         7Ir4VLsiYv8W+kMiJVD1a5EJMT86DXa9XzXImzmetUeG+a6B/lRKjWAI2V42pgtX2Xd8
         MaWSNNcQofoiYV6Dm0d1A/j/3833u3fbBwuyw+O00piB4mFRvtfVMC9dwYJww2LfKsRb
         T7Qw==
X-Forwarded-Encrypted: i=1; AL+hErGl0TH8u3aAhqEm1t0ij8+YRxGDzJpWp4xhhFeqeMx65Y90XDvHfAnVxtexFx+zclZYk3aleWLE+KxzxEc=@vger.kernel.org
X-Gm-Message-State: APuU4Z+sfBwYRa6yqj9oow84Ct7qwbk7wBSxfBmou7FosK9PYxjVpKv6
	1gM2aDGUje9nm02gTQK3Sd3TWwUiEQhR8G+vHwGJk98byN6nYy4VVkDB
X-Gm-Gg: AZFdTZeuoy1lq+wLHLynBHXbqWjy7mOQqWCd/U6ijB3ZGBt+ailld4lEhLEQq+dlk3+
	qfChUuT/kNYXdlrOC6SPotFk1pn5EKgnaybAj4y67PFj6jjD3fozDXKn4AfOqS7WIhGgtsQxy2y
	wMvYSEro2m5NbDYsb6Vka4BbDA3ObQsgjSbStOju1cqLxJ5HVcrT7PUj8S3vj1JszrEyGpreYi0
	LD93GJkJp4FP4nUocGtkJzPE3fO3lrXKwL1VDQqG20p26f8i82ljbCjpPZn87SquxWsngDMxqeX
	kxpWuRCT3k3fb5rag3OG9gfzwHYv82QI79lxH0JufIPsn3qJmnzxoWvmXGkdT7H8xkrYzTUx50v
	ivlBUNd/Aj1iAyEafVzFDt2Z/3Dz3qzqv5ReknQ7SmlKUti57wdVtGl+nTvf8hoW/og+/SLYP/Z
	NiqQjqeqrGJn6ivvmJoPoA8HYTQVci5sN8P92HjyBHy2XGuGTGxzaag8bDHMhE+myEI0V+GicAf
	8lTSq+3io59IqZvfaeKzRN7/MZ9eWqRU20SGqX9lAVON557pEm774cXfb7iZP+n00QVlZUawEho
	ajHV/374x4d0MiQYYxHf7Fi49fPFBokpUTteohu9EmzcOA==
X-Received: by 2002:a05:600c:848a:b0:4a2:1960:6fa with SMTP id 5b1f17b1804b1-4bb887fb678mr116834005e9.4.1795245905166;
        Fri, 20 Nov 2026 23:25:05 -0800 (PST)
Received: from localhost.localdomain ([2a06:c701:477f:ff00:fef8:c87b:1e57:c1fb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb90660cb4sm57742115e9.2.2026.11.20.23.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 23:25:04 -0800 (PST)
From: Avi Weiss <thnkslprpt@gmail.com>
To: herbert@gondor.apana.org.au
Cc: tgraf@suug.ch,
	linux-crypto@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH] rhashtable: Fix safe iterator cursor substitution
Date: Sat, 21 Nov 2026 09:24:55 +0200
Message-ID: <20261121072454.27804-2-thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
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

rht_for_each_entry_safe() uses next as both a macro parameter and the
rhash_head member name. Passing a cursor with another name substitutes
that name into pos->next, producing a nonexistent struct member and a
compilation failure.

Rename the cursor parameter to _next to preserve the pos->next member
accesses regardless of the caller's variable name.

Fixes: 88d6ed15acff ("rhashtable: Convert bucket iterators to take table and index")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---

Alternative approaches considered:
- Use a differently named cursor parameter such as next_node. This is
  equivalent in behavior; _next keeps the change smaller.
- Remove the unused macro. That avoids the broken expansion but also
  removes an existing interface potentially used outside the tree.

Validation:
- Original macro: next compiles; saved, tmp and next_entry fail.
- Corrected macro: all four names compile in the isolated source probe.
- The original next expansion is byte-identical after the correction.
- No in-tree expanding consumer was found in the tested base revision.
- Full kernel Kbuild, runtime and external consumers were not tested.

 include/linux/rhashtable.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 70dac9214617..00838bf88117 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -482,7 +482,7 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
  * rht_for_each_entry_safe - safely iterate over hash chain of given type
  * @tpos:	the type * to use as a loop cursor.
  * @pos:	the &struct rhash_head to use as a loop cursor.
- * @next:	the &struct rhash_head to use as next in loop cursor.
+ * @_next:	the &struct rhash_head to use as next in loop cursor.
  * @tbl:	the &struct bucket_table
  * @hash:	the hash value / bucket index
  * @member:	name of the &struct rhash_head within the hashable struct.
@@ -490,13 +490,13 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
  * This hash chain list-traversal primitive allows for the looped code to
  * remove the loop cursor from the list.
  */
-#define rht_for_each_entry_safe(tpos, pos, next, tbl, hash, member)	      \
+#define rht_for_each_entry_safe(tpos, pos, _next, tbl, hash, member)	      \
 	for (pos = rht_ptr(rht_bucket(tbl, hash), tbl, hash),		      \
-	     next = !rht_is_a_nulls(pos) ?				      \
+	     _next = !rht_is_a_nulls(pos) ?				      \
 		       rht_dereference_bucket(pos->next, tbl, hash) : NULL;   \
 	     (!rht_is_a_nulls(pos)) && rht_entry(tpos, pos, member);	      \
-	     pos = next,						      \
-	     next = !rht_is_a_nulls(pos) ?				      \
+	     pos = _next,						      \
+	     _next = !rht_is_a_nulls(pos) ?				      \
 		       rht_dereference_bucket(pos->next, tbl, hash) : NULL)
 
 /**

base-commit: 65e4fd942f72a9dba0e4e257290c4fa1aa756854
-- 
2.43.0

