Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCBC2DCC1B;
	Mon, 17 Nov 2025 03:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763349208; cv=none; b=Zufq6ABKhUyF3CWS/in1277WZqHlufduglaOViO+73/Sp3EhM5EOPEF5MyZPh8P5/iJlmpwvpwatgPkCM0b9f08GUj2YCCXSZ2zbvYLxo6fD4cjHIBSOSKjZUitzAFElP6clIRadCecyKUKiA1QSlHYSNxAym6kOOHfPvgeTC6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763349208; c=relaxed/simple;
	bh=jLAZxdrR/WwkMhAA+l/dYGP5EVzabgV/LYXlKF5iOWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aMgtvqv2xvWWDbIu+CgArfJzgiuHFCn7wE+SzQC8zGM5IGf+whqZEuP+7ZF+uXDvLgNd42se4vnTuFSnmoBY7D4lRrcT2lDHY1dyOyLa81QHczf14M8CLu3ghYodb+PYZsUuQ3Sjupv589eJT9JrB+KHjfCX3F/ycSvEc/0g5g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NDAU33er; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NDAU33er"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qlMm7biMHzU/zsZZyzTao9DZXlaYBoqAWcxIHDHPw+g=; 
	b=NDAU33ermBIPLm0iZPr7ZbtstmHVK1fT8vbiK32I/+TXIudxyEiy95h0Y1MtWBO2gejVIrzFdil
	tMka9Y3xgSfYjmUr5U/aipQlTEkLslTrbne2RqZ3cgPEmWMpdUNI/rG56P1YQ5DoBLCPkmRc7mNRL
	/d2mVdaV2HEq1PAbtwJD0Khcs6RmSj3Fioe629km/kUeCKUbxXuNsX3dKzTglEERqW+aWTc5Z/kwN
	/pAlMMdy/D+oLpWT1CjdVlBPxEVXZrMiLJgCK8PejqfeID3o07oN/IxHy9aplA7+L7z8VRgxjg8pq
	4xJ0ujuq8J6RxqtFfo4IoH49S66uT2Y4B9BQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vKpfV-003WMc-26;
	Mon, 17 Nov 2025 11:12:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 17 Nov 2025 11:12:41 +0800
Date: Mon, 17 Nov 2025 11:12:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"sj@kernel.org" <sj@kernel.org>,
	"kasong@tencent.com" <kasong@tencent.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 13/22] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Message-ID: <aRqSqQxR4eHzvb2g@gondor.apana.org.au>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-14-kanchana.p.sridhar@intel.com>
 <aRb9fGDUhgRASTmM@gondor.apana.org.au>
 <SJ2PR11MB8472EB3D482C1455BD5A8EFFC9C8A@SJ2PR11MB8472.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SJ2PR11MB8472EB3D482C1455BD5A8EFFC9C8A@SJ2PR11MB8472.namprd11.prod.outlook.com>

On Sun, Nov 16, 2025 at 06:53:08PM +0000, Sridhar, Kanchana P wrote:
>
> This is a simple/low-overhead implementation that tries to avail of
> hardware parallelism by launching multiple compress/decompress jobs
> to the accelerator. Each job runs independently of the other from a
> driver perspective. For e.g., no assumptions are made in the driver
> about submission order vis-à-vis completion order. Completions can
> occur asynchronously.
> 
> The polling is intended for exactly the purpose you mention, namely,
> to know when all the sub-requests are complete and to set the sg->length
> as each sub-request completes. Please let me know if I understood your
> question correctly.

The issue here is that this code is being plugged into the acomp
API, but it isn't implementing the acomp API correctly.  The acomp
API is supposed to be asynchronous and you should return immediately
here and then invoke the callback when every sub-request is complete.

I know that the ultimate user is synchronous, but still the driver
needs to implement the acomp API correctly.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
