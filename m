Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683523CE484
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 07:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774943396; cv=none; b=X1RlOKJE0vxY6EcrWHXlWFe7QHTbWxYHuhjOkHofh9/bmTMZmDWNXmuZCDj51GaZQtRqXxdh6Bra17cGroIfWYv3ZXF1ez6nqn7XLfRbCsuU1GU+EF9bM1u+PXfyjQsA/LpsLfYhB5V8m+MPLCzfr0BsbpevOt4l5BPphyghLfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774943396; c=relaxed/simple;
	bh=AttPA09lHfEVsuIZfl9EGmNOKd1iegfRxlW4j6uM8aA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I1ZaKuGIPZu/2OiUD9BBG5cgdRIXGxtXUtpEDRBO5GBGfDFJAhWwtLEVAte4H2M5IA1tZRWy1a22lqctrrpYZeyULq8YIyXtN4OLhBRIbWtBQCO0jyvUcvZc0bwAuZd9wMklJt+Gm/Fv5LenIgR0mYkLJE/u3+pbInd68nljP3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ldnLnbTn; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ldnLnbTn"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4853b5b0fafso68465375e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 00:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774943394; x=1775548194; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s29Xdjdtn9joPLQhVjn5m444FoNDrSpcw3rugwHh8kA=;
        b=ldnLnbTn6iJ4oeD3jmT1idVEEUNRqfGdG2UEGmTQLYauK/G91uwV9NJ8OSSIu5Gzz5
         EC4mmzJ9BD241ZIdkx5NHGswxhBc82u+G6FPxMMZ7WU0X07gg5zN/7q3xozoKmQJPNyV
         ayClU5+ev8ns2uiQ+uQFjP+FIW1n2htKbNhyXnDUcKv3DATqVZyAseg9b2i61hlAHOW7
         7wQakRvF1aOMLANLv0ujVkO2LiyEuiBMCvnZcF+/sY2dpcfF7KGsdPqxbW6jJnQGLf8e
         TggykqLdZ44T1V+yFEpen2/1bQ2XKegwdpKUA7LzDE5mgNhaxOXKaQAQa80+wg1xWw4f
         mYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774943394; x=1775548194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s29Xdjdtn9joPLQhVjn5m444FoNDrSpcw3rugwHh8kA=;
        b=N42VW+cJ7vSrs9yAgGWJr1qRNuBFnCZlJ47AzoJIXZYNfTbsD/4s8FMnUcX1yONcNS
         SmceUP78n3Vcy9Aq/7E0GOBYeAon5g8tFGdbTChdsjVqMtc3NkXVkSXgMcOJNPebhdNx
         86WSP86qX5MoLcivTTRKhezaX1YLyraFhPJZAcqoO1dA4Nz0a4aWKkrP+xpu5U6gIUu/
         l8pUI4f/cUQdx+1kTEfLlSHQBKgdHov5FVXFLQyE8fnfHMbYYkBkAATn83dvjXXoJdVE
         IBkG16mzJeOuIh4ZRncKamwt8gdYeiJ4HEqccnUByPP1kaUkuK0K8bBntdNYwBZLyVpL
         Fkug==
X-Forwarded-Encrypted: i=1; AJvYcCUcfE+/zgfUMOwfTeN7TFqXnxImDYrnaervaFugJAyCPpygrsYwSEJ/2/XkmYiN4TxHZrV3jF/mDe6sbfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJFPwfKghuUFNLuF0jJBqS6ILLOpIXW2LJ7BRcbiR04SgzlC/o
	6WIxp2X0JtEdOWYwdFl5ITdXVAjDJWxHsjLHFOiQG4fxPoH/9ZG4rF7Vp2pc7H4EOJnNd9SJMw=
	=
X-Received: from wmpc34.prod.google.com ([2002:a05:600c:4a22:b0:485:3482:21e3])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:64c8:b0:483:8062:b43
 with SMTP id 5b1f17b1804b1-48727eb7f4dmr252230715e9.19.1774943393579; Tue, 31
 Mar 2026 00:49:53 -0700 (PDT)
Date: Tue, 31 Mar 2026 09:49:42 +0200
In-Reply-To: <20260331074940.55502-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260331074940.55502-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=846; i=ardb@kernel.org;
 h=from:subject; bh=DspK9ILwbkU2K9P3QWlgKSmk7WPgvh8qrRYpz8jocUU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN0zfQk37L7t5l5LA+oVkvmHHrkYbvO8MtnGdONZ+wMT
 aamP1jWUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACYS0MHwv4LD4VTLCyU++Rb1
 Rw7S0xKuBHKv+mlk90dm4T6+LEXv/YwMu5/kWM+vuHx0R5APlzNvsKLTk9i5d6LNDtiV/DXw1n3 GDAA=
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260331074940.55502-9-ardb+git@google.com>
Subject: [PATCH v2 2/5] crypto: aegis128 - Use neon-intrinsics.h on ARM too
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

