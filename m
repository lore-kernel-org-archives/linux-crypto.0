Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0DE1FECAB;
	Tue,  7 Oct 2025 03:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759807712; cv=none; b=ai3S8W1ukc38GX5QEcrEnia7iymQtR6xepAfu+HsvNNVe9JhG8WwzpEIGnzX9ttXIjsn1HPxXUaiRMYHp3C/qbDV/GywBnxqIxTUKbqkBiCvRFwmMkneOdkDzTSv2NHk+sF/utXeVbhC5vc/DoJ3xJzK++xg/Q56YurClP0oqNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759807712; c=relaxed/simple;
	bh=IGPz1eOHjVYs2b15YS8k4jnXq6lIC6xCUXEPiP3J5Tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TDdZkvcBLMByVFeXIUbVZJ9JeHZMQue5aF+n+WG1GMGYiwq90Fal53lRAR3TCgbJLxDMq7gIwlfMMcsN5oc5HT9aXznSCiPpCCRcvEFWR58wy3DAxyPxQl3dujt5x7GmFmF8bLKLdmXOVpdjgVJueP9TxL6Woith9oa/FgJgNZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uE3WAYpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uE3WAYpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88306C4CEF1;
	Tue,  7 Oct 2025 03:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759807711;
	bh=IGPz1eOHjVYs2b15YS8k4jnXq6lIC6xCUXEPiP3J5Tw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uE3WAYpu8Pl5O8tQpUl5RWgoF1uZ4dmo9fVEVnXY1UldgBdhbpqVlsEaD4P4evweY
	 Gp4/Sf1rydIjKCJ4H9909WB+3F1fPiRY2cUnQm1SGvoFWCxUZPALF7r1eihyePgn+7
	 RoNLsbPpmSRoRo1mY0ir4OZdrvnXZ3OoT5GA43Mp5UMDuvPg+m4NKy0w0nslDoejAI
	 DYq9QYYKVVkXLq8nSkmJQETcjnq2Hktc2bZ63ECdzElidvP0ZBdAWU0RO95dBppNgZ
	 jJElObdFBM631j3NvK1/gKQp16/AcWh/nYRi7NIBO9ipbwR02iaZa1l3kC8mF0xTB+
	 wlMt9QUdgGiyQ==
Date: Mon, 6 Oct 2025 20:27:06 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] lib/crypto: Add FIPS pre-operational self-test for SHA
 algorithms
Message-ID: <20251007032706.GB77681@sol>
References: <20251006172612.75240-1-ebiggers@kernel.org>
 <38ca063d-521a-4fc4-8398-5e77625533c4@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38ca063d-521a-4fc4-8398-5e77625533c4@jvdsn.com>

On Mon, Oct 06, 2025 at 10:03:44PM -0500, Joachim Vandersmissen wrote:
> Hi Eric,
> 
> It's a very minor change but I suggest not using "pre-operational
> self-test". That term specifically refers to a different type of self-test
> in FIPS 140-3 and it could lead to some confusion here. "cryptographic
> algorithm self-test" may be better (if you want to be formal), or just
> "self-test" or "known-answer test".
> 

I don't think that's quite correct.  FIPS 140-3 divides self-tests into
two categories, pre-operational (executed unconditionally at start-up
time) and conditional (executed only when conditions are met, such as an
algorithm being used for the first time).  This patch chooses the first
option, pre-operational.

We could just call them algorithm self-tests if we don't want to be
specific as to what time they run at, though.

- Eric
