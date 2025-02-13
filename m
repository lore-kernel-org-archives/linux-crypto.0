Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C56770810;
	Thu, 13 Feb 2025 04:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420270; cv=none; b=Ti2I1reFwaA993tcx0/gd3Y11aV/xT2uEP2Vn07uCJjv4F4mW6Fodokx9gKX6y+j657FHgIKGMtAPGCIEODxvwASkZrhxk3SjvocYVoTI0uuzeB4vqVJ5wyppbSlUjZBIQ/ScYfEN52X+L5zhACTGfYYDhScU08KJrGOQsGcM9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420270; c=relaxed/simple;
	bh=2vwtRaY8rOUQYf6eoQ/uOWinMGiyPsh+rWgpCkv21aM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LmVRHWW6232Der1AGCn6oExEds2ffc8Z9lU8Z2ZvL4lcj8ax7E9S6AZQ76pQS+4BXcvSUQ7NWNfm3kinE3uHX+1gg73WzwTKsY2wrQbwbvjf5cIbJUABXz2YOzR8UIWn19Rvqz63jUA9ZHOU7aDbK+nmtvF4TUsdjZslJbUs4EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TaY0sHpQ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TaY0sHpQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RgLeQjspT74MnPRQdy/BnqqUlzDaDSRUeORQX7ILuZ4=; b=TaY0sHpQhYJBJrGuUjHmblyVsO
	3nfjIPVNgsz8aIXvokaa92wEtUvu6saTV3ZV/dCn6ESly8nM5nUtYyd+mOiS0dRnM9UXsjdfzQqOz
	zT/JPVvmkDkVqNUaKciZW/VOCHjwe1SoFFjtIazL8O01ndlR1Z3IJSj2h9FBnbxlz5Uf4WSA/Etzq
	PaBGIc6KQx4hJc3RFBkEtZqr/uN1GFAbjE/NKD7pUsIxJwXlocDPZPiU6fgkZRV2a7NouI4rmyALJ
	fyw5cZu+GkRkbLvb5bVRSt3t8ga5fv8vo8ter49SAHAAnishj/tIELSXsclqrf15tkeHsv7MlxCqX
	DeyzhKxg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tiQSb-00HUzh-1W;
	Thu, 13 Feb 2025 12:17:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Feb 2025 12:17:42 +0800
Date: Thu, 13 Feb 2025 12:17:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: fsverity@lists.linux.dev, linux-crypto@vger.kernel.org,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v8 0/7] Optimize dm-verity and fsverity using multibuffer
 hashing
Message-ID: <Z61yZjslWKmDGE_t@gondor.apana.org.au>
References: <20250212154718.44255-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212154718.44255-1-ebiggers@kernel.org>

On Wed, Feb 12, 2025 at 07:47:11AM -0800, Eric Biggers wrote:
> [ This patchset keeps getting rejected by Herbert, who prefers a
>   complex, buggy, and slow alternative that shoehorns CPU-based hashing
>   into the asynchronous hash API which is designed for off-CPU offload:
>   https://lore.kernel.org/linux-crypto/cover.1730021644.git.herbert@gondor.apana.org.au/
>   This patchset is a much better way to do it though, and I've already
>   been maintaining it downstream as it would not be reasonable to go the
>   asynchronous hash route instead.  Let me know if there are any
>   objections to me taking this patchset through the fsverity tree, or at
>   least patches 1-5 as the dm-verity patches could go in separately. ]

Yes I object.  While I very much like this idea of parallel hashing
that you're introducing, shoehorning it into shash is restricting
this to storage-based users.

Networking is equally able to benefit from paralell hashing, and
parallel crypto (in particular, AEAD) in general.  In fact, both
TLS and IPsec can benefit directly from bulk submission instead
of the current scheme where a single packet is processed at a time.

But thanks for the reminder and I will be posting my patches
soon.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
