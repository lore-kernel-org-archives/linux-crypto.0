Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8355383;
	Sun, 23 Feb 2025 03:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740281958; cv=none; b=qEl3U1HxuzorVVBZAJ8Gdo/cwRqJL8CTJdVOJLtiJScnO/L8NHu5drqoB3Lqrixpj0IYORJ8im2cP7ioBMiWLdKNWt1x1RcKBTerui//r8CgYH/SDlDYAozytAdKK7MIUCBOzSciSdWwxZxS2/rSdiDvPvN7ozNe0EM0FS3tHt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740281958; c=relaxed/simple;
	bh=eamp+rGjGq0gF51FcwqJWHpsA8oZ0Lm+OOOQj8lo5gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CmEMrtHjgK0oeSpqwoCVohfvB67f9dYXJoJcD97Hnq9Atlj2H4WGC8P0uCRUZH/rxbH6cK9YPAZhsVbDgt3HAV+t158+kYY3WvolqAB89SRl8ky+s0r0UwbWKhurJxY2u4nKr7IiSLsGG036McMz3NjoA+OeoVWsTZrReL5eJrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=o43E/SPJ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="o43E/SPJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=inMAqLykdkLVqUlvbXLCaPY7up9uFvAXIhqrJX83y7s=; b=o43E/SPJL6tIZouDL5DLBOuz4f
	0fiqNxq4PiXn3GV1FB3nHWE/goITIN55iceOiF/Eu3yHhDaL8woQZZSoaMegw1H2Y6thyucjxi7cl
	XXeoddwNHOUqoNpbcLumoQSfcK201BKzLpSYcd5ktJJDmJtrUF/+6Lu6bwYG/XFUX5+dtJoeiI6tz
	9FVkXRNIgVtoMibBdyIEwOQ3ctl9SJCKjVjBpukkjf5cBCSU3DU8OrARH9/s027F9IBY8Twer01/A
	L6hf/elwtQvT6NdfwKYk9IR6cRlttPmSJFrWrOhx4vQumTU9tnmiMv/ZUQ3UYf23pZnGyT/qw9dhv
	2H0geh8A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tm2pU-000xZl-04;
	Sun, 23 Feb 2025 11:38:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 23 Feb 2025 11:38:56 +0800
Date: Sun, 23 Feb 2025 11:38:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Barry Song <21cnbao@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Minchan Kim <minchan@kernel.org>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Message-ID: <Z7qYUCAqh2YFQ908@gondor.apana.org.au>
References: <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au>
 <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>
 <lu3j2kr3m2b53ze2covbywh6a7vvrscbkoplwnq4ov24g2cfso@572bdcsobd4a>
 <Z7poTnlv-1DStRZQ@gondor.apana.org.au>
 <u7t7gibspxu3lujdl4hambr72qd6o5u33udbojihngznlyistk@gmyyhwjuiwxc>
 <Z7qNf4NerHrflmfV@gondor.apana.org.au>
 <cxspxz5jeiigd34cl7x3asyx4lowefjpffj3ip4mwpxdwh34e6@xzpqbmlihbcg>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cxspxz5jeiigd34cl7x3asyx4lowefjpffj3ip4mwpxdwh34e6@xzpqbmlihbcg>

On Sun, Feb 23, 2025 at 12:12:47PM +0900, Sergey Senozhatsky wrote:
>
> > > It also seems that there is no common way of reporting dst_but overflow.
> > > Some algos return -ENOSPC immediately, some don't return anything at all,
> > > and deflate does it's own thing - there are these places where they see
> > > they are out of out space but they Z_OK it
> > > 
> > > if (s->pending != 0) {
> > > 	flush_pending(strm);
> > > 	if (strm->avail_out == 0) {
> > > 		/* Since avail_out is 0, deflate will be called again with
> > > 		 * more output space, but possibly with both pending and
> > > 		 * avail_in equal to zero. There won't be anything to do,
> > > 		 * but this is not an error situation so make sure we
> > > 		 * return OK instead of BUF_ERROR at next call of deflate:
> > > 		 */
> > > 		s->last_flush = -1;
> > > 		return Z_OK;
> > > 	}
> > > }
> > 
> > Z_OK is actually an error, see crypto/deflate.c:
> 
> I saw Z_STREAM_END, but deflate states "this is not an error" and
> there are more places like this.

That would be a serious bug in deflate.  Where did you see it
return Z_STREAM_END in case of an overrun or error?

> So it will ENOSPC all errors, not sure how good that is.  We also
> have lz4/lz4hc that return the number of bytes "(((char *)op) - dest)"
> if successful and 0 otherwise.  So any error is 0. dst_buf overrun
> is also 0, impossible to tell the difference, again not sure if we
> can just ENOSPC.

I'm talking about the Crypto API calling convention.  Individual
compression libraries obviously have vastly different calling
conventions.

In the Crypto API, lz4 will return -EINVAL:

	int out_len = LZ4_compress_default(src, dst,
		slen, *dlen, ctx);

	if (!out_len)
		return -EINVAL;

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
