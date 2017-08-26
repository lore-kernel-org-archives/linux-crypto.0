From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH 0/2] remove NULL check before kfree
Date: Sun, 27 Aug 2017 02:45:28 +0530
Message-ID: <1503782130-10137-1-git-send-email-himanshujha199640@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

*** BLURB HERE ***

Himanshu Jha (2):
  crypto: n2 - remove null check before kfree
  crypto: inside-secure - remove null check before kfree

 drivers/crypto/inside-secure/safexcel_hash.c |  6 ++----
 drivers/crypto/n2_core.c                     | 12 ++++--------
 2 files changed, 6 insertions(+), 12 deletions(-)

-- 
2.7.4
