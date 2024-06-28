Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A800D1CB31D;
	Fri, 28 Jun 2024 16:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719592977; cv=none; b=rimFINLxSJ/BKcLC5uTCv85cAvqQZ7BNJK/LuolduyL7VIYLMuz++LRRY+CXGk7NsHH7/6QFYoJETF8ORJ6eDH9knQTFfRCVspQIEcWdBLFBEvFd1Y7GS3NPXsANxYH72hDecQOwZrVh7DvnZqflFZ6DR+pPeng/SsAI8hRpzFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719592977; c=relaxed/simple;
	bh=kf9Cz5WqooZnsLSJUPTvU+ghJLUuob00vSQBA2ikd2c=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=if/S5dO/5T9bFBI4H5VsHpsk/xXNF1DXud+XVm/QaztgaTZbLGY89XAgKm+oHDM5v2h8NcYouR5az8VcRgfhpa3NJqT+p0XIbEE0Czs7/14iM1md8Zfdq6LboQftLx8UJ7LfWkN8DKrtMMtI207YU8yg0THLmeKjsHiLCMX4L7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 8297D92009C; Fri, 28 Jun 2024 18:42:51 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 7DC2A92009B;
	Fri, 28 Jun 2024 17:42:51 +0100 (BST)
Date: Fri, 28 Jun 2024 17:42:51 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: WangYuli <wangyuli@uniontech.com>
cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
    linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, 
    Guan Wentao <guanwentao@uniontech.com>, 
    "David S. Miller" <davem@davemloft.net>, 
    Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH] MIPS: crypto: Clean up useless assignment operations
In-Reply-To: <CD5FFEE4BEA56308+0122a540-e098-4982-9bb1-110b449cbe02@uniontech.com>
Message-ID: <alpine.DEB.2.21.2406281713040.43454@angie.orcam.me.uk>
References: <1D248893502B75F5+20240628084117.84264-1-wangyuli@uniontech.com> <CD5FFEE4BEA56308+0122a540-e098-4982-9bb1-110b449cbe02@uniontech.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 28 Jun 2024, WangYuli wrote:

> As you can see, regardless of the Clang or GCC version, this redundant
> operation affects the generated
> 
> assembly code.

 Boy, this code is horribly structured!

 Anyway, rather than making it yet worse with another #ifdef I'd suggest 
replacing both `while' loops with equivalent `for' ones with `len' being 
the worker variable, which will then make the code structure a little bit 
better and as a side effect address the missed optimisation automagically.

 You might also consider Herbert's suggestion to use IS_ENABLED, however 
in the current shape of code I find it kind of pointless anyway.  Instead 
I think that it would make more sense to factor out the block bodies to 
small static inline helpers and then restructure the call sites so that 
IS_ENABLED controls the loops, the conditionals, and the choice between 
them as applicable.

  Maciej
