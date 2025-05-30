Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E6522B8AD;
	Fri, 30 May 2025 12:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748609998; cv=none; b=hpdAqXJvMHmgJ8M3cI8HELV3rtleh7OfEts1NhBHDPsdKpkGY3EqwS6kKTkWZSmMi08NyGc9xS+mU+xt9ThEg/i2WtSCj/Ip6GOiI7EizhXckOZlaYhMgGV5emDcuEmcER2MAESzLR/31ZtF4s/io+OTtkWW0lwwsUdsi3zudJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748609998; c=relaxed/simple;
	bh=KOBGBR8x5nfHMAnS4nMsN6ItLvjcfgagIx2ImOBsU20=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=umgsbH7XZ+gIDwEJNNhhjGDUpYRxBfz5XbnfxJaOjBNM+YiwfqDZYJA9MVyruexO8vL1JlplmS3UKVicapt8RXwFKfnPWfyig1sctUwR8MnQ7IWJ1+LIT+Cgtmdm+XT2N2RlGuiPnRN50dSZoGIdMvey4CbzbeLoFedk2VaHy14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YBPvQT7B; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YBPvQT7B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=v0IgLp7bt6IrYT2OAXA8VhjjXLDapIFwTFBETrBLiwk=; b=YBPvQT7B53CmzaRy9izbxWSoZ6
	RPz4eTReuNSJRCgofAIsfjRQPgbVDS4Q0R6ftd8FWqK3yELwaJSiOlpJU+sS4jTkW6JYiahb7bOHu
	U18NqLu1LtjpTN6xfro0O8VyHBsBrvHd9BIpgwKQMWFtTvT9nx5gj2jVTH8DTuyG0hkPCWqJdkZyF
	jjHKcjqjwb5/Thoj4gQOqxLJ7EbA5znl/FySoYCQ9Vo+0m0uq+SBVzbZjIGx9POCVMATCsuIQJa0J
	8AjhMfNfpQyNFgJoorQFug/Pzud90th+75noVjTE9uJNS0IQjZT7fn+q+cfZghdXOrfhoIrdApPcw
	naPtWxCg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uKzKv-009mtH-2l;
	Fri, 30 May 2025 20:59:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 May 2025 20:59:49 +0800
Date: Fri, 30 May 2025 20:59:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, alex.williamson@redhat.com
Subject: Re: [PATCH] crypto: s390/sha256 - rename module to sha256-s390
Message-ID: <aDmrxfjlKTqKnEIC@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250529185913.25091-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When the s390 SHA-256 code is built as a loadable module, name it
> sha256-s390.ko instead of sha256.ko.  This avoids a module name
> collision with crypto/sha256.ko and makes it consistent with the other
> architectures.
> 
> We should consider making a single module provide all the SHA-256
> library code, which would prevent issues like this.  But for now this is
> the fix that's needed.
> 
> Fixes: b9eac03edcf8 ("crypto: s390/sha256 - implement library instead of shash")
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Closes: https://lore.kernel.org/r/20250529110526.6d2959a9.alex.williamson@redhat.com/
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/s390/lib/crypto/Makefile | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
