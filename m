From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 5/6] crypto: LRNG - hook LRNG into interrupt handler
Date: Thu, 21 Apr 2016 11:14:30 +0200
Message-ID: <1784617.TvuOaYV7QZ@positron.chronox.de>
References: <9192755.iDgo3Omyqe@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9192755.iDgo3Omyqe@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
