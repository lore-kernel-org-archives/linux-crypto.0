Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C3F3AEF5F
	for <linux-crypto@vger.kernel.org>; Sun, 13 Sep 2026 06:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789281479; cv=none; b=ZVZbEVhS55ILqw119gyEw3ER0kSjkGx5Rxauqg3tUOTk0BBKhWlbmxBVj2Tp9jYZ/9FoDGnN4b6GqW1es/zIfLH176TZdZkfLf7YnMks8rQpGqI7/E9VIu0sExh6J1/8qzgmzhqIZ7GkO+Lvfn/uO2HdB6rNlr1Jh1U60qI+F4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789281479; c=relaxed/simple;
	bh=KUYnTow+mDZRnB/aXIhDUlPUhAuwaV1TvnMLZvGLHXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezwgOo8U3obBcQcMyAKFDJjpzdgOuEqRPDz0NjA5AGFKJ9GVyPBVQQ1FpEg2MIni3ugu73XXxwfdyJTX/uiw0Ftl1aC7QEPUNnzisyPSnT6i4Ubwqmn8GphLF2f9WvzX1W4ixP1fw+JfOM8VJtjYwHV4+DwacUXoFdcjtq59hqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CF44E602B9; Sun, 13 Sep 2026 08:31:05 +0200 (CEST)
Date: Sun, 13 Sep 2026 08:31:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kadlec@netfilter.org, linux-crypto@vger.kernel.org
Subject: Re: [v5 PATCH] rhashtable: Add rhashtable_flush_and_free helper
Message-ID: <aqZDKbU0f8VGM0WC@strlen.de>
References: <aqUmlWEzhR3pKYuP@gondor.apana.org.au>
 <aqWazNYddvTO5Sjn@strlen.de>
 <aqXf46iXp4BhuPud@gondor.apana.org.au>
 <aqXqftkCP3Jv1CXK@gondor.apana.org.au>
 <aqX9l6vIJdzBSiUE@gondor.apana.org.au>
 <aqYQJlrjbxEgp4Y4@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqYQJlrjbxEgp4Y4@gondor.apana.org.au>

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> v5 makes the following changes:
> 
> - Add bucket_table dying flag to fix walker race.

Thanks, I will rebase my ipset patches on top of this
on monday and will get back to you,
