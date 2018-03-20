From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2] crypto: doc - clarify hash callbacks state machine
Date: Tue, 20 Mar 2018 09:56:12 +0200
Message-ID: <20180320075612.22719-1-horia.geanta@nxp.com>
References: <20180305103945.3517-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180305103945.3517-1-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add a note that it is perfectly legal to "abandon" a request object:
- call .init() and then (as many times) .update()
- _not_ call any of .final(), .finup() or .export() at any point in
  future

Link: https://lkml.kernel.org/r/20180222114741.GA27631@gondor.apana.org.au
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 Documentation/crypto/devel-algos.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/crypto/devel-algos.rst b/Documentation/crypto/devel-algos.rst
index 66f50d32dcec..c45c6f400dbd 100644
--- a/Documentation/crypto/devel-algos.rst
+++ b/Documentation/crypto/devel-algos.rst
@@ -236,6 +236,14 @@ when used from another part of the kernel.
                                |
                                '---------------> HASH2
 
+Note that it is perfectly legal to "abandon" a request object:
+- call .init() and then (as many times) .update()
+- _not_ call any of .final(), .finup() or .export() at any point in future
+
+In other words implementations should mind the resource allocation and clean-up.
+No resources related to request objects should remain allocated after a call
+to .init() or .update(), since there might be no chance to free them.
+
 
 Specifics Of Asynchronous HASH Transformation
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 
2.16.2
