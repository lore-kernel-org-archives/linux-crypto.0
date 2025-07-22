Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFBF28C5B3;
	Tue, 22 Jul 2025 03:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154212; cv=none; b=EsLMRoova4dmtz4xidDV4owI4SBm0jyXYnkWw/iD4ZtB08Q7KneCminuPxFG5FxIDcUVlaUWZxOegQkZAd3O2maaH50US1Has/Yd3CWgyP2Ba5ix6B7/EriuVew2MJFA2DzMJNFzOJtcIq+94tuUdz+KzytDHkiSrsETkt2cPoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154212; c=relaxed/simple;
	bh=jRVVKcQD9AV4rg9gnkt5Sul+hp6syDS0ASkSp7wBpMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=it970isiid9Dvmdj+RqryVSmsHioaJqj153XOQACuXzIH+a+88MbTw7qMr8dvm0Da5zdGqE0VTX6tjCCI7Mjbm7PLSgEWwuUmOOwpukmYwbJhWw6Y3kmLghnpljpMMHQ21dDN72ish39hulDwWWg6KcJ1vMhu998qSjVmeK3Pxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IbMcTRWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbMcTRWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF56C4CEED;
	Tue, 22 Jul 2025 03:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753154212;
	bh=jRVVKcQD9AV4rg9gnkt5Sul+hp6syDS0ASkSp7wBpMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IbMcTRWbl01GyMd1QcuA9h9P/SLA0OkeyMAybx+jWahxvqj6LLwt+O1wwKDPo6lR5
	 vCb9/LzN6lLCdk5ese/Uvbubj1yOAql2/EHU9Taz1ORdjZBfBwDuxvOfBXVPymeFiw
	 +rcVEPLkdEbXqwkFFOJdkNF46M7SZPmQdti/MnFtPnCFhn3lZ32Xdy2t0BFON4le6Y
	 rnsogveQl0m/pakbhEfsuUf0PQJrKI7MRARIITFF6YolqYdeiKfyZ6cKfksOheWqU2
	 K+xwLkg+MYNm2gYAlHjEm7kaQ+uYt2yI6M3x6rI8rTZdQaua6iFfrFdO3YKCmadDDM
	 86/Pjth8EoBDQ==
Date: Mon, 21 Jul 2025 20:16:03 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: tests: Annotate worker to be on stack
Message-ID: <20250722031603.GA1298@sol>
References: <20250721231917.3182029-1-linux@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250721231917.3182029-1-linux@roeck-us.net>

On Mon, Jul 21, 2025 at 04:19:17PM -0700, Guenter Roeck wrote:
> The following warning traceback is seen if object debugging is enabled
> with the new crypto test code.
> 
> ODEBUG: object 9000000106237c50 is on stack 9000000106234000, but NOT annotated.
> ------------[ cut here ]------------
> WARNING: lib/debugobjects.c:655 at lookup_object_or_alloc.part.0+0x19c/0x1f4, CPU#0: kunit_try_catch/468
> ...
> 
> This also results in a boot stall when running the code in qemu:loongarch.
> 
> Initializing the worker with INIT_WORK_ONSTACK() fixes the problem.
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  lib/crypto/tests/hash-test-template.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

Thanks!

I also added the following to the debugging kconfig that I use:

    CONFIG_DEBUG_OBJECTS_FREE=y
    CONFIG_DEBUG_OBJECTS_TIMERS=y
    CONFIG_DEBUG_OBJECTS_WORK=y
    CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
    CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y

- Eric
