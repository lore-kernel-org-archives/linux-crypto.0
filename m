Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793976208;
	b=Iy+LMvh/NYk/7ULarJpQSSCM3zh6QviVWQJbQBtms02sfuLNMbJyOMpvfCjWpEwc78YW
	 mqb+Sz4gBlCADyyALiFhDjl37YBIJs8VfQEaLm2U7Cr1eUhEINAmPDwwRcJpd68s70Ghf
	 3pBv1N+rGU6+7kEY6UakXBehxG6WRic98GOoR4D1c6NJ7C8RE0sA4MUs+EAieCTQKdlXn
	 AhoZB/qPzWPGIsQpuFlCQvxLlTOkABCdI+OY93SlYpLriVWW2nnQt7pBmuzwXPO2EZ1VL
	 IifoPqzQM3UaU2Fd6xUqlHV51IDcyzZdCpGWeLc9EppgGoGfYBc8ePmHKVzrf8LPZGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793976208;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Date:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1coO61O9o20KGfWhe+U/6TV0ZY/FeV096v+PDZIBmoM=;
	b=n7HFgJbxawi3kL0QGx814wtYuOM4m9Dt/Pk+GC0UZXWwpnGCQCPjH9t34Ev1NV7N2YDe
	 DRKJSlsRoOAF2Gnstb0w0UEiDlVw28a9DvzrreXiSBKgL2jLdu4w/SYGYjuzgDoHbE0mq
	 ZQ+v/L2ConZjB65cODyJt3tQZVk0cfEWfc3vOPfCZw66kods8aQJ05BYVLh3V3jwdh33w
	 5UO3GMr/WmyHLN+Footzwu3N7SzCRvOw5/b+9hRvLSR1wSZ+ZZOWBJC3+m66MuIUY5sZ0
	 /wHqxsc0HpKiRqTUndcpCOztfopSRNn8uQLQE4asCenuMmNTZ490JWjUsCOAQp+5L5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dQ8Kjz3P;
	arc=none smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8243E606EEBB
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 14:43:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8243E606EEBB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dQ8Kjz3P
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b58cb69927so2170934a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2026 06:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793976206; x=1794581006; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1coO61O9o20KGfWhe+U/6TV0ZY/FeV096v+PDZIBmoM=;
        b=dQ8Kjz3Pm/40Y6QK+wnykiNHDgz7dKP607sj6/+hqieIq1ZmyilklclOYXjWaBJyZQ
         wigV9r8VouxbEKE9QgPdw1VpSrB3xLnotHYSSNbzuz878AnRPuvoVHRTNcqgEq7hLDnq
         EBy4H5xYRegGJoTvMOlxOYRVq93ULaPKtOQBRtm4a5TxD5b5qxrLBPFkjRnIHAg/fRo8
         SPdaU35rkr0LfaG3/AS4/PMkK2BSbubxBavooY3Ygux0TcvwzrklGLkuYTCBblRoq/9Q
         wGBWvVpbu/YmDkyrFWrcQ9+Xr/vMo02AxG7ipmZa006A9g2kUtdIwncG4kcQ9DAOguTO
         Q3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793976206; x=1794581006;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1coO61O9o20KGfWhe+U/6TV0ZY/FeV096v+PDZIBmoM=;
        b=hvxLS9lwvLzM2ObKseEj1dy686GEi9K7HWzrHKMMIUtsM2IbhDf0RhJg4I0BPS4j8X
         Ae9bxxIxvBzPbBmAg4/LeRZOhkjTaZMvPQtNJpADKaRzHQViEGSDxL0AzEWpTQy5Bgbu
         W+/VLe0jGSK1I42VL52v6oWLssccuH5jEa34yV8DXVNs8JrbTrsD2KtYYPYkuLi7lUMj
         0RC7N+JDnI/yGRylScHY2uDArObVE6oWZr7YX+cVT1eMtowptxq4NeL6WjBj9+OfWlyK
         lxaLXmg3AF7W9awQbwbpEhSz8RcjypU+WvH7EEGlX8ObPe/mR4U+2/hN3cD9xJ4gvhlI
         gZ+g==
X-Forwarded-Encrypted: i=1; AKwUvBxHSG8Wgu2Xf5Tlibqu9sNbUvWgG0GdL5kKCL4op3PZ6G+46Uzp5ucybEB75vGi3uSYqOwEoTh6k6KQnEY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9FNXDyR6KYEV/XjyCP74gN+k5aRJOYaBx5fIj4yY0AdsepoUIO
	SvMFoALdT+3UFXiswIJgnoOqRdPmxm7Nj7xGi7uGqsmZusFR3baX9Knm
X-Gm-Gg: AYBFou2ZTnuNO71yll0OmBJ0FPpFGB9RaiNDXt+GUWmFLx8/Kl6EcMA0RoWZbKSRkKk
	YEjuapZwJ2PbTHypqBwrK84uNYoUPfjkPdzkEmwefp/+m+/DHeZPD1jR+CjfxCyDfncieFeuGyn
	a2qBWxRbN3AJuW88EzFmER2nZ/j8vn5DEQ8sqh3hJ48QaQuRTI8P9MnjEx4wxRMjfdGoqscTr5I
	Nhmuy4hkvxks7p7cI1CiougRDxEfF2eJLTnqLium0W39Xlpde5brPx3U/TqiwOyelXMTLochr92
	XEtrJIGv/HD2zTPBlOTdOyh9gGMMI/irSz9BZwmnRyNAzSTu6RxwB17O77r6rBfOBpgM9BZrCy+
	3405FaGq+A70Vzrhx1hZ6oA/sF6y5XdM0lrOmnMBjBXxLEsiMx6PTCLtmuKsFT3R2OrkmTg0JxH
	XsiflrQ/SXgvrlXbmvTv5B/nMejWsdeH7Fg5G6bDijNe5Ky9j8efLyqhMxoLPR78zaU2BRR1yBs
	fENISX76ty4eI2GIgCgZpWPL9mjMMDSERzN42f2ZGlvZdKW+osB4hvUf0IwSSXx6e6+
X-Received: by 2002:a17:907:fdcb:b0:c2e:616b:6763 with SMTP id a640c23a62f3a-c4d3525a3f4mr249438666b.3.1793976205728;
        Fri, 06 Nov 2026 06:43:25 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d35631eb2sm86304166b.27.2026.11.06.06.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 06:43:24 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 6 Nov 2026 15:43:21 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>,
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
Message-ID: <au3nidyyEWsNkL9D@milan>
References: <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
 <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au>
 <auzOjphJ8DWpXwUy@milan>
 <CAHk-=wjcKOC7O30L8_8PMniT71aqy_3ZEYK2xyoR8zW9ZCvO7g@mail.gmail.com>
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
In-Reply-To: <CAHk-=wjcKOC7O30L8_8PMniT71aqy_3ZEYK2xyoR8zW9ZCvO7g@mail.gmail.com>

On Thu, Nov 05, 2026 at 01:02:35PM -0800, Linus Torvalds wrote:
> On Thu, 5 Nov 2026 at 10:44, Uladzislau Rezki <urezki@gmail.com> wrote:
> >
> > @@ -1025,7 +1025,13 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
> >                         }
> >                 }
> >         } else {
> > -               spin_lock(&br->hash_lock);
> > +               if (in_serving_softirq()) {
> > +                       if (!spin_trylock(&br->hash_lock))
> 
> I don't think that in_serving_softirq() makes any sense.
> 
> If I read this code correctly - and it's possible I didn't - this is
> always called under local_bh_disable().
> 
> And local_bh_disable() will have increased the preempt-count exactly
> so that it looks like it's in_serving_softirq().
>
Sorry, probably i am missing something here. My understanding
is that local_bh_disable() adds SOFTIRQ_DISABLE_OFFSET and
in_serving_softirq() checks another SOFTIRQ_OFFSET bit.

--
Uladzislau Rezki
