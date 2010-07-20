From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4/4] crypto: pcrypt - Dont calulate a callback cpu on empty
 callback cpumask
Date: Tue, 20 Jul 2010 08:52:20 +0200
Message-ID: <20100720065220.GF11081@secunet.com>
References: <20100714142951.22817d0c@leibniz>
 <20100719060426.GA19696@gondor.apana.org.au>
 <20100719064050.GA11081@secunet.com>
 <20100719073255.GA20403@gondor.apana.org.au>
 <20100720064736.GB11081@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Kruchinin <dkruchinin@acm.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:49351 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab0GTGtU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Jul 2010 02:49:20 -0400
Content-Disposition: inline
In-Reply-To: <20100720064736.GB11081@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the callback cpumask is empty, we crash with a division by zero
when we try to calculate a callback cpu. So we don't update the callback
cpu in pcrypt_do_parallel if the callback cpumask is empty.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcrypt.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 7153a50..794c172 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -82,6 +82,9 @@ static int pcrypt_do_parallel(struct padata_priv *padata, unsigned int *cb_cpu,
 	if (cpumask_test_cpu(cpu, cpumask->mask))
 			goto out;
 
+	if (!cpumask_weight(cpumask->mask))
+			goto out;
+
 	cpu_index = cpu % cpumask_weight(cpumask->mask);
 
 	cpu = cpumask_first(cpumask->mask);
-- 
1.5.6.5
