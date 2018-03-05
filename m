From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: doc - clarify hash callbacks state machine
Date: Mon, 5 Mar 2018 12:39:45 +0200
Message-ID: <20180305103945.3517-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Even though it doesn't make too much sense, it is perfectly legal to:
- call .init() and then (as many times) .update()
- subseqently _not_ call any of .final(), .finup() or .export()

Update documentation since this is an important issue to consider
from resource management perspective.

Link: https://lkml.kernel.org/r/20180222114741.GA27631@gondor.apana.org.au
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 Documentation/crypto/devel-algos.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/crypto/devel-algos.rst b/Documentation/crypto/devel-algos.rst
index 66f50d32dcec..0f4617019227 100644
--- a/Documentation/crypto/devel-algos.rst
+++ b/Documentation/crypto/devel-algos.rst
@@ -236,6 +236,14 @@ when used from another part of the kernel.
                                |
                                '---------------> HASH2
 
+Note that it is perfectly legal to:
+- call .init() and then (as many times) .update()
+- subseqently _not_ call any of .final(), .finup() or .export()
+
+In other words mind the resource allocation and clean-up,
+since this basically means no resources can remain allocated
+after a call to .init() or .update().
+
 
 Specifics Of Asynchronous HASH Transformation
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 
2.16.2
