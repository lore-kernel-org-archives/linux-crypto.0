From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 5/6] crypto: LRNG - hook LRNG into interrupt handler
Date: Sun, 24 Apr 2016 12:42:57 +0200
Message-ID: <1597982.NXJbFZcdAH@positron.chronox.de>
References: <1589319.WyasadRQQe@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: sandyinchina@gmail.com, Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, Theodore Tso <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53258 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbcDXKpT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Apr 2016 06:45:19 -0400
In-Reply-To: <1589319.WyasadRQQe@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The LRNG places a callback into the interrupt handler to be triggered
for each interrupt. With this callback, entropy is collected.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 kernel/irq/handle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index a15b548..8d64e37 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -175,6 +175,7 @@ irqreturn_t handle_irq_event_percpu(struct irq_desc *desc)
 	}
 
 	add_interrupt_randomness(irq, flags);
+	lrng_irq_process();
 
 	if (!noirqdebug)
 		note_interrupt(desc, retval);
-- 
2.5.5
