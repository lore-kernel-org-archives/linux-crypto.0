Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B027C2F999E
	for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 03:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758080443; cv=none; b=HI4TchD7an+Ig+q4nqw59ptPad9owT6AGo/fLJ2lV8O8gWoEmLGMaJiwZGKnupadyvZMQw5DQIldphv+S+PdBR94WV7SMNqzjq5rRFqCkrJL+B6hP2I2G0rYMdmqrx+9sb52BoepfAVx2En1t1gvrJp4dYNioRLisZdbb5oghys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758080443; c=relaxed/simple;
	bh=RlKVeEpy7SM1GRgoNp1ryVPRzP4Jo7O8zkEsd601fFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AYuv+ofW/lRYYlY5vgzKx4O1rNSt/HCyZpJcnVfZCApEdqq0xem1HEf3iGEWlLxo4+an3Ea2U9vJMNXJiPn0YfLw1fO2MzwqpUP5GJhPg3xJLeL8t7FOhyiYfxDDecvniqfN0Xe16m+R2Lx0Kwz7Cu6jY0LRA8A2fbQuWmwErTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=biOUEt2b; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="biOUEt2b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/B6ysI/7ghP4/ED9gtBp/wRs8eJbfa3/4RMrl2tof7A=; b=biOUEt2b9sdBG4nuVSmSkJ4icu
	uCfjrquuWYL4cHBwTfO/lep/Oia9qRDvF+8PiprKX+f8xoLVdPM/Tyn8huwmPCFAOetP5/OgHmpNt
	S/vK6fO/ODPpTNU4MUiq9EZq75dWp+81ZVUezjkcr1nHYsXInKI/dQYOkMHnhwqX+ErKOFfG3ASlm
	ZyCIiHOGtoCNpN7y9HGf4+EuQm0B71x6cPW+8EExbgsEXFxy5JmIBjauJ8HwgC1rJIaGTUOxsuudt
	anxmngy3tbqJAXPsaF+YmmSsDeG8iDX/5wU7UQf0qt2NukVRqILjs+PQ4h1KRTnyyIl2hx6t27a9c
	M7Co/cGw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uyimR-0063hf-0J;
	Wed, 17 Sep 2025 11:40:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 17 Sep 2025 11:40:23 +0800
Date: Wed, 17 Sep 2025 11:40:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Re: A question on crypto_engine and a possible bug
Message-ID: <aMotp5meAdEtqr9R@gondor.apana.org.au>
References: <55446d58-0ca7-4d1c-9e9c-4fcbf8dcda1f@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55446d58-0ca7-4d1c-9e9c-4fcbf8dcda1f@ti.com>

On Sat, Sep 13, 2025 at 02:48:11PM +0530, T Pratham wrote:
>
> So, the do_one_op function registered by the user in *_engine_alg, what is
> it supposed to return? Seeing the int return type, I assumed it should be
> 0 for success and error codes if any failure occurs (-EINVAL, -ENOMEM,
> etc. for appropriate failure). Before returning from this function,
> we also call crypto_finalize_*_request, and pass the return error code
> to this as well. So do we return the same error code at both places?

The do_one_op return value is used to represent errors that occur
before or during the submission of the request to hardware, e.g.,
the hardware queue was full.

If you return an error via do_one_op, then the crypto_engine will
carry out the completion for you.

If you returned zero from do_one_op, then the request is yours and
yours only and you must finalize the request when it is complete,
with either 0 or an error value.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
