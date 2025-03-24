Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFAD2512D8
	for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2025 08:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742803627; cv=none; b=XwZvDb7ZZ0IGa1eIQPcge3GmXyOmTAUzaTci2yJ+d3XhMzrgDpnTnqSD9BNkzr7zsAxWtswDlQP5WJte83SN6ujpm8SlwGm/XStZmaES9EyNSlNWr6bUp4Vn3qPLqt1+cc0yH+uHQnAq80AvxWBi//jKiJ1+Mc1P9MaOxKkKxRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742803627; c=relaxed/simple;
	bh=J8v4s7NlerTFCPE0p8HCGcggRz3JJuSjcFdHREPqtsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lOYIoDmG1/EOkxbETnBFqzdmnWR9umNgBfIJHqEZJkCe7dwBl1GM0YPxJo3UBtPld+DAHoQIOEBErT09zH9YokiZl7IJwx1EZ2kH42eF2OhG1PJAcVLq7nXQGjPMUhOza5YgKFZ5kk7xY2kVr5clfuHploZfcJsdOG3vv/MBFho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=c9rPQMKG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="c9rPQMKG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FSoeMNnOJyqvjn8UF4Juy36GQ0p9JAl8kpjUh6lAj/k=; b=c9rPQMKGGXn6dBYRuabI+/eyQS
	2VTnvOrBkb+7am/g9je9azZHNuWf/P+24QT7I0p4Y9qpkv/0caS1gQuY2lIXoqoLxqp0VeDHORe/c
	C0X1Qf08EkYKlIZ5CUSH94cPIRJuqdzmpVakQSTPLCunM9vgqcHalMhoBjhNGD2IHCpNOjdwBkjUA
	ltDyA2834JD/8/MSdMF1wmj2yCZ9azkowD0RJJS7gmYUo2wXb4sltpoKPEOLJSdOAT4w6LIC+jUgC
	QucEUT7eKLYiPi9ZWLrLPbOTYIYdUWYRgbE1sh/7eEJ76gQkXhMzIbLuxRMBhBioRDhTgsOJYeKJs
	U6ibfuCA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1twcpo-009eqZ-0b;
	Mon, 24 Mar 2025 16:07:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Mar 2025 16:07:00 +0800
Date: Mon, 24 Mar 2025 16:07:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gaurav Jain <gaurav.jain@nxp.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Horia Geanta <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>
Subject: Re: [EXT] caam hashing
Message-ID: <Z-ESpJxIG8jTGHZM@gondor.apana.org.au>
References: <Z-AJx1oPRE2_X1GE@gondor.apana.org.au>
 <DB9PR04MB840907ADF03612B64D1CF910E7A42@DB9PR04MB8409.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB9PR04MB840907ADF03612B64D1CF910E7A42@DB9PR04MB8409.eurprd04.prod.outlook.com>

On Mon, Mar 24, 2025 at 06:23:41AM +0000, Gaurav Jain wrote:
> 
> It should be CPU endian.

Hi Gaurav:

Thanks for the response.

Just to double-check, as there are a few different things called
caam_ctx, I'm talking about the one in struct caam_hash_state:

	u8 caam_ctx[MAX_CTX_LEN] ____cacheline_aligned;

So when the hardware is done (or before we hand it to the hardware)
caam_ctx above contains the partial hash immediately followed by
the running message length and the latter is in CPU endian?

The same is true for qi2, right?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
