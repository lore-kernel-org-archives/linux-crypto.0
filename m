Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CEF1F9F7A;
	Fri, 27 Mar 2026 00:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774570698; cv=none; b=TF//BArIMkMVzyfs1W2OaxHRv0dPR6dUVFrhnXyXxsbJ7let0SAXD+kTNzrZQvbSzLgyR3jwVCQTMs/XdwRHuX5grXoX89RmZ2iU0cUuzzK9a4ACPRAt7OhL3wPInL7Bk2nIfns14Y5M95kZ+Zml8fyZGcecOe7QFVSpdeoGZe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774570698; c=relaxed/simple;
	bh=ZLfzoPTUdlDGPlAs8DT82071cHY3iAc88ymuMOh72hg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uwlm5722nc6nLSC4+7SBVDUYv4yFWvTWodnJcCc3lS870O9erPrmIepY49M4Wp7u+5ED2fkWWcJEy23oyvggG7qsoJKHzdtcQwoswH1C7mTd5VgCy74QxUBaxWAzHw7xiUv6Q4zIaD4VkfBenXFh01ECBBKm4+RPTAvYB9ae/NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JOh5gCDu; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JOh5gCDu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774570695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TtLUoFlBrcDJPLFULHdFLR9YO8FM1EUM9YkpHBXCHbA=;
	b=JOh5gCDui+Ra/616tKtPLTZuKaN6Xf3sAUPclQz81fhLhPFc2QVaCK/o1Q148wbFsyguyr
	G874qJS8Z9FkQEXVKhLjn6Mm3PmJ6OiyUQ46diT9tOB9CowOUf8zx8wG9XivjsgViuabDU
	ZT1QENGjoiQQfB1C5CI8w9YYO13oNW4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: kconfig - fix typos in atmel-ecc and atmel-sha204a help
Date: Fri, 27 Mar 2026 01:17:27 +0100
Message-ID: <20260327001725.2301-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=984; i=thorsten.blum@linux.dev; h=from:subject; bh=ZLfzoPTUdlDGPlAs8DT82071cHY3iAc88ymuMOh72hg=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJlHz0ztfsj6M+rI0esTlsybprad4bjmbDPd5XxXbUsvr /4WcqFZs6OUhUGMi0FWTJHlwawfM3xLayo3mUTshJnDygQyhIGLUwAmIvqL4a/E3ZS+a993Pbtq Pu/JlT/dhsaFulMbdtZLcz+4/9ND/Ic6wy8m0RjfV2IVgiu9dTN/LxaprOJecWDPVIXr8uEyWlz c0UwA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

s/Microhip/Microchip/

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8d3b5d2890f8..16fa56898d35 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -490,7 +490,7 @@ config CRYPTO_DEV_ATMEL_ECC
 	select CRYPTO_ECDH
 	select CRC16
 	help
-	  Microhip / Atmel ECC hw accelerator.
+	  Microchip / Atmel ECC hw accelerator.
 	  Select this if you want to use the Microchip / Atmel module for
 	  ECDH algorithm.
 
@@ -504,7 +504,7 @@ config CRYPTO_DEV_ATMEL_SHA204A
 	select HW_RANDOM
 	select CRC16
 	help
-	  Microhip / Atmel SHA accelerator and RNG.
+	  Microchip / Atmel SHA accelerator and RNG.
 	  Select this if you want to use the Microchip / Atmel SHA204A
 	  module as a random number generator. (Other functions of the
 	  chip are currently not exposed by this driver)
