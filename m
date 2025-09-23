Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3E92D8396
	for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2025 06:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758607583; cv=none; b=r0r0VHTtW7gDCRASjVoqZS8uOOSXkFATs7z6+ZmA1w1NCZ4hOsENAuaYFijHp5IxNmwJcmoStSqaBoeiBYjS9Np0oXAvjLm0WJy5EAsU0IwtuOKVQxMroKr4ARKs3nkkznXQ0n9emkx/qrBpHajpES0dUSNMd5mDwvGS95jcvn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758607583; c=relaxed/simple;
	bh=Er4W8MIpmwD3PLCWmK+B4k++5a8DHlRT/jgXJD2s0sU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t4aCZPCmigLw91CRPPHKQlF8hO+A+28D727HbA0puQMWzWk3atlVxqumtos3URjV5mU0ZIfjFN2IocMxghHUVoDNM6lHfgkDJFhe4w+6Nr0xIOJjBnGbE04mLRVUBmBQXnTNR2ru50jqfd7VhC1g8aJioxpq9Y4mLeArK+EmAdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OrXo81Y6; arc=none smtp.client-ip=209.85.215.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OrXo81Y6"
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-b4c29d2ea05so4599847a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 23:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758607580; x=1759212380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=omk+3E3VbH2i+N8tji9NWKgODSvwpWUngMp/3zr1rgI=;
        b=OrXo81Y6/x3McQ9nk3fL5LKDPCiLm6MADQ7DXICO1fjtmzvSpDYA+do8zQI3prDsoz
         wL47PqaWzBK0+htmxLl+hjmUAQJyIl89lihHOnzDeI8yYturKpCIPIfYYbrk/TYoXma3
         p6DqA5dOlr+YiHjzHQ30gmcxHmXg65YogOpDASFIA1WVCJLbG5xXoMb0seaksdoFRO8Y
         WDip8zO/p2hOwdNfowFU8Cxh5pX+ZJZIs7SuVHXtzUGWNgYHLIhQKuqPFx0H5v+g/Iqa
         er/iNIdkv+M65FACke/iHAkyMQKHb4nov4FqMciilIb1xkxJBtqxe4mz7sHpYDbk7kgi
         889Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758607580; x=1759212380;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=omk+3E3VbH2i+N8tji9NWKgODSvwpWUngMp/3zr1rgI=;
        b=wkqm1lfMVL632tQv8weLW8mFqfDq8V7snyN0foTe1wq7mJM4NruhVPDzbloxRCec7/
         Bm1asSmjU9OPXYM8U6FbxPF1bn6vwASBW0+pHmUtfE6ENmGrxQhJyDJu2VSEGIZ154nf
         xABbk9QFB/C3edZRDYApclOgY0xRNOB6QjMd3vALX5b7iF8VtFZk9TfUxzEtVyKJAsHm
         uFDjw34bxE4mclFRwRthRndpa73ClhzEfh3tgXtYfG/HfWZHWp1etj8JeDY6Im2EXbDh
         bFGI4T23mo84+h+ZDMp9DkP071m2ylgWVbtX24oFq0mMNqHmJEMclGzPktqaQqSi4QVn
         /SMw==
X-Forwarded-Encrypted: i=1; AJvYcCXDN1KwoLCHyrPnIyNUd7qUQW6x97WR922ufyohBUEYMENIIS0pw8oRndJtFDv9yE9H1sfTANrroTbM4lU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJx4mo2Ar55EB96AXyV50cAX+dv5rKDiSykFe8x6P5ZvH3IMNC
	m17J7euR/6ZVhYZWe6K8zgF9gk0CuJzbaWPoN/ydwyNL8wtd5cZGLBsI
X-Gm-Gg: ASbGncscamjb5VH+yLiC2U6SjRjM9HA2qA4MXRdWsZwUmn23IhdYh2mXV4LegSoz79w
	r5K41zcXYiWM8p7U0IxhO72Pfq7CfFn8SfJVen4wGqWzKOq7e0IL0HCVbc4soTYESX+mDR38yEJ
	qeUEd9Z0czjZV7eNQexkjJgTcU6RenUIwyL26ccIRKj4lRDpQSrZxnNWEa4w1APo5A3WwmXHhCt
	BsvjGyHuxVj+ywmdYvXMO0vjoH2o0zUGkHuPEBiVvqr3OHnMZvQexp1rULmjrjO/xp3lTAT0M8l
	bnty4M0fxWCl71a0k0Z6Pi5ewDClC6Om04zAGXXsA/Eoe0wRI+X/h/Ouk/i4t0Yqd/5FFPaZVAK
	eGAf+YRck/s/AnBjXBJI=
X-Google-Smtp-Source: AGHT+IFjh9VwSK8iG3IMnKGftTZdz3zGpcCmuQXcy2PSoEUaE8GN+Ok52y1XVrwZHbztSofbKH8EHA==
X-Received: by 2002:a17:90a:dfcf:b0:32b:9506:1782 with SMTP id 98e67ed59e1d1-332abf16faemr1446491a91.15.1758607579783;
        Mon, 22 Sep 2025 23:06:19 -0700 (PDT)
Received: from 7940hx ([43.129.244.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ed26857a0sm18103451a91.2.2025.09.22.23.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 23:06:19 -0700 (PDT)
From: Menglong Dong <menglong8.dong@gmail.com>
X-Google-Original-From: Menglong Dong <dongml2@chinatelecom.cn>
To: herbert@gondor.apana.org.au
Cc: tgraf@suug.ch,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] rhashtable: add likely() to __rht_ptr()
Date: Tue, 23 Sep 2025 14:06:14 +0800
Message-ID: <20250923060614.539789-1-dongml2@chinatelecom.cn>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the fast path, the value of "p" in __rht_ptr() should be valid.
Therefore, wrap it with a "likely". The performance increasing is tiny,
but it's still worth to do it.

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
---
 include/linux/rhashtable.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index e740157f3cd7..a8e38a74acf5 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -358,9 +358,10 @@ static inline void rht_unlock(struct bucket_table *tbl,
 static inline struct rhash_head *__rht_ptr(
 	struct rhash_lock_head *p, struct rhash_lock_head __rcu *const *bkt)
 {
+	unsigned long p_val = (unsigned long)p & ~BIT(0);
+
 	return (struct rhash_head *)
-		((unsigned long)p & ~BIT(0) ?:
-		 (unsigned long)RHT_NULLS_MARKER(bkt));
+		(likely(p_val) ? p_val : (unsigned long)RHT_NULLS_MARKER(bkt));
 }
 
 /*
-- 
2.51.0

