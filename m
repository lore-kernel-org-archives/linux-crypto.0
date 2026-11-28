Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795898901;
	b=q5mSTg/msIy++tS5toGZp6pV+vCAodwUeX2Bb+fSW16Yoy8pD+Bcnj+j7JTPuT4SWy6i
	 yp+fS/5ap4S4XaLa3W+b+9+aeM7csVoPIkrMd0eR2k9puUGfiA8vaS/0y80KpYkn2ofC+
	 k7b+21iaAqo3BbfH2V21cJN8qPeoUYbmhWAak4mGA3X1Um/y4euko/YUWVge6WoqTmmWi
	 N1jpVYBCyuTgJ8C6pv7NNVM0WY2k28R8sbE+EyGEuBcMdfp7xjbF1b+tJibv41xSMdELP
	 MGv3m9XRMcvwAxBXw5YnRI5pBlRZ1rmPQTS7ehf4xH5kWzHmQM+SvFjedSqty5Yzixg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795898901;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Q47aRM2QNGqkFqQBA85EIO0RPyTAnys38T1MItbpufI=;
	b=JOsGGRfd5uenmUynulW8sNrmL3fJ1yAB2Wx1jX1JRLGprXwG5wVl/qfrQgEplkHMHIw2
	 FjoB9RQPyXdxH2IQJf6tmeGxxvrgQ5ACixB8Dbmp+yv4RtiIQKzAE0QOn9XeWy6nAO6vA
	 gODoy+XvUOFPMcGZkMTeMfc84rcGdAIPnT83aqPuVq2r0ARgEyecNfJ0quwg+OUTZeqeX
	 wT59j61DvFcR74m2kgzhCq/V6vpamtc0b2CV4oqNZqLYT7eiZYrbGF1d/rIzs6Sdib8ne
	 YazLJequyx1/F+fJpEIhVB5vfoTLdy8SKSgRDn1DqjQ4p5lv8Yn3hM6GxB36+YhCH0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=quiUjWOU;
	arc=none smtp.remote-ip=209.85.222.176
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D5B606A321
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 20:48:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1D5B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=quiUjWOU
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9495e8ae239so1012318685a.2
        for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 12:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795898900; x=1796503700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q47aRM2QNGqkFqQBA85EIO0RPyTAnys38T1MItbpufI=;
        b=quiUjWOUVEpSmnpb6MJH33eacZrC/M95sTRIi/t8X5wrjS4kmKsbybBxMvwS524LUC
         uw5cA697/kLpldtgIC3NUlq2A5oGFQibb5VhgUR1efgcZGMwzOQDocbF9NAKKY4HSAes
         Fz2mbRY7jTeEGWQ9yAA1WX2dGQ3WnFmUq61+IrZaO7wQPG7XOxbAyKpXo6x7ISTQz+qP
         LCOfHIZDkmzryudoPmIJnp2eMTYJB9o+LkXuy/GkLMmxSZd97SprQM4HiLywc15/Nuat
         ILpKgFV0eb1M2udkc51MQHYcHZxsgqaQkYngaoMtUswwhhB9u+6ZuJnEsGBEedET7HJL
         NdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795898900; x=1796503700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q47aRM2QNGqkFqQBA85EIO0RPyTAnys38T1MItbpufI=;
        b=s2b6wGRWsONX7YbFizXSt+HtpLgEHSodtQR/vN76e2KgVekiolew1qb3Pa+H4OC9aV
         vMCJp+dXjlWi9gdPcFCTDQQMG6AV3U2q3qNVlBh+K1dRVCa7HCAXeTSIXBv12Ybiii6n
         dAv5V8/3JybNyDIOh1teXcV45C18aHs++mfHXq5HtnB65D0SEZLAQ6nR1qGE9tyxkJVL
         wtENKfkMlrcIawNpmvumQ6qh/qqQRnevG0XTDdydNe4e5B5imKrI4c6yBasFliMQO/Ux
         7YgC0I7qE0twl3RYoWkGe2eHE65jxg7f8RuLDfKk0FoA1+wOH/jW4bfJabz2ij0BnFln
         mekw==
X-Forwarded-Encrypted: i=1; AL+hErH9EPdmoMQXWSxYUVF0a8gYw+kRZMpwHeBu//6OcvC4G7DjuvUdnF4Hxb6XLv7BxCjIwWJF8SZJ+BNpANY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9nFiSvsWHkJOdY5pwQEM9HtZy5FRJHUn0e5/05iM2ou1uQQBJ8
	b1+dcsPOp/ow0XBw+obib06VoKIRB3TawXqJ8pRF+8cimBH8MtpomKqz
X-Gm-Gg: AZFdTZc0fEKOgx20gvEP9Vih/iEXgPNjJhq9zpG7BXR7GwJVzCysB5J8DYxuoHmRzD7
	9O+ZsmVq0aXM4T0+3vHUpjE1qHon/TIcx01dc1e4JdxoMR8iEv9enF0Po4y7EeBV2rNE02Cf2f+
	zTnKxtPtdF+l1Rl8aI9ZgWSZnnumHMa3jWDXgMKwh7AEMfoU7lj0MNO2bbY6GIz0hYXIxQXBk2/
	cwWu+nhpg01uNYDluUdBzj4dbGXJexFHQDCDJnH75idJBt/yVjIhwvJDxF59jOAylAIRUjn1w4I
	0+L+FwQJhJ6UR7S3m1qgSiL70vivJStSqWnweI/IfUyyqkDoKGu60LngDeQGUn5BZ34Q1qg1Ews
	9WZxhMveh0B38AkDNuyEfxFUUWw2ZXWI5/zCNehd9FCwfr9pKX+6BgAFrqikL3MD13JK+Pqomlg
	GfPO8YnrouvNeT0KNwJzNXCfRFQw9bVe1vpKuGHTU0wYCCouIYpksm7as9AWSJARrD5OCVBkAA7
	EVxZEVdUD10KCMRxHRkV8y5+/+mLcNVmYYOTa5zEd95Oz1VXfLO6vFXmji6sS8YUDkUKlCt+ZiY
	NYMq29trf82oiU7Uq330I6R1rNEAo054MNckgVYp6B/oDs7NZEyhHihFchSUkMBVSSfn9cKOT3d
	FDGWduLBXv5NvjxK9mz6SoO+JdRGfnKoLxwOp
X-Received: by 2002:a05:620a:5411:20b0:94a:a39:6fb7 with SMTP id af79cd13be357-94a0a397806mr1734117685a.46.1795898899958;
        Sat, 28 Nov 2026 12:48:19 -0800 (PST)
Received: from BOOST-MACHINE.localdomain ([163.252.152.153])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb349db3sm2129739885a.7.2026.11.28.12.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 12:48:19 -0800 (PST)
From: Timur Kussainov <kusainov.timur@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Corentin Labbe <clabbe@baylibre.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Timur Kussainov <kusainov.timur@gmail.com>
Subject: [PATCH 0/2] crypto: rockchip - fix hash timeouts and debugfs leak
Date: Sat, 28 Nov 2026 15:47:43 -0500
Message-ID: <20261128204745.1044083-1-kusainov.timur@gmail.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On RK3288 (tested on an ASUS Tinker Board) all hardware hashes of the
rockchip crypto driver currently fail with "HASH idle timeout" and the
rk-md5/rk-sha1/rk-sha256 self-tests fail. Patch 1 fixes the inverted
completion poll that causes this.

Patch 2 fixes a debugfs directory leak with
CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG=n, which leads to an oops when the
stale stats file is read after the module is removed (found while
testing patch 1 by reloading the module).

Timur Kussainov (2):
  crypto: rockchip - fix inverted hash completion poll
  crypto: rockchip - fix debugfs leak when stats are disabled

 drivers/crypto/rockchip/rk3288_crypto.c       | 19 +++++++------------
 drivers/crypto/rockchip/rk3288_crypto_ahash.c |  2 +-
 2 files changed, 8 insertions(+), 13 deletions(-)

-- 
2.47.3

