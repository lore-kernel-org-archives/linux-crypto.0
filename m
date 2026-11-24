Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521678;
	b=rfdjaR/JFBvsO552zkxD9lz9TFF0GilK06mdlhnsB5VY7WTF2EKVxF/LWyASf7663p1w
	 DZLiYtAbDfP1xBMIyzCNeagBsfPJYcmghMolJwoBirzLbyXuvSoOszGwxCD926Uk5IFDr
	 /wDBMl2BXYIbq9tyGEc0r4NpP3xbWbiA8oCJEnwDJCdeAMUHbGrPRj8iQkZnnQA6y/liZ
	 53YDhHIDh8eKL6ldhFchMiVrEl4BklKiDsAcP121l8p+/EuXvIg42AWOs0e7HY6dd/GFv
	 NzMzrHljQ2bicog/0aYI0rERbs9bbXR1DxJIVXaOQlKQV3yUsoILYUCa7qJsnHy6ozg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=FKWO26ho61Nb4Vf1urgGRlJ3443TyMqUwpMqSFotZMw=;
	b=BNm9+uqenjS7tTXcFsenGLs4TE50EjhjlX/TnkcbmMC+NIR/pPai7KnhC7GHZe+79wx4
	 q8ygXkGp9pYTuERmDxzldXqiZwN3f/kz83QNtibqumQWvaAcivoWi4lHhFZenU7+urJ7h
	 /UBZrm14QSwu7EIKvi6/RAvWKMMkebyx+YmfoNsB1TgvvH3Kpm1onvy0sGIB+cFHitGYD
	 jFNQjumIxUjnFKONcM8SCmpujHQE26Vdrsi8CV90TEPENjmXWhm6XqyO74fc375CbE2eS
	 Rn5j2sHi2MMgl38tOncxBOwEOCK9p1RbTjfGfQMn87Uwu15M2mTLKlKRjoc+a4elrsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nq6XQLDe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3FBC1606A31E;
	Tue, 24 Nov 2026 12:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nq6XQLDe
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2D9ED1F01565;
	Tue, 24 Nov 2026 12:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795521677;
	bh=FKWO26ho61Nb4Vf1urgGRlJ3443TyMqUwpMqSFotZMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nq6XQLDeXSugrLFDPsFBU+lo0lq0BjUf6a/yibC/GqsTBapox1khxe3xMso2aRtv/
	 d1s+9bFXi6HUNY13ba7ftpLpHgpntp4XK5zZaJVJwHOye5c274J5XU3mb6dld/i3D4
	 1zTS7Ut0qnfs0en8UiUEOw3fhekcyEUytoLKoYETNcW6skhMnU48A8KPCOZkhiT6iV
	 ShG/VWeBK0xnx7/1gacnhzKsBbLTfy56tPPiygUrecrttnkXfcEwvA1k3Llsuuvk4R
	 +X7Kf+IWWHKUbGlzEFH18XkWTO8HYIHnthT89kvVCEVyxlwkYVhVsBB/YJYO/PW4nx
	 /VRo5aGvJ8Z/Q==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
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
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 2/9] lib/asn1_encoder: Add asn1_encode_integer_bytes()
Date: Tue, 24 Nov 2026 14:00:37 +0200
Message-ID: <20261124120044.1481752-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124120044.1481752-1-jarkko@kernel.org>
References: <20261124120044.1481752-1-jarkko@kernel.org>
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
 lib/asn1_encoder.c           | 62 ++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

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
index 92f35aae13b1..22e0acd6fe08 100644
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
@@ -85,6 +87,66 @@ asn1_encode_integer(unsigned char *data, const unsigned char *end_data,
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
+	static const unsigned char zero;
+	int data_len = end_data - data;
+	bool add_pad = false;
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
+	if (!bytes_len) {
+		bytes = &zero;
+		bytes_len = 1;
+	} else {
+		add_pad = bytes[0] & 0x80;
+	}
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

