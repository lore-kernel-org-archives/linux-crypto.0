Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6527217D2;
	Tue,  9 Dec 2025 02:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765247576; cv=none; b=heOmGoMjXlUhssjyCy17cfKrzHNyHpA0kJnW1aBMgj65r1KFexnfWHuImetARBxfLbcfUQp5Tq0ByhOkO542ILJLNhmIYGVZhkhagaxD0C87MY5U6i4JFLMJ2GdzmNlo/fhvk7b1RQ0R8y4gtRGfPgGt49Q6zeQLaSptDqANyMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765247576; c=relaxed/simple;
	bh=aZwYVUDw6YBffU7mDHMNI6dVNGxgYj7dcZKNti7q9V8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dRB6cK6dy1sGPHsXuWGfTKM+z44tVQpzmomLsiljSb+U2X2TvtChSL1jVq0j8faH+qPVxHIpRagt6r2UnNI30OQzjr5dNWrlSijbQ2LGPZ4hYk9KTFSJ+4lmPAYbwEreukL/LNKu4dmSLpkZg5dt4n0A+xMy7PVBfV2tFwgSmL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gnjL+27L; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gnjL+27L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=wZLjNoakVV6bFoonKXxZ2uN/OSTmU5GF66yNKZJxxOs=; 
	b=gnjL+27Lnwc//Pp4AsBRMlTPIpwoztS0SHJEc1yNf09XrIKkzhVBpfYKziPJ/wUrylumg4Phn+u
	VRerEwMBQVN3OvAuVmXUnsgxwVQflVtTgaOnUGBWe6LtCTI9OO05N7tvQdIlRhoYfwO6CFBlUWakM
	0HMPZs7RITXd2p7N6GUaMO0GESc6MsoANjD92lgJucMZPA7l+vPNS6rP4qGPUfNJM8giuz1XDuIwl
	oGaSBr6bg6g5vHnHUUGgaYM62UgXft8lerbubZinUhMGJPymUatyNxl6pRokIw1YBmXEa6mW8HG5W
	xMJmYDX8XpcwGVLHfv0DXSXHyP1IczXXW6ig==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vSnWW-008wNt-34;
	Tue, 09 Dec 2025 10:32:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 09 Dec 2025 10:32:20 +0800
Date: Tue, 9 Dec 2025 10:32:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	SeongJae Park <sj@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
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
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <aTeKNEX5stqjG55i@gondor.apana.org.au>
References: <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>

On Tue, Dec 09, 2025 at 01:15:02AM +0000, Yosry Ahmed wrote:
> 
> Just to clarify, does this mean that zswap can pass a batch of (eight)
> pages to the acomp API, and get the results for the batch uniformly
> whether or not the underlying compressor supports batching?

Correct.  In fact I'd like to remove the batch size exposure to zswap
altogether.  zswap should just pass along whatever maximum number of
pages that is convenient to itself.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
