From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] Documentation: hw_random: Fix issue related to feeding entropy pool
Date: Tue, 22 Aug 2017 21:45:44 +0530
Message-ID: <20170822161544.24958-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, corbet@lwn.net,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

There is no need to use rng-tools for feeding random data into kernel
entropy pool as hw_random core handles it. Documentation suggested that
rng-tools is required which is incorrect. So remove it.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 Documentation/hw_random.txt | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/hw_random.txt b/Documentation/hw_random.txt
index 121de96..46b2480 100644
--- a/Documentation/hw_random.txt
+++ b/Documentation/hw_random.txt
@@ -19,10 +19,6 @@ hw_random driver's official Web site:
 
 	http://sourceforge.net/projects/gkernel/
 
-Those tools use /dev/hwrng to fill the kernel entropy pool,
-which is used internally and exported by the /dev/urandom and
-/dev/random special files.
-
 Theory of operation
 ===================
 
-- 
2.10.0

