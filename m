Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63BD39D3EC
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 16:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783616386; cv=none; b=n3Wd6slMqDVqasgd6CKPvN51ql7HeEHmSI+7Ylf1WYKdvUid+ZoleSS+2XqfSlxfeKGn2UtrUUDdMIgQTgw/z2VwIg9TXVW5110YMobpzcW12s2j3dqYJoQoiCJIg2ahLCAG82tdFgteMDZoGKF7E9OKukb/pQgRM3WB7vIzH3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783616386; c=relaxed/simple;
	bh=x7I7jx1xlGkYcQ0g2wKbDdhKkfSw89TrgshWMQXyV+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=q/lq7BSwOljNYT9a8EzTSznY2kbVfLeB2vN6H0BrXwufjh0DLcg8N14LHS/DiOW6skXh08cw0vYCgMO7tBg1WjIrQs6f0k0WIYJDvDywS4LYP1XTibq7Pn0BhZZ8+nH3/Kg5/TouBpGJNd0/zaDVcvwouAo7gJtPtfeKjyI+J2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=Z+h9yZDZ; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="Z+h9yZDZ"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47122683cf3so80898f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2026 09:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1783616382; x=1784221182; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VJDhVAwwnuJynU+rK7XaHmDAD2JyG8RU5Caf9YS1vZM=;
        b=Z+h9yZDZovU+bnsnMg7Z4tTL2FNt+50VBqnoncNPA1puksfAUX/e/kwqMSMBFHGAFm
         94UiPPccms1SbiyBT+FnrtoVVF7DMu963NG3IdGZukyo8jjW46bJMMjl1p08SGFfC2yK
         aMBEd7/cBVbMYFUwLuo0W9+42IZdR3bL4oRvFWhfgsDw6llnVeq/WT4T4lVrFv8SygAW
         HPpx8M2MGug855od/yCptKEP+63qhHvn/IXwy7mfgpFaOE9rsh9Ou2k6bcykx+WUl0Gc
         ddfI0dBfI69BsyQOBOsE2qEQDGorSPWbkVt64mEWKPuHo0niR2sU0JsGuvo28PNuTVEn
         nBmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783616382; x=1784221182;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VJDhVAwwnuJynU+rK7XaHmDAD2JyG8RU5Caf9YS1vZM=;
        b=TqzLXK6X1s2uLdK5sGMpyjG6X+pMyUuvqZggyroA5h9d4PORozonhJntKgAKZoiwWG
         jsDZCmRD+mJAw3Ji+CvJJCoCsG3cuz5OntMdg0OGkEryquKoMn8xd95gmo/Fj7jQmBEm
         aDFxCitpEEStvWqzkJ+OF4zi+HWhc7TU60fs327d2ujT0ywi/O3yHgsbdAA75XzKuxxq
         YO+npqSfFP8riuwJUfEi3wZuD7zfi0csYGZ7p2JtEH6U09oN9Fcau9c++j5cKJ1AfOVW
         7Mit/DC3vX0IV8wdXrKFolq5fRDxGOZX5QK7xvZSQpIhspL68Y59FDrXRoj93+8VQpOg
         DpWg==
X-Forwarded-Encrypted: i=1; AHgh+RoeD5IZLXJSsHaGOTe3wnvdFXypImjMOwjbSBnL02wk060DbZMh4RL3bh52lgLMYaAJHmjLNdxXTA+vXTE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEqwosvVdDo3li/AjfSxcewk1h1ZLmKd6pB2+PdZ5vt2IOKujR
	mXItuRmRyOsetWMtGpnEJmkHHUB0HiFEV+COMeJIwKzd3KzkaVUL/qAvwfRRyjZrgIc=
X-Gm-Gg: AfdE7ck6udKhoFwprmeIJ5Av8TKgL7QDJzOAWtFEquFxnqyDmoFv3l7ExCTLrgzkWQW
	XYghUX06L9LEu9Wit9lSRhZV5hHF+4UWmQcFnD/QT0X3xN7SZmwtScInVQ2JfvdEPLUp90ewusw
	kBHZdmk7f6dDS98Op8E84pJwy4lbgopIxDHWpoe0arOcWu2n7ZvW9wUHf1YpaKwR3kJcxrY7L19
	U5Bwi5hXUvwbIgu919hZTZazhNJLnHpmCKUVXve3jbXRFeWRIpOu8lGtkvtsGttorbOplRXBvVx
	/ZOJ9LKnL2Phkr+P1rNWxTQRmaF9kHMVpp/Ew3L1q3BQyao0ERBusZylo5h8B3IzgrEtHfinemk
	ZgF9CYnSTJmn/M4hlsD/jOu68s8R0q1XBKgqM3LZd4hUC1gUxG5WzdZx0NysA6NJqCoFK/nPC8f
	2qEnKHA/tr9ilBLASOMc9kzaubnjJ7MB9rd26Yz+x+bdI3ioi7VJbqG4kmlP7WX9cu6nZ+snbfm
	3nP
X-Received: by 2002:a05:6000:41fe:b0:47d:efd0:c026 with SMTP id ffacd0b85a97d-47df071e085mr8532732f8f.11.1783616382067;
        Thu, 09 Jul 2026 09:59:42 -0700 (PDT)
Received: from localhost (p200300f65f47db043de98c19b374aa68.dip0.t-ipconnect.de. [2003:f6:5f47:db04:3de9:8c19:b374:aa68])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-47aa039b0cesm53752742f8f.22.2026.07.09.09.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 09:59:41 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Lee Jones <lee@kernel.org>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	mfd@lists.linux.dev,
	linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-mediatek@lists.infradead.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	linux-crypto@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev,
	Colin Foster <colin.foster@in-advantage.com>,
	David Rhodes <david.rhodes@cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Zha Qipeng <qipeng.zha@intel.com>,
	Thomas Richard <thomas.richard@bootlin.com>,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com,
	Xu Yilun <yilun.xu@intel.com>,
	Tom Rix <trix@redhat.com>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Marek Vasut <marek.vasut+renesas@gmail.com>,
	James Ogletree <jogletre@opensource.cirrus.com>,
	Fred Treven <fred.treven@cirrus.com>,
	Ben Bright <ben.bright@cirrus.com>,
	Support Opensource <support.opensource@diasemi.com>,
	Andy Shevchenko <andy@kernel.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	=?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>,
	Roger Quadros <rogerq@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Samuel Kayode <samkay014@gmail.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-renesas-soc@vger.kernel.org,
	linux-omap@vger.kernel.org,
	imx@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	Linus Walleij <linusw@kernel.org>,
	linux@ew.tq-group.com,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Peter Griffin <peter.griffin@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Tim Harvey <tharvey@gateworks.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sven Peter <sven@kernel.org>,
	Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>,
	Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Saravanan Sekar <sravanhome@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	=?utf-8?q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Orson Zhai <orsonzhai@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Magnus Damm <magnus.damm@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-samsung-soc@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	asahi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linux-rockchip@lists.infradead.org,
	Peter Tyser <ptyser@xes-inc.com>
Subject: [PATCH v3 00/23] mfd: Use named initializers for arrays of *_device_data
Date: Thu,  9 Jul 2026 18:58:19 +0200
Message-ID: <cover.1783615311.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.55.0.11.g153666a7d9bb
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=10849; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=x7I7jx1xlGkYcQ0g2wKbDdhKkfSw89TrgshWMQXyV+I=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqT9Mwgnh31BxHKY/FZjAXkPNmcm0bzYeRgOl6T cuiTlTVXeCJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCak/TMAAKCRCPgPtYfRL+ TjY5B/4trUacM2VOnrdO7ml6L9pBXtZl5zaoNd5/YBFCQiq3bOhzl8d7o4FccdkGs2bFKjHkS4v Z6nqRY6Y5LACAyYQ1lTm6yna4lBkYMK+YNhz7N0wZfXi/wcumQ3qB1NUXcIqrOtVsoWzRjwIVq5 tkwaeRbvvdVgPa9JyKz68aUBkfo78fyZ778y+VJIvkbupkEfBcnfDIGtUaNg3533ZsMq8uHK516 LXGdCz3u66d8ucj/6SA+/se0nKD9+UCjj+SkVZnqkUOKZVXh+Ntr1ZeP+SKzz1RbE/MhXrQh9Ku YordR+qBAJ+oKLXaovmVD5vvRlMmuiNqGroU1DqPj32i9taA
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Hello,

v2 of this series can be found at
https://lore.kernel.org/lkml/cover.1783507945.git.u.kleine-koenig@baylibre.com
.

The objective for this series is to prepare mfd for changing
of_device_id and the others to make driver_data a union, see
https://lore.kernel.org/all/cover.1780048925.git.u.kleine-koenig@baylibre.com/
for the idea behind it.

Changes since v2:
 - Added the various review tags I received;
 - Sashiko found an issue in patch #3 ("mfd: kempld: Simplify device
   abstraction"). The concern was valid and that made me realize that I
   could simplify that driver even further;
 - For drivers/mfd/rsmu_i2c.c I did a wrong split. In the middle of the
   series the i2c_device_id array lacked the terminator. (Noticed by
   Sashiko);
 - The of_device_id changes were done by hand for v2, I created a script
   for that now and catched a few more issues (pointed out by Sashiko);
 - trivially rebased to next-20260708, no changes introduced by that;

Sashiko identifyed a bunch of preexisting issues, that I didn't address.
These are better handled by someone having the hardware I guess.

Andy suggested splitting patch #18 ("mfd: Unify style of acpi_device_id
arrays") into one for the pmic drivers and then one per driver. I didn't
do that as it seems arbitrary to me. Lee, please voice your preference
if you disagree with the patch separation here.

Best regards
Uwe

Uwe Kleine-König (The Capable Hub) (23):
  mfd: bcm2835-pm: Remove member of struct bcm2835_pm that is only used
    locally
  mfd: bcm2835-pm: Drop unused header
  mfd: kempld: Simplify device abstraction
  mfd: lp87565: Explicitly set driver data for the generic dt compatible
  mfd: mt6360: Drop irrelevant __maybe_unused
  mfd: rt4831: Drop irrelevant __maybe_unused
  mfd: loongson-se: Drop unused assignment of acpi_device_id driver data
  mfd: Drop unused assignment of i2c_device_id driver data
  mfd: Drop unused assignment of platform_device_id driver data
  mfd: Drop unused assignment of spi_device_id driver data
  mfd: Use named initializers for acpi_device_id arrays
  mfd: intel-m10-bmc-pmci: Use named initializers for dfl_device_id
    array
  mfd: Use named initializers for arrays of i2c_device_id
  mfd: twl6030: Use named initializers for of_device_id
  mfd: Use PCI_DEVICE* macros to initialize pci_device_id arrays
  mfd: Use named initializers for platform_device_id array
  mfd: Use named initializers for arrays of spi_device_id
  mfd: Unify style of acpi_device_id arrays
  mfd: Unify style of dmi_system_id arrays
  mfd: Unify style of i2c_device_id arrays
  mfd: Unify style of of_device_id arrays
  mfd: Unify style of pci_device_id arrays
  mfd: Unify style of spi_device_id arrays

 drivers/mfd/88pm800.c                 |  4 +-
 drivers/mfd/88pm805.c                 |  4 +-
 drivers/mfd/88pm860x-core.c           |  8 +--
 drivers/mfd/aat2870-core.c            |  2 +-
 drivers/mfd/ab8500-core.c             |  8 +--
 drivers/mfd/ab8500-sysctrl.c          |  4 +-
 drivers/mfd/ac100.c                   |  2 +-
 drivers/mfd/act8945a.c                |  8 +--
 drivers/mfd/adp5520.c                 |  4 +-
 drivers/mfd/altera-a10sr.c            |  4 +-
 drivers/mfd/altera-sysmgr.c           |  2 +-
 drivers/mfd/arizona-i2c.c             | 14 +++---
 drivers/mfd/arizona-spi.c             | 14 +++---
 drivers/mfd/as3711.c                  |  8 +--
 drivers/mfd/as3722.c                  |  8 +--
 drivers/mfd/atmel-hlcdc.c             |  2 +-
 drivers/mfd/atmel-smc.c               |  2 +-
 drivers/mfd/axp20x-i2c.c              | 26 +++++-----
 drivers/mfd/axp20x-rsb.c              |  2 +-
 drivers/mfd/bcm2835-pm.c              | 15 ++++--
 drivers/mfd/bcm590xx.c                |  4 +-
 drivers/mfd/bd9571mwv.c               |  6 +--
 drivers/mfd/bq257xx.c                 |  8 +--
 drivers/mfd/cgbc-core.c               |  2 +-
 drivers/mfd/cros_ec_dev.c             |  2 +-
 drivers/mfd/cs40l50-i2c.c             |  6 +--
 drivers/mfd/cs40l50-spi.c             |  6 +--
 drivers/mfd/cs42l43-i2c.c             |  8 +--
 drivers/mfd/cs5535-mfd.c              |  2 +-
 drivers/mfd/da903x.c                  |  6 +--
 drivers/mfd/da9052-i2c.c              | 12 ++---
 drivers/mfd/da9052-spi.c              | 12 ++---
 drivers/mfd/da9055-i2c.c              |  4 +-
 drivers/mfd/da9062-core.c             |  4 +-
 drivers/mfd/da9063-i2c.c              | 11 +++--
 drivers/mfd/da9150-core.c             |  4 +-
 drivers/mfd/db8500-prcmu.c            |  4 +-
 drivers/mfd/exynos-lpass.c            |  2 +-
 drivers/mfd/gateworks-gsc.c           |  2 +-
 drivers/mfd/hi6421-pmic-core.c        |  6 +--
 drivers/mfd/hi655x-pmic.c             |  4 +-
 drivers/mfd/intel-lpss-acpi.c         | 58 +++++++++++-----------
 drivers/mfd/intel-m10-bmc-pmci.c      |  2 +-
 drivers/mfd/intel-m10-bmc-spi.c       |  6 +--
 drivers/mfd/intel_pmc_bxt.c           |  2 +-
 drivers/mfd/intel_quark_i2c_gpio.c    |  6 +--
 drivers/mfd/intel_soc_pmic_bxtwc.c    |  2 +-
 drivers/mfd/intel_soc_pmic_chtdc_ti.c |  4 +-
 drivers/mfd/intel_soc_pmic_chtwc.c    |  2 +-
 drivers/mfd/intel_soc_pmic_crc.c      |  6 +--
 drivers/mfd/intel_soc_pmic_mrfld.c    |  4 +-
 drivers/mfd/ioc3.c                    |  4 +-
 drivers/mfd/janz-cmodio.c             | 14 +++---
 drivers/mfd/kempld-core.c             | 70 ++++++++-------------------
 drivers/mfd/khadas-mcu.c              |  4 +-
 drivers/mfd/lm3533-core.c             |  2 +-
 drivers/mfd/lochnagar-i2c.c           |  2 +-
 drivers/mfd/loongson-se.c             |  2 +-
 drivers/mfd/lp3943.c                  |  4 +-
 drivers/mfd/lp873x.c                  |  8 +--
 drivers/mfd/lp87565.c                 |  9 ++--
 drivers/mfd/lp8788.c                  |  2 +-
 drivers/mfd/lpc_ich.c                 |  2 +-
 drivers/mfd/macsmc.c                  |  2 +-
 drivers/mfd/madera-core.c             |  2 +-
 drivers/mfd/madera-i2c.c              | 18 +++----
 drivers/mfd/madera-spi.c              | 18 +++----
 drivers/mfd/max14577.c                |  6 +--
 drivers/mfd/max7360.c                 |  2 +-
 drivers/mfd/max77541.c                |  4 +-
 drivers/mfd/max77620.c                |  8 +--
 drivers/mfd/max77686.c                |  2 +-
 drivers/mfd/max77693.c                |  4 +-
 drivers/mfd/max77714.c                |  2 +-
 drivers/mfd/max77759.c                |  4 +-
 drivers/mfd/max77843.c                |  8 +--
 drivers/mfd/max8907.c                 |  6 +--
 drivers/mfd/max8925-i2c.c             |  6 +--
 drivers/mfd/max8997.c                 |  6 +--
 drivers/mfd/max8998.c                 |  6 +--
 drivers/mfd/mc13xxx-spi.c             |  6 +--
 drivers/mfd/menelaus.c                |  2 +-
 drivers/mfd/menf21bmc.c               |  2 +-
 drivers/mfd/motorola-cpcap.c          | 12 ++---
 drivers/mfd/mp2629.c                  |  2 +-
 drivers/mfd/mt6360-core.c             |  6 +--
 drivers/mfd/mt6370.c                  |  2 +-
 drivers/mfd/mt6397-core.c             |  4 +-
 drivers/mfd/mxs-lradc.c               |  4 +-
 drivers/mfd/ntxec.c                   |  4 +-
 drivers/mfd/ocelot-spi.c              |  2 +-
 drivers/mfd/omap-usb-host.c           |  4 +-
 drivers/mfd/palmas.c                  |  8 +--
 drivers/mfd/pf1550.c                  |  2 +-
 drivers/mfd/qcom-pm8008.c             |  4 +-
 drivers/mfd/qcom-pm8xxx.c             |  6 +--
 drivers/mfd/rave-sp.c                 |  4 +-
 drivers/mfd/rc5t583.c                 |  4 +-
 drivers/mfd/rdc321x-southbridge.c     |  2 +-
 drivers/mfd/retu-mfd.c                |  4 +-
 drivers/mfd/rk8xx-i2c.c               |  2 +-
 drivers/mfd/rk8xx-spi.c               |  4 +-
 drivers/mfd/rohm-bd71828.c            |  4 +-
 drivers/mfd/rohm-bd9576.c             |  6 +--
 drivers/mfd/rsmu_i2c.c                | 18 +++----
 drivers/mfd/rsmu_spi.c                | 14 +++---
 drivers/mfd/rt4831.c                  |  6 +--
 drivers/mfd/rt5033.c                  |  4 +-
 drivers/mfd/rt5120.c                  |  2 +-
 drivers/mfd/rz-mtu3.c                 |  2 +-
 drivers/mfd/sec-acpm.c                |  6 +--
 drivers/mfd/sec-i2c.c                 | 22 ++++-----
 drivers/mfd/si476x-i2c.c              |  8 +--
 drivers/mfd/simple-mfd-i2c.c          |  2 +-
 drivers/mfd/sky81452.c                |  4 +-
 drivers/mfd/sm501.c                   |  4 +-
 drivers/mfd/smpro-core.c              |  2 +-
 drivers/mfd/sprd-sc27xx-spi.c         |  4 +-
 drivers/mfd/ssbi.c                    |  2 +-
 drivers/mfd/stm32-lptimer.c           |  4 +-
 drivers/mfd/stm32-timers.c            |  4 +-
 drivers/mfd/stmfx.c                   |  4 +-
 drivers/mfd/stmpe-i2c.c               | 34 ++++++-------
 drivers/mfd/stmpe-spi.c               | 26 +++++-----
 drivers/mfd/stpmic1.c                 |  4 +-
 drivers/mfd/stw481x.c                 |  8 +--
 drivers/mfd/sun6i-prcm.c              |  2 +-
 drivers/mfd/tc3589x.c                 | 14 +++---
 drivers/mfd/ti-lmu.c                  | 10 ++--
 drivers/mfd/timberdale.c              |  2 +-
 drivers/mfd/tps6105x.c                |  6 +--
 drivers/mfd/tps65010.c                | 10 ++--
 drivers/mfd/tps6507x.c                |  6 +--
 drivers/mfd/tps65086.c                |  4 +-
 drivers/mfd/tps65090.c                |  6 +--
 drivers/mfd/tps65217.c                |  6 +--
 drivers/mfd/tps65218.c                |  8 +--
 drivers/mfd/tps65219.c                |  8 +--
 drivers/mfd/tps6586x.c                |  6 +--
 drivers/mfd/tps65910.c                | 12 ++---
 drivers/mfd/tps65912-i2c.c            |  4 +-
 drivers/mfd/tps65912-spi.c            |  4 +-
 drivers/mfd/tps6594-i2c.c             | 12 ++---
 drivers/mfd/tps6594-spi.c             | 12 ++---
 drivers/mfd/tqmx86.c                  |  2 +-
 drivers/mfd/twl-core.c                | 22 ++++-----
 drivers/mfd/twl4030-audio.c           |  4 +-
 drivers/mfd/twl4030-power.c           |  2 +-
 drivers/mfd/twl6030-irq.c             |  6 +--
 drivers/mfd/twl6040.c                 |  4 +-
 drivers/mfd/upboard-fpga.c            |  6 +--
 drivers/mfd/vexpress-sysreg.c         |  4 +-
 drivers/mfd/vx855.c                   |  2 +-
 drivers/mfd/wm831x-core.c             |  2 +-
 drivers/mfd/wm831x-i2c.c              | 14 +++---
 drivers/mfd/wm831x-spi.c              | 16 +++---
 drivers/mfd/wm8350-i2c.c              |  6 +--
 drivers/mfd/wm8400-core.c             |  4 +-
 drivers/mfd/wm8994-core.c             |  8 +--
 include/linux/mfd/bcm2835-pm.h        |  9 ----
 include/linux/mfd/kempld.h            | 12 -----
 161 files changed, 536 insertions(+), 578 deletions(-)


base-commit: b9810cd75b9fb56a3425d391cba3f608502bd474
-- 
2.55.0.11.g153666a7d9bb

