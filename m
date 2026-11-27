Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795758995;
	b=KJ/U+b2v8gEtmWTBpiEsxrgL4r03Mzy4rUH3lkZ+y+boEO5yR/O1y2BBj/+TrotwEHJq
	 1POrHZpLwSdD4NS6WBsH7q2tNyaEO3igTNtjSmyxD48R5DXnArm/fCNphhsxH6CFIS3B5
	 PfpvzxwFqF92SmpwATvQ0aeHIwgilgnZnUD5nenU4+WNFJ6yVbophkR85ySUTI1Ql6LxF
	 ic4H5vF5BdAs7m5cIzoNac2iUFRzzZXxXAn0P0LkZd+UVHnMXCTyk69smUi0/YKcT3Z7+
	 hpAs06641xMaD0mAnKaxjgNS9KTlMlypsV+OkARL+gGwykWrY7/M9vbRWmjY/wurb7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795758995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ckJKF95/oQtqNhFPVFlEGqDFM5F8CpGFh4qi3pk2QRc=;
	b=CjabscQSVlSsN3Fs0r+Bu0lDvF/kteI+M3+xu6mHvt/XfiB8f+w6TRFpQyZrsQFnzUPx
	 gQyOVMq54VSjqb/4O5cA0gQ5RHDNHRoRUKazDDHiS9cTpodbYf95F6AgV1+WcVClt94Vn
	 jSsb7DquwifZZz+x6EEDW4f+sLsv3p98wobC03me6FFGlrPlMbxYK1+Zo+M9WK6Lm6Vvl
	 Bw/Q28Tv/p65Zdh/zsidowLI2GcwgfH0jzKR8p0SjqjdvjvecTgXf5/Aqf1BZiCha4rP0
	 h1y0ZPBQuXE2MpqxrZ62gMHTsk34jgJGhNMmL2FpJg7xabKuYStCSDa5g2E7VC+pVQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kThYNavm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 1A87C606A31C;
	Fri, 27 Nov 2026 05:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kThYNavm
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E9FF61F0089B;
	Fri, 27 Nov 2026 05:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795758994;
	bh=ckJKF95/oQtqNhFPVFlEGqDFM5F8CpGFh4qi3pk2QRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kThYNavmbY0GOb9F8InxQ1S5Lg0SQogM40sa07oWd6Q9R66Mlm2KtMDolCcBpskoa
	 8CiMDUEn3CgVgUqJBelxHZDm9q/i8PaRtngQ1qOovwLXBcQTU61FCdknO2LKR5iWe9
	 XvHQO9DZAmPSNsa/2DBy3qgGqn5cbTr5oWC/xtBnyVSs+U7wUoegaXi+XGEBo6qG2q
	 /b6uVXBeejBwc5h705/HNIabdLX/8DcLUKMEb6fX4qv70iTHxJHHqhyIguVO6RKqlG
	 lYZ8/1cMt0ax1YsP0FrMwgoJUcJ9z5QSj7fTxNWx/6fokHbNZAvtQTFUVDQ/ET5GmC
	 dUHwSbOmrsF6g==
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
Subject: [PATCH v5 05/17] KEYS: trusted: Remove dead branch from tpm2_unseal_cmd
Date: Fri, 27 Nov 2026 07:55:50 +0200
Message-ID: <20261127055602.2357884-6-jarkko@kernel.org>
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

TPM2_Unseal requires TPM2_ST_SESSIONS, and tpm2_unseal_cmd() always does
set up either password or HMAC session.

Remove the branch in tpm2_unseal_cmd() conditionally setting
TPM2_ST_NO_SESSIONS. It is faulty but luckily it is never exercised at
run-time, and thus does not cause regressions.

Reviewed-by: Jonathan McDowell <noodles@meta.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 security/keys/trusted-keys/trusted_tpm2.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 2f7c8e571522..32d90a1f8357 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -470,10 +470,8 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			   u32 blob_handle)
 {
 	struct trusted_key_tpm *private = options->private;
-	struct tpm_header *head;
 	struct tpm_buf *buf __free(kfree) = NULL;
 	u16 data_len;
-	int offset;
 	u8 *data;
 	int rc;
 
@@ -517,15 +515,9 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 		tpm_buf_append_u16(buf, private->blobauth_len);
 		tpm_buf_append(buf, private->blobauth, private->blobauth_len);
 
-		if (tpm2_chip_auth(chip)) {
+		if (tpm2_chip_auth(chip))
 			tpm_buf_append_hmac_session(chip, buf, TPM2_SA_ENCRYPT,
 						    NULL, 0);
-		} else  {
-			offset = buf->handles * 4 + TPM_HEADER_SIZE;
-			head = (struct tpm_header *)buf->data;
-			if (tpm_buf_length(buf) == offset)
-				head->tag = cpu_to_be16(TPM2_ST_NO_SESSIONS);
-		}
 	}
 
 	rc = tpm_buf_fill_hmac_session(chip, buf);
-- 
2.47.3

