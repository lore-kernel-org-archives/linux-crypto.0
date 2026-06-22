Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21355474F
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 02:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782096616; cv=none; b=RItA7OhnR9pFkgdg1RSxBfqVYRnj4haUOf3qSsOmBjMNljuCTKWIQrm3VRkiXYH2FEwsrOYDKvqwnUFhNJZhWeoeWpuPaT10pRCrx9YTixmGDaorkdTIBjwo88TqFWUUAgZQde1ZqUoGDvhYeOimdmw+g3EXq/zVwhRfMOUSubo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782096616; c=relaxed/simple;
	bh=G2rNFoV5adIJ67Q/VHzpJUP6Q4d76KeZ5hsbq7Sf3sY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EndUJmEby8sv/yoXhS1VYPouNATojsdpqBTvOjwifFMzGM/8ra9grQGJQYYo6XNFAFpFA8EL1/qjLtOhC7cPD8uI/bOStu8C1tjvuNkaGdvA94c7r64teWV0CP7XPsSLGe/v4VOzs5GoLGSm99dTq3P+tZgCry7WbSZKC0ztdxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PBUrICb+; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PBUrICb+"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-30bc0b90dd2so350544eec.2
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2026 19:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782096614; x=1782701414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zjdMcRDdKXxOPpTybSRjt3svtv8NnNZAVi3VRsSNpa4=;
        b=PBUrICb+ooNKXFSPIa+jbXrXZFEJ94foeGTqkWoUncB7ikBgTovoHSZnAYAG79WjMM
         +dE/IYGQXAy9u2sOQHaycG8PC4jMg9Ikp7+EkvZZWcwYbYNboneS9aa8n1Bdgz1Qp5f1
         wROv1iFGL5GKeeqTnqGfLO4wr7n5djveUlDORrNt477fJqLm9kj4iO6q8L4Lor5ly8It
         B5mVyqVByryNvdt8ZFGPcXS7XTLgXindUDu/In8m0qhre2kEX4Ks1fvb3QqOVRftYKS2
         oFgKGLQ+T93qDORKkz8o5rKcfL8kovMK4GlubjemNgJwIysNFV7RZi/ogThPYoSZHUY6
         9H1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782096614; x=1782701414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zjdMcRDdKXxOPpTybSRjt3svtv8NnNZAVi3VRsSNpa4=;
        b=BTQmyd3/QQn63+MfBSk5kv6YPKzvg1QrowCUo+2Z2R0BohmcaCCERTR/Ez7ANX1Tyy
         zvos3I2OV3Vrduey2EMq1XTBAxkb9DcVg6EjvBoWHoHAi6zj6rg9Ec7capFU2ZJuyysH
         GlHAXL+shYEgCfG4vOf08oy7VWdywT1djVmbD7WIVVbpZXiHbSZb/hFjTV11tj5XYY9Z
         k7VOKgIyGfaz4Eq7EtRUfLKV2YplLa6KkVtn+HzRTk9Ml616Jt2b8AbcYQ7LiJDOLXBp
         OM7IxYzAjwL+JgBWGUyN8eZQHpixst1ttZ5oWbKCjtSSHORksgWrUt28LUExEO48HnMs
         ozEw==
X-Gm-Message-State: AOJu0YxWlbNzWub9VF6ogk5olO+GPbYkqvoxiELZttAFRBHqlTCkm5PY
	VgM5wzXtGDaSjf87RQhsYYdt4VkN/7L/k/kvIQMZ9Z3zza0ajz9435Fw7P0ifmtF
X-Gm-Gg: AfdE7cmGt89uVELTHZBApQs9LfWnlOp10azWZdNnc19/uYfiGDc3QyCS+lI2t1hLl9k
	zHnhzujZGL59Gtfs75m+a1vDSi5/C9jdASBhBJiiHZxVO49xvbRoLDuoX+bxyoNAkK+zgvLVo6x
	AyfN47l3v5K87t5VOcRVvv7QDoxWJm9QovAoyye7Il2WCGsw9GLf2WZlfLa/W2Hip/RbSUntwPG
	+KbjjjqDM8k5gxX+whYXHnX98ypoWegFnUyPYvNENvmkljxA9KMZAmjj61wLf65nTF4cqdBP4ko
	50+1M7aU1I0RYHMWTGiw4Xg8eYnMy68Kvy6xQkAU0kqXQPzHR8w0r5HxYyFYsRwox5YzkMRZ2Uz
	o0hvuzlDHmjZcHqNDf66Tmr9kT3lV9If5J/oz5c0+QsIX9wQ4XPoGxo9uYik8k4tZt5hwkw5bx3
	guM2dAU2fOBwJm33eb6igeIyWDbHVBf2pxM690KHag8ErKUaHQqVo0y19/15aAxmcCjjohclszT
	s1Nzw==
X-Received: by 2002:a05:7022:397:b0:137:f2f4:ff76 with SMTP id a92af1059eb24-139a210c666mr3664233c88.3.1782096613839;
        Sun, 21 Jun 2026 19:50:13 -0700 (PDT)
Received: from localhost.localdomain ([47.246.98.82])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139adcaad8fsm5946719c88.1.2026.06.21.19.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 19:50:13 -0700 (PDT)
From: azraelxuemo <eilaimemedsnaimel@gmail.com>
X-Google-Original-From: azraelxuemo <xuemo@xuemo.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	dhowells@redhat.com,
	HanQuan <eilaimemedsnaimel@gmail.com>
Subject: [PATCH] KEYS: asymmetric: fix OOB read in KEYCTL_PKEY_DECRYPT on zero-length message
Date: Mon, 22 Jun 2026 02:50:02 +0000
Message-ID: <20260622025002.798934-1-xuemo@xuemo.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: HanQuan <eilaimemedsnaimel@gmail.com>

In software_key_eds_op(), the condition

    if (!issig && ret == 0)
        ret = crypto_akcipher_maxsize(tfm);

replaces ret with the key size when crypto_akcipher_sync_decrypt()
returns 0.  This was added as a workaround for encrypt, where
crypto_akcipher_sync_encrypt() returns 0 on success (it lacks the
"?:" data.dlen" tail that sync_decrypt has).  However, for decrypt,
ret == 0 is legitimate: pkcs1pad_decrypt_complete() sets
req->dst_len = 0 for a zero-length PKCS#1 message, causing
crypto_akcipher_sync_decrypt() to return 0 via "0 ?: data.dlen".

When ret is replaced with maxsize, the caller keyctl_pkey_e_d_s()
does copy_to_user(_out, out, ret) with ret = key_size (e.g. 256
for RSA-2048) on a buffer allocated with kmalloc(params.out_len),
which can be as small as 1 byte.  This reads key_size - out_len
bytes beyond the allocation.

Restrict the maxsize substitution to the encrypt operation only,
where ret == 0 genuinely indicates success and the full key size
is the correct output length.

Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without scatterlists")
Signed-off-by: HanQuan <eilaimemedsnaimel@gmail.com>
---
 crypto/asymmetric_keys/public_key.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 09a0b83d5d77..2c3ac75ec92b 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -358,7 +358,10 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 		BUG();
 	}
 
-	if (!issig && ret == 0)
+	/* Decrypt may legitimately return 0 (zero-length message); only
+	 * replace ret with maxsize for encrypt, which returns 0 on success.
+	 */
+	if (!issig && ret == 0 && params->op == kernel_pkey_encrypt)
 		ret = crypto_akcipher_maxsize(tfm);
 
 error_free_tfm:
-- 
2.43.0

