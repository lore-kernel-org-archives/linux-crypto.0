From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v2] crypto: authenc - convert to ahash
Date: Tue, 21 Jul 2009 14:25:09 +0200
Message-ID: <20090721122509.GG20288@secunet.com>
References: <20090721090217.GF20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:33708 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbZGUMWf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jul 2009 08:22:35 -0400
Content-Disposition: inline
In-Reply-To: <20090721090217.GF20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I just noticed that your shash version of hmac keeps the paded keys
on the transform. I assumed the hashing to be reentrant, so I
removed the locks arround the hash functions here.

Is there a plan to move the paded keys to the request soon, 
or should we keep the locks for now and remove them later?

