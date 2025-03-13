Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCAAF50F
	for <linux-crypto@vger.kernel.org>; Thu, 13 Mar 2025 04:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741838695; cv=none; b=YrcAwHpVBL1/195jxbZ95G09PsuylrG2Pi6f9Rzxvi98jaxNwNzHUX2UUWBebkjraDyqGjJkyjJHFplQmOlFsqyyWmVX1xOtmF+DJ3m+IfAWl2YCw//m7qeOrfSRJgSKAlf6cFITN8r9YXrvmiSE2XYv2jNNJPVszdVSIWeA8LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741838695; c=relaxed/simple;
	bh=foLqHG49dBhWU7AChGGYluLQ6C+RFm1bY8WSgT9TO54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6m/yQOke9D9iKscZDZ5FKCWSOeH+1zKAR87k9w6RFRZdBdJcFo6gkpeFFtCllxxtj875VRwzSMetyUappD/UvgjO6ohTKLHlL4T+FIsYdtwqN2wJnfiD2eaTZN1vIcYikz/hirg5k5mxCHOOM0mWT3fq4ra5ra5/bKi6fssPww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=I120gmsi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="I120gmsi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=e+hp5gcRCIMiWtyx6MemQTDk4Q1CwE0k5qqEKBgDp5Q=; b=I120gmsizuPfMZP0Ig8Iq5XpLa
	+8TreMzB0uc85F4opxRrv68+mEpivKru9wrZz5/NCe8GXby2sbaOyZj1HPY3RA7QNdeGBjEN5xate
	BAU2fdYgHRKRW3MVN57vqXl526cDQFhYdmLGiJVjKoLkhsm2n/yK04enFL7dM5qd/Bq2j1Qmum31A
	+QtRai9nFhPFcfRGiHmba8mih1AASb5qJplyvHO+FWKlG0R+eQjpmP5pJL/4EosjRE6PPyvd0hlMi
	dP/HLnV3frTTn0YQHA7HwNO61uZXke0JXT6dZ9xVmtTyOU/bTfDogz5wGqbs05XQRTaa42Xwg8m9m
	U13Qdh6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsZoO-0067mB-33;
	Thu, 13 Mar 2025 12:04:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Mar 2025 12:04:48 +0800
Date: Thu, 13 Mar 2025 12:04:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 2/2] crypto: hash - Use nth_page instead of doing it
 by hand
Message-ID: <Z9JZYJ3kGEREcgb4@gondor.apana.org.au>
References: <cover.1741753576.git.herbert@gondor.apana.org.au>
 <a68366725ab6130fea3a5e3257e92c8109b7f86a.1741753576.git.herbert@gondor.apana.org.au>
 <20250312200908.GB1621@sol.localdomain>
 <Z9JEvCT-3Q6BUnOt@gondor.apana.org.au>
 <20250313030741.GA2806970@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313030741.GA2806970@google.com>

On Thu, Mar 13, 2025 at 03:07:41AM +0000, Eric Biggers wrote:
>
> Actually the block layer avoids this edge case.  See the comment above struct
> bio_vec, and the corresponding code in bvec_try_merge_page():
> 
>         if (bv->bv_page + bv_end / PAGE_SIZE != page + off / PAGE_SIZE)
>                 return false;

Well spotted.  It looks like block scatterlists don't need nth_page:

commit 52d52d1c98a90cfe860b83498e4b6074aad95c15
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Apr 11 08:23:31 2019 +0200

    block: only allow contiguous page structs in a bio_vec

That still leaves the question as to why folios are using nth_page
for folio_page.  It seems that the only reason is that the same
function is also used by folio_next, which can cross boundaries.

So I will get rid of the nth_page changes, and steer clear of
folio_page too.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
