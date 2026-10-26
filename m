Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792974761;
	b=gz6Jp436AQYxYuzp0RVxTpTNqOZOIeYQKtN5bwzJVaxmok5fsYpl2+MT7udH15p/VyoX
	 qETWTztQj8i1Ng5bPDv0u6tJz44OxyXlLs6NUQu42n3yQUWBeoP7gXmhjMS6VpUMUzi0x
	 Yc9FE+tJQ/YBxr6X/Q1FwEq/E4h5Zea/x0rlolo7loVSFChrJgHqO7wi91qoJu8l3qdO8
	 8TIQMD+pXSncg3JLbduDb/pzCQ9zody5sItHbkL3nYWLPvcLKDE4bB5reng5CVa5wXa1R
	 CYpAUk0GZZbC0WvNiqvmkPQ+TR1Py4ooPG109OsrcJMBboXQCR/aFX5SEzgyolyG82g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792974761;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ItPNGm3M23Yt+NV6y8kRZpOJm7IEZSj6Rf/E4XgKtL0=;
	b=lFWYx4kzh5/7bXbGSjUTxSUYupNddTja9tlD5stvUiwpg1qMQr5V0dOcDsuzRpuk65vR
	 U51kJz9KHuohy0phDpHpDnpuwh9+0Ox74Oz1XNjmY6VE8+uAgn/8tAt/n2jyOhDHNmzsw
	 u/QX7jxuZ9ZRte8i06IimoD6OWeVkA8TwH/MgUEHVVaEi24FogLypIPOxchG5KoUyOc6a
	 ml2qzGUvH9uolRcbWRpeQMXtJycdLYojfrBBu3ljEGxbl+1/UENrj9WWUHr5ThK4tiSo8
	 +XneYDJzGirfh8M2Wc5+o8zThle0tGDsJxJrDQPwQ4E4fCIy/8JsR1JtUTn7Hvm/o2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LDT0AKRr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 94979606A31A;
	Mon, 26 Oct 2026 00:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LDT0AKRr
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B24881F01825;
	Mon, 26 Oct 2026 00:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792974761;
	bh=ItPNGm3M23Yt+NV6y8kRZpOJm7IEZSj6Rf/E4XgKtL0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LDT0AKRr2h+0Bk0yMQ3JpDAIz8wiCjaPfsPiySbQp3Vau4vUgp7eHZBtQUTUIVYYq
	 aXAZCw7tRXvmW9zxR1/jAQh7AxMKfGbCIwWCtLqKjLTN8yXcnTfW6QOKprb05qyVZP
	 ImOJTIocZGH2bPvWSLOZQaq/VQCdaIvrplAOTlpfyGrrViOeZKAPwB7LK4W86LLO5b
	 x8rMRwUY1oB1bzzSvcQkLyEJqVmOSDZs2/qbIxbuNyH2Gufm6sABprTEAtXV+8y3Fk
	 gEVdAxCsxVoo16mrj5q2WpYJwX2GYjtTRuyfJpG/3ZjSJBZtkFsGOTKZw5FlRTTzbc
	 O6sX1lesphLOA==
Date: Mon, 26 Oct 2026 02:32:37 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Check return value of crypto_kpp_set_secret()
Message-ID: <at6fpcT5EJIZD8DD@kernel.org>
References: <20261025211119.138277-1-ebiggers@kernel.org>
 <at5-ve5Ap7Oyp1Fo@kernel.org>
 <20261025224723.GA148998@quark>
 <at6MlY1kpfa01tr4@kernel.org>
 <at6QqYWELUtDqUUT@kernel.org>
 <20261025234009.GC148998@quark>
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
In-Reply-To: <20261025234009.GC148998@quark>

Adding Mimi and Roberto.

On Sun, Oct 25, 2026 at 04:40:09PM -0700, Eric Biggers wrote:
> On Mon, Oct 26, 2026 at 01:28:41AM +0200, Jarkko Sakkinen wrote:
> > I'm not sure if it already is but if it isn't, probably also at
> > linux-integrity turning on Sashiko would make sense.
> 
> Sashiko currently has monitoring enabled for linux-integrity, but not
> email replies
> (https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml#L45).
> 
> (Note: this particular patch was Cc'ed to linux-crypto, which does have
> Sashiko email replies enabled.  So Sashiko would have replied if it had
> found an issue anyway.)
> 
> I definitely would support enabling email replies on linux-integrity
> (for issues found only), like a lot of other lists already do:
> 
>    ["linux-integrity@vger.kernel.org"]
>    reply_to = ["author", "list", "recipients"]         
> 
> If the maintainers of security/integrity/ would ack that, I can open a
> pull request to the Sashiko GitHub repo that changes it.  Or someone
> else can go ahead and do it if they want.
> 
> - Eric

Br, Jarkko
