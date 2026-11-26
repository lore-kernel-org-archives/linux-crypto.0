Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726252;
	b=4l4LbNll4M3ehzDcTiYFaePLDWvHj7N/9LyCoK2+Czdl+2atIpegmxed1g7XC2kNoFEU
	 NP1BnlRwXKM7IHGFzCURN/dzeWzBpXU9ZFShcgvbElos96yiWjrd3B5QwZGVa49Qm4Rug
	 iGffmSf8yIc3GMPU0L291Y6wEGbzItWOwxUIFDfcvJwS5xlD0xRufRxofIuSPgiburhM0
	 ckqhihNoE8346WriRv3BJ5smYKKRQ2tHYRSSgA5di3wvau7iJvbZjeDrOdf6ZBLXi7ODD
	 8cstw1IBY7hq+fDw8lpDLIK2lg7RXVvgXiHPN75mGa6P6lV6RFN2k47Wh7SOX5/15mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=cHcAa/C2aDJiaYitw3R3G9ckGSrrPYAAeiF+dTOf9H8=;
	b=tvrE1O4tBvDvmSsz1e3ZlLm3kvqihEPpunB1PF/RGZ1O9yKCBjdSwqpq4mPSbHHksFZA
	 TV1V2WgbIP+UcAxpUXnKZ9CO4ZpzgHhz/viSzBn/m0IOBEtLEgbbFqg9mzHb2LiP4SPNM
	 VlMCluurzqTn5xObUeWSOijslnd0Cgb68qDqslFHR/4K6yGZn6cNUpe3viVlxKMgR+B3F
	 JMSi8R/LgCs8OrtYnhdRIUVPrbdxxEw4sYiEGoRrHiAiIDtPPpHZSXM0ddeLi6G6M84ip
	 +NtTxP9fOknYNpqWo97UneZ7+4UIbYJzUeE527iKhgrILaLV57D8RDmt56hXV/lUicw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GHmEoUF6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A5DFF606A31C;
	Thu, 26 Nov 2026 20:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GHmEoUF6
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 929221F00893;
	Thu, 26 Nov 2026 20:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726252;
	bh=cHcAa/C2aDJiaYitw3R3G9ckGSrrPYAAeiF+dTOf9H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHmEoUF6suROAaHu1BKzkV2kSXEmQU3+n2rOWxJgyctXfW4tkk5suivAX57ran+MZ
	 nz79uK9K09equHaJCgbI3EdTmhj0l0nQ4dKMLf1Qw7S6fwc9em1leBRnaS3utidNBh
	 HoEJVw8YeFPturZZR3Qk58WmqTbt0mje6sXTwRzcgJb/+ZbhSadrXM5E3ttTyial8W
	 ySDFCOXtKvEJxByOH3OP7OMV83xzsVqzugvHECZekVQsliQeCLU+HuH4fZBMVEBDul
	 CIX9A8vITr3fAdTSMau0AKwcvcD+RBJGAlzABlOLk0dMUe2vhiyk9k0Ok0dl7rd61T
	 nzIofVruIJ5bQ==
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
Subject: [PATCH v4 02/11] KEYS: trusted: Allow ASN.1 TPM2 sealed data shorter than MIN_KEY_SIZE
Date: Thu, 26 Nov 2026 22:50:12 +0200
Message-ID: <20261126205021.2200819-3-jarkko@kernel.org>
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
index 30188a0ec676..8c62342b2588 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -499,7 +499,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 	struct trusted_key_tpm *private = options->private;
 	struct tpm_header *head;
 	struct tpm_buf *buf __free(kfree) = NULL;
-	u16 data_len;
+	unsigned int data_len;
 	int offset;
 	u8 *data;
 	int rc;
@@ -559,9 +559,11 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
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

