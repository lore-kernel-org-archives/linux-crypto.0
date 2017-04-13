From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 0/2] Fix/improve some error handling related to 'chcr_alloc_shash'
Date: Thu, 13 Apr 2017 14:13:56 +0200
Message-ID: <cover.1492085165.git.christophe.jaillet@wanadoo.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        harsh@chelsio.com, hariprasad@chelsio.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This serie is divided into 2 patches. They are more or less related to the
same issue, but the first patch is not a bug in itself, just a clean-up
(IMHO).
If I'm correct, the 2nd one, is a real (unlikely) issue.

Christophe JAILLET (2):
  crypto: chcr - Improve error checking
  crypto: chcr - Fix error checking

 drivers/crypto/chelsio/chcr_algo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.11.0
