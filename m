Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CC329A2;
	Wed,  9 Apr 2025 03:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744169356; cv=none; b=SL2PRWWIvwCuKatD6eYWJpDxYpVZ+khzf0n4XjEbs3E6gDYpsJ8pw/lshedMJ/7O4wkJNmYc3kXBzkaYIujTs/rE4fTovuGSQjzA14WQ2iAcDY0QgklYEHMWh8ke2ogHnzt75DVkn6Up6Da0xEM11ajm435kMA4voCqK2Gv9iZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744169356; c=relaxed/simple;
	bh=4p/IbFEezQpWXPH8NofazJ6FUPVgXzJL0rqHzdQx3QQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpyHj2UNG7NyAKV/+wFBExRfLCsaxk5xVwdzjuQimWx4W/sYVTtTZ7qrRjAc2E9L5XHrrwOVJXvFaOSLphKFk30euEXiA3m0JXQNCiYu7t2mr/Pr6pPBBp/AfXz+gQhla6xWt4rQoHfOotXeSC/FYtFAiRIZJ3eX1ugXuvSCDXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=D2D/ELRP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="D2D/ELRP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BEXCXXMNkXzsQ7EhgQi62ODf9OaSN7AbBYwpyLCGWxA=; b=D2D/ELRPPBU6u3pEkRJ602uyPP
	/hri3nu/1gCHhMSocAYMMSWKnjSDY8vrA5nKY9HpBXpqGcvbIzPkTg8ByzDcTGWmY81eiGN87Zup3
	3aHiwJMw146hdpOkVI+7xlxW/iLfLOSp6ZrVWYTEEorFZxoY3xjYvLM5WyF3aXPC+uhFzolKuCz+i
	kJjrUiqxSMY8pxVdDX9wO7puTZu1pYN8bq6uXHSMXzKihjUQfQL0Ehh6yTQdS8k7OVqtstdco+pbr
	SmmV0V4RBLX+RsX5bjeP28JJeBaeBV7rv4Sbwz46vUDa0rPVMiMJoGSK9Xe5SppzSN1e+tGwb+iMA
	I0/tqI3A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u2M7b-00E6NS-1f;
	Wed, 09 Apr 2025 11:29:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 09 Apr 2025 11:29:03 +0800
Date: Wed, 9 Apr 2025 11:29:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sean Anderson <sean.anderson@linux.dev>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
Subject: [PATCH] crypto: api - Allow delayed algorithm destruction
Message-ID: <Z_XpfyPaoZ6Y8u6z@gondor.apana.org.au>
References: <17f9af67-de10-4b96-99ef-3c5cd78124c0@linux.dev>
 <Z_SxYFdyBJTYe_7G@gondor.apana.org.au>
 <e3dd2f83-8451-47b0-a774-a697b861ceb3@linux.dev>
 <Z_XiPLmSVs8PGTZD@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_XiPLmSVs8PGTZD@gondor.apana.org.au>

On Wed, Apr 09, 2025 at 10:58:04AM +0800, Herbert Xu wrote:
>
> What I'll do is make the crypto_unregister call wait for the users
> to go away.  That matches how the network device unregistration works
> and hopefully should solve this problem.  But keep your eyes for
> dead locks that used to plague netdev unregistration :)

That was a dumb idea.  All it would do is make the shutdown hang.
So here is a different tack.  Let the algorithms stick around,
by allocating them dynamically instead.  Then we could simply
kfree them when the user finally disappears (if ever).

Note to make this work, caam needs to be modified to allocate the
algorithms dynamically (kmemdup should work), and add a cra_destroy
function to kfree the memory.

---8<---
The current algorithm unregistration mechanism originated from
software crypto.  The code relies on module reference counts to
stop in-use algorithms from being unregistered.  Therefore if
the unregistration function is reached, it is assumed that the
module reference count has hit zero and thus the algorithm reference
count should be exactly 1.

This is completely broken for hardware devices, which can be
unplugged at random.

Fix this by allowing algorithms to be destroyed later if a destroy
callback is provided.

Reported-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 5b8a4c787387..f368c0dc0d6d 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -481,10 +481,10 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
 		return;
 
-	if (WARN_ON(refcount_read(&alg->cra_refcnt) != 1))
-		return;
-
-	if (alg->cra_type && alg->cra_type->destroy)
+	if (alg->cra_destroy)
+		crypto_alg_put(alg);
+	else if (!WARN_ON(refcount_read(&alg->cra_refcnt) != 1) &&
+		 alg->cra_type && alg->cra_type->destroy)
 		alg->cra_type->destroy(alg);
 
 	crypto_remove_final(&list);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
