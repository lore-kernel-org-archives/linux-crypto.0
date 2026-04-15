Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FAE41C71;
	Wed, 15 Apr 2026 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776275277; cv=none; b=jUCikfKJUgkuKXcu0OaLL6UQk16D3DGOSlqiNMq83KupQUqvLJCVg63C7p1zbF1uRnI8YHTcthz58go6i5k0H1QOPxPB9c+BG5SHO/x9lVyR+d470l4fgzYUECZndRDEfGYgcuC2TL1mhwAp6FGGeqhG36xX+fpjApcMZr0KVCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776275277; c=relaxed/simple;
	bh=9R8GIgkY9znoWD22HXqzJPBSmLSQpA3WKgY6KvOeBS8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=QMHIjjHF6PLoydIUOFJqFNW9poVJaMlG8G8MD5iP1l0Q70t1tasktJCmGFZpQl8syNzCKALoNFEf5nCLz++gp8QFGR0T9rqpR0fxUdQNs9MezBXKVavRL3S0hjZTASntqNDjdLd1ncbXhscQujuugC3/qjDUAERV/xAVHV+jX+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZfr0SwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZfr0SwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66DCC2BCB4;
	Wed, 15 Apr 2026 17:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776275277;
	bh=9R8GIgkY9znoWD22HXqzJPBSmLSQpA3WKgY6KvOeBS8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=PZfr0SwTG5RgSvn98QSiDA9r8eUy6qNR/sScVFsoqmcJwWtu8L+EKREFmTjj5ONAJ
	 rRjNkYas14MTfHJwXOilRQO0/OM7CO0/gGtdyAZea7YmMVJ9K/h/tCNnX4wuCiel2Z
	 CPmu9zSO0BDzBaZnWSpcH33fJ73w+3X5rZEONt6ngDD+5Sy9aeM73q6LAS0jpsJIpO
	 Acx5tq9O+Xnvtd6bvnwAH65AzKTNDeq2gpGKD8vO1746p73vaAw1kgeW725gfTA8md
	 CBh15zI6CZhL5412mq95kY+SNRrVYFllhcaEH5MK53F4VrZWcieFv5j+fkZWpTj9Zo
	 U3jxqgO6jQo8g==
Date: Wed, 15 Apr 2026 10:47:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [linus:master] [lib/crypto]  e5046823f8:
 stress-ng.urandom.ops_per_sec 4.3% regression
Message-ID: <20260415174755.GB3142@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202604151657.8e26ef70-lkp@intel.com>

[+Cc Jason and Ted]

On Wed, Apr 15, 2026 at 04:45:48PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 4.3% regression of stress-ng.urandom.ops_per_sec on:
> 
> 
> commit: e5046823f8fa3677341b541a25af2fcb99a5b1e0 ("lib/crypto: chacha: Zeroize permuted_state before it leaves scope")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

This commit fixed the forward secrecy of the RNG, so it needed to go in.

For large RNG requests, we could get most of this performance back by
refactoring the chacha20_block() API to move the allocation of the
temporary state array into the caller.

We could also get much better performance than before by using the
architecture-optimized ChaCha20 code instead of the generic ChaCha20
code.

However, neither would be a simple change.

- Eric
