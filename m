Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A6F252912
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 21:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741383471; cv=none; b=oVnqknC7Ul0dtzq84C637OVOp5E9GxVHhtp/33q4l1TVcKUxqx9h/qjr1OUhxPj9lYBVFrIACLR6ZbS1vRmQAKUqUfPQfPW7ZGnLK12wTdKqBXgU6syGD+RV2mC2bpUUZ7ic4pFiuJSD6BueJnVH/gFw60Jwl3gosqSpNsA1v/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741383471; c=relaxed/simple;
	bh=PQY8yqKzXyzZRehdIk4ieQD0vKh9HJ9MzFxl9Udl4y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EhKKKLfGwiyLT1KnJcSK6kai303B5vn1R4dlVgIj9beK0+MBfmpVt1xIJoPETlIZSxfkgHdqGDzaS/anN/XHSXyru72CZ/tktbfUgQBpikJSPLkfamEiZ4b4mktwGa7/2Dcg0LqcHaxPslswEd6gawgS+OOMl3GjiBqL3bwXnmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IoQfFVfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IoQfFVfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD925C4CED1;
	Fri,  7 Mar 2025 21:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741383470;
	bh=PQY8yqKzXyzZRehdIk4ieQD0vKh9HJ9MzFxl9Udl4y4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IoQfFVfYpgMYs+UdTXC34ynKeuoMao4onFZiCtem+Jc3BC7qFbD8AVtsNi08NI9Fn
	 rMer6hMPyY+sjNYC5dM5v0BhPxcTSTNmafXwvx46r8m3vlyI/PFSs6bPfn6ozhMUZc
	 8VTE6r4g7mwtiqHf5Bb6T/n6nnzNHUPPnJKM+8rxttsq8QsmWBjB34VYg4UebHNC0l
	 wemaQJEfj149e3oixNnQCFvTp3roXsGdghzH2Oz5t9f0geAowBVn0grZc9TA9VRM/L
	 x3EdDwWwdoJ4bYK6gX99ErEni1nM8Z3ru+RfFkfUVFRHlH743aOlye79EpvL+p7vUQ
	 O4IHybkki+wGg==
Date: Fri, 7 Mar 2025 13:37:49 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 2/3] crypto: scatterwalk - Add memcpy_sglist
Message-ID: <20250307213749.GA27856@quark.localdomain>
References: <cover.1741318360.git.herbert@gondor.apana.org.au>
 <18a6df64615a10be64c3c902f8b1f36e472548d7.1741318360.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18a6df64615a10be64c3c902f8b1f36e472548d7.1741318360.git.herbert@gondor.apana.org.au>

On Fri, Mar 07, 2025 at 11:36:19AM +0800, Herbert Xu wrote:
> Add memcpy_sglist which copies one SG list to another.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

There's no user of this yet, but presumably this is going to be used to replace
some of the bizarre code that is using the "null skcipher" to copy between two
scatterlists?  For example the code in crypto/seqiv.c.

- Eric
