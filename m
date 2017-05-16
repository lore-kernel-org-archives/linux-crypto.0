From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 13/53] docs-rst: add crypto API book to pdf output
Date: Tue, 16 May 2017 09:16:05 -0300
Message-ID: <8db0b75f4262edc7bb5d25137c2780d9c3186288.1494935649.git.mchehab@s-opensource.com>
References: <cover.1494935649.git.mchehab@s-opensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>,
 Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
 Mauro Carvalho Chehab <mchehab@infradead.org>,
 Mauro Carvalho Chehab <mchehab@s-opensource.com>,
 Marek Vasut <marek.vasut@gmail.com>, linux-mtd@lists.infradead.org,
 linux-crypto@vger.kernel.org, Cyrille Pitchen <cyrille.pitchen@atmel.com>,
 Brian Norris <computersforpeace@gmail.com>,
 David Woodhouse <dwmw2@infradead.org>, "David S. Miller" <davem@davemloft.net>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <cover.1494935649.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1494935649.git.mchehab@s-opensource.com>
References: <cover.1494935649.git.mchehab@s-opensource.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
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


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
