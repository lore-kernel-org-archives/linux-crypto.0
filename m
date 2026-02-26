Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55971335BBB;
	Thu, 26 Feb 2026 14:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772117179; cv=none; b=p10F3fFqXq6Hr8UyXDr8GabFzpyo60lqtnNAsN3Vls/qUPlcuo3GOzvmyYDC27Tn8iMB9fjk0TmelaAiPtlHYVb+N5RjteYFnZOBCYd0NnRW51EhHOsqvPc579EhlWbT9EzMzFssC1UbWFYh4VxzHln5G7Bc9qLbT0FfMyF4LpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772117179; c=relaxed/simple;
	bh=MS2dV98khEDsVe1bAQd9M5OGNZSmvkPi0bQ7XxrStyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqaVktiT9DQicfNOA2Yg9fSSMyCH5KFOQT/Mzf8m7B6rTowb3Ak/QZOYIy3dQHKbzPpVzI/5DU5UI1/ygRqijr3odmTDWV5S018B0VoPULaSsyf5ZrGDd7oREE+M59C4n5RFx8DI0wGCIDdE+sVxuaDKA1z+AFu+rv2Xzu62ucA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB30C19423;
	Thu, 26 Feb 2026 14:46:17 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/5] crypto: Clean up CRYPTO_XXHASH usage
Date: Thu, 26 Feb 2026 15:46:07 +0100
Message-ID: <3b632975201074ccaa129f4901a66aff87b19742.1772116160.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1772116160.git.geert+renesas@glider.be>
References: <cover.1772116160.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Btrfs stopped using this xxHash implementation in commit
fe11ac191ce0ad91 ("btrfs: switch to library APIs for checksums").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 crypto/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index c84fda3acdbda57c..49293b656aff6f52 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1036,8 +1036,6 @@ config CRYPTO_XXHASH
 
 	  Extremely fast, working at speeds close to RAM limits.
 
-	  Used by the btrfs filesystem.
-
 endmenu
 
 menu "CRCs (cyclic redundancy checks)"
-- 
2.43.0

