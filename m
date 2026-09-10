Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D978288505;
	Thu, 10 Sep 2026 14:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789052377; cv=none; b=jRyeEjy4KCDN6n5pBnqmmEeaAxTqBDeuL+BQkOc+48KH1G5OqTh9hVeglcxEjRBTGQ/spjv3EUZ4NgAPewrvScQgMr1VV9JUzr7OgEnZ2OXRsc+xRSiGg3buq2A5IMZ64aFgIgWwdTNB/OLeFjG7hTEiB0kJ1ypgJP3f39pW8yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789052377; c=relaxed/simple;
	bh=hj9qAXn/zoD3nVtm5EQwtB2Qv72feVVly7L/xTEcPK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TapMCDMyJGD3SlwSoYugV/r7Pj5ECVkImPZSyiy6t8qklS/VppnEQ65XBoKmXrzjy/SCmWi6Lih98pWWyAcizT5CNFpjnoqc8nG+dJG7A3QZwivtdE7q6DpiDbFfx+Ce5nhpDEmgvoCs3b5q7BpUIaeFtN2MQrHbT/cARRxoIBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZ7xHOSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZ7xHOSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9871F000FF;
	Thu, 10 Sep 2026 14:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789052375;
	bh=FK+j2G59O6ul73//uvAAAdQWhLiKdDpmn+7SecJshMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kZ7xHOSpWAqcLGxA8bC9w6/r5GnM/pOPfZ5pShSmT0+o+nNiquU3wTYupRR2kX1Wg
	 skUIdKWSAdlz9E+Za1miyJQscx2Uu1qrQ7Y2vZkaDoetB23Vf9slRG+tYbDtNW3wRt
	 WHmmLZIyWEZaFXyqcAlE5Zy2eZUtSVdF+4uqad1TVpAOCH1CgLN6hLhE0IPSGy656h
	 nsXpPnxSlIAbykIbhnCpUC/9zdlV8ag+ipshzTp2XWe8+lENWEqF1bCURuT5rNh0d/
	 FSJjkAPQtkONWai0JxLM69GVIRhSspwKFm/rBKoxu/2VAOekACyPalmnystZgGRO9n
	 PYfwL5rBbgaqA==
Date: Thu, 10 Sep 2026 09:59:33 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
	linux-um@lists.infradead.org, linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 6/8] x86/fpu: Remove cpu_has_xfeatures()
Message-ID: <20260910145933.GB5719@quark>
References: <20260901145740.42337-1-ebiggers@kernel.org>
 <20260901145740.42337-7-ebiggers@kernel.org>
 <20260910083801.GU4121339@noisy.programming.kicks-ass.net>
 <20260910142301.GAaqK9RVdjjmpwX876@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910142301.GAaqK9RVdjjmpwX876@fat_crate.local>

On Thu, Sep 10, 2026 at 07:23:01AM -0700, Borislav Petkov wrote:
> On Thu, Sep 10, 2026 at 10:38:01AM +0200, Peter Zijlstra wrote:
> > Boris, can you have a look? For now I'm reverting this patch locally.
> 
> Yeah, I'll zap it from the x86/fpu lineup and then we can see how to fix up
> everything later.

How about just applying patches 1-5 and 7-8, and deferring the actual
removal of cpu_has_xfeatures() to the next cycle?

> I'm not entirely sure how to go about fixing this. Some seem trivial
> enough, but others, like XFEATURE_MASK_OPMASK I don't readily see a
> replacement for.

XFEATURE_MASK_OPMASK is just part of the AVX-512 state and it will be
implied by X86_FEATURE_AVX512F.

- Eric
