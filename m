Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB6B16C69C
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2024 22:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722895956; cv=none; b=aBwbUgNkLZgKMHZKTfxsG4owbcSaDKkBiJrXimaWCoqGNKHe6iFFymoBPwa3ow/4XtKL0IWfY+0VYZqKYnhotwY4j28dYLRr1BhiePlOxv6cqT2OVqs4CaHKceDisUSdPrQwzT3dtEf7wAsgtuVINBOHHKt4nzz4+Ka6IGy8KXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722895956; c=relaxed/simple;
	bh=GMMQ/BSSoja6QdzkOekqjoODSmfp1vm+ibzeOFuYkao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LGYcTcZkenvQdYDySxaH8r5UMmDJcfBdWX+IMzuNbuzL0ni0J77bjQkaBRJt/lt5heQl568ax224DqNQQsv67BwwZhFnpR1xUzLCb/TpvQHvrDCbnK4dth+rD2XKWHHL3tjybVRh+4inaIMR6hZFRKu4nTRliK4dNEl7Rc798Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=HGhuwseE; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="HGhuwseE"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ef23d04541so335771fa.2
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2024 15:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1722895953; x=1723500753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rjktkTxw/Pi+sq69hQv/6e2Ff6RBaiaqpdpd0sush00=;
        b=HGhuwseEm9/CYF+OrEExQ8aUOWBcveUkaVLpJt8v36yEa/FHSUaeTFr7eVeG5NUfDb
         sXwUHDlaLiZG0uYxxIHl9Y9LP+LSOJsZAjgaHgZ14wCW7ILupd1JaLxfnLfebTOPXgty
         MC0si0m9F2T89RXQNoAZZKCquSnnEFoYizqXcVd7AVDhh7lhjwG1FAe79RkqMLPZNrYf
         YUXk7npWr3QvZlM+H41kYskMX5XZV/rD/NCzO3Cz+Rrw1lRX+aeMmMn45MmIrViEAJYU
         IufUFSeDwjCZgjhN1+w9yNTCd20SiZbTqWoXGKRbciNxIXPUqtiTcETwkK2xUxfbiWPs
         zp7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722895953; x=1723500753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rjktkTxw/Pi+sq69hQv/6e2Ff6RBaiaqpdpd0sush00=;
        b=Dqk7DpA/LBWVcHMkHVSj19KyCa64SL+2DpqNwTXHkCUgDFjMi6I/INBm6W9Orlew0n
         obiv8qm1LvzbulQ8Q3P/hI9eznx+WqIj0eXRMAQtJt8QI0SVY3VROrnMzj4CHtEaJKzO
         fFoUxRNWtRi8eI0n7Z+kTTnTewMCSvuwf4UKnZDbEBdP+iuWbSOjlPsxZEsXTn1avWRz
         bzACQ6kfb7asJITtr1xvwXM50J+KU/oWSNwB2wtAxsvMDHkZCIS+StkgPZJNiEEDjkN9
         RwIK1rNEUDaGhZXqdiMJZOb3Hh1IQ8g7TXkudqlPJ2BNZuMrekNm0Z/EV13G7R0If4mJ
         KpiA==
X-Gm-Message-State: AOJu0YyC3nbtrLVxcvOeJp0nXzQXrofifeHM+Ae06Tb8tINONfesZ179
	/FkVldZOa6KQmyfFsw4Nlu+1wlXh48FAtHd7b4mOieE5DoqQmJcWzeChsCUmgzQ=
X-Google-Smtp-Source: AGHT+IFs0Uy29mB1j2MnwxM05txW4e7pmKV5MgDq485zBDkbVZk2z/Q53EtTBT/oEK9MOwwMhGcJrQ==
X-Received: by 2002:a2e:98cd:0:b0:2ef:23ec:9356 with SMTP id 38308e7fff4ca-2f15aa870dfmr86996511fa.8.1722895953040;
        Mon, 05 Aug 2024 15:12:33 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-26.dynamic.mnet-online.de. [82.135.80.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-428fecea453sm12355e9.1.2024.08.05.15.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 15:12:32 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	kees@kernel.org,
	gustavoars@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH v2] crypto: chacha20poly1305 - Annotate struct chachapoly_ctx with __counted_by()
Date: Tue,  6 Aug 2024 00:11:30 +0200
Message-ID: <20240805221129.2644-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the __counted_by compiler attribute to the flexible array member
salt to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
CONFIG_FORTIFY_SOURCE.

Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
Changes in v2:
- Drop using struct_size_t() as suggested by Eric Biggers and Kees Cook
- Link to v1: https://lore.kernel.org/linux-kernel/20240805175237.63098-2-thorsten.blum@toblux.com/
---
 crypto/chacha20poly1305.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 9e4651330852..d740849f1c19 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -27,7 +27,7 @@ struct chachapoly_ctx {
 	struct crypto_ahash *poly;
 	/* key bytes we use for the ChaCha20 IV */
 	unsigned int saltlen;
-	u8 salt[];
+	u8 salt[] __counted_by(saltlen);
 };
 
 struct poly_req {
-- 
2.45.2

