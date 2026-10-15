Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C1A51FCCC
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 12:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068326; cv=none; b=abj+0pYwiM5gtvycyyhfpdAxLYwW3pLypO/N/AhK4U2edLK+7jmVHHibDDzZzXRe6RT7pOc8jnSpz+4WA3a4Iu5b0SHXA6KwHuzOWtRFl3iyMOHt5ZKqxrtydkG9jYtydPYAm8ilXMRf5Q3q5VvXdstP9HNPTzTV1BMpD22YHl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068326; c=relaxed/simple;
	bh=vylKQQ/G2tNnnLYMwRsPYg1GgKjJI3BVMUSDP2z2GUk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lHr6hezPnEkCEQ4AALinNG8oEOuWJpWlzwyvfEf4cLEF6U7eqJSm3IVcYAkTD2KZMxAInEZgDJ0eAa/d+kKvr3JFV/XB/Y5N1t74B0mkhPgQkZqucPEqAfgftkG+xi0CR+DDLDpXYbnYdKpkWIR79FuALF7+QgIqTWxR2OINz4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=snhSgmRP; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="snhSgmRP"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a16aaf2067so25389755e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 05:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792068323; x=1792673123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=g5NM70b1gJo1/du8KK7kg4ZTGntVLz97iWXJs9yEjyI=;
        b=snhSgmRPnsWlEjXREbKlA10vr1u4CtFlnG8j1WZx1UTUi6xIF5kxfGEhT6tPyFNqNq
         FrE/Bi+iA2P6Pns6d3xBz2aMvdTffRS/NzOGXb8Nsc065KgZcZUqO58xbpipevruJpeZ
         kebAW4hDpR3jZdITocTwe1xIK/Vf4iyon8Woa4AVr5DPTy6ilgbXaImD8ni0dwbuqsLB
         2ioJE1Xjw+WMgNuaSAQBwKsqfA8UiCP4SZBG10ep5TPXquT5MySmxDBWr+ReTy+8vlVA
         V2f+/ZASswo82E590GgBIl2GVkbe5K3Co0V7Q/C1fEazfNPzPhXjrHysdvlajK9ehw0F
         NwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792068323; x=1792673123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g5NM70b1gJo1/du8KK7kg4ZTGntVLz97iWXJs9yEjyI=;
        b=wPseGQEUBStnfWtPLExLVHRsvBaQFHmdGLThghmhJGwxl7f/1CEZKWZy5kMW5y0TtS
         FE0yFIm8hjUqdQ5PVtDmxphr18AYzbC7x5w4RAGZxmPcuJlQy5ygoLQBydVoOt7EHP9X
         w/vWRM376k+r57iulFgRWHvbqIlogy4MB/A2Q6eSP8WYxsquZuT7luBq6dy0GwD6VBt0
         R0hcRywDDjxauOp9AMRmw/s3TneI7qHGbin6Z7lGaNtlv/8BARe/MtUoRdrDcF0qZco6
         tnxT80umJXhcXRPBb+TG441y5ZvscP7QsGJDWbIWzHXjkAOrsu/AYZqB0tmUv8eslgAp
         NA8A==
X-Forwarded-Encrypted: i=1; AKwUvBy2WAlmaKVFw44Ne0Dz0mDCmrZYxg7fgZf7QSwFPIVv/GlqK+S8ZEVZDWojA/KlGtR2dp3iqTDrKNCO7jI=@vger.kernel.org
X-Gm-Message-State: AFq9FYJwp6U5+vnJhl/uxMRBeCfQOYLHwMidFGNT/IQlXxExiBSFGbWu
	2THzMTYlonpF2HXV1/4AufklA9WCe2bsacIG9mEOl5aBRMJU+hjAF0ZDhZSGeJhZvowhglR4q9E
	=
X-Gm-Gg: AYBFou2EaJ6MTY/s6OViNrWOUv1tfGWkWrONwPPUNmJ2qLXZ6XesXre9MwDxkh9XFB4
	pGXuzWPkKlOHnG7z0Se0ekv7LogmhSEZTALVgYTE5uGYDQpEImcld610qGsEnVHJBCV0e+/uo/F
	PC6dCpCoUZl2uACv/ru7K8VhyzH7T3vQ4WhRlUruIqulgs4vVi9slCnSy1vBlyruC4jUM6EQHll
	JppoclK+vratBooKf1i1a0SUlxF7MT/IiDR+Lv5knRwhhkwi+/57dTHQoapb7XGwEjvZeN9STg8
	UwUw9KNEKZdIxXgqSrWOo4XkCxE8bzb1KxNJLxTecPr+Pb9/gKncwEIspNpsI7omWmQWQqg/BIh
	CL5v66aXM+2u6nrReayxvb9CQUHKTtPkW5mM+YnieAai6K69FQQURjw6rHjxZjKQLQqfyAIY+vZ
	PH3QmYgUkHt7JsgnfxDqfYg9M6cUrwBynAVBWj85Dm0Kp2QlN615umjREkQLn7YQ==
X-Received: by 2002:a05:600c:4f42:b0:4a0:b6:4619 with SMTP id 5b1f17b1804b1-4a18e3ecfc8mr457506165e9.0.1792068322613;
        Thu, 15 Oct 2026 05:45:22 -0700 (PDT)
Received: from fedora ([2a02:4540:a7:16c0:b518:4b00:679:375])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd640be0sm52911945e9.1.2026.10.15.05.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 05:45:20 -0700 (PDT)
From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
To: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Subject: [PATCH] crypto: x509_loader: Use %pe to log error pointer
Date: Thu, 15 Oct 2026 16:15:00 +0330
Message-ID: <20261015124500.53228-1-ampr.mhd@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The error path in x509_load_certificate_list() prints an error pointer
with %ld and PTR_ERR(), which produces a raw errno value rather than
the kernel's symbolic error name.

Use %pe on the error pointer directly so the log reads:

  Problem loading in-kernel X.509 certificate (EINVAL)

instead of:

  Problem loading in-kernel X.509 certificate (-22)

The new form is easier to read and matches the convention used
elsewhere in the kernel.  Reported by Coccinelle's
misc/ptr_err_to_pe.cocci semantic patch.

Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
---
 crypto/asymmetric_keys/x509_loader.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_loader.c b/crypto/asymmetric_keys/x509_loader.c
index 0d516c77cc2..373b5106e10 100644
--- a/crypto/asymmetric_keys/x509_loader.c
+++ b/crypto/asymmetric_keys/x509_loader.c
@@ -39,8 +39,8 @@ int x509_load_certificate_list(const u8 cert_list[],
 					   KEY_ALLOC_BUILT_IN |
 					   KEY_ALLOC_BYPASS_RESTRICTION);
 		if (IS_ERR(key)) {
-			pr_err("Problem loading in-kernel X.509 certificate (%ld)\n",
-			       PTR_ERR(key));
+			pr_err("Problem loading in-kernel X.509 certificate (%pe)\n",
+			       key);
 		} else {
 			pr_notice("Loaded X.509 cert '%s'\n",
 				  key_ref_to_ptr(key)->description);
-- 
2.55.0

