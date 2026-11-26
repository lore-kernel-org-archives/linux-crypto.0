Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726260;
	b=R4KgDrjnIOqJOGeugq9shNlzvRRFJ+Gi9leCinDcK16WnSvEDjwgKk2oUQ3o+eCA8IDV
	 VaKImTgLxfWB6UBH2P1zY7vua6z5X6xkk9DXUB5iLWGyjeKOSFZurT0TjEdBVRuGI91Hr
	 iMFzuqj1Zt5AJ+aBw5azcwe/cJHBOut19dkoyLGhvqeU3ifABXfE2OF0JTKtAVJrSz0PP
	 OtYJp/Z3SCJmGYczb1p587SavVAb88muS9M/h12kQYoiqAvamhUj52WnetEoWP711aW1c
	 xvqRb6my1hZjUwxpQLnaRRQiZxLKWeRSWr7+HRqYttaw9JRkinEB5QwAkqfs8Wrkp7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=r7fclzzKOWMyf7ywe58Ae38O43mUtx+8bhUvqry9F/k=;
	b=24ekVtNyGV+txXtXRDqKOt8vVSjzE8VJEJ6i0Mvj6rE9gZFUPr+xPHbJt3dRAHya028A
	 /LgItQ7QzTtu0xMXImrdoGWEXYHjSfdxL97Kj+9fZJtk96xrE34uY8fbqHh0s51Zu+E27
	 FplAF5ai/z1fKp1IlPwQq1qSpJC2ATfmrPf2sjs149MY0AZHmHEHINjNxbaNoLY4wbDlc
	 oLmxd8L3lgAtt1iI1PmfgiRYg6px1ux+dYR2v1v91SSmetk0C82CxHFzVjF7a2mtEIIES
	 19VxPSIaGekRAmLJpWCVnefGVxqKTw3VAjngXmgfvH2RD12+qEVfyzLknaQCHc8UkGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Juh33Ajv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 5767C606A327;
	Thu, 26 Nov 2026 20:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Juh33Ajv
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 44B2B1F00893;
	Thu, 26 Nov 2026 20:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726260;
	bh=r7fclzzKOWMyf7ywe58Ae38O43mUtx+8bhUvqry9F/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Juh33AjvJvBt9BOPYJ8ykukJI4WzeVvzAXyeNkl10FtUufe70yOjGRiKcE7C9rqU1
	 wxmpE0nT5ZUORf1ae+GBK7TdcV62y+s3/42mxsQ0FVPy9LedNj7SP1IeaqFj7ZkepP
	 IzjJfyCcvjLI7NRqHv0yLfroQCNxDrCgkzGZHvhteG54JWLsrReBEkbfYYxO4G4ru2
	 F4Vjfve4somSVnCKNuHOEn7kTRpYoIa+C79pfns8EdAlFawRzahgP+Pz+7Tv4bcfAF
	 N0udI5V9XVeLryt1lDoA9FcWkhYrWD+1zRhc6Uloev3DE12JHHvb8FqgMtHjnCDT4C
	 lHQPaxONbc7GQ==
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
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: [PATCH v4 04/11] lib/asn1_encoder: Add asn1_encode_integer_bytes()
Date: Thu, 26 Nov 2026 22:50:14 +0200
Message-ID: <20261126205021.2200819-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126205021.2200819-1-jarkko@kernel.org>
References: <20261126205021.2200819-1-jarkko@kernel.org>
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

