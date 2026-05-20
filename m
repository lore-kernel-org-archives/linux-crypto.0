Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B3D31BCAE
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 07:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779260577; cv=none; b=I9DAsSzp8ogoOKknW/n+yMKNaOvLO93Wwvxje6po8zExG7fxD1pTV2H7JCh1G+R1c8NdqxVbdF4Rk6R599JwkBFmFspnbMzbyIuQcttv+t6ieKCJ/9ARjUOKzIGtn3a1AbV/NzYF0aW4ERAqcLlUsiUlOVjHirQ9B8HRLqHi3x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779260577; c=relaxed/simple;
	bh=36HTJ+Yl/kWMfQ13i2EP4iI2ISH36vpOiRQioi971/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Qjc6EjvE4Gr5hmWgRxP8hBPguxKrShcRiVGRPgy/OgOIdO5e1pegt621VijtfUz/Sht+uIt/e7NhZRLCsbsf0uBL5rWjQ/huQbmfGvYHVFsHD6lSaUWIUJdikL6+dVxkby/t1RFB/lViyP0QM5jtWxGMQTG8c3JzZ2uWIPt6Spg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=pIylqjFA; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="pIylqjFA"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48d146705b4so49240535e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 00:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1779260574; x=1779865374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wDToPvSvnd0hOAWoBXV44G9Ve2Dn+V6xBsAOZi0rbvw=;
        b=pIylqjFAg9GLrbcmwNonpEwFdXlkcFdg5hYLrwMxd7WKFaCNxrOW3wtGcT99utm9kf
         /oP8MO+PKeZTskZmiYkonmock8C1H5/64NbzEaZ+e0PWDZLbWQjJhGGxLXO1u0oJXs9H
         +yePMcWjyF3sn1iS5FCkoytwjYUn/+SXAOfaVT3Gv+70RIc+OcGyq2R1HJ1eXYTE7c78
         ydZbDTgloTFQc0jUb9sdJQuJBTC7STQNC47OWCcEfFVrRAEoQHf5Tb9VbnxGed7njWhd
         n/gUe0VFtUUmHf1N1ElxRxX1Txz2NRPBREMl35Ue8CRXUkonQFpmhLqxYKCkiyD8ABYi
         ogFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779260574; x=1779865374;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wDToPvSvnd0hOAWoBXV44G9Ve2Dn+V6xBsAOZi0rbvw=;
        b=JcGMYn4/qKj1kBe2d/iMyT31QwX2Lj4Jgje+PxNtM9ERX64wEcFUOHyoha827Zbp0z
         obd1MLcFZgXvUCLwB6UlKsE09aZCFqHGer3T2gRJ1GIMx+ETJSfQnIipKCtvXimms7A/
         VrNnHw6WjjaY7sreoROx0CzlRJOU3KSvmNNJRbtGdz2/GmLSfDjvzHk+ElyAJ/kvUiFU
         n0y1CJhQQps8nPiaxwfLs5WIvrWjxN+C4+kMhhYfZOcxcVZAEtNsFk1XHpCAKd3RL1ai
         nEGPaVMhakuVCRxie/z5PCGyzLW4pKG1pLGA5S5/yxfHwlmEYWlrXr3yDagoDVTS9++O
         ei/Q==
X-Forwarded-Encrypted: i=1; AFNElJ8BFroLYBex8lorb4CA9UojGU3hCXTTZBNqywjAaSsz9r4ijS0zTzQrT3IF1ohiQTjHSHO/SNwBZqDokSc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6dn1MBnKnm/NSDQPSSbBzIaKzbFm22xAcZA0p7GMxzFF9TqbK
	wTeLkT54yZufkF1jDM90gbWI0LxezaeTrOQCPSj8cfqBaHnbYIfE3nDO5V3csK7WjAU=
X-Gm-Gg: Acq92OFFxc8HD7kJYcQTfwHUB/pCRYA04vT1nXeGHePnU2SyoRZdkH3Sz84xUGdXHJa
	5MxXW78JBN+/uT1z8T8i7/S2lHD9FSooixBc6kQih7NdZf92VIeURggcoAXyWPT8TBdesB0BnOI
	bCTTATJ97KJYhv/IS4IfdmRahM4SiWAISIwV5fN+pscUsLeUNilLxRiomncMw79aGURWcBVQKQ5
	togDmiEAGURB8hi2YGP1YhSOyWWgrAizogWQjeCwWnE3nU6DkZT9XRdTPNH52iDh/UApuLcr+aB
	zwKDgKMXHjhiBWPEmIndNGp/aN2FMEmDlaT07TD3XeEJeEJ2UqBqZLVMCgjs8O9JtgfXKjlxoW8
	oVWg0ZJE5HL78pfGh23lYITrHIm4K7orNGkK2eMPxP5OzHqYuWvFcvYSQjeR08iiG67c5Rx/lix
	/md68r/IBPywzplznvNBTef6CJ2+L41Kiq51hlQ4ZTth980o6WcExLr86Koa1zJGv4w/bdVPrkT
	WGAz0VxnJSTr5LBJHOvgohOKw==
X-Received: by 2002:a05:600c:848c:b0:488:b749:8482 with SMTP id 5b1f17b1804b1-48fe60e52c1mr365839715e9.4.1779260573689;
        Wed, 20 May 2026 00:02:53 -0700 (PDT)
Received: from localhost (p200300f65f47db04a02ef40d8e5825ac.dip0.t-ipconnect.de. [2003:f6:5f47:db04:a02e:f40d:8e58:25ac])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48febe78aadsm121262465e9.29.2026.05.20.00.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 00:02:53 -0700 (PDT)
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
Subject: [PATCH v2 0/3] crypto - Rework i2c_device_id initialisation
Date: Wed, 20 May 2026 09:01:27 +0200
Message-ID: <cover.1779260113.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=856; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=36HTJ+Yl/kWMfQ13i2EP4iI2ISH36vpOiRQioi971/Q=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqDVxINn+09H7tvGa2IENrimiiZK6z9nUp0LF2a ui3HrhiNfiJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCag1cSAAKCRCPgPtYfRL+ TngLB/oCdm/hMY9CPFgh2iunOdii1+4bzUaQGyuy7tT/STWiwaCsvhatl9X12zVBrjWo0nmglwb xjbC3UCo4YbXB6cdWMUnPMRFoIEEAjsQrO+YwLb5b8HOfkfLAHFx62tho1mOlPpnsBBUOeMW6rI S1EahTFgIA1h84OqhQqAEwID7LgEqQq5vaH70QRKKQfj0qDzaq9o8zJF9VyujlJhU0GRE6Y2R+9 3PNvvcgj3cWEecWMUAwK/BTaxhiA5TSEW0AffcAvIr4SN7jV22js8m5m0inGz3imGkNq3n86Rj5 aq5gOwGlC/vO3TRpXnhppxwuZ9hJOp1v/Dtk7KgF0wAbjxSd
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Hello,

this is v2 of the patch available at
https://lore.kernel.org/linux-crypto/20260519141033.1586036-2-u.kleine-koenig@baylibre.com.

Changes since v1 are:

 - Rebase to next-20260519 to account for changes since v7.1-rc1 (= the
   previous base)
 - Patch #1 is new
 - The adaption to atmel-sha204a is a bit less trivial, so split into a
   separate patch (#2)

Best regards
Uwe

Uwe Kleine-König (The Capable Hub) (3):
  crypto: atmel-sha204a - Drop of_device_id data
  crypto: atmel-sha204a - Use named initializers for struct
    i2c_device_id
  crypto: atmel-ecc - Use named initializers for struct i2c_device_id

 drivers/crypto/atmel-ecc.c     | 4 ++--
 drivers/crypto/atmel-sha204a.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)


base-commit: 6a50ba100ace43f43c87384367eb2d2605fcc16c
-- 
2.47.3

