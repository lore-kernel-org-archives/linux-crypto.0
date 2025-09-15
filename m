Received: from smtpcmd0642.aruba.it (smtpcmd0642.aruba.it [62.149.156.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4092C1A2
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 08:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757925834; cv=none; b=ICua/tgdYcWCT3wya/oJEzKjzjVYsZXqiTUNpL3NXTXUlUHjHbjnU4kYbTg5LsXlIVtDny26Efo9McykQYyRUxtPTJ0Zl9A85Aypw85jyyRV34XCFUDgWcx2Nx93A+o+sxMYmxpLd8WFUlinEWwB8GKBiqvXqp4XqzyYdOmzp40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757925834; c=relaxed/simple;
	bh=y7NeSVGsy+X2u/x97Q7TYjupwYvK8vixda2WEdUW5NY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i4jYOCO+Cs6RkHOE8mxn9ScWk5SvDWZy/MjpqHODHrU9vcdXSU06pd8nU7eZaytdnvxbEhAoGTGlQjb7k++zMFH0NdgOr13/r9jbY5WxJ9ATrGMIr3qslV+59h/nr/fRW5Kio3ez35PYwbaxBx4EuORdQo9/PVnEyWdkHeKTOYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com; spf=pass smtp.mailfrom=enneenne.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=Jvmh9e9R; arc=none smtp.client-ip=62.149.156.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="Jvmh9e9R"
Received: from polimar.homenet.telecomitalia.it ([79.0.204.227])
	by Aruba SMTP with ESMTPSA
	id y4lLumNEnL0Iyy4lNuiWiL; Mon, 15 Sep 2025 10:40:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1757925641; bh=y7NeSVGsy+X2u/x97Q7TYjupwYvK8vixda2WEdUW5NY=;
	h=From:To:Subject:Date:MIME-Version;
	b=Jvmh9e9RuASLc0g8JQ9155P3KG+hqeOyZYz2J06QyHSmyaRFQIc/HElzEcT2uKxO0
	 /Ygcn3WyMorD0OqnbaHm2uphfmye+etpBJNzXf00NK7v8BggkFgd0H1PzZTAUWXmpO
	 SityRjitEbnq2BldavdGKBuo6q5Y5kUeROCmuWsQaUPvyZuJqfZ07knXi9VEba2LtC
	 FrUeFI2EYic247HNMt537UWcoAb0XIuJY6MIXnE5L/Lrdp4LQ1nY1dpfN//TyovY/K
	 LLsJFnOVnaVc1RICuvBdporGKdfmxVVjQorkTddSnKghshAkStSclVBDQ0GcvO3ikg
	 G3BJJeSd8UGYQ==
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: [V1 2/4] crypto kpp.h: add new method set_secret_raw in struct kpp_alg
Date: Mon, 15 Sep 2025 10:40:37 +0200
Message-Id: <20250915084039.2848952-3-giometti@enneenne.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250915084039.2848952-1-giometti@enneenne.com>
References: <20250915084039.2848952-1-giometti@enneenne.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfOrdSnTy6aGUheSaeHuq2fLET0sbwdBPstiNi97WtbflMzFWGRuBdT77JZcQEoGauyrUj7eUDHNZZXAk1ahNMXcuhGL137S2IFace7Y7G0spwR5SK4xv
 5JUPc2TXHJ1gbDomOn1O2W7C8aUmMWM9n5WI9Nn4hTafF7goC+sKX/ou4viH6o2MI36FnLyBE00d7aJqZ0xmqSMgw3KmLmBYgxmBK+FIGfuXUmFhMlNJopn4
 IxXP5eZGOkZmYlkE4E4QwYnvuWlo/HDZ6WyDoTvyUTOjRIRoW6kahDW4jz5J0od0GNKKT+vRQlth4OLcFnToBWhhmnwnlivQrvxgMIYyHMU=

This method can be used to correctly set the private key from a binary
data buffer. This function class should encode the key and then simply
call the specific set_secret() function based on the corresponding
algorithm.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 include/crypto/kpp.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 2d9c4de57b69..355734cb29ee 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -54,6 +54,9 @@ struct crypto_kpp {
 /**
  * struct kpp_alg - generic key-agreement protocol primitives
  *
+ * @set_secret_raw:     Function invokes the protocol specific function to
+ *                      encode and set the secret private key in a raw
+ *                      binary format.
  * @set_secret:		Function invokes the protocol specific function to
  *			store the secret private key along with parameters.
  *			The implementation knows how to decode the buffer
@@ -75,6 +78,8 @@ struct crypto_kpp {
  * @base:		Common crypto API algorithm data structure
  */
 struct kpp_alg {
+	int (*set_secret_raw)(struct crypto_kpp *tfm, const u8 *key,
+			  unsigned int len);
 	int (*set_secret)(struct crypto_kpp *tfm, const void *buffer,
 			  unsigned int len);
 	int (*generate_public_key)(struct kpp_request *req);
@@ -293,6 +298,30 @@ static inline int crypto_kpp_set_secret(struct crypto_kpp *tfm,
 	return crypto_kpp_alg(tfm)->set_secret(tfm, buffer, len);
 }
 
+/**
+ * crypto_kpp_set_secret_raw() - Invoke kpp operation
+ *
+ * Function that works as crypto_kpp_set_secret() but on a non-encoded key
+ * (aka raw binary data).
+ *
+ * @tfm:	tfm handle
+ * @buffer:	Buffer holding the raw representation of the private
+ *		key as raw binary data.
+ * @len:	Length of the private key buffer.
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_kpp_set_secret_raw(struct crypto_kpp *tfm,
+					const u8 *key, unsigned int len)
+{
+	struct kpp_alg *alg = crypto_kpp_alg(tfm);
+
+	if (!alg->set_secret_raw)
+		return -EOPNOTSUPP;
+
+	return alg->set_secret_raw(tfm, key, len);
+}
+
 /**
  * crypto_kpp_generate_public_key() - Invoke kpp operation
  *
-- 
2.34.1

