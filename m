Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793240227;
	b=SqD+evpwSIOoFiSdrDDvVgzdtaPT+NdHtespF8wXbkC83zZei51Eq0urwQmqXhCfA33+
	 eXGoF1fyUMZXBM6mBazX839kcV3YS/uFFSQwB4EvoXR4chA0FiajiYc9dtFLk9z1Xt2M3
	 B7Fnxljy3PZt2eErE8RCJEteVfvmZzGTHIhwnOk17BFQ0+N9XuWm0VKWrVPQe3ETBHsaB
	 xyFtr6wbzYZje/3gJkYj3pl7gpEb3C0jYFjAcAbwZVh/UZWlOduMb1oMGbsF3VZbp0jxm
	 Iya8+Hmo8AScAindc2JhGiXp2ekmWOAFU8RI85krW2Xb6BuNU44SX7XUt9V8n6Ud0Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240227;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=m9kc8yIzx2usw0N2+/yj9nIikY372WFees0PGb9Zlj0=;
	b=RtEf6eN6TaPqgrfR9KC49jpnMkWlYEiLbl/miQBwVXkvqkpaGpK/dkf99tMnY1qZTCwU
	 iEQ14ewIgHJBeaD+kKIGu4gl/QWyc3o0sYISax6Pfi0eaYc4Jf/bOP4TteA2rGnk/aDDc
	 bAy25DP1h8cv5qy3MnNha0+hm1AKqKR1wA6OCVgSRlNRVS0nbGXdZz2zlJ+4rJRPp8XLy
	 1QQ3ARzp+pNWG3SeVd7rc6+djaCggzoc3irfSVILeItvtM4i9ZE1n1mNM5zBHRKiiALj8
	 ubpw7zXZuIuDK/zGUkp9nImqtiHpunQisHNAopefMEiXQpSD2MT9lJMux0FI54ccx/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=BulVXfD7;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85995606A31A;
	Thu, 29 Oct 2026 02:17:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85995606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=BulVXfD7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=m9kc8yIzx2usw0N2+/yj9nIikY372WFees0PGb9Zlj0=; 
	b=BulVXfD773yLT3qc9u1NANNhJ98Vm6/aRxcwh5PfDZELbo1U/FSB2M/85ZgFhlhiBCV2IvuwAM+
	RvNJIsDMBW/NCmIYF/xef7aWde69p7ClT0iqQY7Lu0MjujY1pK8DLGdr5YwRbgqIID1pc8tLx/sQC
	Izh291VahFbHvOu6WEzhVy7BZOfCUnK5ylxT0cAbh9T4j+b6AlTNngiUvXcQvIrA+2rthRivGcZuB
	NNMsNYkt3FtQEZLRM/nlMsVyeOBmfcEjf2loV3mHj5UYVQ8drR+LgID2bwLDoSLvqe8gUgcburL8P
	tIjNocrWc2A34HmdV5jrxW9im4x2We6R30RQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xMFgy-00000008bSP-0k3I;
	Thu, 29 Oct 2026 10:16:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 29 Oct 2026 10:16:36 +0800
Date: Thu, 29 Oct 2026 10:16:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Graf <tgraf@suug.ch>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>,
	Chris Mason <mason@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auKshDXKQXt1kvjy@gondor.apana.org.au>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028154218.1668182-5-liam@infradead.org>

On Wed, Oct 28, 2026 at 11:42:18AM -0400, Liam R. Howlett (Google) wrote:
>
> Below, one CPU adds an FDB entry for an RTM_NEWNEIGH netlink request,
> while another CPU is inside vmalloc() or vfree():
> 
>     RTM_NEWNEIGH                      vmalloc() or vfree()
>     ============                      ====================
>     spin_lock_bh(&br->hash_lock)
>                                       spin_lock(&vn->busy.lock)
>     rhashtable_insert_rehash()
>       kvmalloc(GFP_ATOMIC)
>         vmalloc()
>           spin_lock(&vn->busy.lock)
>             waits for the other CPU
>                                       softirq: a frame for the bridge
>                                         spin_lock(&br->hash_lock)
>                                           waits for RTM_NEWNEIGH

I think this is a fundamental bug in the kvmalloc non-blocking
support patch.  How can it be used at all if it is susceptible
to such dead-locks?

And if you can't use it safely why don't we just get rid of the
broken kvmalloc non-block path and have it always go to kmalloc
like it did before?
 
> Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")

BTW, rhashtable patches should be sent to linux-crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
