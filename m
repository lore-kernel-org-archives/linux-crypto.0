Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D5B5EE7D
	for <linux-crypto@vger.kernel.org>; Wed, 29 Nov 2023 20:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxldB/MK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98329C433C8;
	Wed, 29 Nov 2023 20:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701290817;
	bh=K758Cy/Gxmng67owvd7DkjuhwZTMbLkHdEXabzygaD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DxldB/MKnA9eORjw03tyyQSQ3n35GLy/4GhHKDFP0qU3MLGAKAhBt9R/Yr+Qv8ixa
	 67aaH2F8/230fZUL6az5uYGuZO2alnXRP/fmh/jiYGeQ0iPSehu2eBclcU/NG1lEAB
	 7zZIpqdZMEOYrQf3mKflRyZokoiJEZibmQFzgeNy1UnyMH1n9ruZMvmZRthkIim9dt
	 /gRzGSKBDLYyCR0T/q7AW8IZXsKUgG9YZdTOMmlMsNvCw4EXxzkLnZoqiFCRVp+OEs
	 RZCIaQEzVo3BoLjcFzXCiXSepgFZ2RsvfQxvKJjU0ASs9/oaRiDLrc7muCmU9Yl3U7
	 //h9w2O7fjw6w==
Date: Wed, 29 Nov 2023 12:46:55 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 09/30] crypto: talitos - remove unnecessary alignmask for
 ahashes
Message-ID: <20231129204655.GC1174@sol.localdomain>
References: <20231022081100.123613-1-ebiggers@kernel.org>
 <20231022081100.123613-10-ebiggers@kernel.org>
 <1a63d090-02b0-49b0-8c6e-50d71010b0a4@csgroup.eu>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a63d090-02b0-49b0-8c6e-50d71010b0a4@csgroup.eu>

On Wed, Nov 29, 2023 at 03:00:48PM +0000, Christophe Leroy wrote:
> 
> 
> Le 22/10/2023 à 10:10, Eric Biggers a écrit :
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The crypto API's support for alignmasks for ahash algorithms is nearly
> > useless, as its only effect is to cause the API to align the key and
> > result buffers.  The drivers that happen to be specifying an alignmask
> > for ahash rarely actually need it.  When they do, it's easily fixable,
> > especially considering that these buffers cannot be used for DMA.
> > 
> > In preparation for removing alignmask support from ahash, this patch
> > makes the talitos driver no longer use it.  This driver didn't actually
> > rely on it; it only writes to the result buffer in
> > common_nonsnoop_hash_unmap(), simply using memcpy().  And this driver's
> > "ahash_setkey()" function does not assume any alignment for the key
> > buffer.
> 
> I can't really see the link between your explanation and commit 
> c9cca7034b34 ("crypto: talitos - Align SEC1 accesses to 32 bits 
> boundaries.").
> 
> Was that commit wrong ?
> 
> Christophe

Commit c9cca7034b34 ("crypto: talitos - Align SEC1 accesses to 32 bits
boundaries.") added an alignmask to all algorithm types: skcipher, aead, and
ahash.  The commit did not explain why it was needed for each algorithm type,
and its true necessity may have varied by algorithm type.  In the case of
ahashes, the alignmask may have been needed originally, but commit 7a6eda5b8d9d
("crypto: talitos - fix hash result for VMAP_STACK") made it unnecessary.

- Eric
