Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D2D192D64;
	Tue,  3 Dec 2024 08:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733215853; cv=none; b=Q21AAfqwwWHSwYXqOUdZyYZn/IP1WifO1ngO6vUd4XuwoPco1ybu1p9nWdUsKZrysVu4Jqi8C4+eL1FEKQ6lIAdj5CTrAf0U9m6ABkDv8slZW6zMtFqgtSloFEtyGrSPDHeqoxT5XS31NLK1/81SoWgdlCSrXW0zHcoIQfADzXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733215853; c=relaxed/simple;
	bh=V9mE91uJU38RWrFIrEtW2u16C+OaUZHHwy6JCoVZGP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0C2JX6vxS0ATRr3YAbu045OZGyXUhBxliHa5rzKj2ZisdsINLJoD3WJTsry9zzsnYiY8feoQbsXSQRUHuGEV6RDIUERO9bM56UIUbBm+pirYlMl5WWkmsuOzqZo187lNz5HW2K0GHxKfmT/AGYrap8tkuFyFUOxeJTQg03PI0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BhgBw16W; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BhgBw16W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jJYA7Tj+Zo3Z3yF+IwYyaS7Puyr19q55Ek5JTHaOGp0=; b=BhgBw16Wy52oNykb/IRpz0izPA
	UCV4vvucnJPrqSe6VYmcV3f/Nh3MruSDFwNP9KqfsjWD4DkXPzzHQKuXHeLF2v1DmDfOVauX2tC+t
	fKuYMr0hRZG5R2Yr7dOQVvV9rSprqgUw7R3fHZ3I3Zj/Ot8RK9ZqWQvf/PK7BcIo0FdsHvdTJE9v2
	7bsyTQclErrzwQCFxWe3Up4leN5G7+xpcm7ZnGQQg++H+RX5Jufjqg3L+8/34DfA3WYWRK9waQaws
	/Ax86fACCYe/w1zzDsZRbf5euX/lUXIt8+YKac4jWempX5GFBtZqjrUlMMp0D+8Fc9vNSbaBPq/wD
	t8CAIlaQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tIOcE-0038VG-3B;
	Tue, 03 Dec 2024 16:50:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Dec 2024 16:50:42 +0800
Date: Tue, 3 Dec 2024 16:50:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: davem@davemloft.net, dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v6 2/2] s390/crypto: New s390 specific protected key hash
 phmac
Message-ID: <Z07GYlVeohJJyLNE@gondor.apana.org.au>
References: <20241129111059.303905-1-freude@linux.ibm.com>
 <20241129111059.303905-3-freude@linux.ibm.com>
 <Z0nUQQ9E32xq0SY4@gondor.apana.org.au>
 <c86548e680a151394fa814f543103481@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c86548e680a151394fa814f543103481@linux.ibm.com>

On Mon, Dec 02, 2024 at 06:25:22PM +0100, Harald Freudenberger wrote:
>
> - The attempt to derive a protected key usable by the cpacf instructions
>   depends of the raw key material used. For 'clear key' material the
>   derivation process is a simple instruction which can't fail.
>   A more preferred way however is to use 'secure key' material which
>   is transferred to a crypto card and then re-wrapped to be usable
>   with cpacf instructions. This requires communication with a crypto
>   card and thus may fail - because there is no card at all or there
>   is temporarily no card available or the card is in bad state. If there
>   is no usable card the AP bus returns -EBUSY at the pkey_key2protkey()
>   function and triggers an asynchronous bus scan. As long as this scan
>   is running (usually about 100ms or so) the -EBUSY is returned to indicate
>   that the caller should retry "later". Other states are covered with
>   other return codes like ENODEV or EIO and the caller is not supposed
>   to loop but should fail. When there is no accessible hardware available
>   to derive a protected key either the user or the admin broke something
>   or something went really the bad way and then there is no help but the
>   storage device must fail.

Thanks for the explanation.  I think it's fair enough to fail an
op if the hardware is absent or broken.

So all I need is for you to turn the BUSY case into a delayed retry
and I think that should be good enough.

> - Do I get you right, that a completion is ok? I always had the impression
>   that waiting on a completion is also a sleeping act and thus not allowed?

No, what I mean is that if you get an EBUSY, you should return
-EINPROGRESS to indicate that the operation is pending, and then
schedule a delayed work to retry the operation.  When the retry
fails or succeeds, it should invoke the callback with the correct
error status.

If the retry gets EBUSY again, then schedule another delayed
work, or fail permanently by invoking the callback if you hit
some sort of threshold like your existing limit of 3.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
