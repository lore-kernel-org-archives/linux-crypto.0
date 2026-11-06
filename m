Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793944204;
	b=LU1KAQYBJ63tBwlD4kl8eoRUWUuiICJqCvauAC8LFkQyevlAdgHeE1PEP8l11YR63MmG
	 BWhgAvhO26GSHb/Xvy0qqlS7OYaDKgnYItuYAWEKO2BFcZjCwxVTPDMKreCtQxCn8RtKd
	 NBmFjEXV0/6y30ooqSnEg6Rp9neLonWrRUiX1M3JSfvRegIw8xdH/briBdbnetPweXIf3
	 CCo1C8QG4U6RrIX7FMozVzppid9nH3wOh1BfU2fXI3AP3JMiS0qYtSZVl4XFBgJcKaMub
	 IHrjGiA2bf1GKxt7DQ2H4z8f1OYVh8BqMdahxMghV5zY0cero/0xpZhCRam8IxHNslA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793944204;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=4x8jyjVTceVaevPhTybBNOQ2fqMlLZ3JJbNWyZ1lHVs=;
	b=0hJmwktbuMW2GE5BFbh1xsBGzWa/x0sTYMD/kDC5nQgVrt1wVllsdP2SpwQ+8zBYIMJl
	 +I856XijeKT66EQ8UnEVlABN4dYOiv7arIsbZHcqUhn0O2qRBiLALlKoDqboq7+aW6hDq
	 YrH9UO0nKMI/Omb+aIngR3cZKkBcN4wSLZL1UsLXg1yQ5LhcvIKOQyqHSg5UHpfkO0a6c
	 J+7VWrw60D4jTzNQcril4SWDEYvFdb29fgq+ihUiz7A9LYobPyNIvVYR9p2VMxnzmxD52
	 9WtY7c5iiibTpc+//j1McWD0SzTRTNkcaBDxyZ1NO6QBUlC1iWdZ0KxD5aLmTyZUfbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=r6qbavq7;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA95606A326;
	Fri,  6 Nov 2026 05:50:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDA95606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=r6qbavq7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4x8jyjVTceVaevPhTybBNOQ2fqMlLZ3JJbNWyZ1lHVs=; 
	b=r6qbavq7bbjaRfZ1zcjNUKa7kKJAsjgQKDVs+7mPQ9rpcEeoS+iElNldE1WZZxi66uDJtrvc36C
	g0e3mI85wZt74LDRBOTTuOkvDvdRX69A3qThoEoL6ihS8jtA6ftYKK/VDCxcK2glMgsjOqCAbU5n+
	H61TkvPZ7tmELi1hGsg3Ogg7X3hC9Y1Y79Q2pd360JSSvsSLr1uiSsbSWcoQ9fbRRdb+vkI9uf8h1
	CzSP2fXQMSzY51nS/8hSzZRPDbAcR6A5tKYVzJZpYHMmTemDG/etwVeQmC5seesi8gqsEJeXUfnWm
	9y0A0JCbHKNAq+c+iQUoVIggs4LQCxJKF5EQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPCpb-0000000BjvR-3kvB;
	Fri, 06 Nov 2026 13:49:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 13:49:43 +0800
Date: Fri, 6 Nov 2026 13:49:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
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
Message-ID: <au1qd5i4UiyNyS8S@gondor.apana.org.au>
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
> 
> I don't think that in_serving_softirq() makes any sense.
> 
> If I read this code correctly - and it's possible I didn't - this is
> always called under local_bh_disable().
> 
> And local_bh_disable() will have increased the preempt-count exactly
> so that it looks like it's in_serving_softirq().
> 
> Maybe I got lost somewhere, but it basically looks like that test will
> always be true and is pointless (and misleading).

You're absolutely right.

Even if there was a way to tell whether you're in a real softirq
context, it's crazy to change how locking is done in br_fdb when
the real issue is caused by a kvmalloc call that is made through
rhashtables.

Now if we did the same test within kvmalloc and simply fell back to
kmalloc it might work.  But then again, why are we trying to support
GFP_ATOMIC vmalloc when there appears to be zero users of it, a
whole year after it was introduced?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
