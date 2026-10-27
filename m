Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793097375;
	b=nWoxorpunWg5lhVf36UkCT7K8EKe4qO8zGD0AP2ZXT1WvdExDc6BxP6DUrkqJkHFA52V
	 YP4GoskMmx3QusNWBbztCV1jguEiTN3K3sp08nhRynWovgnWmyb9X5p5wIl9VvYa/uegG
	 0L6DJ26OUMDmva6MxUk/7bgb6sRFSs/Wvwkaw5/9OLrD+ArwOhtXa4zo6K8HGv7NLFK50
	 N6A0mGOQPj8iNI607IkLIz18WlrnCB1VWckcqrdsPA0ZK5dXLUcFWmFf/WqG0OxcI4R7P
	 DC7o7AYsv1SvCC7CkQ8BkEmqOyLFGNHqE6N1jDYECkAwpS+iBlWeDCM91M/t5AqJOmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793097375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5EJSPUzg0whVepx7G/qDLZdM2wsz34VCNLXrTAyw3pI=;
	b=yFu5+A16UKR1rYavHkDxPgp5hR9pI4RjY+/xbZIRwAY6abfZbAl7xKzqnA8XIyHIo/d5
	 r4t8VO8reDD2su3KZ6gTsrhE4KNo1xYewSwfATzEE9qg6UXQeUDo4amR3p2YGbUYv5QnK
	 2LOT48bGCw0Egp4ZIjRmuuYzP3FFMldLGIH6qiCQfSNKA3uBJIY9S4zCXBEJKFhqCXFtz
	 6l4g6tNR5liRtbh6/EaHRKVfjFL+jeRG98P/2K7MWsAYZhCKLL3wbNKVBMvEv49IXpoSQ
	 esVm0ytwAy0Af6A37PNyWuNpNna5ebNmEc8+P43lCDwuPfhSxHUCdKosWB1V5+93IHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iASb0re8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9597A606A31A;
	Tue, 27 Oct 2026 10:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iASb0re8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC191F01825;
	Tue, 27 Oct 2026 10:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097374;
	bh=5EJSPUzg0whVepx7G/qDLZdM2wsz34VCNLXrTAyw3pI=;
	h=From:To:Cc:Subject:Date;
	b=iASb0re8vO6SmQzI3jESEFwNxt38qBTygyrDAMU44uQSV25dLenh7KNtveoOoALIB
	 vraMrLKDeOVJPBQDRh1irshh95EmTzfsHSsNJ+c3FzgKVugeofULumW2D9m7YZEudc
	 URWw9XIS7TuXb/v5ZpgQwMhKIwLpErX/ngkDurb6vIoI5VH00LuWjtQpH1ZWqMb6tt
	 qp6UsJfvfPdgz3giYTeRGL74w5tDFtnbFn6wu2rXZV76NfCjNDclsh7qxZ05SP71jc
	 pv7FNSGRndDCszm7EQzmxXGO1ibkeHJDKG1cnZRjj09Y/zYDNQtMBo6MiqPX2fgmt3
	 epay1ZXJEKWkA==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
	Andi Shyti <andi.shyti@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	Andy Shevchenko <andy@kernel.org>,
	AnilKumar Ch <anilkumar@ti.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Brent Casavant <bcasavan@sgi.com>,
	Chong Qiao <qiaochong@loongson.cn>,
	Corey Minyard <corey@minyard.net>,
	David Lechner <dlechner@baylibre.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Felipe Balbi <balbi@ti.com>,
	Gyungoh Yoo <jack.yoo@maxim-ic.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Joshua Kinard <linux@kumba.dev>,
	Kai Svahn <kai.svahn@nokia.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Kumar Sanghvi <kumar.sanghvi@stericsson.com>,
	Linus Walleij <linusw@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-iio@vger.kernel.org,
	linux-input@vger.kernel.org,
	linux-omap@vger.kernel.org,
	Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
	Mattias Wallin <mattias.wallin@stericsson.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	mfd@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Milo Kim <woogyom.kim@gmail.com>,
	Ming Yu <tmyu0@nuvoton.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Pantelis Antoniou <panto@antoniou-consulting.com>,
	Pat Gefre <pfg@sgi.com>,
	Paul Burton <paulburton@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Rabin Vincent <rabin.vincent@stericsson.com>,
	Rachna Patil <rachna@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Shi Hao <i.shihao.999@gmail.com>,
	Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
	Stanislaw Skowronek <skylark@unaligned.org>,
	Stephen Warren <swarren@nvidia.com>,
	Sundar Iyer <sundar.iyer@stericsson.com>,
	syed khasim <x0khasim@ti.com>,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Thomas Richard <thomas.richard@bootlin.com>,
	Tony Lindgren <tony@atomide.com>,
	Yinggang Gu <guyinggang@loongson.cn>
Subject: [PATCH v2 00/27] mfd: Assorted resource lifetime, teardown, and error-handling fixes
Date: Tue, 27 Oct 2026 09:30:29 +0000
Message-ID: <20261027093306.2812695-1-lee@kernel.org>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These issues were reported by Sashiko.

This series addresses a collection of resource lifetime, teardown
ordering, error-handling, and bounds-checking bugs across several MFD
drivers.

v1 => v2:
 - Collected Acked-by, Reviewed-by, and Tested-by tags from the list
 - Dropped "mfd: cgbc: Zero-initialise version buffer in
   cgbc_get_version()" in favour of Thomas Richard's upcoming central
   cgbc_command() validation series
 - Restored Fixes: tags (without Cc: stable@vger.kernel.org) on the four
   non-Stable MFD cell stack-pointer clean-ups (ls2kbmc, bd96801,
   ti_am335x_tscadc, and db8500-prcmu)

Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Andi Shyti <andi.shyti@kernel.org>
Cc: Andreas Kemnade <andreas@kemnade.info>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: AnilKumar Ch <anilkumar@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Binbin Zhou <zhoubinbin@loongson.cn>
Cc: Brent Casavant <bcasavan@sgi.com>
Cc: Chong Qiao <qiaochong@loongson.cn>
Cc: Corey Minyard <corey@minyard.net>
Cc: David Lechner <dlechner@baylibre.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Gyungoh Yoo <jack.yoo@maxim-ic.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Joshua Kinard <linux@kumba.dev>
Cc: Kai Svahn <kai.svahn@nokia.com>
Cc: Kevin Hilman <khilman@baylibre.com>
Cc: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
Cc: Linus Walleij <linusw@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-i2c@vger.kernel.org
Cc: linux-iio@vger.kernel.org
Cc: linux-input@vger.kernel.org
Cc: linux-mediatek@lists.infradead.org
Cc: linux-omap@vger.kernel.org
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Cc: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: mfd@lists.linux.dev
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Milo Kim <woogyom.kim@gmail.com>
Cc: Ming Yu <tmyu0@nuvoton.com>
Cc: "Nuno Sá" <nuno.sa@analog.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Pat Gefre <pfg@sgi.com>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Rachna Patil <rachna@ti.com>
Cc: Roger Quadros <rogerq@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shi Hao <i.shihao.999@gmail.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Stanislaw Skowronek <skylark@unaligned.org>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: syed khasim <x0khasim@ti.com>
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: Thomas Richard <thomas.richard@bootlin.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Yinggang Gu <guyinggang@loongson.cn>

Lee Jones (27):
  mfd: nct6694: Allocate USB DMA buffers with kzalloc_obj()
  mfd: ls2kbmc: Unregister GPIO GSI via devm_add_action_or_reset()
  mfd: ls2kbmc: Cancel reset work on teardown via devm_work_autocancel()
  mfd: ls2kbmc: Allocate simplefb platform_data on the heap
  mfd: bd96801: Allocate watchdog IRQ resource on the heap
  mfd: ti_am335x_tscadc: Retrieve parent driver data via
    dev_get_drvdata()
  mfd: db8500-prcmu: Make AB8500 cell and IRQ resource static
  mfd: nct6694: Do not resubmit interrupt URB on endpoint stall (-EPIPE)
  mfd: ioc3: Request parent IRQ via request_irq() and free before domain
    removal
  mfd: intel-lpss: Remove registered MFD child devices on probe failure
  mfd: max8907: Manage power-off handler via
    devm_register_sys_off_handler()
  mfd: twl-core: Clear pm_power_off callback in twl_remove()
  mfd: twl-core: Clear twl_priv pointer on teardown and probe failure
  mfd: loongson-se: Check return value of dma_set_mask_and_coherent()
  mfd: loongson-se: Zero-initialise controller command structures
  mfd: loongson-se: Reinitialise completions and wait uninterruptibly
    for commands
  mfd: loongson-se: Zero-allocate driver data and initialise engine
    completions in probe
  mfd: loongson-se: Prevent out-of-bounds engine access in
    se_irq_handler()
  mfd: loongson-se: Stop controller and mask interrupts on teardown and
    shutdown
  mfd: loongson-se: Validate engine ID, DMA buffer size, and IRQ
    registration
  mfd: abx500-core: Unregister device ops on devm release
  mfd: ab8500-core: Register sysfs attribute groups via
    devm_device_add_group()
  mfd: tps65217: Manage IRQ domain teardown via devres
  mfd: mt6397: Manage IRQ domain lifecycle with devres
  mfd: mt6397: Unregister PM notifier on probe failure and unbind
  i2c: cgbc: Propagate hardware errors when polling read status
  mfd: ti_am335x_tscadc: Remove redundant ti_tscadc_dev_get() helper

 drivers/i2c/busses/i2c-cgbc.c             |  27 ++++--
 drivers/iio/adc/ti_am335x_adc.c           |   2 +-
 drivers/input/touchscreen/ti_am335x_tsc.c |   2 +-
 drivers/mfd/ab8500-core.c                 |  11 +--
 drivers/mfd/abx500-core.c                 |  29 +++---
 drivers/mfd/db8500-prcmu.c                |   8 +-
 drivers/mfd/intel-lpss.c                  |   1 +
 drivers/mfd/ioc3.c                        |  32 ++++---
 drivers/mfd/loongson-se.c                 | 110 +++++++++++++++++-----
 drivers/mfd/ls2k-bmc-core.c               |  27 ++++--
 drivers/mfd/max8907.c                     |  28 ++++--
 drivers/mfd/mt6358-irq.c                  |  17 +++-
 drivers/mfd/mt6397-core.c                 |   4 +-
 drivers/mfd/mt6397-irq.c                  |  31 +++++-
 drivers/mfd/nct6694.c                     |  23 +++--
 drivers/mfd/rohm-bd96801.c                |  11 ++-
 drivers/mfd/ti_am335x_tscadc.c            |   7 +-
 drivers/mfd/tps65217.c                    |  40 ++++----
 drivers/mfd/twl-core.c                    |  45 +++++----
 include/linux/mfd/loongson-se.h           |   8 +-
 include/linux/mfd/ti_am335x_tscadc.h      |   7 --
 21 files changed, 326 insertions(+), 144 deletions(-)

-- 
2.56.0.307.g5fe7bd680c-goog

