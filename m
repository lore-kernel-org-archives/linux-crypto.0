Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFFC324B17
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 19:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246133; cv=none; b=ZxocQCp+Mjw7ATfNkqLtCjnAKDWPdYrQX4jRrNpvZugNy5QOKxa62SBodmeONLpnLpKOkOU2L1r5D3ox0DmH6Xwrf5knLNGsI3nCw1mA3gex0eRnthvydEnqz8yLGbNUFztocRevYJrvrXj1nKu9nMfPl0Tun3LKFwy96Pv0xq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246133; c=relaxed/simple;
	bh=zojxNT+RZbLezTydyxAsIzYgwtxcsP67AtbFNc0SDsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=in8FyZKyhKno90+y/RcbCDmIJdwuto8UPSfLYf1EhHYQCRpgfM4HI+pey7fyy2gFpHQkybQzOzGhTIAFtEbJtYnyhvv7K74EUbtHI7JU8WvpvOX4isCrflmB22/5YR0YUeMRDIttSBW6yaNrLrZGcfUid9Em80PWgw+cMYEvrqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NatTr60U; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NatTr60U"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6505d141d02so10905471a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 11:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246130; x=1768850930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQS0SzXkMyBsX0r/DMnRoitwZR/NjZ11xjjJpvDZxFQ=;
        b=NatTr60UgeiWWQyqA+wUNCsI1SuWNvWELwEFUJx6Z7zqKFoXklxTadNGlkFzFh6gw/
         Gbfc1DyA2sg48wtqzd1lGNbQ4DhYgAH+IZg60u3eZQbi+VF1ZneSQHUlSCfof8fL6Z2A
         Pvav/EdbA3oWdmRiJuOOIJ7w06640VQ6NKzeB9Ja65jdLyPeusic5363I7XxSSTSXLK6
         i8oSZ1ADG3PN+dcSOpgGBjwppxfi63Jd4h5DCTzOpWXKJsHjgMP4B8jQl7BocYk+dQur
         NytbqWiGXWUINkIHrddsbGnX69FAtR1Ny7tKLebPE/uJXikTgTxCcXeWL8UWOJ+acWEW
         S8IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246130; x=1768850930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sQS0SzXkMyBsX0r/DMnRoitwZR/NjZ11xjjJpvDZxFQ=;
        b=WP2+SwNeIlC1RTIMk407N1s6tg7wjpsJuxStPVbVB9WKtRGkIjzS/T4KqMzqWFdkGq
         +Pg92nb1qgpNpNRSi7MNdoBokuzkQNGL5JM3Hgw+ytnJGETOUrhct3izHXKAlCWyt3c5
         5LO+CXc9CGRLRpTdqNfVa4f11MoUJpHIahW7n26FfHdCSRmvM23vl3vQ6Ukc0UHoW9Yo
         cC8MDHGanhA1hRHdlkP6tDvYljTaEEtZBmuCq3uvjFNJEzWfxVUveJ0Hg4bqu8XTDoCE
         GGl10nyKr1gxKtJELKTBBHvZ5NXwKcjfptDkrEyPaW8z2+KCLOeC0+hU9JXnlG/S3XWq
         KT9w==
X-Forwarded-Encrypted: i=1; AJvYcCUphPFNdp8xLhVkVB7okZCELPcY6PuPQ9HcUg39TxGODS1BiyV82X/6JFps8bsawSGZ0QNmVpoMUtuoBQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvuTAJSqkPgidpjmUfBqnX2dj++BzLgJu2kSc/vvG4vVY7yx+A
	QymBx7XOCR36XK6ybZgRHVNQPYmfgoLYdkorSHGg4v0zwIX9dPO1wZty
X-Gm-Gg: AY/fxX6y9nMOZ1Ag2Dtn06qCGX+lYHNACNPTsUiWYGuPr1B6r7Wdh7g4B0m3xD6F6Dl
	VC6k0HO0OAHAunZkxo4EYaRmBJrPvWB8Lgipu8aDaJ1/z1dhfF1osSpSKS6/MKYbY14OGQwlcbJ
	VmoXanBWpsaokV1ITfc34uedPLJ8sZA0l9lxXI2JvHXVlqHhSgPS9YMErwbEUGjPohr1+eW9N/C
	gCqa94nu5Ui/7Gm4sG26PbsII9VqbBhNyEimSDfCA+Y5SOHAm2DZ6fePrzrw7lqhSZrtitrjIyz
	U4u+fY9/cCjn0B1vuC8tKx47bNUaHKf4U4GhtWEkokzMnarFpU5prfb6LQdrDWVnFYCKSzPmkCv
	gULtulpqz5hL1EU5QIDIeY49pU2UK/U7+jXkAF67cHnffSbbshknUV9JD6/6vkcfmbnHnABaglt
	cU/n2Db/wEDfAkMb5AzI3SugC4OiJsFyxTV5Ey7cJmspX2FzstEw==
X-Google-Smtp-Source: AGHT+IFk8wLMtvnspL5X08nCOFuh4w793sCkSNYw871Bcc2rMNI5daxewGVPY4N9IKJlOxERKRgH1g==
X-Received: by 2002:a05:6402:280f:b0:64b:3e03:63b with SMTP id 4fb4d7f45d1cf-65097e8c00fmr14927123a12.31.1768246129525;
        Mon, 12 Jan 2026 11:28:49 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:49 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	ebiggers@kernel.org,
	elver@google.com,
	gregkh@linuxfoundation.org,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	mcgrof@kernel.org,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	tarasmadan@google.com,
	wentaoz5@illinois.edu
Subject: [PATCH v4 6/6] MAINTAINERS: add maintainer information for KFuzzTest
Date: Mon, 12 Jan 2026 20:28:27 +0100
Message-ID: <20260112192827.25989-7-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add myself as maintainer and Alexander Potapenko as reviewer for
KFuzzTest.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Acked-by: Alexander Potapenko <glider@google.com>

---
PR v4:
- Remove reference to the kfuzztest-bridge tool that has been removed
PR v3:
- Update MAINTAINERS to reflect the correct location of kfuzztest-bridge
  under tools/testing as pointed out by SeongJae Park.
---
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dcfbd11efef..0119816d038d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13641,6 +13641,13 @@ F:	include/linux/kfifo.h
 F:	lib/kfifo.c
 F:	samples/kfifo/
 
+KFUZZTEST
+M:  Ethan Graham <ethan.w.s.graham@gmail.com>
+R:  Alexander Potapenko <glider@google.com>
+F:  include/linux/kfuzztest.h
+F:  lib/kfuzztest/
+F:  Documentation/dev-tools/kfuzztest.rst
+
 KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
 M:	Daniel Thompson <danielt@kernel.org>
-- 
2.51.0

