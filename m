From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH 0/4] Introduce bulk mode for crypto engine framework
Date: Thu,  3 Mar 2016 13:19:35 +0800
Message-ID: <cover.1456981314.git.baolin.wang@linaro.org>
Cc: akpm@linux-foundation.org, david.s.gordon@intel.com,
	thomas.lendacky@amd.com, robert.jarzmik@free.fr,
	yamada.masahiro@socionext.com, smueller@chronox.de,
	tadeusz.struk@intel.com, standby24x7@gmail.com, shli@kernel.org,
	broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	baolin.wang@linaro.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, agk@redhat.com,
	snitzer@redhat.com, axboe@fb.com, dm-devel@redhat.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now some cipher hardware engines prefer to handle bulk block by merging requests
to increase the block size and thus increase the hardware engine processing speed.

This patchset introduces request bulk mode to help the crypto hardware drivers
improve in efficiency.

Baolin Wang (4):
  scatterlist: Introduce some helper functions
  crypto: Introduce some helper functions to help to merge requests
  crypto: Introduce the bulk mode for crypto engine framework
  md: dm-crypt: Initialize the sector number for one request

 crypto/Kconfig               |    1 +
 crypto/ablk_helper.c         |  135 ++++++++++++++++++++++++++++++++++++++++++
 crypto/crypto_engine.c       |  122 +++++++++++++++++++++++++++++++++++++-
 drivers/crypto/omap-aes.c    |    2 +-
 drivers/md/dm-crypt.c        |    1 +
 include/crypto/ablk_helper.h |    3 +
 include/crypto/algapi.h      |   23 ++++++-
 include/linux/crypto.h       |    5 ++
 include/linux/scatterlist.h  |   33 +++++++++++
 lib/scatterlist.c            |   59 ++++++++++++++++++
 10 files changed, 379 insertions(+), 5 deletions(-)

-- 
1.7.9.5

