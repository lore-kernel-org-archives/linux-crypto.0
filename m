Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F1047126A;
	Wed,  5 Aug 2026 20:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962808; cv=none; b=jRp8Zef+GPYuuQw6KnmJsZ6enm3NetG3AF1ovImZy5jzQhtWadjMtnwPuoc5/IcrXA0WFG5XUxT4ar4E+pW7rXDAlfPYhsqj0E6U8t6lk646D+WaywLJfSlt2HAOcQWnhovjpq/2z2b5rrc5JzqywA6FA7dHtHBt8PXAgka4+0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962808; c=relaxed/simple;
	bh=Bvy4zsv5pkZIbtqJl8ntvE/ZPBB3XWQGYpJG9+mxNBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dGqrrkJxOqGJ6QZjmgRIS+jvnHOj72iu0+lp0Sc1BZ5PB3OxyijwCW6qjSpU94hj19otsZYI0bMJ+DZ9lRWGGMhFxJiP3c+594sT+/eXmZWgXoEQb4bkdnnA+xe3OeRapYYK85J4MJ/wDas+0j+/riDTcJUQyKFoQ6rgsn+LSSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=omGayz6U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="omGayz6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E611F000E9;
	Wed,  5 Aug 2026 20:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785962806;
	bh=Bvy4zsv5pkZIbtqJl8ntvE/ZPBB3XWQGYpJG9+mxNBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=omGayz6UURnVPo55hXekdARHxddnycVyYrHu4sE5/q9N1Vt/7xRg3FOlY4qd2eCVo
	 Y5XEB44d0PcFxtJ72bo/QsuaEQDOJvEdMXagAhB26po7vWWvhFZo4qJgFOHpx/v4if
	 JvDwgI19A35aDN7UqcP1+A0ZjK8GYuAdVIKy2t5YFtYDVC5zgYaLTRdrsiR3PnvlEH
	 AD9CLDYBw5SoS1M/5NUY6LJe0Zs/0vxDo2zWRPw+sbf21ZZERU9OWl1E6nAXVhQa8M
	 KQVYYmILXhjtqCkD28h4lfzRY6nMf9Rx/5BoBgKO7KiVm8BcrZC+Qcs/+9pS7jEDPk
	 wLKtFHdci5wIw==
Date: Wed, 5 Aug 2026 13:46:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] crypto: Provide wrapper functions for zeroizing
 aes_cmac_key and aes_cmac_ctx
Message-ID: <20260805204644.GH3438@quark>
References: <20260805143611.818559-1-thuth@redhat.com>
 <20260805143611.818559-2-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805143611.818559-2-thuth@redhat.com>

On Wed, Aug 05, 2026 at 04:36:04PM +0200, Thomas Huth wrote:
> +/**
> + * aes_cmac_zeroize_key - Clear a aes_cmac_key structure
> + * @ctx: The location of the key structure that should be zeroized

There's also a typo here: @ctx should be @key.

- Eric
