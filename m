Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793729452;
	b=ZS5T1YyoAzOWorSofU56crRgJzEGASX82TkjF+GY5snuzUOBslGul0nEpjL/K0tzG3p8
	 nlV/cJlZMlVFFQgkSK96aaKiJUkN1TGUQEphMZ3TqtMcvrBqNVnNA9/IU3+8J5qYyBIjr
	 jjMai4jM5ERTgaqUvwGTZxA/tTlvzLwnvbIyPw7EPhCOwlp5hOmoZ3+qDbJOnNjrWNlsw
	 S6wLYGLxUxEWEBQeYHpSDAqlah10aytOuyswpExPDaWllYFXXTaxWc3UrXCE1MSkoDjn2
	 jn3hLj1okP9+hwMMzW3YuuvwmQnGYKC6/4PQMcqcYBnxxT50g4Y2zhXlTZcAsLLQ3bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Toz1R3wAc2FhVXHWEHEjC1eCdZQGifAUi3nvgfstv/g=;
	b=SpHduumJhWBziWPLwKAAUtH/CUvP/LVCjXCkZKQYgRApLDekvcmytUEbhTwUX34k7BQD
	 rW90GzAEhMiPhJYP+6c7mtQ3h6Jo2Zdz8NcFb/HRVAR3aIdrp4NSM1129ep1HDjt2rSfa
	 LimCcArmUv40odBA7/XhBI04Xk3kyVIwzZw6k7zZ8pyZAbkHJjqszyuV8NmKLV4SyENja
	 FX7gqU69io3m1YVx7czYNIA4yUACzttbEVplidAOx59AB31dak/y4dCdPW796lloLiY3a
	 tb/C86NcDumWrB2q3jQ2Pc8A5Blzp5UGMSAbnSDoqfYZkn2O+iilXbafPU6m4LkVdXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OPMOjK7M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E876606A31B;
	Tue,  3 Nov 2026 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OPMOjK7M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AC81F00919;
	Tue,  3 Nov 2026 18:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793729451;
	bh=Toz1R3wAc2FhVXHWEHEjC1eCdZQGifAUi3nvgfstv/g=;
	h=From:To:Cc:Subject:Date;
	b=OPMOjK7MBiTBEhFboXZUcMpuDvA/DO/6BjqgI+FRRViIkueGF+1dL+2uenVjonGzi
	 /zUyHCJt+zQAh/nC7bHVA+F7Tim4d6a7WM8z0w6c+F3uivKe9sxR3oeeDmHUQsLIQD
	 eiQcSyjpZnk049XzgvLoWBbqUDB9eTnV7sw+/zeZQmk/saQeUrDSMFawwnOGKiG3Ir
	 hL+bGo2sBAwS2wTrkpOa4uGPJ3sFvVnAQ5Ao0FwaX3ZewJVMR+GmUwhnMkgjIF+d49
	 u9OAAuTPi01ypTahdXrw95aiNBsKf0X+1CIdkRRkzW8Lq8qDvJSDA2Vj7QTHnJA3Kk
	 FSxDH6cg0679g==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: [PATCH v1 1/2] crypto: ccp - Bump minimum firmware version for SEV-SNP support
Date: Tue,  3 Nov 2026 11:10:01 -0700
Message-ID: <20261103181002.2200214-1-tycho@kernel.org>
X-Mailer: git-send-email 2.56.0
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

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

The SEV firmware has received many critical bug and security fixes since
1.52. Bump the minimum supported firmware version for SEV-SNP to 1.55
(first available in linux-firmware release 20230919). See
https://www.amd.com/en/developer/sev.html for firmware release notes with
exact bug fixes and CVE details.

While these macros are called SNP_MIN_API_*, since 6131e119f579 ("crypto:
ccp - Abort doing SEV INIT if SNP INIT fails") both SEV and SNP fail if SNP
fails to initialize, so this firmware requirement really applies to SEV
hosts that are SNP capable at the time of init.

Also upgrade the debug log to an error log to give people some idea about
why things failed.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 5c996ab63895..13e6af5549f5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -43,9 +43,9 @@
 #define SEV_FW_FILE		"amd/sev.fw"
 #define SEV_FW_NAME_SIZE	64
 
-/* Minimum firmware version required for the SEV-SNP support */
+/* Minimum firmware version required for SEV-SNP support */
 #define SNP_MIN_API_MAJOR	1
-#define SNP_MIN_API_MINOR	51
+#define SNP_MIN_API_MINOR	55
 
 /*
  * Maximum number of firmware-writable buffers that might be specified
@@ -1523,7 +1523,7 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		return 0;
 
 	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
-		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
+		dev_err(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
 			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
 		return -EOPNOTSUPP;
 	}

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0

