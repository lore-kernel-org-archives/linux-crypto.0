Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF0E2FF66C
	for <linux-crypto@vger.kernel.org>; Sat, 15 Nov 2025 17:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763228373; cv=none; b=jOWRoJLANgqnoYM0E/FoWsnXq19X34pfAep9doHf8YGGjt1LBHQ0GvvaGbEnT1uhXwn9GXogNDV1AB0sQAYcr7020uVWO1PueJx/bInlLBWnMzczXmTuLdx3Y7PYOQSnuR+wZY0Qb2EhgI/NxHYrq6NKnem56n2cwq93eRlcLps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763228373; c=relaxed/simple;
	bh=1mpyqGo4hpAjAjZbLsfCCtLiR/5WguPcnLRKeBqp5QA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXpZw8t6M5Jx5qIEbL4XEl8qWgr2odHewKGG/pNbuhb0Y1o6O/XT5C7/3uYalva7ofYnBaBIF2JS7HHK5tAri16ZAZEXCMNmfGZbsz8plQsh4ALK9B8wghw+OchtFiurX5XKBSEpiiSXApHnFltlJjbS+0HrjqJuZdIbZsqAWHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=aNRt3OwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aNRt3OwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD37C113D0;
	Sat, 15 Nov 2025 17:39:31 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aNRt3OwM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763228369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OV/BFGApxXKUVYDvY1tKAGFV6CTc4ZfvXv0Uxs5u8W8=;
	b=aNRt3OwMnH0W6I1ExcT9gcBGYSc+avEWNV8AY9mI3gFzOgfrpNPtv7XCm3BE4nJFdMMk0z
	trd7izsTigprFhBQKfY630D++nQ8ytjW5m+yBY547k0s2DHjrxHjcI55m6J9g6q0DpCeZX
	S5KHGq5U1Kfo/2THaJ8Kie45B+L53Ts=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d1a0f857 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 15 Nov 2025 17:39:29 +0000 (UTC)
Date: Sat, 15 Nov 2025 18:39:26 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Ard Biesheuvel <ardb+git@google.com>, linux-crypto@vger.kernel.org,
	arnd@arndb.de, Kees Cook <kees@kernel.org>
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <aRi6zrH3sGyTZcmf@zx2c4.com>
References: <20251114180706.318152-2-ardb+git@google.com>
 <aRePu_IMV5G76kHK@zx2c4.com>
 <CAMj1kXG0RKOE4uQHfWnY1vU_FS+KUkZNNOLCrhC8dfbtf4PUjA@mail.gmail.com>
 <20251115021430.GA2148@sol>
 <CAHk-=wj6J5L5Y+oHc-i9BrDONpSbtt=iEemcyUm3dYnZ3pXxxg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wj6J5L5Y+oHc-i9BrDONpSbtt=iEemcyUm3dYnZ3pXxxg@mail.gmail.com>

Hi Linus,

On Sat, Nov 15, 2025 at 09:11:31AM -0800, Linus Torvalds wrote:
> So *if* we end up using this syntax more widely, I suspect we'd want
> to have a macro that makes the semantics more obvious, even if it's
> something silly and trivial like
> 
>    #define min_array_size(n) static n
> 
> just so that people who aren't familiar with that crazy syntax
> understand what it means.

Oh that's a good suggestion. I'll see if I can rig that up and send
something.

Jason
