Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EF814A0B8;
	Sat, 26 Oct 2024 06:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925679; cv=none; b=PKlXjH849yyDzDtyCT8/OLZfgb7xTUoMQZQoUcb1oycVK3Pxz69+X2l/zIjh591Qk68ZtS03tpZeANwgpvzTUmBFo+V7yedONsWQ5f5IfIxvjQfEwQ9jYGcJJaf6VVfuD7x4EABr5P2Dy6Mx9n40dtjkE6sOyTHJlOuJaBtWoZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925679; c=relaxed/simple;
	bh=gOMlkacdNMk2lVv/Nv7KkYd2BJCDDRftJTmzbQD7kik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P7V0IlVzrNle97jCTJnYtf2t4MWDeKHMc9dIunhFRNabuFjLGIXHaD8ZQlO7lxBaF9+HnngUjYHewmfIEu0KQfQtkNiV+M8TMe3DfSJRN9rbIb9JMNB7dCNGMu5RgM8gcR8N5hnr3b/SQgEkR/vUrh1n9CuxzgpnfvMrnZ7Ffxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=J663dotr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="J663dotr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dMbiS79IRWkAjW+tIrkhW4M9vtmrftvVQ8uN7qrKRsg=; b=J663dotrqKoH+Ubl5Kih8StJn4
	ZDlkJ63soehxCJgpW74JjsMXip25dUteBV+Onjt4DKJj/S8HTzRZ8ByywvcQIOa9JL/SwugxnEtYz
	aV4PE6/zWDPp/7rxH/CKTiNvUXtxwndEPxycbjZCzmUfcn+FBYaFvZDUHzHBHqRLwyxQaYh4cR4fa
	E8hUw4TNNZFzZ0yVgU8tI8UMV5C23F4tmvVge/QNFcDyoxlzBzkE2cHpijm1gC6+spb7hQzkSX6wU
	lBBVleqreIWdGdgbOGp5I2Ka55Wmw9h6bYOwxNGYkILVvzn4jnHopoWMAdzIMb5rDrp8wJsn5wZ17
	HCY2B99Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4agd-00CFso-2F;
	Sat, 26 Oct 2024 14:54:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:54:11 +0800
Date: Sat, 26 Oct 2024 14:54:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Marsden <greg.marsden@oracle.com>,
	Ivan Ivanov <ivan.ivanov@suse.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Matthias Brugger <mbrugger@suse.com>,
	Miroslav Benes <mbenes@suse.cz>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 20/57] crypto: Remove PAGE_SIZE compile-time
 constant assumption
Message-ID: <ZxySE1gdlTxV3OXO@gondor.apana.org.au>
References: <20241014105514.3206191-1-ryan.roberts@arm.com>
 <20241014105912.3207374-1-ryan.roberts@arm.com>
 <20241014105912.3207374-20-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014105912.3207374-20-ryan.roberts@arm.com>

On Mon, Oct 14, 2024 at 11:58:27AM +0100, Ryan Roberts wrote:
> To prepare for supporting boot-time page size selection, refactor code
> to remove assumptions about PAGE_SIZE being compile-time constant. Code
> intended to be equivalent when compile-time page size is active.
> 
> Updated BUILD_BUG_ON() to test against limit.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
> 
> ***NOTE***
> Any confused maintainers may want to read the cover note here for context:
> https://lore.kernel.org/all/20241014105514.3206191-1-ryan.roberts@arm.com/
> 
>  crypto/lskcipher.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
