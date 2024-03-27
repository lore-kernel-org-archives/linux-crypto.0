Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB159153BF7
	for <linux-crypto@vger.kernel.org>; Wed, 27 Mar 2024 22:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711578379; cv=none; b=YlFeUHCuCkqe08i28nTvtHlirjb8u8WBxE8P0p16FhQNf0Zy+RSJQcwJF3F8eL3saqPsofNE+N3yuYOqyV90AMgnoIJFhAkgWkwLdKnacWlLX9avJDiYyqNYcQGPa5WUwWrL/t29ZT/80BNKcn7uIR6lWvTz+spy6PJ7ZwZTB/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711578379; c=relaxed/simple;
	bh=IpFdxipUZyLZ1WGndAkgbYxrgUnIpmiqCPmPgoQjeak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ILKAkVy1exFtx6c07tDu/UJafnRD+aCWVHFoWujDpDcczhY+rvtImAk1Nn8P6SnkOfiV2h9hPAM5YFNsyJcXYhqzgoO+76NtCce25bqTLl97DXQWzP8HPdLfkL/Xa6aSD/aJVW4FiuSAUp4lo6ceJPJUNB8VZcoLyfzbBJLFjP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=0/rHPNp2; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="0/rHPNp2"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-41495d16568so2238325e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 27 Mar 2024 15:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1711578376; x=1712183176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jc/kebwJfSc9In02r4D75fEwv6vQMObeE/5ZkpkXrTQ=;
        b=0/rHPNp2PG3YSSyg3i/Z7nSAkPEyb0wtVIr1Bd64nIBXoswvKUu60vXe8pZGTDEf0L
         /qoZkQhmGC0YTlwWhPLh6I0FSTnK/4THPJbhgyIZmAqVotF+4tmxBsROSAaislUr7WTO
         ls/1PVKhlQuh77EumOXhDE4Np/cLSiVg+YlqF8CPpZHYTzXQFc1UpMuYkIpGNpmEHskB
         vOhWQJ77qxUvlwTfIcEcPIVQApQNYmrk0LKwzDqdmU0agYXVwKFKY6clRK1iUOREXcXE
         PgVy2eq988AkC5xClpoanmj6YGawXV7/uFE3roXPBQRh3CKpeVbgi8ynSX8FHGs4qg5S
         TjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711578376; x=1712183176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jc/kebwJfSc9In02r4D75fEwv6vQMObeE/5ZkpkXrTQ=;
        b=avm21QTg5rDENwJmnJduU/6os/+2D/+GjFzhuncyT4zHXN52PzLMNP9aP2uZ103LDV
         KCZkhztj7NgOA2kR/av3qkGc3NmidWQwYH29V1964C8Ohn2VLcN7MNgJ9YKFpchl1oH6
         Z1r2Q+zqT1YvqKpJUv77p8ZFccKv5E0Qsr4m01/BUXnasfO9voc2L59AS8JZT/ZcRTfQ
         +MkqK38DL7PxScIJJSMEaU2mLaycRiaG4g732LsQJHUjPLGveI7/A0KRSRUfS2DnfR7/
         3wbn1NUtvmwR14GTF+uMzfomfPgQloqPJHmw2KGcJyz2KP8ACJ0sqPfWwTr3u3kpUFy2
         Sacw==
X-Gm-Message-State: AOJu0Yw2F5D9XetZEGCBsNp3cB9sZGtNdqECq53/RZnvaZgZBN3IKXpQ
	tGkXVP0kT4hRrHCyCZnWnbGycLFEeZejNdvi0JHvg06MKN9WjKMvSyCoQfKSagyekAap1BrDvKq
	9
X-Google-Smtp-Source: AGHT+IFwNhiusV4dv7iZPuOpk/UITq2tStkbzgluwVYTIG7ZthGgEhWlZHDMpFJQMLFh/fxwUE2peg==
X-Received: by 2002:a05:600c:22d7:b0:414:8889:5a65 with SMTP id 23-20020a05600c22d700b0041488895a65mr1177566wmg.30.1711578375898;
        Wed, 27 Mar 2024 15:26:15 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-212.dynamic.mnet-online.de. [82.135.80.212])
        by smtp.gmail.com with ESMTPSA id l20-20020a05600c1d1400b004146a304863sm3390089wms.34.2024.03.27.15.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 15:26:15 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] crypto: jitter - Use kvfree_sensitive() to fix Coccinelle warning
Date: Wed, 27 Mar 2024 23:25:09 +0100
Message-ID: <20240327222507.42731-3-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace memzero_explicit() and kvfree() with kvfree_sensitive() to fix
the following Coccinelle/coccicheck warning reported by
kfree_sensitive.cocci:

	WARNING opportunity for kfree_sensitive/kvfree_sensitive

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 crypto/jitterentropy-kcapi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 76edbf8af0ac..c24d4ff2b4a8 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -61,8 +61,7 @@ void *jent_kvzalloc(unsigned int len)
 
 void jent_kvzfree(void *ptr, unsigned int len)
 {
-	memzero_explicit(ptr, len);
-	kvfree(ptr);
+	kvfree_sensitive(ptr, len);
 }
 
 void *jent_zalloc(unsigned int len)
-- 
2.44.0

