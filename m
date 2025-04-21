Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B839CF507;
	Mon, 21 Apr 2025 03:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745206323; cv=none; b=Cf/UjLils14bCcoPEYAzraKrZLXjTaVMQ9VwyeZjQRv35iQGEmyO8lDSdcBZ0oORd3Q0J9G6YligaXXvT2gyHQv4+uN7QU33UyUoPTixaxlBDpCORQtHM1/hcp3Hz+KiY/vLLjFhxrxbd2OLlK7LSQDRqxjG0AMNiENckbYSu0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745206323; c=relaxed/simple;
	bh=gJmcQzS9mQxoIny6Mfrlu2W63jA7fze9RaoVDjMxI7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewHZ1LXq3BcojJ6VbVm3f7Y69ywdO5lw6fhtWtKkE0W1WzGwC7ZA+1C3SKxD64KmVsLql96TNxx23B+tE28skA8nYrwir7hQ8GgM/+4xdTdpaT0/GzjJCk7Rpzqw7GA2C9Mo/c1aruYpRWmUhwv0fp/u2YjvEaY36DXl463Qk5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CyezWd7G; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CyezWd7G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XHQGWIF/Cf0LNQ2lU/EhN3J9AF8B1+/NLjxMdpt6BvY=; b=CyezWd7GqkBfuVUuu1PjynG9T+
	We0CIr5a4UubcrNgmHmzUXpKvUfUAkUVR2al+UFnbA+nR/onZy9Hj4kxWkVlyLj6HqmPt3LP0q4KI
	xpBAyuxg0Kc4Td9/R6HnJsjkrW6PTRUQvOE6cPF8nV9wA6qKsBOFFb+DIfQ0Yo/IA0QcER49VmJ6G
	hjBQHcXCVRTRKCSI81aEj4RXUxsY1d+2eL8NjuWQDFmj90PxHGo6O3DRcCr3FCzVNRlfnbAaI7leE
	NsWAlPjXm2MewowIpWHT5uB/6nV3MvUZRFc0dUKI7d5Cqwnr4AtoNUorlXJ3qmSa64656T4v7Zm2t
	P8ZiPgAw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u6hsZ-00HF9Z-2B;
	Mon, 21 Apr 2025 11:31:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 21 Apr 2025 11:31:31 +0800
Date: Mon, 21 Apr 2025 11:31:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>, m95d@psihoexpert.ro
Subject: [PATCH] crypto: scomp - Fix off-by-one bug when calculating last page
Message-ID: <aAW8E9NrKWq1Xk2w@gondor.apana.org.au>
References: <Z88h1mPkYNM6yOGE@google.com>
 <SA3PR11MB812082535F1E6D63BC0F1412C9DF2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9mB5IbNEdNdtmUp@google.com>
 <SA3PR11MB81206531E9B3C7F13F5740A2C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9nECMZW67F8XYoV@google.com>
 <SA3PR11MB8120A474C20104FF22CCE396C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <Z9n-OnGPK7BOdGxR@google.com>
 <SA3PR11MB81202E35C1CAF0409711A1B0C9DE2@SA3PR11MB8120.namprd11.prod.outlook.com>
 <20250420140116.b6db3aafcc2f99569190c97e@linux-foundation.org>
 <CAKEwX=P39kvB9Ei1xt+iOcDRMr32=ujGiKKa=e947k0MyJ7xZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=P39kvB9Ei1xt+iOcDRMr32=ujGiKKa=e947k0MyJ7xZA@mail.gmail.com>

On Sun, Apr 20, 2025 at 04:35:44PM -0700, Nhat Pham wrote:
>
> Anyhow, this looks like a crypto/compression infra bug. Herbert, does
> this ring any bell for you?

Yes this looks like an off-by-one bug in the new scomp scratch
code.

---8<---
Fix off-by-one bug in the last page calculation for src and dst.

Reported-by: Nhat Pham <nphamcs@gmail.com>
Fixes: 2d3553ecb4e3 ("crypto: scomp - Remove support for some non-trivial SG lists")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 5762fcc63b51..36934c78d127 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -215,8 +215,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 			spage = nth_page(spage, soff / PAGE_SIZE);
 			soff = offset_in_page(soff);
 
-			n = slen / PAGE_SIZE;
-			n += (offset_in_page(slen) + soff - 1) / PAGE_SIZE;
+			n = (slen - 1) / PAGE_SIZE;
+			n += (offset_in_page(slen - 1) + soff) / PAGE_SIZE;
 			if (PageHighMem(nth_page(spage, n)) &&
 			    size_add(soff, slen) > PAGE_SIZE)
 				break;
@@ -243,9 +243,9 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 			dpage = nth_page(dpage, doff / PAGE_SIZE);
 			doff = offset_in_page(doff);
 
-			n = dlen / PAGE_SIZE;
-			n += (offset_in_page(dlen) + doff - 1) / PAGE_SIZE;
-			if (PageHighMem(dpage + n) &&
+			n = (dlen - 1) / PAGE_SIZE;
+			n += (offset_in_page(dlen - 1) + doff) / PAGE_SIZE;
+			if (PageHighMem(nth_page(dpage, n)) &&
 			    size_add(doff, dlen) > PAGE_SIZE)
 				break;
 			dst = kmap_local_page(dpage) + doff;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
