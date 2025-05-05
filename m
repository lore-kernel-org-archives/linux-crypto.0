Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE9226F463
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472297; cv=none; b=PeveoE07NRYu0ovwi0d2+M271h6UWe2b/xPI/gqVLGvqLTeVM+7o5dW41k8jhaA9tQ6wT/nyatImuJ1+Fm/r9iBIt85TLZTIIxO6sjEVSsHx42m9B0OplO018UKevuJ3MXodYjlC7YGjJZvIAiY9ne1Fu0Hh4/JRjrIVrqKTHOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472297; c=relaxed/simple;
	bh=pLceXgpJQiwQc7pKaXbk50iFSh8WBST3H/Ppeup65+4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EK3d9FKo4lDKc3inM2UfdD/PadFDiNSD+8MNygGgNXWxrgxCtBDOSlZzyMi/yWUkqWNsmLWWdq65BcVFtwtZ6LTGfzZCD+4MZJ777kpEMu+fbJlLFcQxhDOIlaJeXh4sElck+EmgpVcZjqvow78fsS2tTf6aod+p7PTssNzmBAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pmTN2D/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pmTN2D/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526C4C4CEEE
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746472297;
	bh=pLceXgpJQiwQc7pKaXbk50iFSh8WBST3H/Ppeup65+4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pmTN2D/4UnorA3mXW+/qqBW+3BfTVrzRqPwReYNMAwnJOXRTAfs/ec7qjOkoOxOA9
	 cMfPE2aLKFdGkAobd+9Z8pxm3HSzNInG5krcVu22AGiXf0scJw+17SF3a+fIFX75aQ
	 U1/fThAgdSC6s16PiWe62FXK7wKSIYZulGW0wTs1COfzH85nMhBENBCWLW471xSBCL
	 zYhBGw4MaUFPxMzEI/NcWjt8CyPcNEKhoagNDcIwLWPHIDE8Rd+zE8bTMd12RLPA7n
	 W0obvZ44UxIZbYgiLGIM81xA8viCBW2DL3SokGQDkEWPmKeK+XnhBpO53DBBhCMXaY
	 dtbRoKAH25szw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 5/8] crypto: krb5enc - do not select CRYPTO_NULL
Date: Mon,  5 May 2025 12:10:42 -0700
Message-ID: <20250505191045.763835-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505191045.763835-1-ebiggers@kernel.org>
References: <20250505191045.763835-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The krb5enc code does not use any of the so-called "null algorithms", so
it does not need to select CRYPTO_NULL.  Presumably this unused
dependency got copied from one of the other kconfig options.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f0c8cc5e30ae..cf5a427bb54d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -237,11 +237,10 @@ config CRYPTO_KRB5ENC
 	tristate "Kerberos 5 combined hash+cipher support"
 	select CRYPTO_AEAD
 	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_HASH
-	select CRYPTO_NULL
 	help
 	  Combined hash and cipher support for Kerberos 5 RFC3961 simplified
 	  profile.  This is required for Kerberos 5-style encryption, used by
 	  sunrpc/NFS and rxrpc/AFS.
 
-- 
2.49.0

