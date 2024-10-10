Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C39F1BD4F8;
	Thu, 10 Oct 2024 08:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728548687; cv=none; b=pH2hA+K+b0pyoWpspmoG7O1sBzd5mrxF5NAOVLYIkk8NXM/D4L8zFokF7Cf8RimNExG9kTfTQluH1vHmYDXwrHHMR9Qq3fBqAn/hy/oe3XiU/uLsRzys8kafDHzDLjWpqo5m/JRh+uGwQi7y9zR3CkzcW4Da4ykVPX7vrFhN3Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728548687; c=relaxed/simple;
	bh=FBagXwmoXvU7XXwjhgrbodhvH71mmVSljW1zLtYlQbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOcWYml2ps/B6rQ5NaX25gRwSLIRPrjmwXKh9bOsF9LMuSiso3ikjPQzomSEZJGybD0KoKwv/df3ppkjRBjjneGwNdhUZq16GWN7il2UNcn+5h4uNBK03jpYP7Diwjpx6f9zG3LyOv0kuwJ0Sf1TmRLPBL8G+cdES6pJkA4nA9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HNsPJU2Y; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HNsPJU2Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SIflBkcXF4BQ+o90EDUrROcjCvAZBUvwNPAzj7vSA/k=; b=HNsPJU2YSok6X8YnM21QTmqkeB
	pAEGCV/6cK+VGDq6aLJVh1C44gOmInPGKGMm3iFeN8QvE+MFRNUQ4U3e6BgU+DLtfE93tNoIeVwnA
	MiWQzjGjntwLV1Etk7DmOmHB0lwAT5jvMi7kn8R2lf/LTbwX7fA5YCEAG3daGGkRrDAcg6Ps3mILU
	K9TZaIJeXBNqb9NYfzVSuakgU6UZpUpmf6nnBDOjeUsOiAT6DO6TwhSes53FlQaDgDzALBaNMJ5nb
	P8kZaPRwGTxypFtVko7YqnwywoZ9ORlsetcUCc/DmNDKHu/qvzJpBXmpFUOkRD+wHn5RlubSuyomr
	rc6oXwQQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1syoJW-008H4W-1g;
	Thu, 10 Oct 2024 16:24:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2024 16:24:40 +0800
Date: Thu, 10 Oct 2024 16:24:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
Message-ID: <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
References: <ZwJUO5Nz3S7EeqO6@gondor.apana.org.au>
 <1fc4db6269245de4c626f029a46efef246ee7232.camel@gmail.com>
 <ZwObXYVHJlBaKuj2@gondor.apana.org.au>
 <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
 <ZwZAExmK52txvHE8@gondor.apana.org.au>
 <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>
 <ZwduxHxQtHdzz-kl@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwduxHxQtHdzz-kl@gondor.apana.org.au>

On Thu, Oct 10, 2024 at 02:05:56PM +0800, Herbert Xu wrote:
>
> Is it really OK to add new entries to the chain after it has been
> given over to the hardware?

Please give this patch a try to see if it improves the hashing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/marvell/cesa/tdma.c b/drivers/crypto/marvell/cesa/tdma.c
index 388a06e180d6..0de99fa6c1f5 100644
--- a/drivers/crypto/marvell/cesa/tdma.c
+++ b/drivers/crypto/marvell/cesa/tdma.c
@@ -113,6 +113,7 @@ void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
 		 * the request.
 		 */
 		if (!(last->flags & CESA_TDMA_BREAK_CHAIN) &&
+		    0 &&
 		    !(dreq->chain.first->flags & CESA_TDMA_SET_STATE))
 			last->next_dma = cpu_to_le32(dreq->chain.first->cur_dma);
 	}
