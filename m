Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9AD153BED;
	Sun, 23 Nov 2025 05:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763874968; cv=none; b=YQY34i4btNff40gzxSjeTBcZ6GZfrRAfUMyf87xj6QFqOpM1qAfNYLS9P7stV3vTwH28r9qGPTxQ5BhFViAhjiqLdpx7OT+2Kobn8vUXk1wLSVBCDa+3tciXyN5akeSk+sLZrq8Rncn/90qsZbiNKvyOrNGn0royoeOd5vOxFWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763874968; c=relaxed/simple;
	bh=Ahn+h/qSbOQlYlyd66UlXIhBgZecsVW+Vijrj/An1qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=flcooZ5fjeVFVueqvQnqIToOg8Fah/wkACvZBn2uArwIDSVQYxxIBlu3J/kVouadUAxp3ZbFnL60fRGQX3LNnZVXFSj3q9tblHKyt9r6O4yLaJH4dIBfBpuUp/kGsbbNI+GMzIiAkiNKQqlLDplbrFZOLqwy3qs9e89/b8qxBZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=ElKHoa58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ElKHoa58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CC3C116B1;
	Sun, 23 Nov 2025 05:16:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ElKHoa58"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763874964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GYYfPom+bgLtWyVl1vkkPyjSVtRx1YlmM7DLhkj2D/s=;
	b=ElKHoa5888K1DIkKrknVZT5jRP+34upjgfe7GRL6CgbLrzySiZninoW0fqpYyyXVotmaRE
	ktg7WQ/Qmc+f0x/9dYjS9sX9BEok5GZd6PR5hxMRKEVfejyLbMlACi64WWE0+cAEnGXa1L
	5q0v4h87rPMloUaoIGPtly2XMp5XPbI=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0088f830 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 23 Nov 2025 05:16:04 +0000 (UTC)
Date: Sun, 23 Nov 2025 06:16:05 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/6] lib/crypto: More at_least decorations
Message-ID: <aSKYlZMAsOoA3yko@zx2c4.com>
References: <20251122194206.31822-1-ebiggers@kernel.org>
 <20251123040037.GA42791@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251123040037.GA42791@sol>

On Sat, Nov 22, 2025 at 08:00:37PM -0800, Eric Biggers wrote:
> We can make these crypto headers include <linux/compiler.h>.  But before
> we do that, should we perhaps consider putting the definition of
> 'at_least' in <linux/compiler_types.h> instead of in <linux/compiler.h>,
> so that it becomes always available?  This is basically a core language
> feature.  Maybe it belongs next to the definition of __counted_by, which
> is another definition related to array bounds?

This is indeed exactly what should be done. Do you want me to make a v4
and you can rebase -next, or do you want to just fix this up on top?

Jason
