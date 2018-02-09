From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v3 0/4] crypto: AF_ALG AIO improvements
Date: Fri, 09 Feb 2018 23:02:27 +0100
Message-ID: <2808558.OTeCt0oKkL@positron.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <20180201102519.000044c1@huawei.com> <1842104.0gXuQuQB9D@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Harsh Jain <harsh@chelsio.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:17347 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752982AbeBIWO3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Feb 2018 17:14:29 -0500
In-Reply-To: <1842104.0gXuQuQB9D@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Herbert, the patch 1 is meant for stable. However, this patch as is
only applies to the new AF_ALG interface implementation. Though,
the issue goes back to the first implementation of AIO support.
Shall I try prepare a patch for the old AF_ALG implementation
as well?

Changes from v2:

* rename ALG_IIV flags into ALG_IV_...

* rename CRYPTO_TFM_REQ_PARALLEL into CRYPTO_TFM_REQ_IV_SERIALIZE

* fix branch in patch 4 to add CRYPTO_TFM_REQ_IV_SERIALIZE flag when
  ctx->iiv == ALG_IV_SERIAL_PROCESSING

* fix patch description of patch 4

Stephan Mueller (4):
  crypto: AF_ALG AIO - lock context IV
  crypto: AF_ALG - inline IV support
  crypto: AF_ALG - allow driver to serialize IV access
  crypto: add CRYPTO_TFM_REQ_IV_SERIALIZE flag

 crypto/af_alg.c             | 119 +++++++++++++++++++++++++++++++++++++++++++-
 crypto/algif_aead.c         |  86 +++++++++++++++++---------------
 crypto/algif_skcipher.c     |  38 ++++++++++----
 include/crypto/if_alg.h     |  37 ++++++++++++++
 include/linux/crypto.h      |  16 ++++++
 include/uapi/linux/if_alg.h |   6 ++-
 6 files changed, 249 insertions(+), 53 deletions(-)

-- 
2.14.3
