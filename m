From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: [PATCH 1/2] scripts/coccinelle: catch freeing cryptographic structures
 via kfree
Date: Mon, 17 Nov 2014 18:14:20 +0400
Message-ID: <20141117151420.10739.16342.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Michal Marek <mmarek@suse.cz>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Gilles Muller <Gilles.Muller@lip6.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	Eric Biederman <ebiederm@xmission.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17544 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaKQPOX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Nov 2014 10:14:23 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Structures allocated by crypto_alloc_* must be freed using crypto_free_*.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 scripts/coccinelle/free/crypto_free.cocci |   45 +++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 scripts/coccinelle/free/crypto_free.cocci

diff --git a/scripts/coccinelle/free/crypto_free.cocci b/scripts/coccinelle/free/crypto_free.cocci
new file mode 100644
index 0000000..0799b70
--- /dev/null
+++ b/scripts/coccinelle/free/crypto_free.cocci
@@ -0,0 +1,45 @@
+///
+/// Structures allocated by crypto_alloc_* must be freed using crypto_free_*.
+/// This finds freeing them by kfree.
+///
+// Confidence: Moderate
+// Copyright: (C) 2014 Konstantin Khlebnikov,  GPLv2.
+// Comments: There are false positives in crypto/ where they are actually freed.
+// Keywords: crypto, kfree
+// Options: --no-includes --include-headers
+
+virtual org
+virtual report
+virtual context
+
+@r depends on context || org || report@
+expression x;
+identifier crypto_alloc =~ "^crypto_alloc_";
+@@
+
+(
+ x = crypto_alloc(...)
+)
+
+@pb@
+expression r.x;
+position p;
+@@
+
+(
+* kfree@p(x)
+)
+
+@script:python depends on org@
+p << pb.p;
+@@
+
+msg="WARNING: invalid free of crypto_alloc_* allocated data"
+coccilib.org.print_todo(p[0], msg)
+
+@script:python depends on report@
+p << pb.p;
+@@
+
+msg="WARNING: invalid free of crypto_alloc_* allocated data"
+coccilib.report.print_report(p[0], msg)
