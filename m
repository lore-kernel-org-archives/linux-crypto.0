Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEE720322;
	Thu, 24 Apr 2025 00:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745454179; cv=none; b=tgqBT8bSphyBJTBI9fV1z2AcxL9Ig7U5NtthrEjQ7Q688P9OOO6ozWRp3pGh9tirCmyjIREZN9zUk0Tg8CvGokEIL0ayTxBYDMawPS5yCYq8ZzSWs2jq1md7Ud2HsafUirufl6iPRmnmFBmbDHSiHtzHnaLqKGqjiCgGzbnkS+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745454179; c=relaxed/simple;
	bh=rccSS05ssS2rf46bfeneK2x/JfdC1a/pj9EmN7hGOls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRShsUNLVj3YrI7MnuSNRjPdTMN4gXkHNInMWgC8JJt4hfjLYVqasqql3sv9eNNCtYguHG1E+5tPiXMVbQ9/sZGA+1kzyApmO6IYLLQayI78FlXfIeZ0qTSfSdvMlXYnHgPYYOni2F0q8S659Y5jZsM+EMa89cYYIbh6nqP8RnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2B0dh/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2B0dh/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E19C4CEF0;
	Thu, 24 Apr 2025 00:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745454178;
	bh=rccSS05ssS2rf46bfeneK2x/JfdC1a/pj9EmN7hGOls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2B0dh/DG8edBPHhL47uq8g33ExepNWr6h3LPHIZCuKmntMSr/mh8xBGoaCzeCIYz
	 ss0X/+nCSNljZQuvdx+/pPkkezIyuP5LflGCrevm+LNGeVaMyD2Bg6p2Da+9UM9Mx4
	 KIMbFYDHf8G5Up1Y78RwbPpfddi8F6XU3lykN13xvuYUnJupXwxOl1nMQA3Dp51vP7
	 iH3kpAnJrUwX3mmdSdb+ZbQQkvzajKh+TbEXfG5Fs3gexCvVC8F/d9Sg29inCjkDwM
	 EDPcg2qEEExXt3Dh3Gp/NMUGs3fC3hGtzesBe0Ebszy0b8o2TkzOhyB5MydePYwlG7
	 0/PFol/maj0BA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 4/7] powerpc/crc: rename crc32-vpmsum_core.S to crc-vpmsum-template.S
Date: Wed, 23 Apr 2025 17:20:35 -0700
Message-ID: <20250424002038.179114-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250424002038.179114-1-ebiggers@kernel.org>
References: <20250424002038.179114-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Rename crc32-vpmsum_core.S to crc-vpmsum-template.S to properly convey
that (a) it actually generates code for both 32-bit and 16-bit CRCs, not
just 32-bit CRCs; and (b) it has "template" semantics, like x86's
crc-pclmul-template.S, in the sense that it's included by other files.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/powerpc/lib/{crc32-vpmsum_core.S => crc-vpmsum-template.S} | 0
 arch/powerpc/lib/crc32c-vpmsum_asm.S                            | 2 +-
 arch/powerpc/lib/crct10dif-vpmsum_asm.S                         | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/powerpc/lib/{crc32-vpmsum_core.S => crc-vpmsum-template.S} (100%)

diff --git a/arch/powerpc/lib/crc32-vpmsum_core.S b/arch/powerpc/lib/crc-vpmsum-template.S
similarity index 100%
rename from arch/powerpc/lib/crc32-vpmsum_core.S
rename to arch/powerpc/lib/crc-vpmsum-template.S
diff --git a/arch/powerpc/lib/crc32c-vpmsum_asm.S b/arch/powerpc/lib/crc32c-vpmsum_asm.S
index bf442004ea1f2..1b35c55cce0a6 100644
--- a/arch/powerpc/lib/crc32c-vpmsum_asm.S
+++ b/arch/powerpc/lib/crc32c-vpmsum_asm.S
@@ -837,6 +837,6 @@
 	/* 33 bit reflected Barrett constant n */
 	.octa 0x00000000000000000000000105ec76f1
 
 #define CRC_FUNCTION_NAME __crc32c_vpmsum
 #define REFLECT
-#include "crc32-vpmsum_core.S"
+#include "crc-vpmsum-template.S"
diff --git a/arch/powerpc/lib/crct10dif-vpmsum_asm.S b/arch/powerpc/lib/crct10dif-vpmsum_asm.S
index f0b93a0fe168a..47a6266d89a8a 100644
--- a/arch/powerpc/lib/crct10dif-vpmsum_asm.S
+++ b/arch/powerpc/lib/crct10dif-vpmsum_asm.S
@@ -840,6 +840,6 @@
 	.octa 0x000000000000000000000001f65a57f8	/* x^64 div p(x) */
 	/* Barrett constant n */
 	.octa 0x0000000000000000000000018bb70000
 
 #define CRC_FUNCTION_NAME __crct10dif_vpmsum
-#include "crc32-vpmsum_core.S"
+#include "crc-vpmsum-template.S"
-- 
2.49.0

