Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4003279DB6
	for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 19:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771961424; cv=none; b=dA3p6hdU9otqW09H8/S7QY2LWgDH0LvTbDX/SNhixU4wMYBOZG1dZZ4UrWY2Qp9r1ig31Y61UhJP1DPs5QU27UG16t6mviVKX10NVjjHuQ6ngVGgMOByn3AtlhioVhgs6q8cdqRz9henMGEWxiyXpCvONilhHg5dNn4rbQph6S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771961424; c=relaxed/simple;
	bh=P785tkQlXShRriiZLGztdmaeYJ0ERck7XVn9MSbM7tM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WPDDUG2QleKhCDFncYWvDE1g8WR9nzCsoh099oTPuKVsDdlu3WDxyakl3X3aYTiPoJZoC7KFq7E0dJflt3WYzoPGsVyB82NXL33IozD+NF2pmef3I5SXWT4wwzH0o/w8ypvMLt3UFHMMU7f6v9pX+H6IMq7LIT+IVpfOzP0/v2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ha9+T8OJ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ha9+T8OJ"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4806f3fc50bso66398175e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 11:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771961421; x=1772566221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ujsXnYEQ3Eg+/u4bqnrobK1veiGGt5W2AFZc4baGX3g=;
        b=Ha9+T8OJOenO5/5YzsOFb/7fwhl8TIII50BItHC49spbRX/EnsnBeklqiOpdPOko9M
         LIAvz1EJZb0vnJsPjMuTc3XMM4v6HyIFriSe62khaCpzwifogTPNT6b0W6Eg7B9370gR
         GM3W3ydVeKlmVOFLK95zV6Mp0XupRqqjtaI2tfyhtpkU5nuX4I9vXCWcqDXdq00TdNFw
         PhyfQVka54hikPVU8GQApkm29Up8aaNMLqFpBFHyQHYx7+ev1LMgj3GnNrA8izlTAFkI
         AGtULy1I1KdCRlD7/+JL2jFhgaMSYhdm+WZqhdDfAi/T+tFH5bwgOQcCDGZFddLIDLVU
         0/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771961421; x=1772566221;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ujsXnYEQ3Eg+/u4bqnrobK1veiGGt5W2AFZc4baGX3g=;
        b=IIn47BtMQ0fK6p32MoL0J69sy3iIGTc1t+EiXURkida+Nn4LdqiayvBHxg8XvGp0Ua
         lmGbxE/YhEeSn2Pxn4wNdo06f3pFgewsdnSAzrl5LJ1MSo7ZeHOiAn4g6NFtjpNN/sZh
         68RtPuDc1c/v7kBiBgihQY+QblrYYoFONUzqrw3mmXmMTpD7lOKIp804jK/YWQt/JZdh
         LD9Kd4QXTawpdav4n/PTJN+jYgHRHAMmafxKywL0drTy8KphLu8RJtNK2hZuoSTRjbl4
         RV2VZF59FBSSnNZmyt+ZrCPR3fpIY8NkAsZgq5NjCCFqNlGq4HIgR9WcSi1wnHwKS6Fw
         eMEw==
X-Gm-Message-State: AOJu0Yx7Pn9GnrGRk4eTO01nlT4+HGOv37KAPSCR7rWtGcXGSahuiWlI
	OyM+SflgoSUDhl9usS6MpzLX9aRQxXaeo8RMyTTqjLwOQWIniEoEwR7NEHkLGw==
X-Gm-Gg: AZuq6aIxUDYApe1H+Q8YB8tRSLONPdeEmKsIXxGvTZcPV2iu5wFxhqGCkWGXLflnAJA
	aIZaOfRFZqgRQOBYhJfYEZBL5skh9otQBr7acLhlo2QBtIOS8wHdLdJT9xGHt927SvdCZjYuyhe
	PtA8n7BDtc8wD/MCJoC5AkUYnXYOx4pEy89GAFlvenkle9UJ9UgNFlouYN7UULJCEH/HHaIcava
	6nopYEGvrVWdK2Q7VgTg/fHWduqiZYjk8DWx+PecHV/Dl1AepIMSu1kQESSU4P54yq3vF8XA9yD
	yzr2lphDO3hF1fbwETfeVw30gxWuTLk8bzKxbU5LfjXHMXWD/1LJzRc7E3fEtfvFb801Tl9KlK6
	OFDV9sUEGAiv2r6QoMA9/6H/27V+g4ljVzRoQ0fovVGxrlNqLsQ2teu+H/EjtyiaU3AAXPboIVx
	mMvqnJ4jk=
X-Received: by 2002:a05:600c:1f12:b0:483:be73:9b1 with SMTP id 5b1f17b1804b1-483be7309d2mr13495435e9.31.1771961420749;
        Tue, 24 Feb 2026 11:30:20 -0800 (PST)
Received: from localhost ([2620:10d:c092:500::6:ed07])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d54754sm29170786f8f.36.2026.02.24.11.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 11:30:20 -0800 (PST)
From: Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
To: linux-crypto@vger.kernel.org,
	tgraf@suug.ch,
	herbert@gondor.apana.org.au,
	ast@kernel.org,
	andrii@kernel.org,
	kernel-team@meta.com
Cc: Mykyta Yatsenko <yatsenko@meta.com>
Subject: [PATCH] rhashtable: consolidate hash computation in rht_key_get_hash()
Date: Tue, 24 Feb 2026 19:29:54 +0000
Message-ID: <20260224192954.819444-1-mykyta.yatsenko5@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mykyta Yatsenko <yatsenko@meta.com>

The else-if and else branches in rht_key_get_hash() both compute a hash
using either params.hashfn or jhash, differing only in the source of
key_len (params.key_len vs ht->p.key_len). Merge the two branches into
one by using the ternary `params.key_len ?: ht->p.key_len` to select
the key length, removing the duplicated logic.

This also improves the performance of the else branch which previously
always used jhash and never fell through to jhash2. This branch is going
to be used by BPF resizable hashmap, which wraps rhashtable:
https://lore.kernel.org/bpf/20260205-rhash-v1-0-30dd6d63c462@meta.com/

Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
---
 include/linux/rhashtable.h | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 133ccb39137a..0480509a6339 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -129,10 +129,10 @@ static __always_inline unsigned int rht_key_get_hash(struct rhashtable *ht,
 	unsigned int hash;
 
 	/* params must be equal to ht->p if it isn't constant. */
-	if (!__builtin_constant_p(params.key_len))
+	if (!__builtin_constant_p(params.key_len)) {
 		hash = ht->p.hashfn(key, ht->key_len, hash_rnd);
-	else if (params.key_len) {
-		unsigned int key_len = params.key_len;
+	} else {
+		unsigned int key_len = params.key_len ? : ht->p.key_len;
 
 		if (params.hashfn)
 			hash = params.hashfn(key, key_len, hash_rnd);
@@ -140,13 +140,6 @@ static __always_inline unsigned int rht_key_get_hash(struct rhashtable *ht,
 			hash = jhash(key, key_len, hash_rnd);
 		else
 			hash = jhash2(key, key_len / sizeof(u32), hash_rnd);
-	} else {
-		unsigned int key_len = ht->p.key_len;
-
-		if (params.hashfn)
-			hash = params.hashfn(key, key_len, hash_rnd);
-		else
-			hash = jhash(key, key_len, hash_rnd);
 	}
 
 	return hash;
-- 
2.53.0

