Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64642163;
	Sun, 23 Feb 2025 00:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740269671; cv=none; b=UEj1zvq3BnH4BvRAVCGCzjff7wCwfIYYAohNi32YaOc7X2BVzYuPkEOQ3reswF/2LnAJd+QfvEor+ColFcdj4nJkzQ/WIj/m9scdK2rqr8GAJ8nQOYonH5vg3Q1E1w0ASnQb4mAihYKEei674tahCNkx2iVk/I3ZbpNHpsHLSBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740269671; c=relaxed/simple;
	bh=rNWIKtObHcX96ZAdXsbnr6MXuaXQy+xu9lxTXJYFeZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knoZojDuzOVvrSB1MhrWKviQp/S3STxa1FPpySnVd15Evn0HtIWmiv18MHTyGErCDJbLcqfS9tLnV5S9le687WnDmasUif9PnRdYMBbJVpWHBF91SR3av8yIecLjVxEP7j7LcK1clqmPQUJ/ByozAZj4qZ3bKfjZ/nTxwmhp0+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=q5Dcun0r; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="q5Dcun0r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z4R6SM3uMAflgdLS3XK/87m5Avt06drqLQsC39J3eto=; b=q5Dcun0rIjPHdiQEvc+TsWlVjO
	qfEulbqPSm1YCIQw448xmfW1TkybphHEX6yKfXavyR2KBzXt36j7bIomETl3MRnb1hfmxYlgYgBIt
	vdRsOH4QOySTeySbbN1huKEdKjBRiNkl4e8a0tUz3hRcuR+DlcHEEnTJxeLrLkAVKafY0p1YxBxPq
	I8pLP3aa5KqyCI2x3mXGp1tjkEaO+mSORMqCOsnuMmdONDFW0doKTdDBCYrN8Vl0kiS3J4LouY7tI
	pVUVeN8av0eq06PgNdVUjFJxJKYGPNX6+hfD1ubmUmUMPMFNf05Nn43nM1yrbQ29aOZQrhTRW1uhR
	ggmWTw0A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlzdG-000wKT-1M;
	Sun, 23 Feb 2025 08:14:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 23 Feb 2025 08:14:06 +0800
Date: Sun, 23 Feb 2025 08:14:06 +0800
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
Message-ID: <Z7poTnlv-1DStRZQ@gondor.apana.org.au>
References: <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
 <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au>
 <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>
 <lu3j2kr3m2b53ze2covbywh6a7vvrscbkoplwnq4ov24g2cfso@572bdcsobd4a>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lu3j2kr3m2b53ze2covbywh6a7vvrscbkoplwnq4ov24g2cfso@572bdcsobd4a>

On Sat, Feb 22, 2025 at 11:27:49PM +0900, Sergey Senozhatsky wrote:
>
> So I didn't look at all of them, but at least S/W lzo1 doesn't even
> have a notion of max-output-len.  lzo1x_1_compress() accepts a pointer
> to out_len which tells the size of output stream (the algorithm is free
> to produce any), so there is no dst_buf overflow as far as lzo1 is
> concerned.  Unless I'm missing something or misunderstanding your points.

I just looked at deflate/zstd and they seem to be doing the right
things.

But yes lzo is a gaping security hole on the compression side.

The API has always specified a maximum output length and it needs
to be respected for both compression and decompression.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
