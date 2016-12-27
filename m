From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 7/8] random: remove noop function call to xfer_secondary_pool
Date: Tue, 27 Dec 2016 23:41:46 +0100
Message-ID: <9955153.9pz8KSq437@positron.chronox.de>
References: <3254875.f5A5oHPdxF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55038 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754521AbcL0Wno (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 17:43:44 -0500
In-Reply-To: <3254875.f5A5oHPdxF@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since the introduction of the ChaCha20 DRNG, extract_entropy is only
invoked with the input_pool. For this entropy pool, xfer_secondary_pool
is a no-op and can therefore be safely removed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 89d67c0..7b72a01 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1417,7 +1417,6 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	}
 
 	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
-	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
 
 	return _extract_entropy(r, buf, nbytes, fips_enabled);
-- 
2.9.3
