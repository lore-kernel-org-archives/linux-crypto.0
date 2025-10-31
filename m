Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29560340275
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907192; cv=none; b=bMCqXq7T6R5cL7sGbb5R0sCMqPtUGx8X0Yia4o4IX+fky1wDVz3mLsBt3Tdejhq9MB1lZFEU4GnVPztsa8LPzJ8eV8J4CWl73cEN3aFWZut4Pl88h7CjFGugvb61cig7STeCAWOl0F0f00vcbvyVw+ZVXAGseEFqySwxPtbkPGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907192; c=relaxed/simple;
	bh=YgxDh8WWdIzSNRNYvsvKvpMfpn793r2yiLb1h9a45as=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rnsqj9uyWd+eRA/fkyzdjqUfqAe/7f9y/KJami1nVRlgKLp4Ijdja/9EKYffUULVQXTOAHfXMwftqFL8fSQUAxECRBxRnKveMv7Zu6zcFYNgapgr0LL/5PbQya2eY6wpnlv+a2aCfYKAhzl/7rNeR3BahnDcFl5Y3RGRxdvDy8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vcX0loCr; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vcX0loCr"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-426d4f59cbcso1769916f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907188; x=1762511988; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HN/+IzS5796w6R+9DpNyrnH5kTzGCEYUE8OX1y/TT0c=;
        b=vcX0loCrubb98yyHl/WY0Qc4yplD0zlAWkivbi2UVP0Nm3IcJN7itPNpwkXSurdTJi
         1D0alpfN2qkKKINGWF+iiX9Ajp1mVUXb2yZolkHGCw9x6XEQXrC8KPdOKIJrUMnDeGK+
         Ft+uVRsxGicrdB4fQHSGu6IOZCLCZbd4QB7tPopuec9FeiPpoHVxkmT0248yeWsWfNJF
         B1+8h1bLmsg9WihGRw10tDhJ2r1wxgf5D7XAdUw2yj6++pnnw4fbfkw56KVVZzGNHY65
         YodUy/+oXPS97lqCu64RZs6MP2wuh2lu6+wxc2mzDKbXgeWw6aDgMgdbbDcgYWV0BLaH
         P1kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907188; x=1762511988;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HN/+IzS5796w6R+9DpNyrnH5kTzGCEYUE8OX1y/TT0c=;
        b=baRcfZbXow/UNvvHs32V4zP6xyWWqIy3Rd1XIhyeyKZs7zH+Tqu3UYl65AIkFJEQfW
         YfrHLkRbS6BLK1At4wTigl1fQ6l8YF0dMY73DLwUOeqATcac1aqtfuu//5hBM2b5fV3e
         z13iEIVm7nhvMZGfPKHVAx4Ds70pvN4fjHn1tyBuEM2ByYb56ZdCxjEAWruXogLU76u5
         VC0gyEJyQdyP6gWCPODg5LTxzYXX6B4fswq8Ijm7OFxLUN18BTL7BFFRcsV+alksyFEW
         k1FCt1wq8soh9pPiwiYQFV/bRM2ASK1jFqGJ571hIMTLE6aFUMuwDpO41GNcqW0gAwi+
         P1kg==
X-Forwarded-Encrypted: i=1; AJvYcCX4kX9N98nXKfIHSe/jg0KI9eDG4n0QkXnZp4nxs5yjUwsK7kQcRVy16iKq4ttTxVindSNbUbYTg2Ilgyo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4OhkXWfo1HslZX0oGUsoppWj2WN9m5cNJHry7mhOTX8O83dv7
	Jh2dgDT2f8YpXz0QpRhmtkEM9yzfPcoz083mapJGAqMFpbDhrBcC80u2zZwLTqmmV6I1s7axwQ=
	=
X-Google-Smtp-Source: AGHT+IHlmFXxc1C8TcZ+HXf8DCZ7hZ6snCdGJ0O89HH9mn+babxzm78NbK82txSCG6oBizn12pHWQ7nS
X-Received: from wma8.prod.google.com ([2002:a05:600c:8908:b0:46e:4c7c:5162])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a7b:ca54:0:b0:475:dc32:5600
 with SMTP id 5b1f17b1804b1-477262e8fd6mr49406465e9.19.1761907188374; Fri, 31
 Oct 2025 03:39:48 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:39:01 +0100
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1825; i=ardb@kernel.org;
 h=from:subject; bh=yjdixCt9NaDfY8u4Fm681ZNm+FKMZ22mvY7LIiuXs68=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZNl4rFLr9lSCrOW7tixbpb2jXSBA2sFQ/zV59hqMJ4UW
 BvJV8HVUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACYy7wHD/+A1+gVed6+eSP31
 oeHEnZUKayoiHTn2rFzct9j7W+9xWxeGP3y15UmKR/Odrh3eEr7Iwj51X+TpI87ad6Rlf32r4mF fwQEA
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-25-ardb+git@google.com>
Subject: [PATCH v4 02/21] crypto/arm64: sm4-ce-ccm - Avoid pointless yield of
 the NEON unit
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Kernel mode NEON sections are now preemptible on arm64, and so there is
no need to yield it when calling APIs that may sleep.

Also, move the calls to kernel_neon_end() to the same scope as
kernel_neon_begin(). This is needed for a subsequent change where a
stack buffer is allocated transparently and passed to
kernel_neon_begin().

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sm4-ce-ccm-glue.c | 25 +++++---------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/crypto/sm4-ce-ccm-glue.c b/arch/arm64/crypto/sm4-ce-ccm-glue.c
index e9cc1c1364ec..e92cbdf1aaee 100644
--- a/arch/arm64/crypto/sm4-ce-ccm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-ccm-glue.c
@@ -172,35 +172,22 @@ static int ccm_crypt(struct aead_request *req, struct skcipher_walk *walk,
 	if (req->assoclen)
 		ccm_calculate_auth_mac(req, mac);
 
-	while (walk->nbytes && walk->nbytes != walk->total) {
+	while (walk->nbytes) {
 		unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
 
+		if (walk->nbytes == walk->total)
+			tail = 0;
+
 		sm4_ce_ccm_crypt(rkey_enc, walk->dst.virt.addr,
 				 walk->src.virt.addr, walk->iv,
 				 walk->nbytes - tail, mac);
 
-		kernel_neon_end();
-
 		err = skcipher_walk_done(walk, tail);
-
-		kernel_neon_begin();
 	}
 
-	if (walk->nbytes) {
-		sm4_ce_ccm_crypt(rkey_enc, walk->dst.virt.addr,
-				 walk->src.virt.addr, walk->iv,
-				 walk->nbytes, mac);
-
-		sm4_ce_ccm_final(rkey_enc, ctr0, mac);
+	sm4_ce_ccm_final(rkey_enc, ctr0, mac);
 
-		kernel_neon_end();
-
-		err = skcipher_walk_done(walk, 0);
-	} else {
-		sm4_ce_ccm_final(rkey_enc, ctr0, mac);
-
-		kernel_neon_end();
-	}
+	kernel_neon_end();
 
 	return err;
 }
-- 
2.51.1.930.gacf6e81ea2-goog

