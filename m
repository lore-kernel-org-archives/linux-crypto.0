Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575400;
	b=fvox95v5SW4FZ0bJFudYv1bJtZAy01zF8ojlILHqAZ/ay1iBmRjT7eD53Mhj0cKdSo0J
	 BXG6ZOf+AJ8SmcruJEWJiRNZfat+ZuZdpBNZRVcct2/KjAwKCxN5UXtEHJINlYA5jRT0Q
	 0J6l3XD4iLPEbg9M8AO4cL3Pgz33c7dXIhUpfFa3zT9LkjeOhMrXgPpC5iwiYwj5GomkI
	 nmvalMN4GybuGoTx2OzQIBNJ36U4UBW6ZmambQbcGMOYwoiXepw7DMNcNiR97YjE+YQXf
	 xFW+p2YANWTOlpxRSQFh+5/+hrvbx9vtXxMyy03xpNHR99Mmmu52vQc/yVl0mCvhkyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575400;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=UGpozxc5A71n0YtBFvahDsepqP8hUjGxDWMrgIIYyVA=;
	b=QzHoPYtqWvy8qVulcVVxeYnpJoU7QoM5FV7a2fn892WeBYj9w/zppTiAzpmBvrbfcHFm
	 zis0GnG9D966tYDQU+AXCCSN/m/jVLSg9dIDfUysmIQt92qCqkuAxBWP45nOR3VzQwNIB
	 BirpDaRk/9+HzzUZKVsfqrz2GnDrsrbYB+Jg41vjFKB+s5QVRRrOQmQZSYv9r3Tgaf3HA
	 jJJh+a+fNS9m6RxXCZhzXg2y96RcaA/ZKQ1+VbNrniKQWzutLzwWLtZ1Pejzn5c2evBs4
	 FAsBr6lWikWhJ4+3m9bs9I44uJGmbu14MhNsBcncODOKEy2eBA1s2CaRtE/vPvz5Xxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=d4tYK06J;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE8D606A32E;
	Fri, 13 Nov 2026 13:10:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CE8D606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=d4tYK06J
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=UGpozxc5A71n0YtBFvahDsepqP8hUjGxDWMrgIIYyVA=; 
	b=d4tYK06JyuRSphC2q+1jJ/PkmSrhrX/4nWFQPmTyjPIEmJ2dQmIntywfvbpjKXf4mSj6WiAIg23
	zKVekrI4JXBJGthGC+9nw7fkux38tSHXkvG7frI3zH2WyBLLQPS1IsQXjGbvVP4ZQvPKGYFqOGlDN
	+u1mhmq658G6m7wP5puRggMHnyF1kD7RRRoIdTOZMDqJuOItQfNTheWhKgzy0BtE2lCxk4bXJIrXI
	objyyBQ+MJtGlTeN0tXysDpO00aAEXnVXm6j4a71GUT8P9vvHYbYq9rhkfV+CPNpLhJ0UB3dyxhMu
	NO9B5UPo25E/J3W9FZt/nkLwZjO4NTHJU+5g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRr2O-0000000EfNo-3YiM;
	Fri, 13 Nov 2026 21:09:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:09:52 +0800
Date: Fri, 13 Nov 2026 21:09:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Yang <mmyangfl@gmail.com>
Cc: linux-crypto@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] hwrng: histb: fix the FIFO batch timeout
Message-ID: <avcMIMHcnpL5xNUf@gondor.apana.org.au>
References: <20261104114108.2378751-1-mmyangfl@gmail.com>
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
In-Reply-To: <20261104114108.2378751-1-mmyangfl@gmail.com>

On Wed, Nov 04, 2026 at 07:41:03PM +0800, David Yang wrote:
> The poll timeout in histb_rng_wait() was derived for a single word, while
> the device feeds the FIFO in batches. Fix the timeout, and print with
> dev_*() so that the messages name the device.
> 
> v2:
>  - reword
> v1: https://lore.kernel.org/r/20261103041403.4071708-1-mmyangfl@gmail.com
> 
> David Yang (2):
>   hwrng: histb - fix read timeout
>   hwrng: histb - use device messages
> 
>  drivers/char/hw_random/histb-rng.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> -- 
> 2.53.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
