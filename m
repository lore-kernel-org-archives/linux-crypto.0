Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075A82EB10;
	Sat, 22 Feb 2025 06:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740206087; cv=none; b=Qg1ZHqydwt98cdcaTg/zKr/dbGAsGe2gAx/g5zGOR9f63+VPJ/BU9gdy1mJsUF9uZA5vFFrHuKBmQfpW2Mma7Ypq8FY+9mzVVy6Sd3iNecj5WFqqMSH9HJZholbryG7CyYvPjJxvE3AgJulX07onWXDcaL5rtphiy1CNvVEfN0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740206087; c=relaxed/simple;
	bh=Qorb/Ayl7f34ZiEpG7JSaPTu4jGQ8MbNvRD9btNTnpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AzY2t75/21/rFyvtkgADQcvsvwKBP72dqhR4pi75AOH0yw5L8GemW9O7f9a2ap65qEGCYEOrZZveDHuNbQKzDMiPWqZYvBYyh2LslBsAthdMmY6FOg+Ai3o+evY7ZAagE1xm8BF5QKIXBveA+vslnl7iUYp2kww/tpr4uT9+0Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lWVdYTKu; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lWVdYTKu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cP8dZ8a5inH0cvrY/8bl+epQJ00yB6YFykqQ0v13Kcc=; b=lWVdYTKuLzQRnBVboT8tXq9Vow
	6eTAiryEHkGoLKOXCxPbTDeGoCZ6JDAbmPN0kPz33P8vhxOuM/ya4BMUhuzrxI7sOeVhG9b7igoVH
	UVsnR5i3gqSwx+BPn92irFcA64wla50twjUYBKt9rNcaQvIgLS8Y12xj/Hi5F6xFcHLJfD5vD743y
	ezZfUzGag4bAjc3aCm3WA3QH5qnrPWN6emwNdpO6HsIpNdtkGwDLI87iT0J7JIQEs2/WRU/W4/WFH
	B7CdBHwkDnTIufwzVmlEOudzqtqvVV5dvUACCdjeEYOxLbBHvVs03yYIoXiIfkSOSPi3WMi7ybU3w
	LTkND8ZQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlj5c-000nn7-2l;
	Sat, 22 Feb 2025 14:34:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Feb 2025 14:34:16 +0800
Date: Sat, 22 Feb 2025 14:34:16 +0800
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
Message-ID: <Z7lv6JLax4S8vTtD@gondor.apana.org.au>
References: <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
 <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
 <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au>
 <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>

On Sat, Feb 22, 2025 at 07:26:43PM +1300, Barry Song wrote:
>
> After reviewing the zRAM code, I don't see why zram_write_page() needs
> to rely on
> comp_len to call write_incompressible_page().
> 
> zram_write_page()
> {
>         ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
>                              mem, &comp_len);
>         kunmap_local(mem);
> 
>         if (unlikely(ret)) {
>                 zcomp_stream_put(zstrm);
>                 pr_err("Compression failed! err=%d\n", ret);
>                 return ret;
>         }
> 
>         if (comp_len >= huge_class_size) {
>                 zcomp_stream_put(zstrm);
>                 return write_incompressible_page(zram, page, index);
>         }
> }

Surely any compression error should just be treated as an
incompressible page?

I mean we might wish to report unusual errors in case the
admin or developer can do something about it, but for the
system as a whole it should still continue as if the page
was simply incompressible.

> As long as crypto drivers consistently return -ENOSP or a specific error
> code for dst_buf overflow, we should be able to eliminate the
> 2*PAGE_SIZE buffer.

Yes we could certainly do that.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
