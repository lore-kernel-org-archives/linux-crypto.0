From: Baolin Wang <baolin.wang@linaro.org>
Subject: [RFC 0/3] Introduce the bulk mode method when sending request to crypto layer
Date: Wed, 25 May 2016 14:12:28 +0800
Message-ID: <cover.1464144790.git.baolin.wang@linaro.org>
Cc: ebiggers3@gmail.com, js1304@gmail.com, tadeusz.struk@intel.com,
	smueller@chronox.de, standby24x7@gmail.com, shli@kernel.org,
	dan.j.williams@intel.com, martin.petersen@oracle.com,
	sagig@mellanox.com, kent.overstreet@gmail.com,
	keith.busch@intel.com, tj@kernel.org, ming.lei@canonical.com,
	broonie@kernel.org, arnd@arndb.de, linux-crypto@vger.kernel.org,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, baolin.wang@linaro.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	dm-devel@redhat.com, herbert@gondor.apana.org.au,
	davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patchset will check if the cipher can support bulk mode, then dm-crypt
will handle different ways to send requests to crypto layer according to
cipher mode.

Looking forward to any comments and suggestions. Thanks.

Baolin Wang (3):
  block: Introduce blk_bio_map_sg() to map one bio
  crypto: Introduce CRYPTO_ALG_BULK flag
  md: dm-crypt: Introduce the bulk mode method when sending request

 block/blk-merge.c         |   45 +++++++++++
 drivers/md/dm-crypt.c     |  188 ++++++++++++++++++++++++++++++++++++++++++---
 include/crypto/skcipher.h |    7 ++
 include/linux/blkdev.h    |    3 +
 include/linux/crypto.h    |    6 ++
 5 files changed, 237 insertions(+), 12 deletions(-)

-- 
1.7.9.5
