Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC53F2309B9;
	Sun, 16 Nov 2025 18:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763318419; cv=none; b=E9sMgXAL5qGkcFYPLBWPdiJkkKY7E9qsnODCAMSoFIt2IllU+Unv3MCGdTFqpHNJpHRUVk++BW25WwXJ/Y8QOcWRDqpQAKC2vXP9CKsq/F+6lFxc0PvWK3S+v8Mf0aoYBRm5Hsiy6mFBniVaU7fyMZAb3UrCptdBKiiV2F9ql8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763318419; c=relaxed/simple;
	bh=MFvfiF10TjB5tzqijgQzsyHuJS8eAudS8TIxPduTtO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2nong0aWjXlTz2KbEyPj19+p5w3dhvi2JISHyHQf4HSKV6OOppjtSo9tUJwCsHCPvhuZ9ms/grngFlJ+G69h66mRuoWSU8Y1zNZen+d8RTiXbZ/mGizmETeR0l0d5YXjwAmduO2bptUSs0SjF5Pmx+E8riBy/AGz4/vuuJLuoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sagPWVkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sagPWVkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C32C4CEF1;
	Sun, 16 Nov 2025 18:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763318419;
	bh=MFvfiF10TjB5tzqijgQzsyHuJS8eAudS8TIxPduTtO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sagPWVkhWGmvTw/Fj5c+SdhnXn1gkYb0TEzne3TjhPJNmeMXmacilq4RAYyHvQ/Hl
	 4szYGMWb2AF758tjN3euqq/kuuW4vIZX5A2Id/vegmPV8W0pN+F1Ci5wrXKcpwLINx
	 KF11Mu3R0okFRI1vBNluRKMcDZ3oLFFwD26Tx4J11NsBZpn/dDIvAdg1rPibdlVxEz
	 qaYK00ugP3ojgxxmSaNTKWiA+KoVCyo64sMFy2JJUiyt8oV/X4WvLYN9mbYquV+snu
	 KeeDzf2vvHEKdq045m0VH3TT2gMmRCx20JxR2HjDptHOtiZ6eeNS9cwZGrjjrD+EnK
	 BxJCCG4yokZ6Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	larryw3i <larryw3i@yeah.net>,
	stable@vger.kernel.org,
	AlanSong-oc@zhaoxin.com,
	CobeChen@zhaoxin.com,
	GeorgeXue@zhaoxin.com,
	HansHu@zhaoxin.com,
	LeoLiu-oc@zhaoxin.com,
	TonyWWang-oc@zhaoxin.com,
	YunShen@zhaoxin.com
Subject: [PATCH] crypto: padlock-sha - Disable broken driver
Date: Sun, 16 Nov 2025 10:39:26 -0800
Message-ID: <20251116183926.3969-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
References: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This driver is known broken, as it computes the wrong SHA-1 and SHA-256
hashes.  Correctness needs to be the first priority for cryptographic
code.  Just disable it, allowing the standard (and actually correct)
SHA-1 and SHA-256 implementations to take priority.

Reported-by: larryw3i <larryw3i@yeah.net>
Closes: https://lore.kernel.org/r/3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net/
Closes: https://lists.debian.org/debian-kernel/2025/09/msg00019.html
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1113996
Cc: stable@vger.kernel.org
Cc: AlanSong-oc@zhaoxin.com
Cc: CobeChen@zhaoxin.com
Cc: GeorgeXue@zhaoxin.com
Cc: HansHu@zhaoxin.com
Cc: LeoLiu-oc@zhaoxin.com
Cc: TonyWWang-oc@zhaoxin.com
Cc: YunShen@zhaoxin.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting crypto/master

 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index a6688d54984c..16ea3e741350 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -38,11 +38,11 @@ config CRYPTO_DEV_PADLOCK_AES
 	  If unsure say M. The compiled module will be
 	  called padlock-aes.
 
 config CRYPTO_DEV_PADLOCK_SHA
 	tristate "PadLock driver for SHA1 and SHA256 algorithms"
-	depends on CRYPTO_DEV_PADLOCK
+	depends on CRYPTO_DEV_PADLOCK && BROKEN
 	select CRYPTO_HASH
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	help
 	  Use VIA PadLock for SHA1/SHA256 algorithms.

base-commit: 59b0afd01b2ce353ab422ea9c8375b03db313a21
-- 
2.51.2

