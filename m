From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 13/36] docs-rst: add crypto API book to pdf output
Date: Fri, 12 May 2017 10:59:56 -0300
Message-ID: <8c262df84a16c2b7d4b9e735a59022f0f22f1cc8.1494596071.git.mchehab@s-opensource.com>
References: <cover.1494596071.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1494596071.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1494596071.git.mchehab@s-opensource.com>
References: <cover.1494596071.git.mchehab@s-opensource.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The crypto API book was added without the bits required to
generate PDF output. Add them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py        |  2 ++
 Documentation/crypto/conf.py | 10 ++++++++++
 2 files changed, 12 insertions(+)
 create mode 100644 Documentation/crypto/conf.py

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 15f34d6863a7..ce62723491d4 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -351,6 +351,8 @@ latex_documents = [
      'The kernel development community', 'manual'),
     ('core-api/index', 'core-api.tex', 'The kernel core API manual',
      'The kernel development community', 'manual'),
+    ('crypto/index', 'crypto-api.tex', 'Linux Kernel Crypto API manual',
+     'The kernel development community', 'manual'),
     ('doc-guide/index', 'kernel-doc-guide.tex', 'Linux Kernel Documentation Guide',
      'The kernel development community', 'manual'),
     ('driver-api/index', 'driver-api.tex', 'The kernel driver API manual',
diff --git a/Documentation/crypto/conf.py b/Documentation/crypto/conf.py
new file mode 100644
index 000000000000..4335d251ddf3
--- /dev/null
+++ b/Documentation/crypto/conf.py
@@ -0,0 +1,10 @@
+# -*- coding: utf-8; mode: python -*-
+
+project = 'Linux Kernel Crypto API'
+
+tags.add("subproject")
+
+latex_documents = [
+    ('index', 'crypto-api.tex', 'Linux Kernel Crypto API manual',
+     'The kernel development community', 'manual'),
+]
-- 
2.9.3
