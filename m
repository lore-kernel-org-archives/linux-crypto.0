Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32CB8837;
	Sun, 23 Feb 2025 00:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740270320; cv=none; b=UCLmZ7nKDVbSkFSRBcwPhKhc8STnlkMFXlP8V1vkTCyjJBkT2UE/YCPEhRnzQoSDD+cr+Xbumz8BCmNcmUbU/UqfH+B+nStfcNZNOBotTc9ZLwMxXhHRd+lc2YYdyKK9iu50ls8ct6FmmcrY6ePO+wfuiPAPiQEdzW+OR8LcZ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740270320; c=relaxed/simple;
	bh=/abc2TQQuweVnfx/3o2Q/UhMdo9mK7rzwxOvhovxxMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDQq8idH+IdN4i7JTfvhf8nvdWsY3GV74I2smP9I0jQP427xoXRw0K+9epvpS233SHzuY0CQ5XWlhjZdQfyjI/9qRI8bBpo3nO0Hx/Rx/WYBEvFA3+UQydWcn20SkNpXY1IrnrEcU3Kcp+TTHX8PC/4tUYRITi/petcVSxcym5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jOjIKNca; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jOjIKNca"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YsUNozI1qYaNf3PLjJnLmZ1v+5hjdx4SoX/hexNADPc=; b=jOjIKNca3xpUQYJxEEkQx9x5Pt
	zh9+51ThCu+V9jHoqsKBD+VYdfs6XfZgZvS7kJSAfOXFcql5A0AzxDmTVWpm/yTKQ9m2Dt2Kb4sPs
	4m3bzKpXdlGnCiRZlsNFtjEoaZ4sOImLC50+DDYQBSh1Z5HHE5wVCakp3IlrO7EWoaYQH0grjlaV2
	ir91Tolq9ig7QHv2u4eF3BAYh5FpKuT53otfpKiby3uGwwUFhsIKTl2HYI1TZyL1CrmYtkdJ4eo0F
	n85Dv/wy3X0DyYyXlLfApnurAYQq7abIS9Q5akfIu2qwjv96ZJNFGwfzLxBqY4cgVe/arVjifTuzS
	hkAWvKbA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlznl-000wPh-05;
	Sun, 23 Feb 2025 08:24:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 23 Feb 2025 08:24:57 +0800
Date: Sun, 23 Feb 2025 08:24:57 +0800
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
Message-ID: <Z7pq2ayAsRsTW_vd@gondor.apana.org.au>
References: <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
 <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au>
 <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>

On Sat, Feb 22, 2025 at 09:31:41PM +0900, Sergey Senozhatsky wrote:
>
> The idea behind zram's code is that incompressible pages are not unusual,
> they are quite usual, in fact,  It's not necessarily that the data grew
> in size after compression, the data is incompressible from zsmalloc PoV.
> That is the algorithm wasn't able to compress a PAGE_SIZE buffer to an
> object smaller than zsmalloc's huge-class-watermark (around 3600 bytes,
> depending on zspage chain size).  That's why we look at the comp-len.
> Anything else is an error, perhaps a pretty catastrophic error.

If you're rejecting everything above the watermark then you should
simply pass the watermark as the output length to the algorithm so
that it can stop doing useless work once it gets past that point.

> > +Minchan, Sergey,
> > Do you think we can implement this change in zRAM by using PAGE_SIZE instead
> > of 2 * PAGE_SIZE?
> 
> Sorry again, what problem are you solving?

For compression, there is no point in allocating a destination buffer
that is bigger than the original.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
