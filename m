Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795759007;
	b=5LvGpF/BGuYxEt5MJhCRx5RETesBSZlJ1JIWXyfO9ya+r6K4QayfFXTQCY1Zs4kvNj8u
	 u8bdnUEMGzHH5adACOvO9ebafdX0ABmzhn8oCTen9k46Ne0wz0xLkllgYMoNKOfpkTd8V
	 DCATHWyh9LbZjP+s26FkDZWBXCZa0+TYKosG0VfviFhiOOxcJ0QAnZ85EmfgGSLakSz9n
	 zR0PHeiE173Lkumz0sk4oCe3uDE8kMXA+kipsB7B3KO2Cd97JUrWcJFUupyZXNjI3tXMa
	 MQeAWjyiE5DTv5vNLAHkujqMns8nYNgCzQ97s/kYD1u6EZixAtghIhhRaJTZtSTod5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795759007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0C1J3Yo4LK3xrHtS9mw2s3inRXtAeEdwhOFOurWOo4Y=;
	b=CplmNTXz+ht74gpOyZ8qA7WQmU6wdIXB9Zi0JIFiM7wqBubhfOPoNw+G9vtcEdpMP9eQ
	 GZLe+HCkRw2lKHbtCMdM/7pRE0NyC4iOBrdlem0AzChWLm05gBhhsWb8JqeDLg+kZKHFZ
	 UOjGKtOP/rf/voNoR4HP6oF+So9P+0j7y5xATakEHH1T7HbA7NHNwyciir7j1uCApou06
	 qbHnn/ArooXWb778JHpPcq+SsB8vdFyKAFXO2WHvQSGKYZWuYPX01QMTYE4eiw/6qsjaX
	 ag+01sspnu9nbP5WenZrkOF771Ixge9CBoWJ8TFHmaBbGItVwHGsAcYvBOmkF0+vG8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GTyO+mWU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id BAF18606A324;
	Fri, 27 Nov 2026 05:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GTyO+mWU
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EAECD1F00923;
	Fri, 27 Nov 2026 05:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795759006;
	bh=0C1J3Yo4LK3xrHtS9mw2s3inRXtAeEdwhOFOurWOo4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTyO+mWUJE0rprMsntD41sYQhVENuJtqd9O9x6/eDam7sO/KN0j50UhaBWdcKRtn5
	 5vZzo6PKHkOKGRZcyJH4CrESyulrV/OzCbtfDrEjJlp+dIP35vJ3LKfCwT5eYrzu/Y
	 pjxWN2rbf63LvgXfkZNvUPGRzEv/TufNaUiZmB1AS7c891H0nsdkayS2F5xkOqhR3a
	 wMFSgBxpdHRc0S2SRTb5/ewK9DRkjCpyYQWwXEIpwvbD0a9UfTVNZmzSBkh/p4aT6v
	 hSMO96JOA0yB/4areiX80txzOrDrtpPUbK0zXemPktDbubLqtScCBTvh+cVN4AE6r0
	 RHF8y4AOLSZJA==
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
	Sumit Garg <sumit.garg@kernel.org>
Subject: [PATCH v5 08/17] KEYS: trusted: Allow ASN.1 TPM2 sealed data shorter than MIN_KEY_SIZE
Date: Fri, 27 Nov 2026 07:55:53 +0200
Message-ID: <20261127055602.2357884-9-jarkko@kernel.org>
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

tpm2_unseal_cmd() rejects unsealed payloads shorter than MIN_KEY_SIZE (32
bytes) with -EFAULT even when loading an ASN.1 TPMKey (OID_TPMSealedData,
2.23.133.10.1.5) blob.

While kernel-generated trusted keys ("new <keylen>") and legacy old_format
blobs are at least 32 bytes long, external TPM2 tools allow sealing any
non-empty payload up to 128 bytes.

Keep MIN_KEY_SIZE for legacy old_format blobs and accept 1..MAX_KEY_SIZE
bytes for ASN.1 TPMKey sealed blobs.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 security/keys/trusted-keys/trusted_tpm2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index e20e54203b83..6b4cd07176cb 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -490,8 +490,8 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 	struct trusted_key_tpm *private = options->private;
 	u8 blob_name[TPM2_MAX_NAME_SIZE];
 	struct tpm_buf *buf __free(kfree) = NULL;
+	unsigned int data_len;
 	u16 blob_name_size;
-	u16 data_len;
 	u8 *data;
 	int rc;
 
@@ -555,9 +555,11 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 	rc = tpm_buf_check_hmac_response(chip, buf, rc);
 
 	if (!rc) {
+		unsigned int min_len = payload->old_format ? MIN_KEY_SIZE : 1;
+
 		data_len = be16_to_cpup(
 			(__be16 *)&buf->data[TPM_HEADER_SIZE + 4]);
-		if (data_len < MIN_KEY_SIZE ||  data_len > MAX_KEY_SIZE)
+		if (data_len < min_len || data_len > MAX_KEY_SIZE)
 			return -EFAULT;
 
 		if (tpm_buf_length(buf) < TPM_HEADER_SIZE + 6 + data_len)
-- 
2.47.3

