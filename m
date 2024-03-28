Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F5912EBD6
	for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711641899; cv=none; b=Rf/dC+MO4oUK4tXK8IMcSI+3Cmj1nN7Bf0RQd823gI8pb6KdikYQlgVG9jVH6QwdAw2TG4TvwliTm2FDmh84Bqe7osfk12ctQ0+tSpTiwzDEHoE+JRolWOUw5SXGpy5jmnaXm28IRmr1qpn9QHuSrPugIlAAHipj7ab1b3CHNgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711641899; c=relaxed/simple;
	bh=jkgQqEjhRXI9Kg5HCJwBu1K2XFo6+zfHCumlEZPCDJs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FTdGsSHG56KHxyGBBL6U9syjEx4dZjFq944E02n/9GlTrlc3S+aO0P+7rjsL9EGoWK75D3u5VunMrVhzdGqy3DZ5dXhNzn5WopyqfBD2nZbulzQTgrBjHjdzHN/mGHgSnsAhz3H5YK+70/7Lfwos0E1qtq8hGUaldkKqOigzj1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=c/gyCv7C; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="c/gyCv7C"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-56899d9bf52so1528616a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 09:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1711641896; x=1712246696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vI6ZoGEa9V83cdHy08Sxu7AfclgAoun/MX2DchJITXI=;
        b=c/gyCv7Chpj+xmXlPn2peXeDHMRQ90+JLVKbjNiG4d0MDTiQdwwkqRCAhqhPfKqZEI
         N8TwhFckxAKh6NYK9lH5s4POuyS9i4/y8iEvwKM4I7zviE2X7RJb425NBp1FaVXILE5U
         SF0ma12p6Q3CeXlTbM1kKwsoH1A+Xp3CecxJpLqYaaW/ibWBDsoKk0NR5ACRRU8bqMiI
         sfknNLeQRRrZasa++uEfiV0dvo1aPA4Drtny/el7CMCBI2XYWyvUTnd4GF2ZNtg/JXYp
         hnhaFieYAKbaXN4ai6mJFuJMkUHZIBGpnSB0ot8YW+rg9k3YNK1wikUNHounDgyVVyr+
         akJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711641896; x=1712246696;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vI6ZoGEa9V83cdHy08Sxu7AfclgAoun/MX2DchJITXI=;
        b=HMK3sHZmWbWqb8I58oz7994rClughv3EgDQ/KLsZDLWw+W1CXDn1e1gYh8DKii8SVW
         b+jnPmPy9vGIIIjIXAmh6udUhxycDSTilYpl1MG7QfFOmsuIuR36+L2lMw0oB8Wo8sGS
         plGdd10mpnqxIyh7hE+L882Ts/KXQCx0YdxhZhaNH28MNpuxFTLF620QGCSHKIcahs8V
         MAnZqGdoASXri5nbYkth6wZen9KoQt4umKjStTy8Y4q6tGZf0UO4zs3J/+luuVXuxXsq
         AtOitD1YarjirFESCqJITpkKGEr/O7g2o2mYxUQpkrhN/yurXUY4+7W2ZcDG4c5Oxn34
         itBA==
X-Gm-Message-State: AOJu0YyUpZrP7qC7NNvuNtWP2PQVPd/PJSwd6emydNfnqzTlNOjE+xeF
	zxhv/Mi515bHggTpUaXGy/IdB8Dl2J+w45q4X+FMRYBcAGw14tpVwMP5Usxz+FE=
X-Google-Smtp-Source: AGHT+IEY0llE5S1AsYzABRko/je7SVUd0HjrRfskEzSp9n9Aqx94IpT8XC7p7f934G10wxckne9PCA==
X-Received: by 2002:a50:d68d:0:b0:56b:9f91:d26b with SMTP id r13-20020a50d68d000000b0056b9f91d26bmr2950294edi.14.1711641896547;
        Thu, 28 Mar 2024 09:04:56 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-212.dynamic.mnet-online.de. [82.135.80.212])
        by smtp.gmail.com with ESMTPSA id i40-20020a0564020f2800b0056c36a36389sm986115eda.19.2024.03.28.09.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 09:04:56 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] crypto: jitter - Remove duplicate word in comment
Date: Thu, 28 Mar 2024 17:03:47 +0100
Message-ID: <20240328160401.445647-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

s/in//

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 crypto/jitterentropy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index f2ffd6332c6c..d7056de8c0d7 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -157,8 +157,8 @@ struct rand_data {
 /*
  * See the SP 800-90B comment #10b for the corrected cutoff for the SP 800-90B
  * APT.
- * In in the syntax of R, this is C = 2 + qbinom(1 − 2^(−30), 511, 2^(-1/osr)).
  * https://www.untruth.org/~josh/sp80090b/UL%20SP800-90B-final%20comments%20v1.9%2020191212.pdf
+ * In the syntax of R, this is C = 2 + qbinom(1 − 2^(−30), 511, 2^(-1/osr)).
  * (The original formula wasn't correct because the first symbol must
  * necessarily have been observed, so there is no chance of observing 0 of these
  * symbols.)
-- 
2.44.0

