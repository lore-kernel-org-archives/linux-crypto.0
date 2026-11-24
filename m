Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795549264;
	b=UspNMGARZAfovgIDzcQXBpQPWlSA4RDoMZHDryyDPhJfd5v0zRIKexeqKRPMOQPQ6kEp
	 cBmLmrE64dstnP2WfPpP5UtuAzdPZBCsDiFVrfzBnYPzW/KT/h5XsrV7s1SOPB8xbh0+1
	 x6u/AlX0dIZwyRbgvWqftkOCTBkrVl39gpTH6Ln4xavFEdXNX06oyQYR2ZGRj8DnTv3qZ
	 3z8NdvN42nX6r43u7ZOkUFX4ORakVhN4sFn9l1uoaRek3y+mdQVb1LO1ks4X9wuapKQEE
	 O2z9FbKhDs0mWwu2odRfdhdZdiU4Nfbez1jNtbFdh9MU28kswvKHwFw5DPEX3BEa8Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795549264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/LoSCDtktTiyofq6Y/OdbeIIAzEYEK4kTQ2viNMgYkA=;
	b=KjLkDZn+8Ptq/VojaTD4zMh994W0UaF8uUt92VEpMnHw16sn+zneGThq/YUlQ72BtliB
	 /WLTmdnjPtvg2Pk+fdRz21XC2ek0B50cxkUtWzWLYEcBORwosNC7/D4QhxzmJKIabGX0h
	 CXCg1YVdLD9JDmYMOpUjNoG9olx/rW18N/AUuu4lYlFrHgQ4S8MZQGKO1KtKKwqCrt9nt
	 g6tw4LBVzdfnMCnIYPmCbfIsF7/cWXSS2EM+nlF+3t9S9MDOumbkh1X3NdAh0Fqadhqxu
	 o0+bxR9ixIKjlJMtrZ49YkanqT2wHWCA4Rki8LrRYFevB6Ty39ccqysMEs5X/tEVozg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ivxu6pj+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 1C1A6606A337;
	Tue, 24 Nov 2026 19:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ivxu6pj+
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 087981F000C6;
	Tue, 24 Nov 2026 19:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795549262;
	bh=/LoSCDtktTiyofq6Y/OdbeIIAzEYEK4kTQ2viNMgYkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ivxu6pj+X/WvR7ras8jHw2U2fIu0Go5VijVC7FnCrhzigaCr/x/W9q0XY8YdhrS4k
	 0e1+ZbzW6DQufApJYv8MR68xxIayCgnC21VTJ8vRlIK3KbSB/vLyozCX/39L9cYYPs
	 daNDjmnNQJVWoSKOvZECitSoC4KLnQqAf6F13ovYV9LVvrO0dtCnZc9nj2OI+jkqnG
	 CmY61dyLVicQId4jrXLqukXczme9ALo9wChx/AVbQ+Wx+maEDKC/m/AFTU9JzbH2JX
	 x+0dnLZaNI35INQDD1PyDgq6oNmuLm78cQs3a7V6ZEXuV6QrcVvkVexhbfeb3Yhr/v
	 GsA9/s/Iox3Cw==
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
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
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
Subject: [PATCH v2 1/9] KEYS: trusted: Allow ASN.1 TPM2 sealed data shorter than MIN_KEY_SIZE
Date: Tue, 24 Nov 2026 21:40:35 +0200
Message-ID: <20261124194043.1651679-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124194043.1651679-1-jarkko@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
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

