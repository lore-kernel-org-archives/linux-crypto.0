Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793868728;
	b=sxSMb9Qsv8CLb1LtpSh5GyEd23OT5H2/lrHbkNXV8I2sUMNDkF8wvO8lZu+kNF6XFnoW
	 y77U8LBvjZpUv4RuKRnGCKZ3/bxcUzNO+SkVuP3VQyQ7+9gbq6fYK8w2EjeDoYEMUDbhG
	 ef394Sv1xrs30iloC2ojAtczf0s/0a83XsCPLVnIE5WsWXymnVOqUQp87525qw6GpNaBL
	 HIPNpSR9f+rZZYONXkmM1k3kNBBWGWyye1PpcwXH++tCw0CiWnoxC7z6qWqaKngXxwDdJ
	 zIumAuRxJz/Gk8e78uOzOawV7AfYGGGkQqLaD2rVuYoK0Wgnj7rZKP9jYrMV3khMovg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793868728;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Y4soA1wbGGkJusNMsltnTjlcCbzxXwWGOb9aK3q0azE=;
	b=MUFCKj4N3OFcis85yHv/HeG5uNj/hZPPr44rjE6vu6TOGJ0xPSVcctqfvA8c2VwqLq2t
	 su3UZIvHxQMGBguSvvBRt0wE/ym16yoZrMNGJ1XaZdd0xJHL89/1DuRXqW0jQM+rC5Omg
	 O3ErqgQRw7eNV9/6FMfHZ/OqS8GA+daV5BTDnMAupiu7gI2oseFfQiEzxCMORG/f3knCa
	 pRaiz0Vq/4iUxFtzPBDdlPNwxbwLTDUEL59MQCKwX+NidJ1qCj88t9N+cIzCdRuZFKRq9
	 SwZI0sVBGmB/xdfiKO0kkvgjHG1Z5gqlJY52P+Qu26xv7z+TO46496UkycGt58mRSTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=hQiyX4SZ;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC2D606A31B;
	Thu,  5 Nov 2026 08:52:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AC2D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=hQiyX4SZ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Y4soA1wbGGkJusNMsltnTjlcCbzxXwWGOb9aK3q0azE=; 
	b=hQiyX4SZA2tS4OXtKu5IuvLWAXyaLoxbQnJcqusLNlkaedE6ATQ+A26fMjA+DYRDUg87uGUyiou
	lRoULOF943cIw6tI3K5Gc22hTeG/Ng9v6UlF2mFw11tbJk30wbOJrfqNpzIDiRCPr/CITaVGpo2mu
	poZo3XOSqfuhiG1btoJU0qjEBRk56rx7Asf3gHcsABOhPh1m1gKk3R9k5NGYbHUEvCMMHcL69Q2+B
	W3GWTdl/jvFmVLDSrI0uBXfF6h1TC0alZsj+uGooCwXHrg5dbLH2huVft4OF2ZZd/GOlnzvExmkns
	T6iqHL02WTG56M/nMw7sLkSlzw6ZKMYHcyoQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOtC7-0000000BJbr-3JtE;
	Thu, 05 Nov 2026 16:51:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Nov 2026 16:51:39 +0800
Date: Thu, 5 Nov 2026 16:51:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <auxDm_YO4oACA_d2@gondor.apana.org.au>
References: <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
 <ausS3LQNkdc6lBy3@milan>
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
In-Reply-To: <ausS3LQNkdc6lBy3@milan>

On Wed, Nov 04, 2026 at 12:11:24PM +0100, Uladzislau Rezki wrote:
>
> There are users in kernel. For example:

Thanks for the list.

> drivers/GPU
>     /* Allocate the file in vmalloc memory, it's likely to be big */
>     iter.start = __vmalloc(file_size, GFP_NOWAIT);
> 
> AMD-GPU:
>     kvzalloc(size, GFP_NOWAIT);
>     kvzalloc_objs(struct amdgpu_coredump_ring, GFP_NOWAIT);
>     kvzalloc(ring->ring_size, GFP_NOWAIT);

These appear to be executing out of process context without spin
locks so they're not really GFP_ATOMIC.

> Virtio ring-testing:
>     (alloc_ring(0)), gfpflags_allow_blocking(0) does not allow blocking.

I didn't really look into this as it's just test code.

> net/ipv4/udp.c:
>     err = bpf_iter_udp_realloc_batch(iter, batch_sks, GFP_NOWAIT);

This looks buggy in exactly the same way as rhashtable.  It's
called under spin_lock_bh, and the same lock can be taken on
the softirq path on another CPU.

So are there any safe users of kvmalloc with GFP_ATOMIC? If not
I suggest that we change kvmalloc to disallow vmalloc when called
with GFP_ATOMIC.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
