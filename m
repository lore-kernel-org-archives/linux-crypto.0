Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E109085C4A;
	Wed,  7 Jan 2026 04:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767758829; cv=none; b=d6XBYk7e0Q30YyPIC1XZU71dXlsp46n5by7ImHD4jxPfEOT2iW+aEpQpQDP6pX2SiGGHZCrV3adnF5+ViFkP7BlaJFTYduU5UP4x0wSrkkVc10kkTBxZY4wgFVwd2aHEkFGHZdE9OOwsPLPVtxvB3ZjT0pCW1deOJX6kLjMLWC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767758829; c=relaxed/simple;
	bh=ZbHSDxkqO6xgkZX6xrAfNyWXtmoOcWAmj9JoxRjjaDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUHkshMwE9yF8UJihUDtIxwjlXWc7OOxi7JhQdSarEKDbNZhifAQiq+BaMAG8fhfL+eF0wh4rvic/KPi01VGv5V0f7CyMdVNhX7Eb+5LQqCoT3uV1nKMCzndRFFXYp7rBkDyvWSJyoF2/XfejFYVZhxQ8qLpUVFOECe+0f1tMWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dA5uQ99c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dA5uQ99c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81289C4CEF7;
	Wed,  7 Jan 2026 04:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767758828;
	bh=ZbHSDxkqO6xgkZX6xrAfNyWXtmoOcWAmj9JoxRjjaDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dA5uQ99cb6j5xipGVmymA4Tmmto1y9PG1ZYGUKMvb0QcWn2u36BNc1p1+DPM+w7PO
	 WdWoNIdsW6+AQYGFpIazgNJWoDY2pD26MsebgJGCK4Qbi/cVaOFZ7NjpZph9SkewFF
	 /Wo/btJlvULUAX4nkAKqp/g3zwC2JnKHA/6A/IZdKJzkM6xFcb2rhiqF+1htEHZ6i9
	 JcmKOFPBaMj4WSVFcHDKo/OMKIL4N+ubIbjKJ06AKmM0ikTrn8PTeF845f04KqC7sU
	 u8LhZlNm91WaR+hD4+hT80a8o0+7KwONdCcDv1z0PZIK+dqRcoFzO3NgEtj1w/6g7X
	 BStqduKJEs35w==
Date: Tue, 6 Jan 2026 20:06:48 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: tests: polyval_kunit: Increase iterations
 for preparekey in IRQs
Message-ID: <20260107040648.GD2283@sol>
References: <20260102-kunit-polyval-fix-v1-1-5313b5a65f35@linutronix.de>
 <20260102182748.GB2294@sol>
 <20260105092043-d18628ec-a42a-490b-8bbf-d611dd5afb5a@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260105092043-d18628ec-a42a-490b-8bbf-d611dd5afb5a@linutronix.de>

On Mon, Jan 05, 2026 at 09:21:32AM +0100, Thomas Weiﬂschuh wrote:
> On Fri, Jan 02, 2026 at 10:27:48AM -0800, Eric Biggers wrote:
> > On Fri, Jan 02, 2026 at 08:32:03AM +0100, Thomas Weiﬂschuh wrote:
> > > On my development machine the generic, memcpy()-only implementation of
> > > polyval_preparekey() is too fast for the IRQ workers to actually fire.
> > > The test fails.
> > > 
> > > Increase the iterations to make the test more robust.
> > > The test will run for a maximum of one second in any case.
> > > 
> > > Fixes: b3aed551b3fc ("lib/crypto: tests: Add KUnit tests for POLYVAL")
> > > Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> > 
> > Glad to see that people are running these tests!  I actually already
> > applied
> > https://lore.kernel.org/linux-crypto/20251219085259.1163048-1-davidgow@google.com/
> > for this issue, which should be sufficient by itself.
> 
> That works, too. Thanks!
> 
> > Might be worth
> > increasing the iteration count as well, but I'd like to check whether
> > any other tests could use a similar change as well.
> 
> No other one of the default tests failed for me in a similar way.
> 
> 
> Thomas

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

I added the following note to the commit message:

   [EB: This failure was already fixed by commit c31f4aa8fed0 ("kunit:
    Enforce task execution in {soft,hard}irq contexts").  I'm still applying
    this patch too, since the iteration count in this test made its running
    time much shorter than the other similar ones.]

- Eric
