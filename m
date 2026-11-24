Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795526701;
	b=AfvXlhFByBtOx71X3wSizkAq6TGa8Dte+SgIdA6mkFsu8TlCLvPdVeQa00e29yvIBV/J
	 e5xL7oT/s57crS+bTrHtNWlFGKhJ1wH+hvO3+FVw4FBzPEc/5WDKfMS0Dc+nQX3LzTVcN
	 DPFND0q5tTjWQ/aoJeOKLDucmk2ed7qoiH+S4s6PhfT/FT9ZytLIiWcH3A70SPxzn4W6R
	 Z7OaKjm9ulemVal7ebLej8t7+OByYubPEGeVxIL0SAxX9oW/75lLv7VUIjTiJ2rBLduu3
	 Fxc41A0om7UN5z0xnjQdwVKKE7OAdrqpFtO2piK0hWRKJiZTX8VBt8yA7d3YfojsR0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795526701;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=hPrmVEljjzeQEI/FmqGeWmopUmtwltsWl7yaWV09Xrw=;
	b=Nqfa0nFGpqFA1flFvK9KKaMmXF4s4D59imxeNpUtlHBYBDUWsQwpBmrTyn2Wgk05kCbn
	 TvpfRc4v0adjO5mBK3IweH3ii9RdHUyx3lcGDttUEVB81rIDhYNnelrSCTNBrR8GoZ+9g
	 PoWI5F1eIxTun0+SCqTNZlmDOxLICMOLBDh6dEMrVmIhIpvt4fhisylMPn+mJ5A2kdr+g
	 17UCwz1KPuBBrLbHLaZ12QfJgn2o6WjxqKjYA6kGTVxxBz23GlhzgmbBRtlDZTLxgwSL2
	 7MucDWh0JHqWcSFHEzRZGNbkXCJQZDENGVmUh0mxoHurvrokhue6Rx6HC6TF7F9W09A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=hxIyBpug;
	arc=none smtp.remote-ip=195.10.208.52
Received: from mout-b-203.mailbox.org (mout-b-203.mailbox.org [195.10.208.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73D9606A31E;
	Tue, 24 Nov 2026 13:24:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D73D9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=hxIyBpug
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-b-203.mailbox.org (Postfix) with ESMTPS id 4jYk7Q2mFvzLmKK;
	Tue, 24 Nov 2026 14:24:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1795526690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hPrmVEljjzeQEI/FmqGeWmopUmtwltsWl7yaWV09Xrw=;
	b=hxIyBpugj9UyyXKJni4cCm5WL0cRCOpxCmn0qpQioxmJX6OEBCutkg8jRo84yr79JUW6oD
	OGhbNbs8/aacaYSne7OVHDHlyh7XJlSKXkM1Y2/OnZm5gF42PugVhSE9kyFHS6r99M3fwp
	Okbs+QtBovjrmR2VlTVDQYlYqGTF1AOTTbhXgdkhSJJiygw/lSfkSCLfOwrZczid4OgjJn
	A78nybEfXJB4HhGappJU8nUAlLv9IdyXB8ofF5DJYR150QtNSLJSYAuKYXASWcSIOaMeoK
	6YxePRLcsNAUdQoFFiEsR3WrcFLeE/bjLV74TR1f7w7uhbLjb+QRwbp9nNTojg==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
From: Antonio Quartulli <antonio@mandelbit.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>
Cc: Antonio Quartulli <antonio@mandelbit.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] crypto: pcrypt - Refuse to wrap a pcrypt instance
Date: Tue, 24 Nov 2026 14:24:41 +0100
Message-ID: <20261124132443.3666372-1-antonio@mandelbit.com>
X-Mailer: git-send-email 2.56.1
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
X-Rspamd-Queue-Id: 4jYk7Q2mFvzLmKK

A pcrypt instance keeps the cra_name of the algorithm it wraps. When
pcrypt is requested with a generic inner name, the new instance cannot
be found by the requested name, so the request is retried and the next
instance wraps the previous one, now the highest-priority match. Each
retry adds a nesting level until the driver name overflows.

Nesting pcrypt is pointless, so refuse it.

Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto parallelization wrapper")
Cc: stable@vger.kernel.org
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
---
Found while enabling pcrypt for rfc7539(chacha20,poly1305) on 6.18: an
AF_ALG bind of "pcrypt(rfc7539(chacha20,poly1305))" left 11 nested
instances and failed with -ENAMETOOLONG. On v7.4-rc4 the same happens
through crypto_user: each CRYPTO_MSG_NEWALG for that name adds a level.
With this patch only one instance is created.

 crypto/pcrypt.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 9f372442981e..d2acc64bcee3 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -271,6 +271,15 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 		goto err_free_inst;
 
 	alg = crypto_spawn_aead_alg(&ctx->spawn);
+
+	/*
+	 * A pcrypt instance keeps the cra_name of the algorithm it wraps, so
+	 * the inner lookup can return an existing pcrypt instance. Do not nest.
+	 */
+	err = -EEXIST;
+	if (strstarts(alg->base.cra_driver_name, "pcrypt("))
+		goto err_free_inst;
+
 	err = pcrypt_init_instance(aead_crypto_instance(inst), &alg->base);
 	if (err)
 		goto err_free_inst;
-- 
2.56.1

