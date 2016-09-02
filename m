From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH 0/2][RESEND] add omitted release in qat_common
Date: Fri,  2 Sep 2016 16:43:57 +0200
Message-ID: <20160902144400.31216-1-lambert.quentin@gmail.com>
References: <20160902143759.31125-1-lambert.quentin@gmail.com>
Cc: kernel-janitors@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Quentin Lambert <lambert.quentin@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160902143759.31125-1-lambert.quentin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The first patch introduces a variable to handle different error codes and be
able to reuse the same clean up code. The second add an omitted release by
jumping to the clean code having set the returned value to the proper error
code.

---
 drivers/crypto/qat/qat_common/qat_uclo.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)
---
