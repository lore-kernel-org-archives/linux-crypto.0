Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D143DE459
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 14:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777905448; cv=none; b=LYCPw0kdIseaLfuQUDH9uGHZVpXN8zmD88EReyOuiYTpUnl0h1QJtqt/GY3sulESxT5ML6l8SFMBfwQ9nmLss0CMTxZB5hylq6zIfM4965fcD88cpSQ4xtoZ+Gggccsxvsb3Q4qvRPq9PuAgBq0o7EaczBLVBJ9bpbJ8p6D1XHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777905448; c=relaxed/simple;
	bh=zrzEItvI7wQsj7VV6oxbb2bq9vyhQ+Qb+IZ2obak6Us=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N/Z1R+A8Vhmwb7g189OaxgWF/d9v+eJdBo/jucY9n2rFiGIgjZKn1D4BOo+jHZ4DcuSYmywzFrLunqWH3A4BE1uXxqiw+Lk895u3icxFuRnAfGdKAtwE5FH0y1MTud/i3Jn+YAzEnvNkLdxhfP18njgtXbnGRJ80hKhVReruomY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Iogc645m; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Iogc645m"
Date: Mon, 4 May 2026 16:37:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777905441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TAGJTouWHe3Gioqsz3YMSQxBMTpanXbhgaHt14I0wls=;
	b=Iogc645mOlS0Q/AcdFW+OfjhF2ooCTHU5uuvG8G2rDU9YUsSrYpdswl2EzkIyfdoyFgg7e
	9viVS6LwX48fNQO8oklbh7G1I2AFrC/AcpyS48K7Hl5ojv6jcfzMdE3xwFWpu4wm7MVFOR
	JjrwnAvkc305nacIIkVXvVcY7y1adnw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] hwrng: core - use bool for wait parameter in
 rng_get_data
Message-ID: <afivHbWdCprHpJSB@linux.dev>
References: <20260430110047.248825-5-thorsten.blum@linux.dev>
 <20260430110047.248825-6-thorsten.blum@linux.dev>
 <afilBnLk4lapbAj4@black.igk.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afilBnLk4lapbAj4@black.igk.intel.com>
X-Migadu-Flow: FLOW_OUT

On Mon, May 04, 2026 at 03:54:14PM +0200, Andy Shevchenko wrote:
> On Thu, Apr 30, 2026 at 01:00:49PM +0200, Thorsten Blum wrote:
> > The 'wait' parameter in rng_get_data() is a boolean flag - use bool
> > instead of int to better reflect its actual type.
> 
> ...
> 
> >  static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
> > -			int wait) {
> > +			bool wait) {
> 
> You want to fix the checkpatch warnings while at it and indentation.

I just checked again, but I don't get any checkpatch warnings.

> static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
> 			       bool wait)
> {
> 
> ...
> 
> > -		rc = rng_get_data(rng, rng_fillbuf,
> > -				  rng_buffer_size(), 1);
> > +		rc = rng_get_data(rng, rng_fillbuf, rng_buffer_size(), true);
> 
> Is it the only user? Why parameter is needed at all?

The other one in rng_dev_read() already uses a boolean expression, hence
no changes.

Thanks,
Thorsten
