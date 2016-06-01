From: Baolin Wang <baolin.wang@linaro.org>
Subject: [RFC v3 0/4] Introduce the bulk mode method when sending request to crypto layer
Date: Wed,  1 Jun 2016 12:58:03 +0800
Message-ID: <cover.1464756501.git.baolin.wang@linaro.org>
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
cipher mode. For bulk mode, we can use sg table to map the whole bio and
send all scatterlists of one bio to crypto engine to encrypt or decrypt,
which can improve the hardware engine's efficiency.

Changes since v2:
 - Add one cipher user with CRYPTO_ALG_BULK flag to support bulk mode.
 - Add one atomic variable to avoid the sg table race.

Changes since v1:
 - Refactor the blk_bio_map_sg() function to avoid duplicated code.
 - Move the sg table allocation to crypt_ctr_cipher() function to avoid memory
   allocation in the IO path.
 - Remove the crypt_sg_entry() function.
 - Other optimization.

Baolin Wang (4):
  block: Introduce blk_bio_map_sg() to map one bio
  crypto: Introduce CRYPTO_ALG_BULK flag
  md: dm-crypt: Introduce the bulk mode method when sending request
  crypto: Add the CRYPTO_ALG_BULK flag for ecb(aes) cipher

 block/blk-merge.c         |   36 ++++++++--
 drivers/crypto/omap-aes.c |    2 +-
 drivers/md/dm-crypt.c     |  159 ++++++++++++++++++++++++++++++++++++++++++++-
 include/crypto/skcipher.h |    7 ++
 include/linux/blkdev.h    |    2 +
 include/linux/crypto.h    |    6 ++
 6 files changed, 205 insertions(+), 7 deletions(-)

-- 
1.7.9.5
