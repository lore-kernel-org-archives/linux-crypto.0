Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FAB1D7E42
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744455450; cv=none; b=TfL7Qk/I1T6lVVGScdDnWTpHELCjeJKUf53s5wadkVDsc2B2K8iz23UEc5EL7aIvm1SC5ifhGsZkdybWrJC39UbWq/XZVmddLHbrjJjg88jP+naaTfpA8sKPqVJzlcZE/t7owUG4+sRHDMoGFsxLfPXgjcRNqtyHnNoE+Sr1NnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744455450; c=relaxed/simple;
	bh=x4cgi/eNdYnXU6Azc/fwrlX40v9FIFnQ3nVnZTJ8ARc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=hoKgTvY9Nr9/4CJ3uN5cizL6rWsB0IsbVE3Jvj5OjFq3QSGCNQkWQSoAQxzXL/2xuRArbMBItmCrbKwEFWv4OI1TZQvD8htRNZHp9CZea/QvzIaoT6ypMrTt6R1hvNtNqgkr87mog9QOVoA+ItAq01KcVFhCU4UVwyyzo1C/+F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BBeZf4P3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BBeZf4P3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3taFg7/J8OiJUAP4pU1TZ/aEtAT/FE2f4x/3LCbVOrA=; b=BBeZf4P3MsWOmsrAi0rbAyGRve
	2qF5bE38T2BBQf0kMOwX5EQ4Y6HIA8DwJkmeJh1kRoEtNUIZomWtB9/9wo8TTVkuNGWQgyqdI0qwl
	92GhEwQuL1xWYOaOZAys9DT3o8B8B1kV3ncwnlioPDDwfaXzlatAInNVUIAW/0NCTv/86V68+Yya0
	teq4yOKxicwRnaJhmgsPP8xAaFml13Ao1JVDWuyXjUFul4HE/pzo/5CY6+wMhxu88AArfQjRbFQ2p
	2A+na98d0M5L5KUIyqnmyfR1HmSYwIQ/e0LnlWP43Wn25x2aHAkPxr/jFlLvaM6X6IfubBDxzk6vh
	fk6KkNzw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YY8-00F5KF-1u;
	Sat, 12 Apr 2025 18:57:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:57:24 +0800
Date: Sat, 12 Apr 2025 18:57:24 +0800
Message-Id: <46a016a18a0e7440ff74c6f4e8d04cf54baad659.1744455146.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744455146.git.herbert@gondor.apana.org.au>
References: <cover.1744455146.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/8] crypto: arm64/sha512 - Fix header inclusions
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Instead of relying on linux/module.h being included through the
header file sha512_base.h, include it directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/sha512-glue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/sha512-glue.c b/arch/arm64/crypto/sha512-glue.c
index 62f129dea83d..f789deabefc0 100644
--- a/arch/arm64/crypto/sha512-glue.c
+++ b/arch/arm64/crypto/sha512-glue.c
@@ -6,11 +6,10 @@
  */
 
 #include <crypto/internal/hash.h>
-#include <linux/types.h>
-#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <crypto/sha2.h>
 #include <crypto/sha512_base.h>
-#include <asm/neon.h>
 
 MODULE_DESCRIPTION("SHA-384/SHA-512 secure hash for arm64");
 MODULE_AUTHOR("Andy Polyakov <appro@openssl.org>");
-- 
2.39.5

