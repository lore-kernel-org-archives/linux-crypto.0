Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403FB143C61;
	Tue, 17 Jun 2025 03:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750130829; cv=none; b=Xzca9NaMKn24A+LDmQtM4BWTwv/nZTnuZ/4KfkmAlamdWXAY3GMMuzk1GWuAO4jXPT70kdYO5kIEDEG2uMJte/e4wTAzdMHcvscZC/4DBLq5cCUIkBpoV+E9FN5z9u8kPUM6W68Jhz42PJ6Ogm6r/Yr1NE5hyeSGsJSGHsyIUlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750130829; c=relaxed/simple;
	bh=/MSfD0hCGVoLXanVrX1fIFTwV3ONNCIF6lOaxNt/2WA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ubtAIyKDJHGE4/KPy/Jqx1YshFhq3KRfBKZ+Yd9a2/js+MV+6D1HOgCVNURx3Th3C9VDBSD3Sk9/Er4+c1ZhndSceEvQ1PjGk608A5W3OobRj8pmBgYbElJxwL6hW1n+DfkbdQKwvMc16ol2bHCFzaRj1Q+JK9I1jVZjFeFjFcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mB06Oc6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mB06Oc6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2D2C4CEEA;
	Tue, 17 Jun 2025 03:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750130829;
	bh=/MSfD0hCGVoLXanVrX1fIFTwV3ONNCIF6lOaxNt/2WA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mB06Oc6YVtmlKQ6PxeLF5f/4vQ9avYUjuBsVV0IWEC8d/HBQhKTIOkzQ0l5l6PDxW
	 g0fMndnrMXcQFcyNIhrMZJwUXepWJ4MaqYNL1njhGbuVBNc2dLyza9JPGuS74IJhU7
	 WmmxwUaweapfrquO+SsNqrmXbz/b+PfKKO7+b+vWiAUNHu8l9Z+HPwv9OBEJHYEck+
	 IL8SR4BJlF8bKFNGDCbv7Yz+X/FMxJjkVQ4BZ6TBxjzBaljOsfQh+pAJXfWCUfg/qJ
	 zcaBKWjappbbrZ+svVHmTezpOcFoZsf22xnBnOAbL0nBlO6JL5+phiyNapn7Dl7YBC
	 xrFAzh1ifjxQg==
Date: Mon, 16 Jun 2025 20:26:39 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld " <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2] lib/crypto: explicitly include <linux/export.h>
Message-ID: <20250617032639.GC8289@sol>
References: <20250613184814.50173-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613184814.50173-1-ebiggers@kernel.org>

On Fri, Jun 13, 2025 at 11:48:14AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Fix build warnings with W=1 that started appearing after
> commit a934a57a42f6 ("scripts/misc-check: check missing #include
> <linux/export.h> when W=1").
> 
> While at it, also sort the include lists alphabetically.  (Keep
> asm/irqflags.h last, as otherwise it doesn't build on alpha.)
> 
> This handles all of lib/crypto/, but not arch/*/lib/crypto/.  The
> exports in arch/*/lib/crypto/ will go away when the code is properly
> integrated into lib/crypto/ as planned.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> v2: keep asm/irqflags.h last, to avoid build error on alpha
>     (https://lore.kernel.org/all/202506140001.CtqYqDPn-lkp@intel.com/)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
