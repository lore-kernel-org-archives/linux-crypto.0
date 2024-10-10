Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8F463D;
	Thu, 10 Oct 2024 06:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728540367; cv=none; b=qHBepl9TiNeTxdqiQz51GGiYTn4VmgeRgvOips+C2ciawPOMj08UTUiYE0bg6D2skLN4NHeMsu1IyaMFbTv0wF6imaDlbD9WEOndsA3XOxaSoYHZOnGGWAcw0ns2IbWivG9kcq0eoci1jFMrlbkGnhzwVl7HbfnBCHKlR0O9uV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728540367; c=relaxed/simple;
	bh=B2NxE/VURy/vjBy0GHUs/N24pfT7iFiiBWoSUrtvJ0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BMKY3dbQ0HGhl1Z4o/IA4qvFceQcXGf11ITbOUfk9f5Rxl20UCMt3otEiy7euEXoo6pfqac6s9ttdCTWpeI8TqehvFuO5aHL9k8Uz9b7QfwrbS6wvY0Y6ZoN81FmEZ+DyELVGotESYljwZxjOjRAkT840Aw1pK5d8eP94yeG++I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fnuRMqLZ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fnuRMqLZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6XUnNZxdV444hVjpvvyIdb/pQ4HNS1/DPVIt1z8Oi3M=; b=fnuRMqLZ0sBmx/sXo7vulvdPVn
	4WaRmpEVAMy6omDESvcQewfyn05mcKwfqQlD5gu+Q1QIQLOohxJP7xd8604d7eAKcptfJpvppdfrB
	6rXtGtsjIzX+vDwIn7LHCalKJMh6+ZA+J0qxH3eGEw9q+/8i+o+rYW6eIxH2a9JXMdYwzdY92img3
	ykR16cWAo9tucP4dSADxxZCUklzaWqidcQH5VkmQz2Ra2XgRN5sUBQR30tAXqKFfSpBYAjTcQi6kp
	lPbF/O5Xz6xhtbH7CAlliq/AlrFm7eofUscBu6zhmhYOtp2xfRLRvOTPuscxhmQtO+6c8Hi0bIbww
	wFCbN7FA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sym9H-008FZ1-01;
	Thu, 10 Oct 2024 14:05:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2024 14:05:56 +0800
Date: Thu, 10 Oct 2024 14:05:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
Message-ID: <ZwduxHxQtHdzz-kl@gondor.apana.org.au>
References: <ZwJUO5Nz3S7EeqO6@gondor.apana.org.au>
 <1fc4db6269245de4c626f029a46efef246ee7232.camel@gmail.com>
 <ZwObXYVHJlBaKuj2@gondor.apana.org.au>
 <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
 <ZwZAExmK52txvHE8@gondor.apana.org.au>
 <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>

On Wed, Oct 09, 2024 at 06:48:21PM +0200, Klaus Kudielka wrote:
>
> Oh, I had to increase log_buf_len, to catch everything. Booting is really slow now ;)
> Full dmesg output is attached.

Thanks! This is very helpful.

> [    4.118765] mv_cesa_ahash_queue_req: 0 (ptrval)
> [    4.121966] mv_cesa_ahash_queue_req: 0 (ptrval)
> [    4.126678] mv_cesa_int: 0 0x4ea1 0x80
> [    4.131394] mv_cesa_ahash_queue_req: 0 (ptrval)
> [    4.135927] mv_cesa_ahash_complete: 0 (ptrval)
> [    4.153221] mv_cesa_ahash_req_cleanup: 0 (ptrval)
> [    4.157942] mv_cesa_int: 0 0x4ea1 0x80
> [    4.157949] alg: ahash: mv-sha256 test failed (wrong result) on test vector 3, cfg="import/export"
> [    4.161699] mv_cesa_ahash_complete: 0 (ptrval)
> [    4.170686] alg: self-tests for sha256 using mv-sha256 failed (rc=-22)
> [    4.175132] mv_cesa_ahash_complete: 0 (ptrval)
> [    4.175136] mv_cesa_ahash_req_cleanup: 0 (ptrval)
> [    4.179589] ------------[ cut here ]------------
> [    4.184304] mv_cesa_ahash_req_cleanup: 0 (ptrval)

As I suspected, the first multi-request op on a single engine
triggers a failure.  This looks like a bug in the TDMA chaining
code.

It is chaining what appears to be a live request.  In other words
after we have already passed a chain to the hardware, we appear
to be adding new entries to the end of the chain in
mv_cesa_tdma_chain by assigning last->next_dma.

Unfortunately I don't have documentation for this hardware so I can't
say whether this is definitely illegal but it certainly smells bad :)

Boris, what are the rules of engagement for TDMA chaining?

Is it really OK to add new entries to the chain after it has been
given over to the hardware?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
