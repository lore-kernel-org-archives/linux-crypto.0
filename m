Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893B3187346;
	Wed, 14 May 2025 11:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747220972; cv=none; b=Z9MAmoLLCzll3fqzvygOg6S1hysKv50ZbseWAzZZOKhCnMVBTDYwRQOxNV6k2+kaaRZGdiyPwZyeT6Qw/zEWcz43WdGLDn1I5VBeKB58Y74+lSwUA4LcmrmNKzmR+KR8UaDRfpHCfTollX70zTrolFwpKAKcO0Pzj9P0opyJehI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747220972; c=relaxed/simple;
	bh=gs6oVQZghPS4vPL6JjYWbVPJu95Py1bNj+u6Ia9TJRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FWEsm3zLaID+E7/O7RLa/BHY8jChIk9XTQima3EBA5iqxN2QS64MdFSRP73w7W6dDt9q4CVqkj+DUiK0n/8D85LrfwqWezoNqJYTC9vPtTGB9qIRyrBX+CeiC1NnZhxUziWdzLAaOZpJoTVi9Dt58K9MUvmwxHio15svwIUQ0FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=CX3AZRd2; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Ii2l2BLL; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CX3AZRd2";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Ii2l2BLL"
Date: Wed, 14 May 2025 13:09:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1747220969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=03vPXI9ofAu7xmrYXYtVxCHVRk/wSESU2ZQWVeOCLwU=;
	b=CX3AZRd2reIxv0bRwhXGMfOC+DeuqFdSD96E+h0RVZR5gj3ZPYDeGTPFPqg82MuNhR3Lwk
	XZ58aCiQfLHj9sv9ksEeVvYqwBBeyXkZQP1/rOWF/wUfgi+KvEblbNFWWkd+8IVx2JTnPW
	zu3bbW2dCYNPlNalzqhsRep6XOgkdeYfTqveo5C5K5mxAnp+/Vev5WgRNflrYQ822NNClS
	jEdqywlitgrAh2KH59T0NQeE0CCdrSPO9zl6sIcoByXLkKLh0vnAAB2EVKrDzFrcCNOe1F
	vIRYPa/FBULE0cziLuWxRrXHiLsbDNya+sRaiZDWghLreGGNLVehsoHa0hnu8A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1747220969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=03vPXI9ofAu7xmrYXYtVxCHVRk/wSESU2ZQWVeOCLwU=;
	b=Ii2l2BLLLc2LxtAsdtk70ZwjJyLSg37whUHMMhLEicnBgGDHjt0iQEfM/pqMhsRWMRlY36
	zpvkFygs9uwGoGAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/2] cryptd: Use nested-BH locking for cryptd_cpu_queue
Message-ID: <20250514110927.cwwZr3Sw@linutronix.de>
References: <20250514110750.852919-1-bigeasy@linutronix.de>
 <20250514110750.852919-3-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250514110750.852919-3-bigeasy@linutronix.de>

On 2025-05-14 13:07:50 [+0200], To linux-kernel@vger.kernel.org wrote:
> cryptd_queue::cryptd_cpu_queue is a per-CPU variable and relies on
> disabled BH for its locking. Without per-CPU locking in
> local_bh_disable() on PREEMPT_RT this data structure requires explicit
> locking.
> 
> Add a local_lock_t to the struct cryptd_cpu_queue and use
> local_lock_nested_bh() for locking. This change adds only lockdep
> coverage and does not alter the functional behaviour for !PREEMPT_RT.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

This is meant as an example for #1 and should not be applied.

Sebastian
