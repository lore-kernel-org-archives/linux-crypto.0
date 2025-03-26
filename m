Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537DD7404E;
	Wed, 26 Mar 2025 03:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742961137; cv=none; b=YosUHUBL5/56iWNomiyP0wzBQRjpgkYcdKARCJS/0SqALD4/iP5QJXSz7UbI84x6VGWcpqKNTPuC4aRH2ENmw+UQAVYG3HSz/NAi6YExKm4QIkWEwMtRGJlnc0mSv5jiFBov/X58Ajb6FkZ1v7hzmTMJDLN+Akd2FTV1FXI6cEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742961137; c=relaxed/simple;
	bh=xjK6OO9WhiD5GaxdX3+pZJqehxiV8rYX7PzOad2aE04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V/0cVEUXihNNEE0NQzjz6mcTZH56cWOryD3rmCl3TwonlVpa01FP4J7D6EblQbhx+Ik59OBwPXJJlixYP/7beKR2/UODmVHNvI4A07gz+mWMpwe4jwG8bSwJcDvLPQHDFfLoUmxiEu8h2ekViiH6ZvW88Vsr13dK83TmYhRItcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=H5RBtf4Y; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="H5RBtf4Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7IL1aSkiLK9cGPr2RAgTt8n5LglVETf2rwIU4ORwdDI=; b=H5RBtf4Y2fyuIo/21AEOv5s1Tp
	E7L1icUuopsnPHiCzoYoF+9bsz+f8AGe1LTUJ2g905HPUW3W3zGRZNttdtVAiNiW7j2DAvuOvm0AI
	/rV599ibF9iC+Jkix4vuAhV1CV17HCdXn6GQKNoIMEvnwd8DWXfrMzzsC0g0cVwlYXwfhxN2CTcJ0
	q8DNPSXhckdxO+ccVrTM5LYuMiDlKl7MXOh/uya6iHgViGajTY9cQpL30tLD8m6GdG39uuVx7D+Dk
	nu3iYA2E46W3WdQJGvIeAOBcXwZNYA1U6hH31FsFiSjhcWbbFQBT4a17YR/ZML5lD7XUJv3zfZa5/
	fyMllNuw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1txHoD-00ABL5-1s;
	Wed, 26 Mar 2025 11:52:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Mar 2025 11:52:05 +0800
Date: Wed, 26 Mar 2025 11:52:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 6.15
Message-ID: <Z-N55Yjve6wTnPqm@gondor.apana.org.au>
References: <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
 <20250326033404.GD1661@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326033404.GD1661@sol.localdomain>

On Tue, Mar 25, 2025 at 08:34:04PM -0700, Eric Biggers wrote:
>
> So I think your observation about the workqueue being unhelpful is generally
> correct, but fixing that is already partially implemented and is being worked on
> further.  And regardless, this does not have that much relevance to the crypto
> API.  Yes, you can't sleep from a softirq, which means you can't wait for an
> async crypto request to complete (other than polling).  So if you want to do
> that, you have to go down the workqueue code path.  But in practice 99% of users
> are just using the CPU-based crypto that is synchronous and does not block.

The point is that you don't have to wait.  Once verity verification
is done, all you do is mark the page/folio as up-to-date.  That work
can be done directly from softirq context.  So all you need to do to
support async crypto is to mark the page/folio as up-to-date from the
completion function, no work queues are needed anywhere.

Look, right now you've got this crazy cargo cult programming paradigm
of work queues that is worshipped because it lets you wait for async
completion.  In reality it is forcing everybody to go async even when
they don't need it.  Take ext4 as an example:

	ext4 calls verity
	schedule_work(verity_work);
	return asynchronously!

verity_work:
	do the crypto work
	__read_end_io(bio);

Just get rid of the work queue, it is not needed for async crypto,
which you don't even support anymore because you hate the interface
so much.

Even if we want to support async crypto, all you have to do is move
the __read_end_io call into the async completion function.  Voila,
no work queues are needed.

	ext4 calls verity

verity:
	ret = do the crypto work
	if (is_async(ret))
		return asynchronously;
	__read_end_io(bio)
	return synchronously;

async completion:
	__read_end_io(bio)

Networking has been doing this since 2008, I have no idea why storage
insists on the crazy workqueue paradigm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
