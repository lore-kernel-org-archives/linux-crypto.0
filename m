From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Fri, 5 Jun 2009 11:20:30 +0200
Message-ID: <20090605092030.GO20366@secunet.com>
References: <20090513130618.GD20366@secunet.com> <20090513130818.GF20366@secunet.com> <20090602035041.GB22831@gondor.apana.org.au> <20090602092151.GJ20366@secunet.com> <20090602092815.GA26832@gondor.apana.org.au> <20090603093216.GK20366@secunet.com> <20090603094049.GA11356@gondor.apana.org.au> <20090603112353.GL20366@secunet.com> <20090603115931.GA13361@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:43560 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbZFEJSF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Jun 2009 05:18:05 -0400
Content-Disposition: inline
In-Reply-To: <20090603115931.GA13361@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 03, 2009 at 09:59:31PM +1000, Herbert Xu wrote:
> 
> When pcrypt instantiates an algorithm, it should set cra_name to
> %s and cra_driver_name to pcrypt(%s).  So as long as the pcrypt
> priority is higher than the underlying algorithm, it should all
> work.
> 

As it is, I can instantiate pcrypt if the priority of pcrypt is lower
than the priority of the underlying algorithm. If I do the priority
check in crypto_alg_tested() the other way arround, I get it to work if
pcrypt has a higher priority than the underlying algorithm. So I guess
we need the patch below, right? If so, I would send a signed-off patch.

 
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 56c62e2..2492e6c 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -255,7 +255,7 @@ found:
 			continue;
 
 		if (strcmp(alg->cra_driver_name, q->cra_driver_name) &&
-		    q->cra_priority > alg->cra_priority)
+		    q->cra_priority < alg->cra_priority)
 			continue;
 
 		crypto_remove_spawns(&q->cra_users, &list, alg->cra_flags);
