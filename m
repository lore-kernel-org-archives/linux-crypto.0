Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB3E231A2B
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744021263; cv=none; b=aurCV5qq9tSBQcK3ritbJvfrD+ap30p2AX+5luoDT0vVeZFJWcNHfW8FVihHZIaVSpbfyY30lP0m37/DMPGl4iBAwrA4hgShDQPnJIQz6UppZFYEc5Iu+p7io1NBx/enzhKwDScZWTB1vFgZ9e5FBH4OzO/7pOp6LUG9vNf7Gy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744021263; c=relaxed/simple;
	bh=i3VYEwGGYSArUBu/VXsj3ebdms9dXziUhw674AWvsR8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Van3gGU1KFWJXEAhgiHNqDD3AD5xQtjAS1Ck7qWtkf7MO+FPLqSAFnJxRG5qx82PHnffzvPy3uc4wBV1aNYslE1q3Zgzhk5wA9l1J5ux5FzqLHW8djqvBT09ywWq0XyYcYxZ2OmvFnT9bkneleMxuu2yru2ouDSWRyYMF8y3oyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hwP6lRBZ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hwP6lRBZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ogi0BaUzgQ9A7wYNlowbOlIcuJ3zpm7JzTGEHKO+R6Q=; b=hwP6lRBZ+6+KKrgC7tab67AGMe
	GHOHii3RzXFAOOVbAlhxyqHDLVNnYxIAFnkpU1OplTJF2noou3meZ1nsz2fXBPDYcPRry4+glN4/4
	uLvUBZYnfBn6fox/cfn4ozP+m5MS9VRObD3sWtqwag6eO20EOQhom/PbnNMig+cePxauPf3zmxVM9
	zIHNh/sZrOET1FeWM2QYgvajpzx2ULcomTbpz4izG4q5t+LH491fa3XdDHEMhMDoc2ywDLs1HDz+6
	CrAdB5lpWYKfo2MZ86NL+D9zo/AELle+tPzewfbPsSEct4RC1QHu8h41AtZBm41JwO5mHo4j02LSS
	hkzeJtvg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jb7-00DTZ2-1a;
	Mon, 07 Apr 2025 18:20:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:20:57 +0800
Date: Mon, 07 Apr 2025 18:20:57 +0800
Message-Id: <86d10cfe7bc4c6d1a283f60648a12e7a241a379a.1744021074.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744021074.git.herbert@gondor.apana.org.au>
References: <cover.1744021074.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/7] crypto: api - Mark cra_init/cra_exit as deprecated
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

These functions have been obsoleted by the type-specific init/exit
functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/linux/crypto.h | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index a387f1547ea0..56cf229e2530 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -300,17 +300,8 @@ struct cipher_alg {
  *	   by @cra_type and @cra_flags above, the associated structure must be
  *	   filled with callbacks. This field might be empty. This is the case
  *	   for ahash, shash.
- * @cra_init: Initialize the cryptographic transformation object. This function
- *	      is used to initialize the cryptographic transformation object.
- *	      This function is called only once at the instantiation time, right
- *	      after the transformation context was allocated. In case the
- *	      cryptographic hardware has some special requirements which need to
- *	      be handled by software, this function shall check for the precise
- *	      requirement of the transformation and put any software fallbacks
- *	      in place.
- * @cra_exit: Deinitialize the cryptographic transformation object. This is a
- *	      counterpart to @cra_init, used to remove various changes set in
- *	      @cra_init.
+ * @cra_init: Deprecated, do not use.
+ * @cra_exit: Deprecated, do not use.
  * @cra_u.cipher: Union member which contains a single-block symmetric cipher
  *		  definition. See @struct @cipher_alg.
  * @cra_module: Owner of this transformation implementation. Set to THIS_MODULE
-- 
2.39.5

