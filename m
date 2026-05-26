Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1C2369203;
	Tue, 26 May 2026 22:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779836244; cv=none; b=Ofat9f+ttGcNtMYu/YDAEgEBONdek16pHFNc4C56XWC6gcrxw0KBeAtqRrL7ypRLJNKpN52YbSKg3svq48NyIvKUSvCXj8ut0y+LJy3IQ7YU4O+pkmYUzkyOVdU7XP0uzOxG/tieO/8THrxW59c5pdxtobXI2bkvm2byDgoAwu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779836244; c=relaxed/simple;
	bh=rrm1X2Au+GwWM7X248OH5MAqa2qLhw0nxEyO79WXfdw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tZEFVNA4J6iMl+wQnSeRl1wyRonfOs44oyQuVqyGzLQLouIvwh4ho+d5a2xbHU97bhV8aDmrXowCEZC6kaW4iiT5jVhHAxOWCOWlxFQBAx/fAkIOfezJFOkZyBzpwdihk3f0Cad9lyiYA8RJIhBMG3rzQpd8SPxkiPkIkK0rWNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrAZrVAf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrAZrVAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCD51F000E9;
	Tue, 26 May 2026 22:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779836243;
	bh=GTLQbQirWCX9wneQxMJs+zrdeHvDyYa9lL03+uAy86k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jrAZrVAfWe5reoPlJzAvC0IunOmAr3jfsAMnufUy0DSpPA8pWHG3wkkMtYQLNY8/r
	 h17vDPURuVj+SwJbgdgdYupLniYFm8h+JX9rcq8run04D02CUL+M0+i7IUt4ec0Slp
	 52MNOK4zlevHB+n+JxK9emNwl495Y6Ux64z6JFaUt1j91K+SY2FMXvP0LCr2GPpUqf
	 Ai/cBhijYBMtMEYsQ7U+GqXliCBGCQq63sHmdM4JPDZ/h6eB26l9eWOr/s/7Z0Wpwd
	 z+smdefEGbhcrBvETFN5vLF8vxm95mK/enTZ055bUJzYWAYBe2RD8CesP6HWURkl0I
	 defyHEprr3JMQ==
Date: Tue, 26 May 2026 15:57:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de
 Bruijn <willemb@google.com>, Simon Horman <horms@kernel.org>,
 netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] sock: add sock_kzalloc helper
Message-ID: <20260526155721.16154829@kernel.org>
In-Reply-To: <ahWezce_kddgrgy6@linux.dev>
References: <20260427104129.309982-7-thorsten.blum@linux.dev>
	<ahBRCxCXbCq5LeCc@linux.dev>
	<ahVkZOxZtFes6Huf@gondor.apana.org.au>
	<ahWezce_kddgrgy6@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 26 May 2026 15:23:25 +0200 Thorsten Blum wrote:
> Could you take a look at this small include/net/sock.h addition and
> provide an Acked-by: tag if you're okay with it going through Herbert's
> crypto tree?
> 
> The series has Reviewed-by: tags from Kuniyuki, but it hadn't been Cc'ed
> to netdev before.

IDK, feels like the usage is low enough to border on pointless churn.
Other netdev maintainers may feel differently.
