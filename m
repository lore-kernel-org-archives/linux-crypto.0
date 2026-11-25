Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795645514;
	b=O3zRaABqmEKlkYcOO9AsjCezuvQFVXXvu/q5GLn0eE4ljCXqL6jwykI+11CTTwBAeMsy
	 tTnkaPM1o7dsDzyyI5KmOLIvj6vPPC/Shym9ox5L2UhsnUlGzQhRgJv8LXNCGUBmRzWV8
	 /eoaC07qcuVGfymNK6m/H/F4gY8scjwg/TvZYffJDAzrw3Z3Xzb26Wj51sEk+S+nOjMLb
	 gURSS4lWAaauOMVf4VKGWylUTA87cBrkkqgE9bTKn0noLb4KLBRxe6+5U6y2vJytqAEm4
	 MfpDpFf6Q4Re3c8C3aosvrbreZqpkhTlixbfLGVNxUf2RvlH1dPIdWiEWiQ0eeOEyaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795645514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=tA8fanYUNEMCKg95/5mIB2W/4rmsixDLYX61xDs+OiI=;
	b=nsbRvArOv4dvDwxFTaTCGFnOsld/IaejEXloP2B6D1CBhgDzZeM/8Uh5aJ4YppS0MHlP
	 m4j6rVJNZSEms692ByD7RS9CVAWbtqASO0M/FFcgX2dlyP7zqFU1A2Mm2TEWZUJ1AQO2z
	 j9W04hIN0L7C/fn4yrkGmdQES1S9GQ0L4RJOs8HlXkXGRuGZoz+ft1Ceo1K2/zaUBtaLW
	 yhnSTnbCuQR/iWVFEIXC9bZKj/sd1jEbTkrlZjQ5ZQvYjfTPmWpQNCnIPOaRThH+5I1A4
	 uhNmM7IE8XY1E9RK1nT7Vc1m5+Ww5rmhNNuLOcaPLeXwN7LGx74QLgVkLLe1un+vMiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--elkin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Hc8LIBqX;
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEB960A2600
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 22:25:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFEB960A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elkin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Hc8LIBqX
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33713e5e6daso10352764eec.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 14:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795645513; x=1796250313; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tA8fanYUNEMCKg95/5mIB2W/4rmsixDLYX61xDs+OiI=;
        b=Hc8LIBqX/i4qh0XvLtJP23L+eOD2VsoHlO7L049gXWJbF+ger6+KOnNHPeX8fjoGw8
         XrJnxPre+5/ckLQACOqFa58IVlBi+Pk6344tWHPb621Cxw3+6Hj8wKlzgFzNaIPDUdxA
         qRy25mT0R/EhwRKu68EHv4885MNtFvQaQ6HwSoLKAd/TOX9dI5VaBGypebG6NHGo8LBu
         Wqs0IvI2yKamFSiOZKvbF9z6MHKRrSR9sLLVOPZFgHZinVEkg65VD28nMNS+W74LaApg
         oUBcQlztHbcO/3ys8z0QtozswgYYojsand5nIu+HviH4Y2TUohZj8d5ElLb2+v3BgXa0
         YKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795645513; x=1796250313;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tA8fanYUNEMCKg95/5mIB2W/4rmsixDLYX61xDs+OiI=;
        b=mNleIxdnPwRhPvIhKKW98LxvzzfjsXUhSrqfOiHk/4ArH36SpZuLSjupG5n3thKie9
         Wl/eRr+R9HpqyH4W18kAh1EnIYzk50r+ccA96CV+KiUh1Xx9YamvUYUd1iZcamUh3V/2
         9QkuW84Ggm+s9/qQ6wd2xiyWWAzbvVpTuEpBR22z3hT1mlaHmZY20xWycuxwOfYX5o7V
         pj/mzFnsiCA3QYuurZUZxm/jIu+Gu524WYaSXvYgSUzaErjp7hALC5ez6i16qiTRxL1f
         z48c+rw+v8AxYlCI/TZOAE8/FYm2+86kizv43/q2Q/Xa9SC8DUCNYp+8PUZ6d0VDKtni
         H0wQ==
X-Gm-Message-State: APuU4Z+0TO2+NDOevGmMjfP1c+zZbjDCdRwzWKnR4M6NVekfSLHGDq2C
	H2tgHxRSbu4MZjb314/KrirS2q6OpE26qHpD+WC9kLjZ3XKJnguDjU8xNwrCuGWSs6y4uhZGCXU
	Whg==
X-Received: from dybkf17.prod.google.com ([2002:a05:7301:3a91:b0:359:198a:8046])
 (user=elkin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:dd8b:b0:372:32a1:b384
 with SMTP id 5a478bee46e88-38571510675mr21473493eec.33.1795645512613; Wed, 25
 Nov 2026 14:25:12 -0800 (PST)
Date: Wed, 25 Nov 2026 22:25:03 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261125222503.1445426-1-elkin@google.com>
Subject: [PATCH] crypto: sa2ul - fall back to software when assoclen exceeds
 u8 enc_offset
From: Elkin Cruz <elkin@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, irogers@google.com, Elkin Cruz <elkin@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In sa_aead_run(), req->assoclen (unsigned int) is assigned to
sa_req.enc_offset, which is a u8 field corresponding to the 8-bit
SA_CMDL_SOP_BYPASS_LEN_MASK hardware command-label field. The existing
fallback check only tests auth_size against SA_MAX_DATA_SZ (65535) and
the unsafe [240, 255] packet size window, allowing requests with
req->assoclen >= 256 to silently truncate enc_offset modulo 256 and
corrupt encryption/authentication offsets in hardware.

Fall back to the software AEAD implementation whenever
req->assoclen > U8_MAX, and compute auth_size in u64 to avoid 32-bit
size_t addition wrap-around.

Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Cc: stable@vger.kernel.org
Signed-off-by: Elkin Cruz <elkin@google.com>
---

I am trying out new Clang static analysis checks for kernel bug
classes, and they flagged this code as possibly buggy. The findings
were triaged/fixed and commit descriptions were drafted with help of AI,
then checked against linux-next (not runtime-tested on hardware).

Thanks,
Elkin

 drivers/crypto/sa2ul.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index f8216b5d3991..1d9cb5932b25 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1771,17 +1771,18 @@ static int sa_aead_run(struct aead_request *req, u8 *iv, int enc)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct sa_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct sa_req sa_req = { 0 };
-	size_t auth_size, enc_size;
+	u64 auth_size;
+	size_t enc_size;
 
 	enc_size = req->cryptlen;
-	auth_size = req->assoclen + req->cryptlen;
+	auth_size = (u64)req->assoclen + req->cryptlen;
 
 	if (!enc) {
 		enc_size -= crypto_aead_authsize(tfm);
 		auth_size -= crypto_aead_authsize(tfm);
 	}
 
-	if (auth_size > SA_MAX_DATA_SZ ||
+	if (req->assoclen > U8_MAX || auth_size > SA_MAX_DATA_SZ ||
 	    (auth_size >= SA_UNSAFE_DATA_SZ_MIN &&
 	     auth_size <= SA_UNSAFE_DATA_SZ_MAX)) {
 		struct aead_request *subreq = aead_request_ctx(req);
-- 
2.56.1.839.g22a8290db9-goog

