Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A82E1E492;
	Tue, 20 May 2025 02:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747708400; cv=none; b=C4gE2BLT6G7TBP0O7jiM1MCaf76u9TfL0VBFNwVKCUrah+fZcOByEgVNYXkmuo/PUD4BJyO2SEpJxrrDHlpe/ZUUOKf3rBXjQ37iBb97LPOeEWJdyf183q20ZNJ3wpdBMtPmWBCI2Msoazr2IAxi/oYzBS7z+WyIA+7KJY4DDLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747708400; c=relaxed/simple;
	bh=iMvC6LEFdL/yVigSsxnamE3yMYtB8hNKM1p6zBXeaIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uNX0ex1PblsAG6fS/PKWtTF8FhXl7hOiI/DeeVqodw9WS452gbQ6ZMF27uh3HHxMr1+Z/OwweVPimJ8sdG8BLuvhR/gSZZ1dgb2kavwFTk52T0uGHNqmTxn07Nb8Lbyh65eJN81/SsBq+YUaMiG/trA+QI2LeIda75djhjeoD/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GSq1gQaS; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GSq1gQaS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IEJHYJRcBOOza6rnvYFfZ2/r4z4MC7ZuTGxku3UCA20=; b=GSq1gQaSwNftG4++AamXlDNuuy
	9e4L+errUG6Td7f0476kvuoYb/r3mNg1qFayKHloRI4jbRqpoKRihYSOsxk+wEKFtEUSADpdMgsW8
	tSsqVHOSLgwFQ2o8M5PzQ2vRS5DdgfpOxVC1m/4AZ2EzkddeIoCoiCUM4xOMGi1+txrnRMot0TEpN
	rfEypLHd+j2TP9MzR5j51vxI8M4UQBVHHDSx7YPj8H97KXy27lAuddWfQvNSeRH4N6Cwv0ZB+cFnD
	FviYyalTnpV3QfSHcb6tV9HuHNCZ6PqgX25+nKCSMlzdxn1rFn4k5xmKs07IwxwWiGuD5Q+je4pEI
	/Oz7E8Nw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uHCmk-007Ox5-2x;
	Tue, 20 May 2025 10:32:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 20 May 2025 10:32:54 +0800
Date: Tue, 20 May 2025 10:32:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, naveen@kernel.org,
	dtsen@linux.ibm.com, segher@kernel.crashing.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: powerpc/poly1305 - add depends on BROKEN for now
Message-ID: <aCvp1rzh2vV9L4g_@gondor.apana.org.au>
References: <20250514051847.193996-1-ebiggers@kernel.org>
 <aCRlU0J7QoSJs5sy@gondor.apana.org.au>
 <20250514162933.GB1236@sol>
 <aCVNG2lm9x9dzu6x@gondor.apana.org.au>
 <02c22854-eebf-4ad1-b89e-8c2b65ab8236@csgroup.eu>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02c22854-eebf-4ad1-b89e-8c2b65ab8236@csgroup.eu>

On Mon, May 19, 2025 at 03:55:16PM +0200, Christophe Leroy wrote:
> 
> As far as I can see related patches found in linux-next tree were not sent
> to linuxppc-dev@lists.ozlabs.org.

I just checked and it was definitely sent to linuxppc-dev:

Cc: oe-kbuild-all@lists.linux.dev, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Venkat Rao Bagalkote <venkat88@linux.ibm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Danny Tsen <dtsen@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, Michael Ellerman <mpe@ellerman.id.au>

> Could you resend them, and split out the introduction of
> CONFIG_ARCH_SUPPORTS_INT128 from other parts of patch "crypto:
> powerpc/poly1305 - Add SIMD fallback" and add the lib/tishift.S in the patch
> which adds CONFIG_ARCH_SUPPORTS_INT128 ?

I'll just revert them and mark powerpc/poly1305 as broken.  You
guys can sort it out later.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
