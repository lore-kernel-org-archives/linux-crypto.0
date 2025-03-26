Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFD31F4736;
	Wed, 26 Mar 2025 20:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743019921; cv=none; b=QUv0h1q2mH3oHboe8vHnK/DJxQiPnd7YCBV3zqx7NqkrM/FJiZP5ukZ69mgAl3LKpJqn7ncb78ToxFV4lm9bArFW3V1a4hHGAv4j3mumcdreJ/daMAzShZuiyyUEUSRxWhRgynmGPM/bVpK1Bf0XNPrOv0Z7b94IV+0Js3TrRII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743019921; c=relaxed/simple;
	bh=Nw5+UdFmuqeASIGkBgOhWfX5YPpSQVc+i/qjez8P77c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dv+yb0OZee74jLqyTwbBActwjGTxOspVqnj0r8ldVbdZfdCbWwLG/XiaSP5aF2kMOFL5H6ZqhVVArxraVqXI+WxSx18ONf62NE8gqrELzYu6vDgzpzQeniRha6nYRwU+GpXmu+f8YhquHsrzFykPXnMcUfQwCJykzIhI/tXhUY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXiWo7nc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXiWo7nc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6420C4CEE2;
	Wed, 26 Mar 2025 20:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743019921;
	bh=Nw5+UdFmuqeASIGkBgOhWfX5YPpSQVc+i/qjez8P77c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pXiWo7ncIulaeSE7eQDy33lCzqiEvuYvR0wLIXgzGKJzHVKUVnpMkD1FqtKZoYgHR
	 HJB/bOaswS+rwdA2ygkbI5oCmwFvQun4YYzHCKOXmOEvOoKU9/CrpRZMjws8GklFm/
	 pY6HeoyrRtu6RPcFC9l89hpn/lGBhe4HpBZlltW70sJfZfJQDuOSLmo77fcxDSol/0
	 P9T8MQduY+TxjMjeAtf6DkM8Hx4GFOgbILuChTjcCPYkbZgLpcW98J115BywP6A9g6
	 jqf/50rmI6YRQgSLY7hHG4pRJLu/hhmz949j3i/pD3B1dUZ83cWzt3wG73L+/QLx82
	 NBX/kAuhtpVMA==
Date: Wed, 26 Mar 2025 13:11:59 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Binderman <dcb314@hotmail.com>
Cc: "ardb@kernel.org" <ardb@kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-6.14/arch/arm64/lib/crc-t10dif-glue.c bug report
Message-ID: <20250326201159.GA6625@sol.localdomain>
References: <AS8PR02MB102170568EAE7FFDF93C8D1ED9CA62@AS8PR02MB10217.eurprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS8PR02MB102170568EAE7FFDF93C8D1ED9CA62@AS8PR02MB10217.eurprd02.prod.outlook.com>

On Wed, Mar 26, 2025 at 07:12:00PM +0000, David Binderman wrote:
> Hello there,
> 
> Static analyser cppcheck says:
> 
>  linux-6.14/arch/arm64/lib/crc-t10dif-glue.c:53:33: error: Using pointer to local variable 'buf' that is out of scope. [invalidLifetime]
> 
> Source code is
> 
>     return crc_t10dif_generic(crc, data, length);
> 
> but this line
> 
>             data = buf;
> 
> looks very suspicious. Suggest move local variable buf out
> to file scope.
> 
> Regards
> 
> David Binderman

Thanks for finding this!  Kind of a silly bug, but that's what we get for
programming in C...
https://lore.kernel.org/r/20250326200812.125574-1-ebiggers@kernel.org and
https://lore.kernel.org/r/20250326200918.125743-1-ebiggers@kernel.org fix this
for arm and arm64.

- Eric
