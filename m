From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH 0/2] Fix a resource release omission in error handling code
Date: Fri, 22 Jul 2016 15:32:40 +0200
Message-ID: <20160722133242.21916-1-lambert.quentin@gmail.com>
Cc: kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The first patch is a style fix, the second add calls to npe_release.
The reason for me thinking that they are necessary is that every other branches
leading to an error return are calling this function.

---
 drivers/crypto/ixp4xx_crypto.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)
---
