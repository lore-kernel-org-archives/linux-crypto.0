Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916A24477E1;
	Thu, 23 Jul 2026 20:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784838434; cv=none; b=Z9oJMidJGBqj5px2PtatP9Xy7XgLahxiWoGQO1rPTL6sKdPg6RVCkRIW6VH02GDQRWBU53QOyhbuVIlCqYDpifgYFG/ta19l+WY9tlHT9a0vaw4nNPoLA75cOeleT14da6iF1fcGvUYdViO3m7lo9Jl+WQXvbbkvyLYB0ICCCmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784838434; c=relaxed/simple;
	bh=F812CFouPZkH/vlk4R2JvEprY/HILGKHvr9tNzb6BuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUhTHhm1aD5uqBbrICHohGgtntNSDk7UmLZd7PI5gwUyZZkLmHrBBuZn+MsybWl6Z6bGXwxxwlr79IiHeY74v8YXS63WC5+1jbGzlaDYe5pEUosRRS+/3OjBHqZ3s0JhPJHku/5gWVIP2WxvQR+bjQc0a2g9DZSt1X/ae403aH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SErWW7wP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SErWW7wP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25ED91F000E9;
	Thu, 23 Jul 2026 20:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784838426;
	bh=0eEGwBWQ37AzG7D2H2CJsEQb6LH6p+JctMynLuf8Ufk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SErWW7wPHEWHiniBYGv2BbQNthExI5xvwAqaRbtRBAjedHxKfZwqI+LWB+pYKE6dC
	 NFIqBJVPbNKj5r6mRlD8fKEKi8xb5xfaNX8PUKcgTbs459zUW2y4BQbrBIJMZBYWQY
	 YK58/islK1P/S4/h42HgCMupOLqTbHg8uEWPdp5FbUHyv8SpQXd6Q/1k48SInyRVBF
	 STa7jANGStIfhWopHhzTGFyG9UqwIggxGZP52IDZHtc7Ixs1TM5kd5dehWOGDFpOV+
	 HBp62tCgeLImgID8UWnu8Q3VhVfFVzPNswT1vb+SAey5SEoEtKvlcyb9lAX4Pd9a60
	 QfOS+SeUvFo2Q==
Date: Thu, 23 Jul 2026 13:27:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, brgl@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v6 0/8] crypto: qce - Fix crypto self-test failures
Message-ID: <20260723202704.GB110634@quark>
References: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>

On Fri, Jul 17, 2026 at 05:53:29PM +0200, Bartosz Golaszewski wrote:
> This extends the initial submission from Kuldeep.
> 
> The QCE hardware crypto engine has several limitations that cause it to
> produce incorrect results or stall on certain inputs. This series fixes
> several bugs and adds workaround allowing the deiver to pass crypto
> self-tests.
> 
> The failures addressed are:

I was also looking at how the request queueing works in this driver.
qce_handle_queue() gets invoked synchronously from almost all the
ahash/skcipher/aead API entry points.

However, it takes a mutex, which can sleep.

Not a great choice when these APIs can be called in softirq context.

I strongly suspect this would crash if anyone actually tried to use this
with IPsec, for example.

This is interesting when we consider that the driver implements the
"rfc4309(ccm(aes))" algorithm, whose exclusive purpose is IPsec.

I'm not sure if there are some out of tree patches going on, or if this
was just never actually tested with what it was theoretically supposed
to have been useful for.  But I'd guess the latter.

- Eric
