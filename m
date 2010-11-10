From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 0/5] omap-aes off mode and error handling fixes
Date: Wed, 10 Nov 2010 19:26:51 +0200
Message-ID: <cover.1289409924.git.dmitry.kasatkin@nokia.com>
References: <y>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <y>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Dmitry Kasatkin (5):
  crypto: omap-aes: change in prevention of OCP bus error
  omap-aes: DMA initialization fixes for OMAP off mode
  omap-aes: redundant locking is removed
  omap-aes: error handling implementation improved
  omap-aes: unnecessary code removed

 drivers/crypto/omap-aes.c |  269 ++++++++++++++++++++++++---------------------
 1 files changed, 143 insertions(+), 126 deletions(-)

