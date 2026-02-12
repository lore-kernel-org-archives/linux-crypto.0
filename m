Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438E84964F;
	Thu, 12 Feb 2026 10:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770891668; cv=none; b=Mw9h4tb3rHAIF2cJ0HQ9gYrBXpjk1jXKxfWbTlsVeXgvIAvIy0jl8G/EfjtsUjf0Gl9hWEd4rgSnwSrgr+Zw83jUbdkRHEy+7gUbARvbRdzt5/E9z/FZFloSdJP7Wq27dXOx3deH9oEGO1Q2m92kf9Kriyo/7H3F+nHR6073peU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770891668; c=relaxed/simple;
	bh=egG7NOMgE84DrrDlDVX+Vuena/oQ6IhL97E+DVT0cf8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZEurzIJjxeuSdSHdyQaK6mUKl5UenDPJr3fgtwQ2JkFre5MfaH1sX/PWsPdz+xlT8v4R2StC0omzWUpXg+jdCwdCWDPNpTGSAxo8K/Q8NtZ2k6Y7DWhrA+IGdp8BsIO9ANp+BJZ05uP8+h5RIdZmPPrGiaOuaOVyV0/dDPusvIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWiyNXH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWiyNXH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C023C4CEF7;
	Thu, 12 Feb 2026 10:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770891667;
	bh=egG7NOMgE84DrrDlDVX+Vuena/oQ6IhL97E+DVT0cf8=;
	h=From:To:Cc:Subject:Date:From;
	b=EWiyNXH8yHHRV80tkDxmDIcpGtGG7nVONGyiyEJRE1d63yGC6dQ6qiL8rhQEzhKnD
	 /nJC+BZYpmg1qJXqVYwR6KMoCkF3SM/8cXln4qf3WNQHge0ZxW1TNhSQCYXjvFiPxJ
	 ydvrxM6QG+BPB7JU6pzREKnEQm6Ia7HYGm9iqmK6x6uZYMLmfzChZw2+b3en9L7vQH
	 Km+yvmrPjww7LnsDt40SIjRgT9vDQVBjpIHRAtYoOED3K4LjMDIFFw20pyobEXzN16
	 5lyPK9C95Q1V7ebHmhbbBxt+HUORTlWmRBKMigr+oQ6SrwCZzm8IuPbgkTha79hQCN
	 4HwzclPXVjLhQ==
From: Arnd Bergmann <arnd@kernel.org>
To: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jarkko Sakkinen <jarkko@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] x509: select CONFIG_CRYPTO_LIB_SHA256
Date: Thu, 12 Feb 2026 11:20:55 +0100
Message-Id: <20260212102102.429181-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The x509 public key code gained a dependency on the sha256 hash
implementation, causing a rare link time failure in randconfig
builds:

arm-linux-gnueabi-ld: crypto/asymmetric_keys/x509_public_key.o: in function `x509_get_sig_params':
x509_public_key.c:(.text.x509_get_sig_params+0x12): undefined reference to `sha256'
arm-linux-gnueabi-ld: (sha256): Unknown destination type (ARM/Thumb) in crypto/asymmetric_keys/x509_public_key.o
x509_public_key.c:(.text.x509_get_sig_params+0x12): dangerous relocation: unsupported relocation

Select the necessary library code from Kconfig.

Fixes: 2c62068ac86b ("x509: Separately calculate sha256 for blacklist")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/asymmetric_keys/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 1dae2232fe9a..e50bd9b3e27b 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -27,6 +27,7 @@ config X509_CERTIFICATE_PARSER
 	tristate "X.509 certificate parser"
 	depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 	select ASN1
+	select CRYPTO_LIB_SHA256
 	select OID_REGISTRY
 	help
 	  This option provides support for parsing X.509 format blobs for key
-- 
2.39.5

