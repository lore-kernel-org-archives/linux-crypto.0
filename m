From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 0/2] crypto: qce: fix few sparse warnings
Date: Fri,  4 Jul 2014 17:03:28 +0300
Message-ID: <1404482610-25608-1-git-send-email-svarbanov@mm-sol.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Stanimir Varbanov <svarbanov@mm-sol.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

Here are sparse fixes for Qualcomm crypto driver reported here [1].
The patches are based on cryptodev-2.6 tree.

regards,
Stan

[1] https://lists.01.org/pipermail/kbuild-all/2014-July/005429.html

Stanimir Varbanov (2):
  crypto: qce: fix sparse warnings
  crypto: qce: add dependancy to Kconfig

 drivers/crypto/Kconfig      |    1 +
 drivers/crypto/qce/common.c |   15 +++++++++------
 drivers/crypto/qce/common.h |    2 +-
 drivers/crypto/qce/sha.c    |   20 ++++++++++----------
 4 files changed, 21 insertions(+), 17 deletions(-)
