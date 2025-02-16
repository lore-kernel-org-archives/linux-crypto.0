Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCEE179A3;
	Sun, 16 Feb 2025 05:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739683097; cv=none; b=D4KqfAxijtYb3dpKchT8xIKtjaQQtMc0sQDhEKtQ5UlPmp4sKaghHf6n3ZyJq5UegRt1dWCqLhYsW8h8UxJX9oT10MGXQnuWpzUcLIj5UrERyBBCNVQVcNFDixF05jdMRVw50CMiniSRxXF5hqp6hQ3yqWhZUC0SxljOCZXVtPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739683097; c=relaxed/simple;
	bh=J3YRkeUJbkUD7s4CL23jRSB4nTtO4czaU9StexrGbL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bBJKg/u+Mud+qa72hr0UTpXyWiXxS0Ekq0Fhq+8N/8rh8R+X8KONNZvAD1wr7VmkVRaWg0b7SRYvUjKKyg1KXDkiAM6Cuw6SOkBovi7peE9IuPKGc3dgk3ABJ1nA2g4qVwesXqnDMgxtbSMrebEXalPKuRIKQ8hrZroPdWHCi8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BF119Psl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BF119Psl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ltEpkMdVnehiq7zLE8+9J4AaK7cG1Lq4CxOYTIUDLdE=; b=BF119PslGUH+jXcMNSUETyYs9g
	/ptsvgS/sC5LGW582/ION2X6TuFq7iyZwLbebQJbChHf3cBNq56Jwi3/CdbEJjSVjsEUxfZy9C24k
	TraTZLmex7rDI2ezduRt2ZcoASF0y6CQx1U7ToyM9WxIucbexMeVf8thZn6o0xejSf3Bc4uvWPtqv
	XSKTUJ7znWqxI4SAdgpwxatW8TFDAGLB9xpI3XL80s5XK1jHDaEXpiHBS78wlRRrxL3Af+ISVgXsM
	fhg7cbCU/qs16aK3CaFvaVUq2yfPRC/vsziEvRmx30UeMWLi/vFryavb7wqo7qQFvJW9fEEujrbOE
	yWIx+5Yw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjWpa-000hHM-1O;
	Sun, 16 Feb 2025 13:18:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 13:17:59 +0800
Date: Sun, 16 Feb 2025 13:17:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
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
Message-ID: <Z7F1B_blIbByYBzz@gondor.apana.org.au>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-3-kanchana.p.sridhar@intel.com>
 <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
 <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
 <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>

On Mon, Jan 06, 2025 at 07:10:53PM -0800, Yosry Ahmed wrote:
>
> The main problem is memory usage. Zswap needs a PAGE_SIZE*2-sized
> buffer for each request on each CPU. We preallocate these buffers to
> avoid trying to allocate this much memory in the reclaim path (i.e.
> potentially allocating two pages to reclaim one).

Actually this PAGE_SIZE * 2 thing baffles me.  Why would you
allocate more memory than the input? The comment says that it's
because certain hardware accelerators will disregard the output
buffer length, but surely that's just a bug in the driver?

Which driver does this? We should fix it or remove it if it's
writing output with no regard to the maximum length.

You should only ever need PAGE_SIZE for the output buffer, if
the output exceeds that then just fail the compression.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
