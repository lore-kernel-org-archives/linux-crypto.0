Received: from mail-pj2-f35.google.com (mail-pj2-f35.google.com [74.125.227.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E9F45038
	for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 08:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789807579; cv=none; b=KexWodVmobQuNmVFisBBkfekUIbkR+1fkQrSF2DelU1dusrlrtc/CPkXJa541LaGV0MPXsteRvLABo4/X43s6NnVmbUc3U0WwFzol3inYbRlEgEkVFciO+kRIvUADQ4wZXMY5BWP+eop4HLLLGlRgQ5fPITHpY2fvPl87XfkaWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789807579; c=relaxed/simple;
	bh=JndLelUDpELb/PZVPnoF6LuWW5egrcLn2Pb0by+xRbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcdOOwHnWxCEVm+GAEoBl/R2BrZRhKv8JzAnWnl9fI8qT6oYyuW+oFWIjTJEjYpf0HJXnu85BrRdMIFoGWu4ECE3sdRV+t63CLZnsfmzQ9EDQPGfjh4eLmJ0yWH15HeQ1M8MTcGUD10XdxJpaaMJFXAGrhs/0KIoOxe5EwXy7cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eGtzYN7I; arc=none smtp.client-ip=74.125.227.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eGtzYN7I"
Received: by mail-pj2-f35.google.com with SMTP id d9443c01a7336-2dd77300825so15854255ad.1
        for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 01:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789807578; x=1790412378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F5yYyyF3qfZDda23XJdjzzQIL/ht3WCIVf7/hf6XCFU=;
        b=eGtzYN7ITzeV/MttdG9hZ2RwDBXmOhJJwO1tSf8rog9KSMpc583grvciLliUcaLTTX
         MABzIM/Stl+Hnv4lhe65o1bdvBwwYnQ/MVkQAbNTNEYjJRxp85UtwPOdlQqzK5doi/pu
         7SY/1sCCgpJUyi8T55mn+xOBnSwjAVb0Ip2PUPj8iIzjQ6Erbb3k0sGJAWwuXBmuY0ZA
         9qwc/mlOgox0JRN+UBFDBO66waYP65Hoiq7rDcHqJHOIiulOn+EKp4kQrvH4gAFCsLSW
         9Nc/IYVw/OB/VMhIk42jq5UnqHwifw/yiIGHmjP9MEdQ+lSTG9SdoIXtufdwAZaPSRzE
         BBKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789807578; x=1790412378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F5yYyyF3qfZDda23XJdjzzQIL/ht3WCIVf7/hf6XCFU=;
        b=HV9BcHAJKlIvO4VmQToTHmOotVUP8PVvRleJVi7E6uGQl2ZHo+Z4FE8TIsUEdrT1OD
         iak4vRxcNKxWLPRUgNZtQEtnSa0JvNbb72x7kaJfXn/+klu/dsTQeYt3aIQ4XxbTrfpz
         5JkmxieRZguFcGqm9sCI8n/ewKW3eBlsxgc9U1Zs1Rmll6yBxYJ2Nau+DGtJRa9mx3LM
         dnVoUSs+QdxNtfyGcWHoPBmxD9ryXtD4rBYj13bohp0T4s45dDFx7B1ktgLPO4veg0au
         B9Qh2g2ufheKyEy48NvDm03ZaAfP3f6on5135e0iAVG5MrE3StqmrBX9TPbWCuDRSmy8
         0Ffg==
X-Gm-Message-State: AFuF++mNGQcvZGxO+FUZ0sLRU4Hbt2vjtpL5M1eEMDPNGeYBaBH2ia/X
	GiZUu9q8Jxqs0Sr7soackBZnwod2Fhqe8kCwETqLzDJPw7tl07apIHXW6VAFML7FEWpXTc3t
X-Gm-Gg: AYBFou1xyGjDk6hkXFVR2FudSo3UuuqY52275G4DoJ6T3Q8N8SgJZTCKk1fVRNV+S2j
	Xmk6Qthjptfo+xnc9tDHJpXnU8t4bb3q2TfJEwcPeDO+I4Ne9BHIr9X/VOB4+fQhfKJ/XyE7x94
	kJ08hHDJ9LZ+uQGzw6d/nAH1ArpW4jiSyaqpGiDwbz3OOVyDnWlSwkBRuMAZ1r8RR82q37DIywW
	giVMsjFX/inUqQxOPuqUKRX8et9HnhPenPcMx2OBuXzH6jdBeF2kVdfagOHgbijXFvd0YvQLwMI
	rt24HPqwHcpXHb+ZprISRzJwYOf4haqrSBPyR6dseBony8s90A7cPshj/N3XxOJP+Uvfv8vPqJg
	PnQpcFBfN3zQ5z50sLZPcShahzBZHYVq2XkbzRozkHIkPhw7c7ry8j520Ot+dZOQmyOcACSU0pc
	0zpOM3+heJTVvGXL8qyktw9f6AnYwqlrS9cAiAJcDo+P3HkJpRLLLXvO8zVzb9WwbKaSSAbcEpn
	BRL2u9IMheen3OB0wsfwqjjBQB/WOMgeBXZL+gRNxnuAW5EM4HyPoHHCrM4Jx3WSZm5Bw==
X-Received: by 2002:a17:90b:4d91:b0:39e:6c68:c782 with SMTP id 98e67ed59e1d1-39e6c68c9f1mr3018528a91.56.1789807577881;
        Sat, 19 Sep 2026 01:46:17 -0700 (PDT)
Received: from lenovo-thinkbook (42-2-127-248.static.netvigator.com. [42.2.127.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6cae997csm3490897a91.11.2026.09.19.01.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 01:46:17 -0700 (PDT)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	keyrings@vger.kernel.org,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>,
	Ren Wei <weir@nebusec.ai>,
	xuyq21@lenovo.com
Subject: [PATCH 1/1] KEYS: Account for asymmetric key payload data in the quota
Date: Sat, 19 Sep 2026 16:45:58 +0800
Message-ID: <6abaef5a35f2eb9d551a16817df12f786346b7c6.1789801335.git.xuyuqiabc@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789801335.git.xuyuqiabc@gmail.com>
References: <cover.1789801335.git.xuyuqiabc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pkcs8_key_preparse() copies the attacker-supplied PrivateKey OCTET
STRING into the persistent asymmetric-key payload, and
x509_key_preparse() retains the public key, its parameters, the
signature and the authority key IDs.  Both charge a fixed 100 bytes to
the owning user's key quota, so the retained memory is not accounted
for.  With the default 20000-byte non-root quota, a user can pin
roughly 11 MiB of kernel memory by adding PKCS#8 keys.

Charge the size of the retained payload instead.  An oversized PKCS#8
key now fails with -EDQUOT instead of being accepted for 100 bytes,
and the same applies to an X.509 certificate that retains an oversized
public key or set of authority key IDs.

Fixes: 3c58b2362ba8 ("KEYS: Implement PKCS#8 RSA Private Key parser [ver #2]")
Fixes: c26fd69fa009 ("X.509: Add a crypto key parser for binary (DER) X.509 certificates")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Reviewed-by: Ren Wei <weir@nebusec.ai>
---
 crypto/asymmetric_keys/pkcs8_parser.c    |  2 +-
 crypto/asymmetric_keys/x509_public_key.c | 23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs8_parser.c b/crypto/asymmetric_keys/pkcs8_parser.c
index 9dd1c181789a..fa8b142a8e14 100644
--- a/crypto/asymmetric_keys/pkcs8_parser.c
+++ b/crypto/asymmetric_keys/pkcs8_parser.c
@@ -150,7 +150,7 @@ static int pkcs8_key_preparse(struct key_preparsed_payload *prep)
 	prep->payload.data[asym_key_ids] = NULL;
 	prep->payload.data[asym_crypto] = pub;
 	prep->payload.data[asym_auth] = NULL;
-	prep->quotalen = 100;
+	prep->quotalen = sizeof(*pub) + pub->keylen;
 	return 0;
 }
 
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 25cf8ac7f257..f2bdd0244262 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -163,9 +163,11 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 {
 	struct x509_certificate *cert __free(x509_free_certificate) = NULL;
 	struct asymmetric_key_ids *kids __free(kfree) = NULL;
+	struct asymmetric_key_id *id;
 	char *p, *desc __free(kfree) = NULL;
 	const char *q;
 	size_t srlen, sulen;
+	int i;
 
 	cert = x509_cert_parse(prep->data, prep->datalen);
 	if (IS_ERR(cert))
@@ -228,7 +230,26 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	prep->payload.data[asym_crypto] = cert->pub;
 	prep->payload.data[asym_auth] = cert->sig;
 	prep->description = desc;
-	prep->quotalen = 100;
+
+	/* Charge the memory retained in the payload, not a fixed estimate */
+	prep->quotalen = sizeof(*cert->pub) + cert->pub->keylen +
+			 cert->pub->paramlen;
+	if (cert->sig) {
+		prep->quotalen += sizeof(*cert->sig) + cert->sig->s_size;
+		if (cert->sig->m_free)
+			prep->quotalen += cert->sig->m_size;
+		for (i = 0; i < ARRAY_SIZE(cert->sig->auth_ids); i++) {
+			id = cert->sig->auth_ids[i];
+			if (id)
+				prep->quotalen += sizeof(*id) + id->len;
+		}
+	}
+	prep->quotalen += sizeof(*kids);
+	for (i = 0; i < ARRAY_SIZE(kids->id); i++) {
+		id = kids->id[i];
+		if (id)
+			prep->quotalen += sizeof(*id) + id->len;
+	}
 
 	/* We've finished with the certificate */
 	cert->pub = NULL;
-- 
2.55.0

