From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH v2 0/4] Introduce bulk mode for crypto engine framework
Date: Tue, 15 Mar 2016 15:47:58 +0800
Message-ID: <cover.1458023695.git.baolin.wang@linaro.org>
Cc: akpm@linux-foundation.org, david.s.gordon@intel.com,
	thomas.lendacky@amd.com, robert.jarzmik@free.fr,
	yamada.masahiro@socionext.com, smueller@chronox.de,
	tadeusz.struk@intel.com, standby24x7@gmail.com, shli@kernel.org,
	broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	baolin.wang@linaro.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, agk@redhat.com,
	snitzer@redhat.com, axboe@fb.com, dm-devel@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34194 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934112AbcCOHs0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Mar 2016 03:48:26 -0400
Received: by mail-pf0-f170.google.com with SMTP id x3so17945423pfb.1
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2016 00:48:25 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now some cipher hardware engines prefer to handle bulk block by merging requests
to increase the block size and thus increase the hardware engine processing speed.

This patchset introduces request bulk mode to help the crypto hardware drivers
improve in efficiency.

Changes since v1:
 - Modify the sg_is_contiguous() function.

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
 lib/scatterlist.c            |   69 +++++++++++++++++++++
 10 files changed, 389 insertions(+), 5 deletions(-)

-- 
1.7.9.5
