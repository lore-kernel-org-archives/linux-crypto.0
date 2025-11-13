Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA989230BCC
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 13:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763042112; cv=none; b=MBAzNP5oz6ko+nHN8cTkF1SZAQ15gzJugDryNdG3OjfBfgVk2SoWsnbdc4ND/IsvzMJ9OpXF46b/6rt+vi/rTMF/ZC47CqHxXi+iwHBoYiEWuU+QkvrZ4oQUBgO1SBsTAI5vO6SKpVIwFhrhlgJfzJEwjudVC+FcsDVU42zbkS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763042112; c=relaxed/simple;
	bh=uW+IuG/Sf7T8gkkGzx0AcLdnK9/ZQ8qHnzJpOQ624do=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oCJwoClxd/BNUMdoeyCVCmbUQez1yA3CS8abe21HrZ67Yj8yS9tphlYXz0UoLDv+oAh3k2Q3quEg5yZH6HCi+MFzNCstcIMBWpKZswLr6O5Aqt3XOL4dMr3dbUXm7OuGjol6NHcJUAK6iI3lI0nf/wZ0eXU+ZqDOEHzFN7hX0nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L8adYPZ8; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L8adYPZ8"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso1441310a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 05:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763042109; x=1763646909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tMshJ9A2DIKrA2Zogs2Cpxc6fwt/f5x2waGapESpvZ4=;
        b=L8adYPZ8zHBubLDnvFEl8Nm0l1WG4yo7GFmPIsLbIdnurxbcBHI2RHMsZiF+cZl3Kg
         XcNLyhEebeXket5My1EUyss4y4u+pl4nHYXXr1Albehl3Zca0dZgU7gaBYL+WeiD9UUX
         KVq+TNfuWyYNTpebKgVGoANZv4sTbKQgjlstcvfnYfyBSV8+7Sow2BD5GTY/iLLyM/Fz
         TTaGv8240yNAHn/06CWenP1UC0VfwmCXtISo6ZBi4FARZOj4j6w3Xf/f7ZkF6FSDaR39
         wtAd9KcRBUYSqzY6hbQVKlOqNWvXrskWS72pTi9bWD2tNlba5KbFnB+s6jvjFnAoUiXS
         bm0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763042109; x=1763646909;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMshJ9A2DIKrA2Zogs2Cpxc6fwt/f5x2waGapESpvZ4=;
        b=gxwQKn9rXTrcFQRR37/O/ElhGjXh4eTjdVYe22nhUmFj3xzKtw+gmJrhAmBLTXK2oW
         ot2lzOMtwpqPd1ZEa9YtsqACqFz1by2vvcErNLSSefjpBb+Yw/Ly9yVsBNkc/K+aAh04
         ElUlFW97TcqSXBNAUHAvneXpFADlNtnEPQ0Lovcq2dnwcwUKCZ/5Sjv3zU1L6U96QuH6
         3SN7kkeh8C290O58AuuH9R8pJPLciMQhDwjkTaJlRGFF0ay9xRvh455/816Z+L7/3GiO
         8oiMlJRC5i35Uu/9Dc+BmvCjBJgICKe3IISHv56jBHjJ1G6xIZe2aZPv9hT0TSQNYxxH
         +2Dw==
X-Forwarded-Encrypted: i=1; AJvYcCV/mD9Sv+MLZ9j6xU6VNS4IwBAuYtRZ+TN/SqvQvrNLU6/tkEW2ZoUFQRNrZYZUTFOIwfVQe+L4lr07ej4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw28JmINLser2uK+whGqKJnRCMWGgL5gev2qSn6X2Zw7o82hbzF
	gMv3e7BX6+oHRw0KKACQ9A0UUBwigtlMZXCq8Dnh+RfJBCg6LZFpmjhtPipVZMW6F1k=
X-Gm-Gg: ASbGncunXf9NhZ1sSMg3Ps80RrCRz50n17LXxhea17jmvhWTWhAfLj95aYzSQKX40gl
	8KU5KVeScy+PyTQc1GaHN+yqJFIsTVfcMNTLTd7InShk0lygnC2VTCEw8YgFpKzXz2X7srKQGTy
	VgdDoeYEx0DGsvYkEjRBirMBTjyV5Vn6luJVNVAnKIS54ylig749u5hzNtPgMfTYFVZ81XES3mg
	6Ba9mCGWQ2nQms/3SvDIVYbB5cBTf9flDvqj8KDu/d910Q+wWFnJuu5y9XTmK8DOeQPjZxUgwTf
	KsqbRVrsAyoN7L0ZnGixBd0sC445UUMWFZ7mntl00HC3CttvRnxmV/iXkXFclEPNfv8ef9ldPOI
	vKAfg0g4D6t0BgIwoSV38e4Mv2tBBfnyFLAhlqu/JtqLOlQeVpGf7g7JWH6zo58wrohQ1a94o+X
	6C6bU6AaKi6U+pVi/5yJ4/gXLttgey5w63IC5OMEW4Ey/YyBL3Yr1uXCDp/QRBtDsgqn65ACIyD
	vfVPDWQ05nYeHerFOu3XRgG4Ek8DPpUUWePP5NR+kzTUg==
X-Google-Smtp-Source: AGHT+IFjLNMTWll3wOMHJj7C1o2xo2PeNqA8MwVTUyKTH4gfY4gLjSKxihlZto1PIt7UB0ETL87owA==
X-Received: by 2002:a17:907:ea5:b0:b73:5e4d:fae0 with SMTP id a640c23a62f3a-b735e4dfe66mr32565966b.23.1763042108849;
        Thu, 13 Nov 2025 05:55:08 -0800 (PST)
Received: from codespaces-334936.m1k4x3cq3poebda54cltipn05g.ax.internal.cloudapp.net ([20.61.127.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fad41d9sm171201466b.27.2025.11.13.05.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 05:55:08 -0800 (PST)
From: Joep Duin <joepduin12@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joep Duin <165405982+joepduin@users.noreply.github.com>,
	Joep Duin <joepduin12@gmail.com>
Subject: [PATCH] fix MIC buffer sizing in selftest
Date: Thu, 13 Nov 2025 13:55:06 +0000
Message-ID: <20251113135506.18594-1-joepduin12@gmail.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joep Duin <165405982+joepduin@users.noreply.github.com>

Signed-off-by: Joep Duin <joepduin12@gmail.com>
---
 crypto/krb5/selftest.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/krb5/selftest.c b/crypto/krb5/selftest.c
index 4519c572d37e..82b2b6a3607d 100644
--- a/crypto/krb5/selftest.c
+++ b/crypto/krb5/selftest.c
@@ -427,10 +427,10 @@ static int krb5_test_one_mic(const struct krb5_mic_test *test, void *buf)
 	memcpy(buf + offset, plain.data, plain.len);
 
 	/* Generate a MIC generation request. */
-	sg_init_one(sg, buf, 1024);
+	sg_init_one(sg, buf, message_len);
 
-	ret = crypto_krb5_get_mic(krb5, ci, NULL, sg, 1, 1024,
-				  krb5->cksum_len, plain.len);
+	ret = crypto_krb5_get_mic(krb5, ci, NULL, sg, 1, message_len,
+                   krb5->cksum_len, plain.len);
 	if (ret < 0) {
 		CHECK(1);
 		pr_warn("Get MIC failed %d\n", ret);
-- 
2.51.2

