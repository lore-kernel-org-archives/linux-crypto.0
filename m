Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A14E18B484;
	Fri, 25 Oct 2024 09:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729850077; cv=none; b=NINr0eJ29nmEu2XMvLuk62yadTe9chLir5pmMKbWZAmW/PBUJN1AxMl02azwYKn2ttuUFZCVyplY35WHXUIsfOwVDDdZhhhWgrOWpwdPByS/CZ1O+UzyGZujF7H4rS303+eoegJiXUr43omXeCVY3OEJxQ5VBX4EH3oaV9rf5lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729850077; c=relaxed/simple;
	bh=VaY2KYzLE62zhvzBnMR7wbJJZD8/BO9nA9OQj2/oiiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/o2jsZbkmwvX/Bpn19s9rP0ISZeoJTVY2hA46Knv0CT3/TTphvFBrT3Cc3sN/PNgtBfqcUHQipVol9zEfD+F89HLBjSwZQ3mReDAs+7FXupXMaPWZf5394lJrFFF+wpl1e5zoe6BnCgJ+BOfFKf/hoisuEUX7m2zHK+E/TeZsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bBHGOoDs; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bBHGOoDs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=scgKpMyHPoXj/z+PG5byqhezzc3ZA105Pg/BIYUr3WQ=; b=bBHGOoDswiWdw55NBzvJt0oFKw
	qO0ehaYYnR+uxDdFrwNid6yBWxDwkpSTYyZovZSHOfYBhsnEwG4wCt9ebUfqRgoZu4Q8fO8a3LgpL
	a0gmky0glkIaWEB/FP4K9hdM0wkR/l/xzzNEiZY74Yxos5b65+smctVEjxbMefnCYht/z4GeabQSY
	idfKxL/PcCaVryFlt9af0BycAN6om+astwOkaQ6+TAUslgG2NlUcuWIpMt8CLt1TRM9KDzWs+Kd4l
	ZvBY0xViLV5vvqTptopPj3RvQJi6xRQdtXMWeLOyg484x0oVqulhBmgSw1oF4oxs4rPwMKQVGhVDd
	XO9uKhWg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t4H1V-0000000558l-1bIm;
	Fri, 25 Oct 2024 09:54:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9A8CE30083E; Fri, 25 Oct 2024 11:54:25 +0200 (CEST)
Date: Fri, 25 Oct 2024 11:54:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com
Subject: Re: [PATCH v4 1/3] spinlock: extend guard with spinlock_bh variants
Message-ID: <20241025095425.GI14555@noisy.programming.kicks-ass.net>
References: <20241025094734.1614-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025094734.1614-1-ansuelsmth@gmail.com>

On Fri, Oct 25, 2024 at 11:47:22AM +0200, Christian Marangi wrote:
> Extend guard APIs with missing raw/spinlock_bh variants.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Feel free to take this through whatever tree the rest of the patches are
targeted at. I don't think I've seen conflicting 'demand' so far.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> ---
> Changes v4:
> - Out of RFC
> Changes v2:
> - Add this patch
> 
>  include/linux/spinlock.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
> index 63dd8cf3c3c2..d3561c4a080e 100644
> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -548,6 +548,12 @@ DEFINE_LOCK_GUARD_1(raw_spinlock_irq, raw_spinlock_t,
>  
>  DEFINE_LOCK_GUARD_1_COND(raw_spinlock_irq, _try, raw_spin_trylock_irq(_T->lock))
>  
> +DEFINE_LOCK_GUARD_1(raw_spinlock_bh, raw_spinlock_t,
> +		    raw_spin_lock_bh(_T->lock),
> +		    raw_spin_unlock_bh(_T->lock))
> +
> +DEFINE_LOCK_GUARD_1_COND(raw_spinlock_bh, _try, raw_spin_trylock_bh(_T->lock))
> +
>  DEFINE_LOCK_GUARD_1(raw_spinlock_irqsave, raw_spinlock_t,
>  		    raw_spin_lock_irqsave(_T->lock, _T->flags),
>  		    raw_spin_unlock_irqrestore(_T->lock, _T->flags),
> @@ -569,6 +575,13 @@ DEFINE_LOCK_GUARD_1(spinlock_irq, spinlock_t,
>  DEFINE_LOCK_GUARD_1_COND(spinlock_irq, _try,
>  			 spin_trylock_irq(_T->lock))
>  
> +DEFINE_LOCK_GUARD_1(spinlock_bh, spinlock_t,
> +		    spin_lock_bh(_T->lock),
> +		    spin_unlock_bh(_T->lock))
> +
> +DEFINE_LOCK_GUARD_1_COND(spinlock_bh, _try,
> +			 spin_trylock_bh(_T->lock))
> +
>  DEFINE_LOCK_GUARD_1(spinlock_irqsave, spinlock_t,
>  		    spin_lock_irqsave(_T->lock, _T->flags),
>  		    spin_unlock_irqrestore(_T->lock, _T->flags),
> -- 
> 2.45.2
> 
