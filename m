Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210F8364E98
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 07:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779260579; cv=none; b=ZuARmO0DXzFw1idmshiyErcdQ+k/5QEEUYb8muBSOB4NZN+HJaQVdIqblHXEsgu9omg0gbq1+ABI6K2dcz5UvR6CKnfI63pD5g8RVdjnBnsfBjJLyz+I9ls3lwNCnKzH88ca4pEdMODuyTr+lvQY5NTGuWBndOQ+OodIYA+1WjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779260579; c=relaxed/simple;
	bh=vsTr2WXJVlF73qf4sZw8bIYO7/nU9FyhgZ3DQYFToF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t5yyqAlqhkHxE9pIZ+V4nLbg+yhdr9na2Um/4fdNbHtU88PxwFKBU99X+/MTlQlx0S5SyUfpi0uZYqbY2lTpzeDiRaG7+Hxwn9aIeNu+JSBeyHj1Dhow3x9fJAqyseZRqH0yvz5bwWINcgHvy+Uzw8DUnqdss0TBvp3xWvg8WmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=ogWGdbPm; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="ogWGdbPm"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48a7fe4f40bso53943615e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 00:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1779260576; x=1779865376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nBwDHSWyPjF9labkr88yZlgFOaG+Rkrr8b9gOHE4eqM=;
        b=ogWGdbPmEA9riYijMkkytabvbyLc1O4GfVnLrchA7yv4vveQPnZh9sF1IgQSleAduW
         nBpmYcPSkmA0C6Yfp/qK1IKGVaZ97qnhkg6oNJUAIAlPnoWepuDDqvkwq6HudkAOkSI7
         qOt5oUvhbm7tuccxMJlTYOhqMBI4zyhYgrv6Xwq5d8hSgNYSQ8axKDt/vDILUoo+5w/8
         dfA3x5fKikEL8tHkjzJ0CrXg9JJhpgOsb/WYZj/Y6rsx7l3dEllGd3X+AzRZWwgaaVP0
         XR3CRg1Kf94d+sqSyiPpJH7vY+tIIK7oFPfu7WnrKvTqWOO3ivxX/z+pvg4eJ+5cfpXg
         09Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779260576; x=1779865376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nBwDHSWyPjF9labkr88yZlgFOaG+Rkrr8b9gOHE4eqM=;
        b=lYpCs0OfWeedifJaAPt6K0EXvOrDhg3BLhHS3Wo1xPohtBE4mNSrf+34STibn3qprz
         EUB5F9zQA3jrBuLY+FBzqEqB8qTRP75Snbw6Co2LDFTl1bYHYPs9QqpQI73W92ePX5UO
         8YPRC4+R2RAXHLUbo9kuz5VCZ+zAs8jUq1pgUZ2hQ08QZb4MagZMeE2pBr8AvxGoi0ll
         EjXOtoSTX4T+sQHlFupTI3nRbgO8rTzvoE3k8Y/GT2ktdpwRbRMKNM1AocSLFnHjd3ge
         l1ceESvmXkbIs7BngQQvn8rFmJr3eTiPPj/2y3bRDXnRg5a9bIIwMe4QEFXa9ioVf6VA
         F2Qg==
X-Forwarded-Encrypted: i=1; AFNElJ97n3IQW29L5q9BtRCrlKFsB4HLjJujGDd7gHK5uIZ0aT8vKUUiHOm9CR9MBoXFYNUKaTXFsEG/32WZpZ0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7IQKc6CYWODFFhXnBv0prALQvx//oLb2eSYT+R4fKQ+zWOeCc
	GC6PFc+s8/wQy+FBlESYjEZ5dgm2uK35sDeWvQa+UJwtlPUrjLigBSEFY9xTkOlFtRU=
X-Gm-Gg: Acq92OEJObH8p9wsVf0U/Cm6K866d1VPlv/UtIljOflYXvsZaNx3ROvK9XFUgtB9qGY
	SjuaBrjOEhki+Ub7rYDKLB2EtGiXg+fIcRr3CDl+xEp1Ug7UXss+PU5NTBj7TIvcFCtmsMb8Hbt
	IOU9UkpC1UM5zOwtVHC0kmRKt1d03HAJClJb9JcWHcby3o1c15muq2KsZ4/yYrDKIK0Vrhy4Akd
	+ak7+M36kK1GAFQ2swb1nSCr4iQ0X7ioRWWXSp0BVxDX6Jr37gyHEJfXPcvvzIT6H/hg+IHvXjx
	yjB7puDBtferzhsUbCZ/1FEQalVaoICuNlylaR/bmlArx0Ifil3tHMNGnjO0Stu/9x847LNDkED
	FxOinCD5oN2+b/fjL9Vd5PFpvgAr4W6ntXK/KWj7k1TJNCZk4m4hmj1Fsu/H9TteoTLep5D2kNr
	nD4tKInRjbt3ZG97RQJwIKcomY+NLSYrJ0xptSkJz/LJyTU2IeY+KNSZv0AMuNLfT4d3lt7KRRv
	cwv1I8OOEYYUYs=
X-Received: by 2002:a05:600c:821b:b0:488:b811:51c4 with SMTP id 5b1f17b1804b1-48fe6515831mr334398165e9.25.1779260576342;
        Wed, 20 May 2026 00:02:56 -0700 (PDT)
Received: from localhost (p200300f65f47db04a02ef40d8e5825ac.dip0.t-ipconnect.de. [2003:f6:5f47:db04:a02e:f40d:8e58:25ac])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48fe537c788sm357422625e9.12.2026.05.20.00.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 00:02:55 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] crypto: atmel-sha204a - Use named initializers for struct i2c_device_id
Date: Wed, 20 May 2026 09:01:29 +0200
Message-ID:  <d97be8401911ad6de62170b8e9c98364ac65f0f7.1779260113.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1779260113.git.u.kleine-koenig@baylibre.com>
References: <cover.1779260113.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1400; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=vsTr2WXJVlF73qf4sZw8bIYO7/nU9FyhgZ3DQYFToF4=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqDVxNCjnxtb1/VxjbdwdnMLQ5HrtoX6QFPNJK3 XQNulk3uOyJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCag1cTQAKCRCPgPtYfRL+ TiN1B/4zsqo/nDBD9Lh5++k0ejsMpNKssANOQ0g9bQiA7dVE1kFbKttj/Fl2jD9o2vtXGhbls1y IAsMc2+PJcKgfzvWhNxsgha5XHIMy8G7Gfd94Gkv6p2ajzYkEh2/VHEd/h9ATkTHGl6N9v1hfqi cIbWe1f9R7d5pk0slrlt/BrQ+h1fqz+F1RLznP5LZu+HUMOkINcB0w+T5CBQMjq19dYcLDZHPP8 UP853poez/ELoMzR2Veoc5XEnW6abWzr1STuvUWsvdL8qd9TyHQY3dqoVfLs1GMzaKtZwQQbW6F 46BQjcbwIzN0UTMx/cpAqYMBd/fpAO4oiHb92pcX5F1Xdnrl
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

While being less compact, using named initializers allows to more easily
see which members of the structs are assigned which value without having
to lookup the declaration of the struct. And it's also more robust
against changes to the struct definition.

This patch doesn't modify the compiled array, only its representation in
source form benefits. The former was confirmed with x86 and arm64
builds.

For consistency also assign .driver_data for the array item that the
driver relies on i2c_get_match_data() returning NULL for.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/crypto/atmel-sha204a.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index f17e1f6af1a3..f3bbe836778d 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -215,8 +215,8 @@ static const struct of_device_id atmel_sha204a_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
 
 static const struct i2c_device_id atmel_sha204a_id[] = {
-	{ "atsha204", (kernel_ulong_t)&atsha204_quality },
-	{ "atsha204a" },
+	{ .name = "atsha204", .driver_data = (kernel_ulong_t)&atsha204_quality },
+	{ .name = "atsha204a", .driver_data = (kernel_ulong_t)NULL },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_sha204a_id);
-- 
2.47.3

