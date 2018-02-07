From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v2 0/4] crypto: AF_ALG AIO improvements
Date: Wed, 07 Feb 2018 08:42:59 +0100
Message-ID: <1842104.0gXuQuQB9D@positron.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <CAOtvUMe8gqBJtFjkO-Jssw1Q32GdR0oZNPRitt81skKO2f_+yg@mail.gmail.com> <20180201102519.000044c1@huawei.com>
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
Received: from mail.eperm.de ([89.247.134.16]:59338 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753156AbeBGHpI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Feb 2018 02:45:08 -0500
In-Reply-To: <20180201102519.000044c1@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Herbert, the patch 1 is meant for stable. However, this patch as is
only applies to the new AF_ALG interface implementation. Though,
the issue goes back to the first implementation of AIO support.
Shall I try prepare a patch for the old AF_ALG implementation
as well?

Changes from v1:

* integrate the inline IV and locking patch into one patch set

* reverse the order of lock context IV patch and inline IV patch --
  the reason is to allow the first patch to be back-ported to stable

* mark the first patch (locking of the context IV) as applicable to
  stable as there is an existing inconsistency which was demonstrated
  by Harsh with the Chelsio driver vs the AES-NI driver

* modify the inline IV patch to have proper unlocking of the mutex
  in case of errors

* prevent locking if no IV is defined by cipher

* add a patch to allow crypto drivers to report whether they support
  serialization -- in this case the locking in AF_ALG shall be
  disabled

* add a patch to inform the crypto drivers that their serialization
  support should actually be enabled and used because AF_ALG does not
  serialize the interdependent parallel AIO requests

* streamline the code in patch 1 and 2 slightly

I would like to ask the folks with real AIO hardware (Harsh, Jonathan)
to test the patches. Especially, is the locking patch should be tested
by Harsh as you have seen the issue with your hardware.

Thanks.

Stephan Mueller (4):
  crypto: AF_ALG AIO - lock context IV
  crypto: AF_ALG - inline IV support
  crypto: AF_ALG - allow driver to serialize IV access
  crypto: add CRYPTO_TFM_REQ_PARALLEL flag

 crypto/af_alg.c             | 119 +++++++++++++++++++++++++++++++++++++++++++-
 crypto/algif_aead.c         |  86 +++++++++++++++++---------------
 crypto/algif_skcipher.c     |  38 ++++++++++----
 include/crypto/if_alg.h     |  37 ++++++++++++++
 include/linux/crypto.h      |  16 ++++++
 include/uapi/linux/if_alg.h |   6 ++-
 6 files changed, 249 insertions(+), 53 deletions(-)

-- 
2.14.3
