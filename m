Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132FA1E3DF7;
	Mon,  5 Jan 2026 08:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601302; cv=none; b=e8oeBgqlUhx3aQp67TOYpLd4YV1HEMdhoV9SV2ECKdZVr+9lW8TBcdfFrUm3WP81fjj6OCjZq5zbvSB9JAPYxnqY5oITyEW9ilfWlPF0MVan2U7lHJ3wxiWBVn30re34doNP2ZX+loNNnva2Y1s/lrOr1ypiO8wVTLJKZCF2rxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601302; c=relaxed/simple;
	bh=pzNN45vfkXr1RPUBI6KmJfUB8k1HbHBXCQstcnguEYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2hkAylfVqENPKtFesRl87QsMA5aziyFRvbQX1xDJGNVV/nxGLs7tIZyfOLRKjL7e2aL242XvZmXbXPoaKwV8SWMrFmOuobNTLxCmJwkOzvd2WkwZAKRiJkotknMgHalKFNv+fHKAJIuxOr8gQjqsWwU22YhuaawqHzHlLyZWBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=dqzFMntG; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=zxo48jSG; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="dqzFMntG";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zxo48jSG"
Date: Mon, 5 Jan 2026 09:21:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1767601297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PR1oU9VKOy/F8fVKY6y8SKt+SSbfQRO8I/mYAyWRNPs=;
	b=dqzFMntGuqY9FOKdA5Mmqc0jGzur9h5ZdPKouby+M5w+QSZQ1lBqCnml5icAZ0C4WmUG+A
	H0kSrmtr0u4qs4nuNmrzvGSlASZT5uc708bxI4AUgxPLoFfpKQbog6uyN4DsB91VkXXKJe
	N6YJIrY9k6TAlAvLOPT0sOroZvSkQfPkrMrGBwdpQpvLSR4kzNJuJ1e2S+JUO1bTlgMLYv
	nh94tt94TA6Fox2nrS2eQk5AdRiTWIACu3sBlkuQKVKQ+mbungITQb/8sKY52O4ptgTCob
	UcffgD+mz2IhB0ir3clBXsS0t4NgW7lZ7Wq2GZFdwqa8Oh5iH4Eo+/zkAjEmqA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1767601297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PR1oU9VKOy/F8fVKY6y8SKt+SSbfQRO8I/mYAyWRNPs=;
	b=zxo48jSG29LHlvI6PEikRbIskNKLrs4WtT3vSDqF4A1eubexBcwGuI6etfZ/GFAfOimzGt
	j8NJox7iS+tc6QBA==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: tests: polyval_kunit: Increase iterations
 for preparekey in IRQs
Message-ID: <20260105092043-d18628ec-a42a-490b-8bbf-d611dd5afb5a@linutronix.de>
References: <20260102-kunit-polyval-fix-v1-1-5313b5a65f35@linutronix.de>
 <20260102182748.GB2294@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260102182748.GB2294@sol>

On Fri, Jan 02, 2026 at 10:27:48AM -0800, Eric Biggers wrote:
> On Fri, Jan 02, 2026 at 08:32:03AM +0100, Thomas Weiﬂschuh wrote:
> > On my development machine the generic, memcpy()-only implementation of
> > polyval_preparekey() is too fast for the IRQ workers to actually fire.
> > The test fails.
> > 
> > Increase the iterations to make the test more robust.
> > The test will run for a maximum of one second in any case.
> > 
> > Fixes: b3aed551b3fc ("lib/crypto: tests: Add KUnit tests for POLYVAL")
> > Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> 
> Glad to see that people are running these tests!  I actually already
> applied
> https://lore.kernel.org/linux-crypto/20251219085259.1163048-1-davidgow@google.com/
> for this issue, which should be sufficient by itself.

That works, too. Thanks!

> Might be worth
> increasing the iteration count as well, but I'd like to check whether
> any other tests could use a similar change as well.

No other one of the default tests failed for me in a similar way.


Thomas
