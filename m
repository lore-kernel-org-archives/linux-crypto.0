Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19ED218AC4;
	Wed,  5 Feb 2025 12:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738757628; cv=none; b=o6bh31y2jXcWHqPOqwmoKr6ZXFbB2seByqNw71QWBxs7mA5meTJF+LOk4RDQYa9xqWfhLBAwXszSlSz4mS2/nTivlFFDhZFGRCf3syZWtpPpjoPfhW4XqqRZ/AqQ1E7A5+oblBHfajUo2wFd1Qvg6GgZIo9uw+t/aoosIv4XTlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738757628; c=relaxed/simple;
	bh=Z79+chHQqx4OtIJNShxIC+ZnIf3vo4Kti4bGWnyvkYY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=my4XbK8uyFkhc/P/mNDXMAEL7T7VQ/dLLqfWKX42WFjQWsbvX11YiUCgJAfX9W81H0aCzI795BSTNmJSrt6wRbb9aNh/+t0L+eA4ekq8Bd0wyRDfNeMb/SPgk9XZRyEMHY+89EVK+zmAZBXlO0yOYv1BTMT1IqXUo5I6HmSm4Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dkqm8/Xz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dkqm8/Xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F8BC4CED1;
	Wed,  5 Feb 2025 12:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738757628;
	bh=Z79+chHQqx4OtIJNShxIC+ZnIf3vo4Kti4bGWnyvkYY=;
	h=From:To:Cc:Subject:Date:From;
	b=Dkqm8/XzYhU63+YbnX5WGXgcWAYs7eu9KLl+dNdBLLGVJFkk5I86pvFCelatQI33v
	 efDu8GvWLOZV1vpmVhggebyWacQP/83jWtTh0TyAPa/I8sWlplYNxHPJ8op8S9sUU/
	 mPd1FOWrW9LPg6+SF0TAtJ5vW0AyWwnG+M9c8w8dhDu3vkdlAghzcHvURemRtvtkdc
	 GvNHKKCCkSLPg4jLfFXNJoLpWxjX/WI8GZotYqTehP6bR4DW6t2Mdp5q4fM1LrILm5
	 zFCnHvy6RvXh8pxEZEK8avk67eD+fWFWtUXkLZpfvTUw6petFAEXsq2LkdQg2HS7+X
	 KnnHRITtoevrQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Lukas Wunner <lukas@wunner.de>,
	Eric Biggers <ebiggers@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Stefan Berger <stefanb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: testmgr - drop unused static const arrays
Date: Wed,  5 Feb 2025 13:13:15 +0100
Message-Id: <20250205121342.344475-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The ones[] and zeroes[] definitions were previously used by the
rocksoft tests that are now gone. With extra warnings enabled,
gcc now complains about these:

crypto/testmgr.h:6021:17: error: 'ones' defined but not used [-Werror=unused-const-variable=]
 6021 | static const u8 ones[4096] = { [0 ... 4095] = 0xff };
      |                 ^~~~
crypto/testmgr.h:6020:17: error: 'zeroes' defined but not used [-Werror=unused-const-variable=]
 6020 | static const u8 zeroes[4096] = { [0 ... 4095] = 0 };
      |                 ^~~~~~

Drop them as well.

Fixes: dad9cb81bc30 ("crypto: crc64-rocksoft - remove from crypto API")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/testmgr.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 4ab05046b734..61c7ae731052 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -6017,9 +6017,6 @@ static const struct hash_testvec rmd160_tv_template[] = {
 	}
 };
 
-static const u8 zeroes[4096] = { [0 ... 4095] = 0 };
-static const u8 ones[4096] = { [0 ... 4095] = 0xff };
-
 static const struct hash_testvec crct10dif_tv_template[] = {
 	{
 		.plaintext	= "abc",
-- 
2.39.5

