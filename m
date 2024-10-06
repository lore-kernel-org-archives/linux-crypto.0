Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EAA15444E;
	Sun,  6 Oct 2024 09:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728205897; cv=none; b=Mr94HX7M5M97eDYQXumkqbun9Wg43dLi2Un8fVf+eATpA27Me7bW/yHQJhDg+P/LjrWcpgTokrtq4UDMGGmuW/ng34p4wwiJl+fItQi3Pdhqm3W1R/iNq8dfnpQraI/sLUe3H9HoiyTkyvqftCzt921g5fdqRi3y0kvxNcHrmxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728205897; c=relaxed/simple;
	bh=xlKlKgRuc8qjN4G3/Tzxa0cyrZ3RlG9lR8hrI9QjqKA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Wrh8QVmNczSZ9ojoamgqOZokeVQgcNLSLVTdbnGaWkNZHz4GryLW5S6MJuw+9BUZ7CqGGQrXSZDKAMowDjVa8/Egs1T15RT9TrRYu3TP+tiZMrfGiy+oBwKhMftd7uEyKEg62WBkqG6f8o8tgiiMsg/iuJPikzQP24F8CEk/+bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bDCb6nn5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bDCb6nn5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=WlRrQ+D7JLm1BG4Mvs34iW8Ec+6c18hoPBAnK0niUA4=; b=bDCb6nn5MNs28YJUHuNsYgkxEN
	87XxNAP7hFsdBW7nA1JjPuXQymL8tmHTV3oUJyojyqZTQKMrWUg4myeF4Z261+j1DwPsCUdXD68Wl
	PHSor409Wkqp8wAZiH+yrNVnf9ydjPLhU4m3yAXQetCfajCVSqF6RleExaROcfkLY1bFW7yaHk7dP
	O9bANMGAIsD111KnpPv9jXCi+mvI4f0sXbymrVS/FD065WKPzBhjF9PxkosBEOfyKAdmm+vZ3omYr
	TtWl9VSOeZ+UE2Ckbykbl0H9Qk3JLb+gUsOiJQ0OD9lkxDdxWV1vDeYhCZPKvoDsqSc+qZy1HtTzN
	CPePNMKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sxN8X-007Dj5-1k;
	Sun, 06 Oct 2024 17:11:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 06 Oct 2024 17:11:23 +0800
Date: Sun, 6 Oct 2024 17:11:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
Message-ID: <ZwJUO5Nz3S7EeqO6@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef7c7a96a73161e0f5061503242a8d3eddef121f.camel@gmail.com>
X-Newsgroups: apana.lists.os.linux.kernel

Klaus Kudielka <klaus.kudielka@gmail.com> wrote:
>
> [    0.330736] alg: ahash: mv-hmac-sha256 test failed (wrong result) on test vector 1, cfg="init+update+final aligned buffer"
> [    0.332541] alg: ahash: mv-hmac-md5 test failed (wrong result) on test vector 1, cfg="init+update+final aligned buffer"
> [    0.341851] alg: self-tests for hmac(sha256) using mv-hmac-sha256 failed (rc=-22)
> [    0.352648] alg: self-tests for hmac(md5) using mv-hmac-md5 failed (rc=-22)

Please post your kernel config file.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
