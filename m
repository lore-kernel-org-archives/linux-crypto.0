Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793335712;
	b=4gLRK7M/YTTKvxIXomyLycq7ibpj/SJVj300wTBCwlOjjmkr22NpkANgqG9dIrr/PzKa
	 RtHfuSUK2JxDB9fBysZG4kK0ouYo1lbwQCMCVIs/c0fZ3POI9H9LvK6GW8GP0PsBWtNf8
	 oCC0DPFKheODwNY1M0pttI3Z5noF9sJgLFuSmNsyzlIuGPwayA4kaIST4WpD9V46FcrKM
	 UPvfC3LjF1uT7rzQuw66F5kndmJk9rp5UggzxJQcGfouFEWWdFM7xU80qOpeKgyn63R7Z
	 GRKOPEIHrtw6ST1PX5hfWkaKuwAISagsB5Zs1OzGwE7MbkdOxPXgV2krDkmjpSMfd/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793335712;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=xCO2gpCBQE2FwzGxXtXJnVmZ+zGlw7S7nKOHMvP3QG0=;
	b=vPTNIdCdmIWA+LBWVoZLIm+pbnbXlYV26Mhc1Z0w+X7kgn2Fjzr9LtTz+rmUHI1B6KUC
	 O8dlAJ9nhGnyaEsYgg8vCV8hgTAb1Ut66fZl1N9dzCh/TCaIBgZNbZpjR3vh/ld/2gVWW
	 jiWIHY+WVdUObKA9permuChzM/87r+l8TDSGS5g1hM3xRsf16n2rNwxu8SCIrwH1zOWXf
	 eght5eqi2s8z0zIMWH2d6D1t9zY8BMDjcG7GSZ/8Jn0psW0Ip2ijVCM0Y/R526KBvb4hQ
	 HYZkHkZIIdwQocdl7o0Bx6tZzdGmE9J7cYDOUm+jFBOZD+OxDRXI/bOWF5auQ/60F5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=hKQDCwWc;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9103606A31A;
	Fri, 30 Oct 2026 04:48:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9103606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=hKQDCwWc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xCO2gpCBQE2FwzGxXtXJnVmZ+zGlw7S7nKOHMvP3QG0=; 
	b=hKQDCwWchBDZrqV2HNumPX2hRrvnfsyuREe+gEk1+dUcp8Ix5tYjEtSit3Ix1F6SCsLMbtLB63R
	uZ4U+z5dDPcyVnSPDudr+gqN97h9YbEiQymk0YBvHWBreByFOtJgk2Xh6I+GPGa5r+A1nP7BPdYIP
	vum6ASLLzYK0W339d7mFON4zuKKHSr7CpSgWU+18qIVY7dxeaT9Uuc/rwp+mjogVUayQrhMjXz5zD
	n43lkbkGyO0OI0eY3jymvs6qA0TbpeZwPR2D2hn4qQklHAvB8BaoZQ3crAbmS47ueoqFaDPrt7W3m
	RmJKWZjND5ofD7F2w9P0CzgYKXeCgqSSvxJg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xMeXI-00000008yjK-3ZRY;
	Fri, 30 Oct 2026 12:48:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Oct 2026 12:48:16 +0800
Date: Fri, 30 Oct 2026 12:48:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Liam R. Howlett (Google)" <liam@infradead.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auQhkHG6XlgNTdRr@gondor.apana.org.au>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
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
In-Reply-To: <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>

On Thu, Oct 29, 2026 at 10:53:56AM -0400, Liam R. Howlett (Google) wrote:
>
> Given where we are in the release, this fixes a real issue that can
> happen so maybe we take this now and settle the general handling later?

There is no rush at all since the bug that you found has existed
since 2025:

commit c6307674ed82c0c57d6e1e3408e84ac449ab8e94
Author: Uladzislau Rezki (Sony) <urezki@gmail.com>
Date:   Tue Oct 7 14:20:35 2025 +0200

    mm: kvmalloc: add non-blocking support for vmalloc

Let's take the time to fix this properly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
