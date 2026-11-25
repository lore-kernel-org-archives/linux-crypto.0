Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795630002;
	b=khxwnfpWVtAD9CI1tXBLTjd5WUbTTEAU1nB8gad209sXzsAuxPBGfUll9Apa6z+hskTJ
	 3uX4zzuBQmcbIw6lYkAuWGJHLfT+hfp1/DubskTqSY7Akcw9z9CY9Ai4SnUGqZvw0vUVB
	 sQOw/a6PWE4oSNeTWXDl+SkJU3FOzs+uBgomQeuiTOqiYbfIuNDfG7VQLru6j5N26sDHt
	 3vvQOcP/ocX42rUwxh0rme+gxQoDWziBVQNcfKpWsRZKGPXE4dwDOECphIPpZR/M9UMU9
	 dBoelpO4xL+0Fc9AkVItwXmByUWVYUsAMX+yEHEtbpgNG7U/+HCn9/QIeqUWNHrIlcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=r7fclzzKOWMyf7ywe58Ae38O43mUtx+8bhUvqry9F/k=;
	b=tLlaUq+z5k5uHWpOhgSrphOgptZ3LueCtbe2A5Wo7CfGPzDv+0S/t6UdBuAe4RgwZGqD
	 tvi0pn4fY9BmLuZgRO+tuqHEjrjGlLUEJzspecSJ1T+WIjvnHh3gEWsZlAi8OreDZVP/2
	 s8NRteHkJaZ1R+gLi8dG7M2frtj/MgXsxoK7MUn+X+5luRRZnYgb5XoeW68/Is3rAL9a1
	 Uw8HKQW3l5mF84b3KvolvMoUI6gxlCnlXTCFEAbNBpvx4D4ReI5De8Eqw8Cd38l0dbtqb
	 0pD5ho528STeHeUO5EeG/z6RU790oxZ9BqGPt+gs3CxhXf7DbOXVGi0U8z0xjegK6NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G+CcQnhm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4B177606A680;
	Wed, 25 Nov 2026 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G+CcQnhm
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E72A1F000CA;
	Wed, 25 Nov 2026 18:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795630001;
	bh=r7fclzzKOWMyf7ywe58Ae38O43mUtx+8bhUvqry9F/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+CcQnhm1M6hFURQ7/NuimNTYQB5+0aM1YZeCH3BYww/ojEjMpBexcihlGfLHZSsg
	 U+kyjfPn/xOpmYUeGvN4jQEWKyo8HSvbAaorNrVDUxPKAUkulgrQFoOdwD0gWlpRZf
	 h6RpSUcS/VgkeaS+mLp8lS1MUJ0NGpwQVPJF8xJlm0NHrgxlebTmD09Zs9A+o+8CMr
	 /r29JZ2GMYvFkv/50wHigiEYqrfY8plmZYw/wyATYMFwBCOZ+GIb+/q2PiZQ/lzVeX
	 P15uaIjYPPAFjXb5o1XXtjlf/nXF87wiI9diajEPjBF2SAQEE+9UmjSo9hcxQQDzP4
	 V5GMRXCFjfWBQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	David Laight <david.laight.linux@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: [PATCH v3 3/9] lib/asn1_encoder: Add asn1_encode_integer_bytes()
Date: Wed, 25 Nov 2026 20:06:09 +0200
Message-ID: <20261125180616.1854753-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125180616.1854753-1-jarkko@kernel.org>
References: <20261125180616.1854753-1-jarkko@kernel.org>
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

Add a helper encoding a positive integer from a byte array in big-endian
format.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/asn1_encoder.h |  3 ++
 lib/asn1_encoder.c           | 56 ++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/linux/asn1_encoder.h b/include/linux/asn1_encoder.h
index d17484dffb74..e206bd425854 100644
--- a/include/linux/asn1_encoder.h
+++ b/include/linux/asn1_encoder.h
@@ -12,6 +12,9 @@ unsigned char *
 asn1_encode_integer(unsigned char *data, const unsigned char *end_data,
 		    s64 integer);
 unsigned char *
+asn1_encode_integer_bytes(unsigned char *data, const unsigned char *end_data,
+			  const unsigned char *integer, u32 integer_len);
+unsigned char *
 asn1_encode_oid(unsigned char *data, const unsigned char *end_data,
 		u32 oid[], int oid_len);
 unsigned char *
diff --git a/lib/asn1_encoder.c b/lib/asn1_encoder.c
index 92f35aae13b1..8fea70dc0846 100644
--- a/lib/asn1_encoder.c
+++ b/lib/asn1_encoder.c
@@ -10,6 +10,8 @@
 #include <linux/string.h>
 #include <linux/module.h>
 
+static int asn1_encode_length(unsigned char **data, int *data_len, int len);
+
 /**
  * asn1_encode_integer() - encode positive integer to ASN.1
  * @data:	pointer to the pointer to the data
@@ -85,6 +87,60 @@ asn1_encode_integer(unsigned char *data, const unsigned char *end_data,
 }
 EXPORT_SYMBOL_GPL(asn1_encode_integer);
 
+/**
+ * asn1_encode_integer_bytes() - encode positive integer bytes to ASN.1
+ * @data:		pointer to the pointer to the data
+ * @end_data:		end of data pointer, points one beyond last usable byte in @data
+ * @bytes:		integer bytes
+ * @bytes_len:		amount of bytes
+ *
+ * Encode a positive integer from a byte array in big-endian format. Strip
+ * leading zeros.
+ */
+unsigned char *
+asn1_encode_integer_bytes(unsigned char *data, const unsigned char *end_data,
+			  const unsigned char *bytes, u32 bytes_len)
+{
+	int data_len = end_data - data;
+	bool add_pad;
+	int ret;
+
+	if (IS_ERR(data))
+		return data;
+
+	if (!bytes || !bytes_len)
+		return ERR_PTR(-EINVAL);
+
+	/* Strip leading zeros: */
+	while (bytes_len > 1 && bytes[0] == 0) {
+		bytes++;
+		bytes_len--;
+	}
+
+	add_pad = bytes[0] & 0x80;
+
+	if (data_len < 2)
+		return ERR_PTR(-EINVAL);
+
+	*(data++) = _tag(UNIV, PRIM, INT);
+	data_len--;
+
+	ret = asn1_encode_length(&data, &data_len, bytes_len + add_pad);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (data_len < bytes_len + add_pad)
+		return ERR_PTR(-EINVAL);
+
+	if (add_pad)
+		*(data++) = 0;
+
+	memcpy(data, bytes, bytes_len);
+	data += bytes_len;
+	return data;
+}
+EXPORT_SYMBOL_GPL(asn1_encode_integer_bytes);
+
 /* calculate the base 128 digit values setting the top bit of the first octet */
 static int asn1_encode_oid_digit(unsigned char **_data, int *data_len, u32 oid)
 {
-- 
2.47.3

