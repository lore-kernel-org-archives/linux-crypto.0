Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844CACF
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:13:06 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2a-0006OU-5i; Sun, 10 Dec 2023 23:12:48 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2S-00ExXo-CA; Sun, 10 Dec 2023 23:12:40 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2S-000RVl-1s; Sun, 10 Dec 2023 23:12:40 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Rob Herring <robh@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de,
	Hadar Gat <hadar.gat@arm.com>,
	=?utf-8?q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Martin Kaiser <martin@kaiser.cx>,
	Avi Fishman <avifishman70@gmail.com>,
	Tomer Maimon <tmaimon77@gmail.com>,
	Tali Perry <tali.perry1@gmail.com>,
	Patrick Venture <venture@google.com>,
	Nancy Yuen <yuenn@google.com>,
	Benjamin Fair <benjaminfair@google.com>,
	openbmc@lists.ozlabs.org,
	Deepak Saxena <dsaxena@plexity.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	Yangtao Li <frank.li@vivo.com>,
	Yu Zhe <yuzhe@nfschina.com>,
	Alexandru Ardelean <alex@shruggie.ro>,
	Andrei Coardos <aboutphysycs@gmail.com>
Subject: [PATCH 00/12] hwrng: Convert to platform remove callback returning 
Date: Sun, 10 Dec 2023 23:12:15 +0100
Message-ID: <cover.1702245873.git.u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2074; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=aN2uTP9pET0YKd8ErrSoTK5vjrK84yOnSnlqPftwp5U=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBldje/IGRTw6Qp6aopoOZNEu5aabfn86EmYir5f 1EWoJBaSb6JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZXY3vwAKCRCPgPtYfRL+ TiWpB/0QkgCxo9rWPPZuG0mV+7+gEk/GZc38dQ5EFWJhV8Stqce7VjU2EH4481MoRPnL/0AXAPH XiiR4C7gz2B/1olwgpo6lWRPxtxXYx6Sd3+aWvOsfgqAW/q4OjcKyEk3xg48rrbtLvf1xoWFo7y 0fw9lVR0RmrbvnjwaTKkcDngwN7dAD8Qflw7z7gflMyrKN0MFgRgzwvvbuD5RqWmP2ZVOJM4GRh 0k+qapzlIcA2ElXaxL07bXhanFkd0Mdw38vbHTh4dy8RCryXCfaxbiWkCskcDwfQzZ0FlwQLcQS Fb2Sj2N3HmsMlw8S8d8sC9OF1ybvnjz5+54B3FySEScCa9Gv
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org

Hello,

this series converts all hwrng platform drivers to use .remove_new.
See commit 5c5a7680e67b ("platform: Provide a remove callback that
returns no value") for details and the eventual goal.

All driver conversions are trivial as all their remove callbacks return
0 (as good drivers should do).

All patches are pairwise independant. These patches should go in via the
usual hwrng tree. It's merge window material.

Best regards
Uwe

Uwe Kleine-König (12):
  hwrng: atmel - Convert to platform remove callback returning void
  hwrng: cctrng - Convert to platform remove callback returning void
  hwrng: exynos - Convert to platform remove callback returning void
  hwrng: ingenic - Convert to platform remove callback returning void
  hwrng: ks-sa - Convert to platform remove callback returning void
  hwrng: mxc - Convert to platform remove callback returning void
  hwrng: n2 - Convert to platform remove callback returning void
  hwrng: npcm - Convert to platform remove callback returning void
  hwrng: omap - Convert to platform remove callback returning void
  hwrng: stm32 - Convert to platform remove callback returning void
  hwrng: timeriomem - Convert to platform remove callback returning void
  hwrng: xgene - Convert to platform remove callback returning void

 drivers/char/hw_random/atmel-rng.c      | 6 ++----
 drivers/char/hw_random/cctrng.c         | 6 ++----
 drivers/char/hw_random/exynos-trng.c    | 6 ++----
 drivers/char/hw_random/ingenic-rng.c    | 6 ++----
 drivers/char/hw_random/ks-sa-rng.c      | 6 ++----
 drivers/char/hw_random/mxc-rnga.c       | 6 ++----
 drivers/char/hw_random/n2-drv.c         | 6 ++----
 drivers/char/hw_random/npcm-rng.c       | 6 ++----
 drivers/char/hw_random/omap-rng.c       | 6 ++----
 drivers/char/hw_random/stm32-rng.c      | 6 ++----
 drivers/char/hw_random/timeriomem-rng.c | 6 ++----
 drivers/char/hw_random/xgene-rng.c      | 6 ++----
 12 files changed, 24 insertions(+), 48 deletions(-)


base-commit: bc63de6e6ba0b16652c5fb4b9c9916b9e7ca1f23
-- 
2.42.0

