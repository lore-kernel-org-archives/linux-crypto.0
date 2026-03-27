Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EF22571BE
	for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 11:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611079; cv=none; b=pVtuhla9FbSADqMdN7raoNno8dztOm5Zj/RuToeIPN1toZwgb9vFbDq3ZQMUl/r/gy0IatcKd06XP2WEbDlowXsn8jXKkjdTqZh++YtIEsor6hGAxoLVW2dD2l9kcFN+8ozv1LVqNgt0tSMwBD2ncQyTSoIbLpizvPVpgTsGR8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611079; c=relaxed/simple;
	bh=AttPA09lHfEVsuIZfl9EGmNOKd1iegfRxlW4j6uM8aA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BIExj9dNKuFa7f7p5eNEvkRC0bvQrCEXoD3YueRDIQRq84OoMNhcTGMkXaD/aClt78crxHQW5bPGA5qL2CT42C0MLpqrrIe1Q+kQ8ODm+OUhXU4xZus+7Q8M5pWEVfS5O9J08conqfiY3GbVWDeRf3AxH6w5lPokvRxln0VBmRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OKSUCEru; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OKSUCEru"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso22689685e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 04:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774611074; x=1775215874; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s29Xdjdtn9joPLQhVjn5m444FoNDrSpcw3rugwHh8kA=;
        b=OKSUCEruQTVYUMnRZ57aoktdj0DGYCFJShVN7tx7XPTyySKkKiR3WF+phF64YWQGRP
         ZXIP6Qi+2uTQKhurSo8V1CkZEOHMVvRFXFCGeuMxws0D0maSAWVMWkLelTaow9i/zdaA
         GF+4CxN6Zv/ErMSCDWY/9NxHB9iO75ZwV9Lh/LZxhX+ZCYiczKTlWRW7m4EFuGmD3dtW
         P6Ds9D1cr/mPBJvmjnM9ZSkEoUFdUf2Cb5jYNISsDtgP7MJb5LAmR1JntzJabFVn2ywI
         KUx5NMHId2dVhxk6Z5ILHJse5xOapJg2qcuhDhPYq7X1AbdItIqWetuwp0yIBpO6AHKT
         9rfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774611074; x=1775215874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s29Xdjdtn9joPLQhVjn5m444FoNDrSpcw3rugwHh8kA=;
        b=jKW7UM3usSud6OwAcYwmNfAsxG7a7/dP2q5awB+zFbxgM4VHy96hPW9PrcYSMfCC3j
         vUW6QlWKwrWjcdeEAtXnwZ0HzP9UP2NR3Joo8EZpLgxD95mlTAa3JsKPDPYaBUl4xkl/
         lciTwdt21ji6ZErCuFtyu7PAtGP2IJbHJxrX/xKkbHHWieo6s4LgHUF07Ow34wZDJkcX
         teAph+a2n6ztBvFhFyNvBnI3yBqYHMJkQVOzUKob9CA1nOdymCS3WpoKSgFOMlAMe92Q
         YcVROpbdOVwP7xAyqmK646jPDnLMTrgy1142NQRz7uCAKx0F1OLJT3JFRMgyUOocs51P
         98UA==
X-Forwarded-Encrypted: i=1; AJvYcCV6wPQv7SdI/Kgci+QcHWcXrhdLHNbU2Iwv1n9ZdKwhtpJUlb1C+ccuCbQKQJuxRAa82Xi9PJBYmmy/f38=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMr4qV+68Yrnh6MZh8HRoifnPN1Ne8b6rv0broImz4a1QA4C0W
	7Xgo+sPALdHdFxhtltsKErNWFDPGGq5esCzU9xSSSp/FgVNmq/mNn3bnQWpNUtClfHuQauJwmg=
	=
X-Received: from wmph38.prod.google.com ([2002:a05:600c:49a6:b0:486:fe68:2045])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a303:b0:486:d76c:fa51
 with SMTP id 5b1f17b1804b1-48727f0a808mr26067575e9.27.1774611074454; Fri, 27
 Mar 2026 04:31:14 -0700 (PDT)
Date: Fri, 27 Mar 2026 12:30:50 +0100
In-Reply-To: <20260327113047.4043492-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260327113047.4043492-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=846; i=ardb@kernel.org;
 h=from:subject; bh=DspK9ILwbkU2K9P3QWlgKSmk7WPgvh8qrRYpz8jocUU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfNYVlaSb9n928w8lgdUqyVzDj3ysF1n+OWzjOnGM3aGJ
 lPTHyzrKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpADeZi+Gf9ok0veLs3ntKDCJn
 n96tZ1UV/yGTwBriuPjwOfM5lbprGf6pp2Q37qwxSlBlftLoUrjN6dkSuz2sO9oYrx9WmzhDpYc XAA==
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327113047.4043492-9-ardb+git@google.com>
Subject: [PATCH 2/5] crypto: aegis128 - Use neon-intrinsics.h on ARM too
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-raid@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Use the asm/neon-intrinsics.h header on ARM as well as arm64, so that
the calling code does not have to know the difference.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/aegis128-neon-inner.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
index b6a52a386b22..56b534eeb680 100644
--- a/crypto/aegis128-neon-inner.c
+++ b/crypto/aegis128-neon-inner.c
@@ -3,13 +3,11 @@
  * Copyright (C) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
  */
 
-#ifdef CONFIG_ARM64
 #include <asm/neon-intrinsics.h>
 
+#ifdef CONFIG_ARM64
 #define AES_ROUND	"aese %0.16b, %1.16b \n\t aesmc %0.16b, %0.16b"
 #else
-#include <arm_neon.h>
-
 #define AES_ROUND	"aese.8 %q0, %q1 \n\t aesmc.8 %q0, %q0"
 #endif
 
-- 
2.53.0.1018.g2bb0e51243-goog

