Received: from gauss.telenet-ops.be (gauss.telenet-ops.be [195.130.132.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842D01C878A
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jan 2025 13:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738331644; cv=none; b=tV1+315nJT+7OWavZq+eqteyl8PJZ4oQzg/x9E0wHoCgU3uSn1agTnrqXP5oJ8ZdX9vKkYuVQ1vtd20srQkiezFQVKpupM8zspl8zSEYgz6IRu0xa2XLeUKJbmb0LLyHNHKwD25B82/2y82nQVtOyWXT134tOXnt8GfdS0NTOyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738331644; c=relaxed/simple;
	bh=xc3M33C0iwXkHtkGreXFYtXp9BYNda0pGb+ISZTOV/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tc1BlqcPglRJ87wvwaR7+aEUibW9uuw/QBIG8lpt5g2YlyCs3QL7wxcb6VAX1OQLkPNrGjGDR3Dvgrnmgqak1fckTNlz+zBJ6PEWdJudzUza2apDhDX+OCHfJdFt6AKxdhqe4DB9f2UbWJdokhEJYLu/z9baVPffZ+BNEBKO2xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
	by gauss.telenet-ops.be (Postfix) with ESMTPS id 4Ykxz06dYPz4x0ng
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jan 2025 14:47:24 +0100 (CET)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:a916:3147:9f19:c260])
	by baptiste.telenet-ops.be with cmsmtp
	id 7pmw2E00W0naHe801pmwxH; Fri, 31 Jan 2025 14:47:24 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tdrM6-0000000FHxr-1qQW;
	Fri, 31 Jan 2025 14:46:56 +0100
Received: from geert by rox.of.borg with local (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tdrMG-0000000DFVN-1Vog;
	Fri, 31 Jan 2025 14:46:56 +0100
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Crt Mori <cmo@melexis.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Jacky Huang <ychuang3@nuvoton.com>,
	Shan-Chun Hung <schung@nuvoton.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Alex Elder <elder@ieee.org>
Cc: linux-clk@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-renesas-soc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	linux-gpio@vger.kernel.org,
	linux-aspeed@lists.ozlabs.org,
	linux-iio@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 0/3] Non-const bitfield helpers
Date: Fri, 31 Jan 2025 14:46:50 +0100
Message-ID: <cover.1738329458.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

	Hi all,

This is an updated subset of a patch series I sent more than 3 years
ago[1].

<linux/bitfield.h> contains various helpers for accessing bitfields, as
typically used in hardware registers for memory-mapped I/O blocks.
These helpers ensure type safety, and deduce automatically shift values
from mask values, avoiding mistakes due to inconsistent shifts and
masks, and leading to a reduction in source code size.

The existing FIELD_{GET,PREP}() macros are limited to compile-time
constants.  However, it is very common to prepare or extract bitfield
elements where the bitfield mask is not a compile-time constant.
To avoid this limitation, the AT91 clock driver introduced its own
field_{prep,get}() macros.  Hence my v1 series aimed to make them
available for general use, and convert several drivers to the existing
FIELD_{GET,PREP}() and the new field_{get,prep}() helpers.

Due to some pushback (mostly centered around using the typed
{u*,be*,le*,...}_get_bits() macros instead, which of course would
require making them work with non-constant masks first, too), this
series was never applied, and became buried deep in my TODO haystack...
However, several people still liked the idea: since v1, multiple copies
of the field_{prep,get}() macros appeared upstream, and one more is
queued for v6.15.

Hence I think it's time to revive and consolidate...

Changes compared to v1:
  - Cast val resp. reg to the mask type,
  - Fix 64-bit use on 32-bit architectures,
  - Convert new upstream users:
      - drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
      - drivers/gpio/gpio-aspeed.c
      - drivers/iio/temperature/mlx90614.c
      - drivers/pinctrl/nuvoton/pinctrl-ma35.c
      - sound/usb/mixer_quirks.c
  - Convert new user queued in renesas-devel for v6.15:
      - drivers/soc/renesas/rz-sysc.c
  - Drop the last 14 RFC patches.
    They can be updated/resubmitted/applied later.

I can take all three patches through the Renesas tree, and provide an
immutable branch with the first patch for ther interested parties.

Thanks for your comments!

[1] "[PATCH 00/17] Non-const bitfield helper conversions"
    https://lore.kernel.org/all/cover.1637592133.git.geert+renesas@glider.be

Geert Uytterhoeven (3):
  bitfield: Add non-constant field_{prep,get}() helpers
  clk: renesas: Use bitfield helpers
  soc: renesas: Use bitfield helpers

 drivers/clk/at91/clk-peripheral.c             |  1 +
 drivers/clk/at91/pmc.h                        |  3 --
 drivers/clk/renesas/clk-div6.c                |  6 ++--
 drivers/clk/renesas/rcar-gen3-cpg.c           | 15 +++-----
 drivers/clk/renesas/rcar-gen4-cpg.c           |  9 ++---
 .../qat/qat_common/adf_gen4_pm_debugfs.c      |  8 +----
 drivers/gpio/gpio-aspeed.c                    |  5 +--
 drivers/iio/temperature/mlx90614.c            |  5 +--
 drivers/pinctrl/nuvoton/pinctrl-ma35.c        |  4 ---
 drivers/soc/renesas/renesas-soc.c             |  4 +--
 drivers/soc/renesas/rz-sysc.c                 |  3 +-
 include/linux/bitfield.h                      | 34 +++++++++++++++++++
 sound/usb/mixer_quirks.c                      |  4 ---
 13 files changed, 52 insertions(+), 49 deletions(-)

-- 
2.43.0

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
