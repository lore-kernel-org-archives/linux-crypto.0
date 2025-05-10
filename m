Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDEE13AA3C;
	Sat, 10 May 2025 09:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746867946; cv=none; b=QWJ0WYgE53SIi62gpqdM1hv70N4BXMWsQM08KSvyMQlFjG8c4FMGFosYtiI2mzSw13y9Yfq29IZtel5i7vzJMI8Hp323aICKNUrI+GaF3Ebd6IoFcyiFmOfgU+xtv2lcu9cIfzPGwPHVxBD4ErGPjefXgy9r6kjCW+b0ki6bZks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746867946; c=relaxed/simple;
	bh=7pPEpt1ZFjKyQHQAaquYgejiWLSjoSfy/kespplo5bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lku54611gt3pyGsn8yhIC1l+WlrJoKpc13zHCSe5D3QsO1EfpjTNnuwany36Nwsf90XXvtwGDMgWi3aBRmcXjwoK4kZ3h024NvTQQyg3MRMWjsIv5Xz9Dxlk3pwoy5IbGvTJTxScqKveP0ojYplsPyaahcZcdfYuSPdPx4fnazw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lCu1/nNh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lCu1/nNh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zG2CZ00hIij72Wfq75L5nm6s6AZFu66zk2JfVghbHw4=; b=lCu1/nNhbiJJRdSPbwFvj3OYGo
	NWOZF6zDpi1AdgQUSsqtApZBa+6ULLoCjif7xRqlE+Pkt+kewUmL0/EeEO9FaVY+/ZF64Hxsv3e6o
	CLag3jU0ZJcdFdmM1VBmkBUa38nQutBr+pNFKqhe10fQsrnLUdUBojz4GZtgjdYt5RguYWJV3Xsyk
	pulCPFdTe8HY4t5ZLsNqWRdeDcaKGvOfHXhZmrxfQtIBWgg1KZ9q+2zt8XJtkiiZHrIcINsIUBVe/
	Qq4tSycZXdx+sC9BTQOJLOznEaiTffnzHpw2EvsI0Ja8Y9EkiAhKeb8zznvkMhOm8/X6AI3g2JCuM
	iBt99fcw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uDg9K-0052ZL-1c;
	Sat, 10 May 2025 17:05:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 May 2025 17:05:38 +0800
Date: Sat, 10 May 2025 17:05:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [v3 PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
References: <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
 <Zw31JIEyh28vK9q7@gondor.apana.org.au>
 <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <dd55ba91a5aebce0e643cab5d57e4c87a006600f.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd55ba91a5aebce0e643cab5d57e4c87a006600f.camel@gmail.com>

On Sat, May 10, 2025 at 10:32:53AM +0200, Klaus Kudielka wrote:
>
> So, I am back at the hardware (armada-385-turris-omnia), and gave this patch a try.
> CONFIG_CRYPTO_DEV_MARVELL_CESA=m
> 
> Upon modprobe marvell-cesa, I get the following results.

Thanks, could you please try this patch which goes on top of the
previous v3 patch to disable chaining completely?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/marvell/cesa/tdma.c b/drivers/crypto/marvell/cesa/tdma.c
index 9b5fd957dde2..f4fe2a881f1e 100644
--- a/drivers/crypto/marvell/cesa/tdma.c
+++ b/drivers/crypto/marvell/cesa/tdma.c
@@ -123,7 +123,7 @@ void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
 	 * Break the DMA chain if the CESA_TDMA_BREAK_CHAIN is set on
 	 * the last element of the current chain.
 	 */
-	if (last->flags & CESA_TDMA_BREAK_CHAIN) {
+	if (1 || (last->flags & CESA_TDMA_BREAK_CHAIN)) {
 		engine->chain_sw.first = NULL;
 		engine->chain_sw.last = NULL;
 	}
