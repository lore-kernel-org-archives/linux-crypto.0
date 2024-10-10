Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C96B1CF5C3;
	Thu, 10 Oct 2024 19:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728589524; cv=none; b=Te5l2AZemWsF4ZXs+JD2hqQ7o7x0vzwYw2qaBD2GU9eOgrlRwj+b7sAUU7TSqtcpKut152S03kUP71zA4o+1Rzb74Fg61SB9hKnRMCysrjW0MJpfGZ+gxz2Rou+a8hNXug8NgP58M+yXTyPZyUTFEVR0TY7oWgz1kvDowCeGabo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728589524; c=relaxed/simple;
	bh=8tEpKzuJJod0wz3ZcPjN+AayChvMMlQKA3FkFqFp7Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0W8JNvNv++VjHo7jJFTG/gmJrvxqBBixVxV4nidgzCkheH6Y9nzlBfsqbzeztM8ZfIf9/In7Dld5ZgtagieRFbZTAlHBTHvWBaeRW2DCUdoiG4bfLDVVTNpYneDZUqXxzmNwxmUMzJUaR/Ztt/zF87E4CVvQnUEMJ/hY5K4Drw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MzRc4Jgi; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MzRc4Jgi"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7e6ed072cdaso950824a12.0;
        Thu, 10 Oct 2024 12:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728589522; x=1729194322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q/vVq5169u7i4biYWRH+U02krdapDJFUv5/71gKhc60=;
        b=MzRc4Jgifk3kUgx6mtSHn7J7IQJtZ/wD7VEDSCFG5zj8/2tyOV2qGUOFPGHH+jTWfl
         g67o7UXCnDPpDobKKgy5CEkWuWDrUcQ+4pHH2g8fM5RNyOrQjPodPfwpzeAzA5d/OjtL
         Am3czQuFiMNM1FvLM0SdTrYFNtou427MQfJzoHbPPkHq2K0gi/i+Z0oCVifXLgtfW2Jx
         kFNRwc/Nw7mg40UWb2fet5db7PS5FcW/WqdnnwOfstj7wvlHItoo7y4OB9swXi46JFb3
         nVftVm6UzKBHyoDS4lLHMOLDJ7jzmDlOD8PKf5lyBz4e3UgQ5adtbR0f7D7kKRIJZTIR
         PWjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728589522; x=1729194322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/vVq5169u7i4biYWRH+U02krdapDJFUv5/71gKhc60=;
        b=Fuw08d0xSWDsWuyI8/wtGUmS2niImBGVdO7XVy0UHqkl9AtaRoiZauBIJESk1V2Hij
         Sc53kJDLhyvCw+4hJrPckU+eBuBdnYzLnIKLTZButASW9bBhzmZwWPp3J5XoASKZNj1j
         lQJ0mFlW8Le2MjAutMEei4XNfcAoP4jnODORVOKtq3xNQX1ozrPvhho2NkWY0Q5oEQlJ
         stbIpMwa+dC637jb50DT1hUB2gNAf0xUqIOJoGp+y1tWl62hN0vFDRG6Cgu9UQPnm9BF
         2VjKZe80XqTENgstFFDYiekxKMeis2B/2Sz42CEHM64kiBpXMQahqZuhXFKd7lst0br8
         vyew==
X-Forwarded-Encrypted: i=1; AJvYcCUOybhJHd4GewSa3ddG1aZsmyA0UGBI/kefQpgiYBIAu1RbTEWEB25Schm+45M4bvqMxI6csGrXZ0DlKss=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwIyuDbvE+1tkqk38GPvFAxqSSzL87lhJDsAAXieH/ZJ0yLTGt
	9qlxvtitOW672/rpSphwf/KjIIBquFr8fvu5AjjHHm2c7nFQ81/DeCETN/v+
X-Google-Smtp-Source: AGHT+IFkP32W5FTePBxbjmQ6asSjg+DfGIyQ+ZyXqTnfkEwDw0+8Ev+wAy1piA16dz4RUdZcSOnBNw==
X-Received: by 2002:a05:6a21:1190:b0:1d8:a18e:177d with SMTP id adf61e73a8af0-1d8bceef578mr176044637.4.1728589520893;
        Thu, 10 Oct 2024 12:45:20 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea448fe50csm1374762a12.29.2024.10.10.12.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 12:45:20 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2 1/5] crypto: cesa: add COMPILE_TEST
Date: Thu, 10 Oct 2024 12:45:13 -0700
Message-ID: <20241010194517.18635-2-rosenp@gmail.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241010194517.18635-1-rosenp@gmail.com>
References: <20241010194517.18635-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This can build on x86. Allows more CI coverage.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index 78217577aa54..4c25a78ab3ed 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -7,7 +7,7 @@ config CRYPTO_DEV_MARVELL
 
 config CRYPTO_DEV_MARVELL_CESA
 	tristate "Marvell's Cryptographic Engine driver"
-	depends on PLAT_ORION || ARCH_MVEBU
+	depends on PLAT_ORION || ARCH_MVEBU || COMPILE_TEST
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_DES
 	select CRYPTO_SKCIPHER
-- 
2.46.2

