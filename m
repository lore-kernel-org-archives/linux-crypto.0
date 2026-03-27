Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E893AA4ED
	for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 10:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774606244; cv=none; b=RvQIkfi6iT3TwnKLzzbbTgHv90w4+wrX1+8w2nfSG5BVwqSdLPG8vacLWLWt0U3X4Ccx1C68I9+qKkylaS71djdUWMhD2bNVsyU5qBRmM4Qe6nRGMQ8lqA4gOebapZt7r4bLImiFDZWHjyfYF4CvREZp05M4Fec8xMwobHX4G6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774606244; c=relaxed/simple;
	bh=/BZC//PSTPv2Qev40giwMEcM4HO+a/28ZT0Be2OKstM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=sWa+qcl2nqwhOYwrlpPipnx07fy/0Gm+VIOsLsY3pyJAuKFO5dfwrw/TmARkIllfWpCN9fDB/DiOp2Ghwu0S6Ko+y5gr4nYsEVR1Q2cIWuJ6C2VJk1eDvczHChBommjJz17F7iQIAsmWOyqicAXojhJejuPIRQzTHngxz7h7k3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=GfFh+6o1; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="GfFh+6o1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=IyH+TOy0qztrY0+q8jLQw20I+8xBNRRomt+FT6JRB8E=; b=GfFh+6o1vbhXf1nAAdywwyjkcc
	lnw/HHbE2IIEg3F/wmH9Igucia2RLG53rcM3p4YH+eQHyAju5IkuxKLVq8XHEa4bVSNLYq/W4E4oT
	GvzgEgiC5Pg286NEZxMEIeoCo0nl7q6SoUa4rGsjPfx/N/yVw7OAGF+Z82q8AVW+REbOQfpB/Cc0/
	xK5DBlAAUr1o1uTCS8Mvge+b5KRa5fbIzu9mWiFC1bU9QRz1toiYVi2XCpLHk1adX8zeGaeKf0vSP
	SB+Mt+y6xrSlETxVwZe5Xo6D4EdYySTn5GN4p+NEYirt7KKl6Za3NMOdUba09Dkn7BzxkXzWOwv0Q
	yC4/qtPA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w63jp-001bss-0b;
	Fri, 27 Mar 2026 18:10:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 19:10:40 +0900
Date: Fri, 27 Mar 2026 19:10:40 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto: inside-secure/eip93 - add missing address
 terminator character
Message-ID: <acZXoNafzrlOgx8F@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a50ac0c-11bc-47c0-9e4c-c098c80ccde7@yahoo.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Mieczyslaw Nalewaj <namiltd@yahoo.com> wrote:
> Add the missing > characters to the end of the email address
> 
> Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
> ---
> drivers/crypto/inside-secure/eip93/eip93-aead.c | 2 +-
> drivers/crypto/inside-secure/eip93/eip93-aead.h | 2 +-
> drivers/crypto/inside-secure/eip93/eip93-aes.h | 2 +-
> drivers/crypto/inside-secure/eip93/eip93-cipher.c | 2 +-
> drivers/crypto/inside-secure/eip93/eip93-cipher.h | 2 +-
> drivers/crypto/inside-secure/eip93/eip93-common.c | 2 +-
> drivers/crypto/inside-secure/eip93/eip93-common.h | 2 +-
> drivers/crypto/inside-secure/eip93/eip93-des.h | 2 +-
> drivers/crypto/inside-secure/eip93/eip93-hash.c | 2 +-
> drivers/crypto/inside-secure/eip93/eip93-hash.h | 2 +-
> drivers/crypto/inside-secure/eip93/eip93-main.c | 2 +-
> drivers/crypto/inside-secure/eip93/eip93-main.h | 2 +-
> drivers/crypto/inside-secure/eip93/eip93-regs.h | 2 +-
> 13 files changed, 13 insertions(+), 13 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
