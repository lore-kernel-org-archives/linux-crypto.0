From: Baolin Wang <baolin.wang@linaro.org>
Subject: [RFC v2 0/3] Introduce the bulk mode method when sending request to crypto layer
Date: Fri, 27 May 2016 19:11:21 +0800
Message-ID: <cover.1464346333.git.baolin.wang@linaro.org>
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

As Milan pointed out we need one driver with using the new 'CRYPTO_ALG_BULK'
flag, I'll add one cipher engine driver with 'CRYPTO_ALG_BULK' flag to test
this optimization in next version, if I am sure this optimization is on the
right direction according to your comments.

Looking forward to any comments and suggestions. Thanks.

Changes since v1:
 - Refactor the blk_bio_map_sg() function to avoid duplicated code.
 - Move the sg table allocation to crypt_ctr_cipher() function to avoid memory
 allocation in the IO path.
 - Remove the crypt_sg_entry() function.
 - Other optimization.

Baolin Wang (3):
  block: Introduce blk_bio_map_sg() to map one bio
  crypto: Introduce CRYPTO_ALG_BULK flag
  md: dm-crypt: Introduce the bulk mode method when sending request

 block/blk-merge.c         |   36 +++++++++--
 drivers/md/dm-crypt.c     |  145 ++++++++++++++++++++++++++++++++++++++++++++-
 include/crypto/skcipher.h |    7 +++
 include/linux/blkdev.h    |    2 +
 include/linux/crypto.h    |    6 ++
 5 files changed, 190 insertions(+), 6 deletions(-)

-- 
1.7.9.5
