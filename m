Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793492386;
	b=P6ns8Z1ZN1engobT2nHy/2zgeLO56qOc8n6h1IW98gWQ2zBB1fiod8drvhfC3KjZ2Qk/
	 26Jue/D7pZw1X6lfkH4FxX1wYSyDE7ofYA4IwFL99KSg+hlI5MwjDkfB6qCllfgQDBf9R
	 WESWEUlOt/wi7OJqj9Fd0Q+T0ZA3IgiYPurZWfCDbD0JkWcD8KYEMalK9aihOS+GXuDOq
	 u1PDjFVfH99Ngq88/vT32Pg7We0jE5pdSpEHdwKINjPGuIUxRf+ak04uD2VA+baO38s0L
	 HBXOR/TBv82nMPg8dDxbB+6YOjvp3Yo4bpwdpMVZDmq4OovQF7s+c1LSHuWtmJbxgYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793492386;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=1C0upMKH+zbLi4SJoiKyMvaAF5IBekHbTFPSl9D526s=;
	b=UHKou63FIgx5GMzs0bXAAtGFdwRBfjKY3VvLI/USraoogePmjDXcFYzqTbl24gzkayXt
	 NYQT+F2j5H3YMotVqShAD6Bga670mSvhKxqSICc6+dSESX3ufRj4yo31K5TSV8eTYwdqh
	 5Cjhz0KV/OGp81FXT/UIoNiakbPPRk7+mBmZuXU8wttbbKIgpk0UGl9eWYJ4p/A7sFvDd
	 FHKihPhq8zeiqX4ZqUsOWp4fan8ojaSsHNcFM1d/78A5A4FN9pUwQIqjpIWLM+OG55do8
	 rWDAmTwPNX+ldNmJ42ivE95wP+pPi796l/uE9qUuBlB3r/zNFTqn8CuMVMPmHFLA6Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=lkyQI4BJ;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1E6606A32F;
	Sun,  1 Nov 2026 00:19:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F1E6606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=lkyQI4BJ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1C0upMKH+zbLi4SJoiKyMvaAF5IBekHbTFPSl9D526s=; 
	b=lkyQI4BJQJM4QlpFUo5SzXFSGLC4h9MwwD8oRQBAnobiz6XM2fsoCt2xrkyfzuBcm0pmLwYFv91
	aDWf3RC5jq2sqrGwTNNz3RQHUAZKwhT21H9Py0aeaKI2FXP9EMMEdSJ5f5oiESJb9Dr5VUUHxunMR
	Y0GYxx/whefT7APpF8NowSHqbdTueONn/SjoSwxrc6CRtjCSWHN6Hl1ht6e4YiVuw7y8HKzfVPbvC
	mmp+V+pEu6a3Uf6KruAQgje0h/LYiBPYosOzXSAXfLodwgMVgzn65/IMpLQYwztCZDTA0QFwi51Zi
	uYj4nGY51xJ1qmURuY5itLz0WmitqsUrkB9Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xNJI4-00000009U6S-0XzL;
	Sun, 01 Nov 2026 08:19:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 01 Nov 2026 08:19:16 +0800
Date: Sun, 1 Nov 2026 08:19:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>
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
Message-ID: <auaFhOa5EBz4gJwK@gondor.apana.org.au>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
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
In-Reply-To: <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>

On Fri, Oct 30, 2026 at 08:56:03PM -0400, Liam R. Howlett (Google) wrote:
>
> Hubert, I have another version of this patch set to send out, but this
> particular patch remains the same.
> 
> Are you okay with keeping it the way it is for this release?
> 
> I don't want to force your hand but I also don't want to keep a valid
> deadlock scenario in-tree.

Instead of your patch, please revert the original change that
added kvmalloc to rhashtable:

commit 93f976b5190df32793908d49165f78e67fcb66cf
Author: Davidlohr Bueso <dave@stgolabs.net>
Date:   Tue Aug 21 22:01:45 2018 -0700

    lib/rhashtable: simplify bucket_table_alloc()

The newly added alloc_hooks_tag call should go after the if statement.

This patch should also be split out of your series and posted to
linux-crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
