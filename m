Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA249FC02;
	Thu,  6 Jun 2024 18:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717698856; cv=none; b=GIrRM3jMI3Gyd4VDmQb6zVy3VRew96f8Huh9KWSDetocHDLYEw/HVhApS5KZOBktpuxEuf8kTjEck1J4+fJJQwp1jj1AlJCKOdFzwVq8RNDtXr3vzoOtonZoPvE70NML+XSFUOKHwOqcfYCAbJLMsUA5hggcYraIvNlRoccU6do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717698856; c=relaxed/simple;
	bh=SMSQX3vBx8/6zCSg8t6RetA9/orE5haQ9zI7GiZfMSs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=vB7G9SeXLjbOPiNs8vZqbM+Ynirb8m/XiwwjW2jz/8YFTTBV4CKJ3KPrWByZ6HGbtRR1ZfcH/Mjs2tB1AIiVhpQpknneAlbPkv4eEkDMNFGv+QphWqI6IP65Xiy6LoO3mfukGQc8waiRa/4FDW+YiA3NGtlrNqLyAGQiLAHkRc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NzEP5FMC; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzEP5FMC"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52b93370ad0so1796900e87.2;
        Thu, 06 Jun 2024 11:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717698853; x=1718303653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d2jzHqbtOHxJocJoYLUc12OeLIP2ldL+UHFmhA/tWI0=;
        b=NzEP5FMCB81ACIFJGbzcqSojqXCVrkSFu25EoyV+3Lrj2TumRA4ST6T4aJei/Wp/q+
         Vn7HrWZUyhC/HL5+Tgh47aS5xVc0l6/nk11Iq77oi7vqIzUvh7Enlx3os+vsT80YZ54k
         6ARY7a7Y/+4JdX+EJis+3I0GvlEWQBPHRxy7MdGKOJhiXO1PIvG5qqr4J1kMSgamhZtY
         QzL0km5E4+1yMiT+tJHtbZjaXwtr78I/W9lBS5YfQsK2GsmlhJkOw+cYlM8kKBYUh3X3
         WyRRs+mRPUkLj3zAPeVZ/dGEMpgnP91RGkLxvdiNk9pxLp1SM6qBNdorcMrIzF8Xtt7F
         BWYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717698853; x=1718303653;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d2jzHqbtOHxJocJoYLUc12OeLIP2ldL+UHFmhA/tWI0=;
        b=F+nwv4lIT+BfQ8IkYQXDxY4VsMIViKI1XHTuL4DjzyTAarlAS4Hu/L274MrMoTum5M
         v2qTwD0KXQ3Ax2Ci90xT4cwdoOl/JRz8KD4sH46c1+V/tsaFtlDYAxMgYJuBEJGSK5sK
         7JU0gbxinB63YZn0YIqG8qoV4gFYKDbLkyYbQaQO4brPzo75N04q236iMrOIA465roax
         KFULtGQYqH1v6T8HWBGG76Gg5T1Gfp8mnopeUwwHYzy7GIu7yEZQX93Np+qyudYarguC
         vQzVz4kkT6YsmhoAqjfZ18Sy0QB9cqqQKDqCZRC3/zGG98uQeTczcv5b7JvuXFg2F2Ha
         wWsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhD89LczIDnZ/uHGk3gE01q29bYy9VGMeU/j27uEFnRZqVur4sho4qouehwmlMpNP5x1vNdYRZ0Otli4B0xpiWBCGqoPke0X638OZRzXte5MbHSQuxzVtCcoTnRIZ7UWoTrfGuxeqJzzEF
X-Gm-Message-State: AOJu0Yyx8RhNBKid3b5ek3rb43Fva8mm8CEX6Vh0dgXl3r/i6PQfT6iG
	IeEzquHYxa8QUS2NWlM+7BQCxj19bDPcFMloL2i72r3jDTF3Vjae
X-Google-Smtp-Source: AGHT+IFYCTFSmAYfpWZBYWlKajHppklE/wrNbIfE//NUCY03qyqbYaxJ2yLhnVNN4Ni+2nsBVP905w==
X-Received: by 2002:a05:6512:36cc:b0:529:b6e9:79a7 with SMTP id 2adb3069b0e04-52bb9f853acmr312004e87.35.1717698852639;
        Thu, 06 Jun 2024 11:34:12 -0700 (PDT)
Received: from alsp.netis.cc ([2a02:2168:8a08:3100:4883:2cdd:2b2a:fbd5])
        by smtp.googlemail.com with ESMTPSA id 2adb3069b0e04-52bb423d7b9sm266318e87.219.2024.06.06.11.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jun 2024 11:34:12 -0700 (PDT)
From: Alexander Sapozhnikov <alsp705@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Alexandr Sapozhnikov <alsp705@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] crypto: algif_aead: deref after NULL
Date: Thu,  6 Jun 2024 21:34:00 +0300
Message-Id: <20240606183401.11-1-alsp705@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandr Sapozhnikov <alsp705@gmail.com>

After having been compared to a NULL value at algif_aead.c:191, 
pointer 'tsgl_src' is passed as 2nd parameter in call to function 
'crypto_aead_copy_sgl' at algif_aead.c:244, where it is
dereferenced at algif_aead.c:85.

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

