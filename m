Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793387476;
	b=N4Ac/Iu95E1IRygbjYUSsgkCPhXmtCvoxfctORSPZrCfmp8pKPbyt4A/Fz9uL/4zAPc6
	 6eYZVUm6OpALw4jmtxotTzmmDOm40ISCV02wSPzI9r7ZkeAEu2nsWziBLmrzGWJA2BqXr
	 nvI/jQXUHtDB27/q4uVX+EN+K5YJiPURg11EvD4OzLMmFK9DzUdujytG9BU8zU4ge0WwP
	 bCOPAHxJA14SVA2Au6tpiA4lQPke/0Oe5mUmQ8t5m8LwBFjZHcrKLg3JRY1Ovj4tZVcTk
	 6KBYBhS+dyujapHyt0OatdwBtr4aSBilJm9osnxB1Flli4p7oB5jp4iRE/GGeIRqlJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793387476;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=19Ak8N7iaTdP1KRs11X/V7bN5o/EP6FFYiTibflRDNY=;
	b=MKj+cOa5PbnNsuTh59XcHIK59xpRGcBm78h22wvL7yCNng98T3RCK2akGxRJEUSNSsls
	 F6dHgHdxTVQCWuFsFh4zQRnq2SHtOkgJFHWC0WX0QyUfIYix1VkcYzrXo/1X611CjfvnT
	 xZ/3Ug7VLbH1hO0gFg+R+rlIytLa7VNF0rlCbJ8WBjPwIvWLqyR2UUgeXuBcgIEd3RNwU
	 XFgNOforn5PsQqZenx9uMkh+NBq0N0tBUNrZHL08y+KcmTMnFqYTVb4qgBIQXePoSnNi2
	 9Fd4qFDjQHD5ARbTF1HAp2YNeWId46Nqfl0khESDGuNItbflMS/wRx1k/kLGkP9XqFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Ruc6vxep;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC015606A31A;
	Fri, 30 Oct 2026 19:11:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC015606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Ruc6vxep
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=19Ak8N7iaTdP1KRs11X/V7bN5o/EP6FFYiTibflRDNY=; b=Ruc6vxepI0BvkM9nTI1PMx6lZm
	EzQJ5W1MMjkIG9wl8uxR6Th2S+A7dJz5IpyMMZs5KQZcY7TdPCURl6Gfq3ziVCZ5kv1DFFwjb0Hwg
	rFkFdZqHj/RhRXcq8lpfu+cHuqlXaA/jE1LV4vDJIcB9oajzT3GMSJrB0nMB64OpMfLZQ26n0xK3f
	sWN0JQrmDwjUnx2+gJnIA1SMHmIE46r+aHxfwjFg8+MAlbAbu6elrzRyHm8wKmQcmpO6k/1nztfL/
	fzWrgD9Q5QzQwWwse7xx4cJ+ckGn9+7mE3x8LMCGlu8Sn0/9ZBpcrbvyWTQcqm63WlodJExydZqLd
	QXTHm8PQ==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMs0M-0000000AIZp-2cp6;
	Fri, 30 Oct 2026 19:11:10 +0000
Date: Fri, 30 Oct 2026 19:11:10 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
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
Message-ID: <auTrzlSFCWNJYisW@casper.infradead.org>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <auQhkHG6XlgNTdRr@gondor.apana.org.au>
 <auRo5WBj2OlKlWGW@pc636>
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
In-Reply-To: <auRo5WBj2OlKlWGW@pc636>

On Fri, Oct 30, 2026 at 10:52:37AM +0100, Uladzislau Rezki wrote:
> The problem with spin_lock_irqsave() is that vmalloc() path can take
> time to alloc and map pages. I am not sure this is worth to switch to
> irq-save locking primitive. So this is the "heaviest" allocator in the
> kernel. Callers have to be careful how the call vmalloc().
> 
> IMO, this caller has to be fixed.

Which caller, though?  Are you saying rhashtable_insert_rehash()
needs to call kmalloc() instead of kvmalloc()?
