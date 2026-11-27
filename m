Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795758986;
	b=C723AnESAzt+CN2vdZqfnMZT2wNvg8tZvFMSApOvXlaAg5gm5etVKpIDirxCDepmJExq
	 z7w5vzywnlYXx3vlzpXTPgxyuAR0TIU8iHc9l+Dclmx1xQ7UwbQsWu/z6XtUwzYr7Ny10
	 keBqSaUWVHhtWXT9eYaKpJzxx1NRvZ7tx0XHHqsfIW+2RFdFeoCPWOhHakXwXB6AXRbzI
	 VJDsIAqR015Kn/oNTUJqrVCZeun4rJMC7U0a7jFTlmnYVewzIqKaErU0TvJ+RHxF/8QfU
	 9PMOaIEgfeMJzCa5WRyoWezvTO1TbjW19G+SBtSGGZquqHmzfUzAn32hN5raT859bIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795758986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=t14hz/KjvT/cyL0QDHjHhbDfGWLTe7lYBiuRy47drZs=;
	b=dEjDudwMUj9IZZ5oVaYDDjTH4MtQcUjMn0MsXiJL9Ip9JbFpkoTUEQJbc0AwJ2e8yA3R
	 LB+ofbcSyOY5EOySu7HwMGbQU+Cf0kjW/zblQFFfO8MW7FXn5+xDw/YGphXjLvjDd3KJv
	 spS+uFBa2VightJhNiBKU3JM5k4KMknaYextx+DARuh1f4nVnmLkePOUCblpsuksG+n4M
	 gkF7wmWfzNA3LKsqifs0bTZgxlPDJzzTSkhfd+9xbM7knv44F5Os0ba+ngBdkB5adgjC6
	 PBrgihpyUFDEDjqIuCM7zv41ABjbs0eRzqDCgpyUmV0yjhGOIsSBf4KvSPfOJIpXohw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZOnzTvVJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 91132606A31C;
	Fri, 27 Nov 2026 05:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZOnzTvVJ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 71E011F00A15;
	Fri, 27 Nov 2026 05:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795758986;
	bh=t14hz/KjvT/cyL0QDHjHhbDfGWLTe7lYBiuRy47drZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZOnzTvVJXCdoMVNdZVnVH13bFyXkMawgq4hzQ4z32pvbYt7/S/SewWQXeP+xQsqQk
	 lOvPD/Zh2xjP7LrCaBGkXA4wTtqqVapnllbRkBXj3XWHG/1r4KB1vBnEcs25jYtE34
	 cHZHAA1Drz+ebixd4z8eAfMKoJYIhssxQSXSt3c3xmUzK74lrbagyIdOnfV0rqR23b
	 b8UWzdB6Uu4CQKaz/0rzGgi1iyx/lh1KT/6gK1JNtj0sasrGYIGvFTe7clitmiQuzm
	 ePNeYNL8p3dkQHM8n/Kk2OmjEuepMXB1neVEXyMfk9qAXGCXLyFiDGlPtbbKAwKpRo
	 tIeP8N40aKriQ==
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
	Jonathan McDowell <noodles@meta.com>,
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
	Sumit Garg <sumit.garg@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v5 03/17] tpm2-sessions: Drop TPM2_NAME_SIZE
Date: Fri, 27 Nov 2026 07:55:48 +0200
Message-ID: <20261127055602.2357884-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127055602.2357884-1-jarkko@kernel.org>
References: <20261127055602.2357884-1-jarkko@kernel.org>
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

TPM2_NAME_SIZE was left to include/linux/tpm.h when the base definitions
were consolidated. Switch struct tpm2_auth to TPM2_MAX_NAME_SIZE and
convert TPM2_NAME_SIZE users to TPM2_NULL_NAME_SIZE, removing the
redundant TPM2_NAME_SIZE definition.

Cc: stable@vger.kernel.org # v7.3+
Fixes: 88c5a62c3af7 ("tpm: Move TPM common base definitions to the command header")
Reviewed-by: Jonathan McDowell <noodles@meta.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/tpm-sysfs.c     | 2 +-
 drivers/char/tpm/tpm2-sessions.c | 2 +-
 include/linux/tpm.h              | 8 +-------
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index d915307ae833..0f726cf65189 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -318,7 +318,7 @@ static ssize_t null_name_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
 	struct tpm_chip *chip = to_tpm_chip(dev);
-	int size = TPM2_NAME_SIZE;
+	int size = TPM2_NULL_NAME_SIZE;
 
 	bin2hex(buf, chip->null_key_name, size);
 	size *= 2;
diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index 9608e545602c..94c11135beb3 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -137,7 +137,7 @@ struct tpm2_auth {
 	 * we must compute and remember
 	 */
 	u32 name_h[AUTH_MAX_NAMES];
-	u8 name[AUTH_MAX_NAMES][2 + SHA512_DIGEST_SIZE];
+	u8 name[AUTH_MAX_NAMES][TPM2_MAX_NAME_SIZE];
 };
 
 #ifdef CONFIG_TCG_TPM2_HMAC
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 0f97abc82846..2eb17e1ccd58 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -94,12 +94,6 @@ struct tpm_chip_seqops {
 /* Fixed define for the curve we use which is NIST_P256 */
 #define EC_PT_SZ	32
 
-/*
- * fixed define for the size of a name.  This is actually HASHALG size
- * plus 2, so 32 for SHA256
- */
-#define TPM2_NAME_SIZE	34
-
 /*
  * The maximum size for an object context
  */
@@ -166,7 +160,7 @@ struct tpm_chip {
 	/* saved context for NULL seed */
 	u8 null_key_context[TPM2_MAX_CONTEXT_SIZE];
 	 /* name of NULL seed */
-	u8 null_key_name[TPM2_NAME_SIZE];
+	u8 null_key_name[TPM2_NULL_NAME_SIZE];
 	u8 null_ec_key_x[EC_PT_SZ];
 	u8 null_ec_key_y[EC_PT_SZ];
 	struct tpm2_auth *auth;
-- 
2.47.3

