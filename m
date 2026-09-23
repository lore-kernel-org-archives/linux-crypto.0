Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF478496D33;
	Wed, 23 Sep 2026 10:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160201; cv=none; b=cTKiQKIxqI+KnutU673V8cGY0bVchqA6y2N4K9Vhh9VSGCq1yPNEriAhfRytxtG3su9X1I07xPgU5Ellx8KorqK32evEgq6vq90yVFs7r4A6el0M2WpC+F9OpiFkk++g++MZxAVCaQ4T5398d2RL/zaficeSPUlysufLpp8tMNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160201; c=relaxed/simple;
	bh=UzQAWVqpECBtJSeBBqlIc1ks1ChKKGMwKNz12UKFjVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hIxVmB565lBMtZsGVwwY6DBCSiGMNRTTljOZk6byKb50OEvZsQgJqsdcLTPcw4u1hzjSla2PtQKY0Z/knJuLgRH5gvFuSjnavtA1keFXp0H4T9/r4w+wWzXesZeXvlsRotlKSUIyuVKO1o96TPFi+/E7Y5MkM+GVx5VX4PfT/Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aq7KfXKa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aq7KfXKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044531F00893;
	Wed, 23 Sep 2026 10:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790160187;
	bh=4oVf8DzdA35aYlTjZL9C99SgepL9G6bQsKftQLJ5+Ig=;
	h=From:To:Cc:Subject:Date;
	b=aq7KfXKamBL1ZhwwkniocrPwNXyC2k0vaHhCHlqUxCikNDGUjqQmX4PtcInxutw9C
	 enPgJyqJ3L6ar0nkSTh/vy1G0wMAp9xalWPT+jRm0woB6/ASTUN0ElPnC8/xSNppag
	 aG/AOPwGeR87P5O5uCEF8FGyrheMYnoDDyvFLMvSaFXK2AoRjSz5u6XTtH0JQ81IeI
	 lq79cFr4O2KOAYln494+wcKdjxCxrPNVGHoWbv5tgasUExLD420y8MD3Rksg0spGu0
	 YxqRwIf0lDtzb30g/gtond6jX2Hk/GSSPlSkiX+snyBU8VqdByg4s6YxyIxTWAkjE/
	 9RXuRuQg385Cw==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kees Cook <kees@kernel.org>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: intel - declare warning string as const
Date: Wed, 23 Sep 2026 12:42:35 +0200
Message-ID: <20260923104237.82599-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1400; i=blum@kernel.org; h=from:subject; bh=UzQAWVqpECBtJSeBBqlIc1ks1ChKKGMwKNz12UKFjVQ=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmb18qGsMg2OG8znfzt1tzc5XLZMXUy9t0lObX/ePQe/ Nn9de7WjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZjI5CqG/y4VgssN5sz6fuit 2754YV1e84IregfZKrfpnYj7dcAreSHDX/Hm+ontDD9m5Zx9k7f2KsfKK53JJ9ZrOwo8mb76emf 8Qz4A
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

The warning string is not modified and only used during initialization.
Declare it as const, replace __initdata with __initconst, and indent the
string.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 828ed57f8500..dc3c7b6e1e59 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -305,11 +305,11 @@ static int __init intel_init_hw_struct(struct intel_rng_hw *intel_rng_hw,
 	if ((intel_rng_hw->bios_cntl_val &
 	     (BIOS_CNTL_LOCK_ENABLE_MASK|BIOS_CNTL_WRITE_ENABLE_MASK))
 	    == BIOS_CNTL_LOCK_ENABLE_MASK) {
-		static __initdata /*const*/ char warning[] =
-PFX "Firmware space is locked read-only. If you can't or\n"
-PFX "don't want to disable this in firmware setup, and if\n"
-PFX "you are certain that your system has a functional\n"
-PFX "RNG, try using the 'no_fwh_detect' option.\n";
+		static const char warning[] __initconst =
+			PFX "Firmware space is locked read-only. If you can't or\n"
+			PFX "don't want to disable this in firmware setup, and if\n"
+			PFX "you are certain that your system has a functional\n"
+			PFX "RNG, try using the 'no_fwh_detect' option.\n";
 
 		if (no_fwh_detect)
 			return -ENODEV;
