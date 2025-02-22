Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0298B1EE00F;
	Sat, 22 Feb 2025 06:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740207156; cv=none; b=LKfv9IKUQ0vt13T5gaWsTk8eXthRbFzZ9L6ROoI1Sn3yXd/k/JQT0TbgNJLmQJt+T2vsxtc4s38hxrEmfxHgdm2fZM/Im0JMM/892P5w8kFm4M1fI3nXqK9q8951DOG+Go5w3cSRqdHNUA5nqQBqraAqkTwCQNfCAKf/9kGkaPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740207156; c=relaxed/simple;
	bh=ZDvEsN3suVBVEdHYn5ok6BHD4FxoDJzquryTKsexVLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=srYhV2KbrfnvvbUIolvNu6MCQXRUfvF7zDplIq4ftxo6nSYAi2ByO+1K6B5rrjmUWZD0OEYLyZyTNRAvPdUJ+BHfFaQWjsew+j1B9qv9ur3yHhWb2xxnV8qd0tAsnp1u0+SEwGSud0qLZY/xeK3Y/kYdg/qnkmkt5/2mUfZ/oJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Xtj7E3Db; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Xtj7E3Db"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vH6uKMiru79pBM9Dw2poMCcKEhUxww0lUrrWo/rOx9Y=; b=Xtj7E3DbS3hHJD1tZ87VKCTV3p
	JuQhXlGdKzu57R0nZgITqHg5Cv3JWu8HDwqteL84+u6czSsgh//rzTsRm8aaQntmeD8dLIz8FkeZt
	EP6ZBvpQD1WDb26XqepFO+jiGtB3FWSccUhk4Xty4k60ciyOXDBFhlhxlTEia+dhrAiIJnvmcZ82X
	cHARuil+56CDJD9z/2Tld1AnPyQ+gBes/dPYX2JQoM7nKq4hqsUExaXPQLMVf2jjAHsfpOLmyzChq
	H37Hyax3cJPh04bu0IZknbNGs5CZ26X+3YwyQ01IsZSGmZvsZ+0OEdLywfNn+WV8tXgGmytkXaRhG
	+3RRWGLg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tljMz-000ntN-2j;
	Sat, 22 Feb 2025 14:52:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Feb 2025 14:52:13 +0800
Date: Sat, 22 Feb 2025 14:52:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Barry Song <21cnbao@gmail.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
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
Message-ID: <Z7l0Hf-CFFjeKaZY@gondor.apana.org.au>
References: <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
 <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au>
 <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <Z7lv6JLax4S8vTtD@gondor.apana.org.au>
 <CAGsJ_4yAQxjTnSALZHAJZDdUnXKAYFvQCcjQjHiQSUip6cJGKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4yAQxjTnSALZHAJZDdUnXKAYFvQCcjQjHiQSUip6cJGKg@mail.gmail.com>

On Sat, Feb 22, 2025 at 07:41:54PM +1300, Barry Song wrote:
>
> probably no, as an incompressible page might become compressible
> after changing an algorithm. This is possible, users may swith an
> algorithm to compress an incompressible page in the background.

I don't understand the difference.  If something is wrong with
the system causing the compression algorithm to fail, shouldn't
zswap just hobble along as if the page was incompressible?

In fact it would be quite reasonble to try to recompress it if
the admin did change the algorithm later because the error may
have been specific to the previous algorithm implementation.

Of course I totally agree that there should be a reporting
mechanism to catch errors that admins/developers should know
about.  But apart from reporting that error there should be
no difference between an inherently incompressible page vs.
buggy algorithm/broken hardware failing to compress the page.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
