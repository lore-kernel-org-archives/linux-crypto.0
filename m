Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F452182B7;
	Sat, 10 May 2025 01:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746839758; cv=none; b=oHOvwF71hRAhE6BAFRVFkjhIaeEK3ZndlJ0BOTp4+bb+ibTtsOIu15sdW1wSeomE2yUo22AaRp+m8sYqe9M8Hdy2WqopYREfHNsoJjom70DObz71d+bXdbUdkZdKLelXgEwNiSoWJG0otaYLG1b8faxrPSSHVdIeuoywJQdSQRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746839758; c=relaxed/simple;
	bh=xN0mI61CCbjnAJidvm6mc6MGIf/12yeUoebdZTQCqlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pd77gWjZUrcUI54QcTF6/jQXPGPvCgmcI5yfT0xpTKz8k7FfnHu2tUlaHGkB8Z2UL2NlETgXfXO5ybSAO+kahP5BKtVPY5XnYKPCRRXGiJsC0saxw2b3tqtAjiLFOXb/kJQ2Quryv0cd+Xhf31GgOyeCzRBww6Y/REYRVKyP45g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=m8Yv/WHl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="m8Yv/WHl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=m8sGDlkRh33ccPPEleeEdQLuAYEDzwIyT5J4abnEPMM=; b=m8Yv/WHlhJLCaTyet3GNUzbcyC
	cX/Uq8XbMEc08s/Qi/Xk/jAexzEGqJfYLuLrDeWfBNxKcfQXQ6wcAD8ZPKqY86xfPFiQ3clha935x
	E6SEgLQ8JU4GsftdgCbs2YxJUva/yomzMYxVTfDXJsEL1BzJU0o9RtwtKyKOKH6A0IBpt/tBH0hEQ
	I6t4JrnMh3J50Wm6cRhHrnaTcbuoMECnNLIUgcp+WAOWqzVnz/EmO+j2W/O0YKxivkB8yw/RlcHQK
	Cj/qi9Nm2zJaleEPxdVThtLhIamhZ5aWJZI70o22rxAVfVEftZyKFdJJIngLVSkBVjkGvvSOegSg6
	A32AqzOA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uDYog-004zdh-2a;
	Sat, 10 May 2025 09:15:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 May 2025 09:15:50 +0800
Date: Sat, 10 May 2025 09:15:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [v3 PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aB6oxlR6DINIvdLM@gondor.apana.org.au>
References: <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <aBypVwhHHzmqqN5K@Red>
 <aBytNdRyd5Ywh1Pq@gondor.apana.org.au>
 <aBy06xyzh5kKC48a@Red>
 <aB10PqZNk0L-ly70@gondor.apana.org.au>
 <aB24nSeEJKtP1bO_@gondor.apana.org.au>
 <aB3ggeQDdaPblUxi@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB3ggeQDdaPblUxi@Red>

On Fri, May 09, 2025 at 01:01:21PM +0200, Corentin Labbe wrote:
>
> Got http://kernel.montjoie.ovh/478064.log

OK it seems to go further, but that might just because the first
few tests get done with no concurrency.

I see some bugs in the driver with regards to zero-length updates,
but I'm at a loss as to why that would only make a difference when
run concurrently.

Please add this patch on top of the previous patch.  It disables
chaining altogether between requests.

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
