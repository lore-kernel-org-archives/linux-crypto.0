Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D92198E90;
	Thu,  6 Jun 2024 17:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717694466; cv=none; b=Nj8zWMF7bWxluG9A8Z1MMFQCKh30IWVczrVvHDIKOBvKg9WbxR9kpGDJarAhjGLMCtHQvdnuGf2b1ZbYOdB45c8iv//6MLsIIeJTwe4s9lEpldiK1CWhHyDzL3o3hgldpe5aoCpYY4mrw0cQG2gj9IpwSkDeGqpl7vja3hJOeHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717694466; c=relaxed/simple;
	bh=Ot9A6SeA8dAsQwHKsNxRkFPhOuP4b68dsYRTMjNGsNg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kQTmHGPWvHeAbmqrpvf8dS/MDhMRN7wsudpfhcQ+RQyFm7FB957iUOtxHTDaMzaiHZyWT7cGNdnxkbgL4SIulpJPy4uPWuLzHPWWxxfvXxUfRN6pob517SJN7YOf3aXAPQy6gLq9jLck1WnSEDByUQZ3h3dQXTtQ4/8AFePw0WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SzwQUBHQ; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SzwQUBHQ"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5295e488248so1504345e87.2;
        Thu, 06 Jun 2024 10:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717694463; x=1718299263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EBzQ8negayjPzH4I927JPLD9bGZumwIM1r0NZmwJJnc=;
        b=SzwQUBHQFxefchAPAscBLcY4DQdC6AdCaYNLNdvEv+EtHkgdaRyoSs+bRaFlidUWsL
         t/LeWqR8uABmirPdimWpbYSLs8/pkl3yQQgDtJqOS2MRNz5fvM2Mn7r6EVEKNMLmH3ec
         rDhB4Xb1m6Mgrplgbhjl4/viuzuJ0S8wN/pQZhfjlXc9Id0SS2LIdsefsI6Uc/wO6qoJ
         Y5i28/qw86sV47dMOdccquOR9UVGWm4GfhrT3RdHBGlrBXGgWg2R/LTXuq18V6O06jL2
         7PqtI35Lu7tMmSnMBsYsou+Qh6mUAEIgXeSRq6lxp8xZT1CBZzgpi5JUTCvESg6PwjeD
         6tkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717694463; x=1718299263;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EBzQ8negayjPzH4I927JPLD9bGZumwIM1r0NZmwJJnc=;
        b=W0UehYSuH4rRgKusi9fyGl8twdG1KLG/0mvCl8oxXME54ECirOEZ7ihi3kJWkh3RKH
         S0uAh20qQ7dMuJyQ8smDfufoIFV+cpJq7KEiVMhZhzVZ0N20t4Nx7obeNQspZuKv02pP
         89GXyz91fLVN2FBI1AHxNx2v5wgIXP+omCJpuJ/DHkAlX3kO1cnUcsjyvEU2W3QOEifO
         5ggX8Q2IqUArS+Goj4UtMzw0F8deUE+4K0/E4FCClm7g6sEwJhU74QfefUhFN3X+CqYg
         j9Wpwr63a3GWpU2Iu1oc0EgWfqPaMLuEFfCPT9oAhvEiC6kRF0gN97CYn4sSrFZ9MRnI
         K4ng==
X-Forwarded-Encrypted: i=1; AJvYcCX5SFXU+YKwM6ShGf58w524PXa5+HWtrG4Z0PQMrYoJX+W4Do1c23zed9sGdKgYm5oG/n/Oy+CM3Vn+RyFtNgrQ/3dLLFTVutdJq13U4VBpOECCXaJIkddbXiVdMrXpDNdlWAi7cqGP+hOa
X-Gm-Message-State: AOJu0Yw3KN6Mfu4MoudfyyuwGvBehzKZRKQTB4AUcWrA9Iy6WdKz/+Qt
	IMwChRG6YpjXBccDakt3TFgUsp9pD7jPCOeeTRY0lF5WWKcu6I6ODb4fBg==
X-Google-Smtp-Source: AGHT+IE2jJfxNHfndA4jVkwzr8ji42GiKL6ddO3EGnD7yTDIo+519kYcIXxcxarQcigruI8iFaWKVg==
X-Received: by 2002:a2e:b711:0:b0:2ea:c00e:2a93 with SMTP id 38308e7fff4ca-2eadce715b2mr2147021fa.40.1717694462861;
        Thu, 06 Jun 2024 10:21:02 -0700 (PDT)
Received: from alsp.netis.cc ([2a02:2168:8a08:3100:4883:2cdd:2b2a:fbd5])
        by smtp.googlemail.com with ESMTPSA id 38308e7fff4ca-2ead41b078asm2613361fa.74.2024.06.06.10.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jun 2024 10:21:02 -0700 (PDT)
From: Alexander Sapozhnikov <alsp705@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Alexandr Sapozhnikov <alsp705@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] crypto: algif_aead: After having been compared to a NULL value at algif_aead.c:191, pointer 'tsgl_src' is passed as 2nd parameter in call to function 'crypto_aead_copy_sgl' at algif_aead.c:244, where it is dereferenced at algif_aead.c:85.
Date: Thu,  6 Jun 2024 20:20:23 +0300
Message-Id: <20240606172023.23-1-alsp705@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandr Sapozhnikov <alsp705@gmail.com>

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexandr Sapozhnikov <alsp705@gmail.com>
---
 crypto/algif_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 42493b4..f757907 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -191,7 +191,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		if (tsgl_src)
 			break;
 	}
-	if (processed && !tsgl_src) {
+	if (processed || !tsgl_src) {
 		err = -EFAULT;
 		goto free;
 	}
-- 
2.5.3

