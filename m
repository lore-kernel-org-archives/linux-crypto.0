Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC320366561
	for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2026 17:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773337667; cv=none; b=ZR1pT9Bz3Eyx23AWeLlBrT+eTnmP+0Vvi6L+zoD1j7xSJQth5metuHtjYKhw/zgVbegUjRCjWXI280nOF+kyARlhJDa42ReKSY4DA9C3MQc4Hp6j5hgkK200phtmy1oCVGyKyZ7srJkeBoSifam2wfz4ud7ZUC8o7lBzfgyYUtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773337667; c=relaxed/simple;
	bh=JKHIHgJNlinGQNonZhIeyUWWdGyYv7r01HY4wDdE3tk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mHCTzeTOupzxT8yDJPTXzEwIdXw35KKHGdYmQ1AkMIJ5EepoqR70x0NlaDY0eD8HQc8mqc2boWZ2iXXpc2igqlI9a2c7O4FRuXESHhFU5Zk3F7LFoJbkNI8XNLnuX1ROQus39z/kwJ9hqjwn2sZPrFoDeLMmVoCxENriAGCpAik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iBs1Nn0W; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iBs1Nn0W"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48538c5956bso13062375e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2026 10:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773337663; x=1773942463; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fvf+99+NeAUCA29xYfsHkx4iZY0Ru2OICw3Uc3ChGiE=;
        b=iBs1Nn0WQ/kw2uiKhBelxx4tYUEfFg7iBTIyOoqNQTTGdtBBtWV8Anw1a53QMBh0LI
         WZiRWmwojP8Wwb0YYtNnPQjvOQ/umJt24GuoECAgAkwOpZSZ7oJ8ZtOYr8L86WZ3RNKY
         1Ygw9LPXkquHlctrb9voLfgD2of1Z+yBfTfpKJJTCzBPsOJB0mCOgF23cefHXuivFjmD
         DKbstuU9K8hEAD3AJAsBTyjk++gYRBNcWR8BlhgtYW7u6yuKqT09kq/4XQYLyYWZrm/4
         FmWObVfwSpFTDLuihII0aw8WacMLXXwBfzvEKpylggG2b7HCktRYoTmH8OJ3d4p5ZOZd
         QsFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773337663; x=1773942463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fvf+99+NeAUCA29xYfsHkx4iZY0Ru2OICw3Uc3ChGiE=;
        b=l7kFHmePx7rekO8eP+TVBx6qC8E+Upe9Y1tHXX7o3m53B5MLb9Zd8X4pBJHSYQVG2w
         m56+HgZUWxM4V1DgkC6G+wLdsVPIMAJ61ZB+atnhIBfCL5vlMfgGrHyIuSvmkf+WcepV
         GGfFrLi0Kdi2xhTsAQvnVbr8fI7U49/VCxcihUXNdcQ4h8meZ50FfbwufDPGRY6xd5Vz
         Sxsoo7r2++xnyE9GTFwaiTw7E6zcQeHimHLHGpPi3gzKfVy+v/kF+OiMwiszZRBx9aXN
         gHbyo1T1U0wiuLYBhIlZnodBj5ufuQKWirdH5hm1ZkvJYINZeUPg/pp6jFqdCzH7PFe8
         BmTQ==
X-Gm-Message-State: AOJu0YwDNn+5R/I5fxZt7EJA4P0TGDZdYTRePkaJ22YqxDa2C7FO2TZH
	9WwJhR704tj+7TS+ThWPqQV9dJE4CGRQcz7PGZpK3l5inDQq6rtx3Z+3
X-Gm-Gg: ATEYQzxMjvtt6lhjk51jwPZC/hkap9wJbzlLHY2N1Bjep2xMMKV1znDdnn/vgtzDhgv
	dJgrB1DKIA/G1vKX4N/LFqndaH/8rGpe/zn7zCeUzoa1muRuvegQQuzUvli33f6JTUvDyo0Sfas
	xLCktYMcmoyR/TJfca3wm1hciR990FEXoBG+ZSQIrsqSGthGaW6ycaBVgsx7UNi9AeoGBUXGoTJ
	yTDkJ5/ozRcaqReSCvcRyh8YEJdld+6MtUhH7vv+M3Z3tVJs1GUo361eUPwozkSXubisJYj+emo
	IBbCDzruiNwsOHp4mgwjeSZmOcto5VnM0EgU71cW+yvCX6EXeatAzI7SoQl7PcC5zDETU4tVZhL
	43VFqbbbcLQyWh+pBKUK6ylPdiT4rMzbTBqE6dEmZCbQmYa3IFOMbRviE0Ym/37peQ/2LOkKF0L
	EdxglSBABR3/iEcVeHw02oLafi5Rc=
X-Received: by 2002:a05:600c:4752:b0:485:38f1:5cec with SMTP id 5b1f17b1804b1-48555ac714fmr10347445e9.7.1773337662796;
        Thu, 12 Mar 2026 10:47:42 -0700 (PDT)
Received: from kali ([160.179.83.160])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4855641355csm1300825e9.17.2026.03.12.10.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 10:47:42 -0700 (PDT)
From: Abdellah Ouhbi <abdououhbi1@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	Abdellah Ouhbi <abdououhbi1@gmail.com>
Subject: [PATCH] crypto:skcipher: fix kernel-doc warning for anonymous union member
Date: Thu, 12 Mar 2026 17:47:36 +0000
Message-ID: <20260312174736.37651-1-abdououhbi1@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix htmldocs build warning
./include/crypto/skcipher.h:167 struct member 'SKCIPHER_ALG_COMMON'
not described in 'skcipher_alg'

The struct skcipher_alg contains an anonymous union with a macro-defined
member SKCIPHER_ALG_COMMON that was not documented.
Add documentation following the pattern used in other headers
for similar anonymous members.

Signed-off-by: Abdellah Ouhbi <abdououhbi1@gmail.com>
---
 include/crypto/skcipher.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 9e5853464345..4efe2ca8c4d1 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -145,6 +145,7 @@ struct skcipher_alg_common SKCIPHER_ALG_COMMON;
  * 	      considerably more efficient if it can operate on multiple chunks
  * 	      in parallel. Should be a multiple of chunksize.
  * @co: see struct skcipher_alg_common
+ * @SKCIPHER_ALG_COMMON: see struct skcipher_alg_common
  *
  * All fields except @ivsize are mandatory and must be filled.
  */
-- 
2.51.0

