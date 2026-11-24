Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521674;
	b=vAqoeMseG4sarjm5RiDVS56XGYZFXGgF1tAiAHYdblLXRYhyMtTQCDLonCOXG0x45mWK
	 rGrbBAZvEHPzPB2vqOJcl2LFTuVtuSMD4byGoZ0rtZMb3pGt98LI3UELI5eMyGH+M0Rmg
	 8lRlcf9A1K6PsXU8TumpUFZ8oXUlkZmqVPvBcFmsezwm7ocRKFmxyCOwOed4PMhqXOCjq
	 2oU2Q/tAUJacNFSJ/MDrEpO8y/MiXdHmcVpVS6WQ+6q6Wni3/DK2qMNgfU/yx1NzeT4DG
	 F3mTJlvbJTZkn+O4S+r2BsuhZ5Arw3OkzgXhEVvHF2CSrVAvwVqxewSPdjtbNmW7ACg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=O8J/bGNVib+yTxxwAmRX4BLhLnbS/J0CGMJH7a8e4E8=;
	b=zsttvnlkQ26FcKS4xqZE9geUx4xxz/i5OLRhUGLg9jxNR5soF87l7ObKoJQIpU8Yj4mU
	 92Fe4XIR9JCNQaNkr6aFDQIQQqIAjW40/JuVSAnK4F78e0G+btOoJJzFWlI25kOSP6m14
	 mH83lsiIc1N5RrC9gh3FSEIgUVxn1aeMOwbCQ0cuXO4x7VNnNghBdZKIX9UT08smBKwuY
	 wuCOvzt9DzsbeoESV5JLDeQAud57WhZU84Ehngvze/ATRZfUl02xGaE3RQG/gQ7pa5F6y
	 qB8dWEPIOf2bsrBOwYMJ0C7Wl6GYJ5S3RTpmDjNRssRIIMS5M5rVRwYPX741cDyzT9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6rA5myb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6779C606A321;
	Tue, 24 Nov 2026 12:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6rA5myb
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ED7BC1F000D0;
	Tue, 24 Nov 2026 12:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795521673;
	bh=O8J/bGNVib+yTxxwAmRX4BLhLnbS/J0CGMJH7a8e4E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6rA5myb2NjduCMJ3oPi5z0r011fyxS/UNszpEkVDZUonwpD6DN8bTPOE3lz3KT5+
	 5paO8zXBIluiz4aAUrSKL708Ab4RipOzGFQHZnBgwlSJS0HHd8RrUS/71tT1MGa0/U
	 u2QYKair+eG4HUtqipLyF0Yy57wClqJTNLcb/wBDa9eQkT4GFCTSMGIQFJDvNMNBs4
	 ud3c5a3GAADuyCyDKWqzA3jw8qDxxefelcPKWKbUBF75Yg9KDT7a5NvfEUqrPkX23L
	 jvus3fMK+8S/9cOwQkT5GTKwyuSFYcSXDq6hw4SmNQcxZxHW7rHMnGwe/oNYO7KBNI
	 INZu1igygz2jw==
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
Subject: [PATCH 1/9] KEYS: trusted: Allow ASN.1 TPM2 sealed data shorter than MIN_KEY_SIZE
Date: Tue, 24 Nov 2026 14:00:36 +0200
Message-ID: <20261124120044.1481752-2-jarkko@kernel.org>
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

tpm2_unseal_cmd() rejects unsealed payloads shorter than MIN_KEY_SIZE (32
bytes) with -EFAULT even when loading an ASN.1 TPMKey (OID_TPMSealedData,
2.23.133.10.1.5) blob.

While kernel-generated trusted keys ("new <keylen>") and legacy old_format
blobs are at least 32 bytes long, external TPM2 tools such as sealing any
non-empty payload up to 128 bytes

Keep MIN_KEY_SIZE for legacy old_format blobs and accept 1..MAX_KEY_SIZE
bytes for ASN.1 TPMKey sealed blobs.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 security/keys/trusted-keys/trusted_tpm2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 30188a0ec676..d7336f25b514 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -559,9 +559,11 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 	rc = tpm_buf_check_hmac_response(chip, buf, rc);
 
 	if (!rc) {
+		u16 min_len = payload->old_format ? MIN_KEY_SIZE : 1;
+
 		data_len = be16_to_cpup(
 			(__be16 *)&buf->data[TPM_HEADER_SIZE + 4]);
-		if (data_len < MIN_KEY_SIZE ||  data_len > MAX_KEY_SIZE)
+		if (data_len < min_len || data_len > MAX_KEY_SIZE)
 			return -EFAULT;
 
 		if (tpm_buf_length(buf) < TPM_HEADER_SIZE + 6 + data_len)
-- 
2.47.3

