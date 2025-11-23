Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6A5BE49;
	Sun, 23 Nov 2025 20:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763929828; cv=none; b=tMoOZwI7uUtNO3zNxVcsyCYbkOXx2qHw2QgCwuLJXtR/j67ToT9J6uaG5njhEcmpukrPY+ysrczsxDduSIg0/ZUGMH4uhxZR4JJ6oXd9h12FyZAVxLbgNHSk5BLbz4VGJ8nOQJTYVVtVB+/+gN6A+ohlbfr74QohmKL1nSYoZOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763929828; c=relaxed/simple;
	bh=JM63ayrWpSuof7rhDRvrr9oR0Mr4K7ptSWjm/UYkNtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AL0FDi7jmEXTeJSGmJZ8m0sY5PNDMfLO8nzbQGSXaWbe/p726ofVlRhh3Mly5EkmEXt5DqkMalQOBrUtVRyzD6HWoG+S2eYHko9PD37GX8eKB/3EqXHR0q5nqACQRlhuf2JZE1s48qap/375fHG8cNqJz516xDq16issH6rWydU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fz49bZAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fz49bZAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BE9C113D0;
	Sun, 23 Nov 2025 20:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763929828;
	bh=JM63ayrWpSuof7rhDRvrr9oR0Mr4K7ptSWjm/UYkNtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fz49bZAsBX+lWezg3WAXpBI+4s4n/9xft37evNQsZxvkby1Mma67GhEG0ZuBGgsm1
	 5L7C2em0axlbYWjUB9hZVVtky8dRVbJOzc+28ePkZioWkBbTturALdLFOCLTYaFZdN
	 s3llPPS0ppsnyf+fccEmtnk0pKzLU8x6RDFrBe/O+nrCXvepjgHYCRTYA38iBZL9L/
	 VRK0PBNoZfRCEpAFDJ7qdpdlQsT+iazhGEN/M1C9x7tADJYjya9IbHEMrU69ET3mM9
	 2ve+TpkDEBzbOqa5hmF70BwVcakm09gM4YQMmDy6lRV2t+gTcXuWOaTUwx+8Z0TtDt
	 fHqWbElvUNJwg==
Date: Sun, 23 Nov 2025 12:28:41 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: Re: [PATCH libcrypto v4 1/3] wifi: iwlwifi: trans: rename at_least
 variable to min_mode
Message-ID: <20251123202841.GB49083@sol>
References: <20251123054819.2371989-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251123054819.2371989-1-Jason@zx2c4.com>

On Sun, Nov 23, 2025 at 06:48:17AM +0100, Jason A. Donenfeld wrote:
> The subsequent commit is going to add a macro that redefines `at_least`
> to mean something else. Given that the usage here in iwlwifi is the only
> use of that identifier in the whole kernel, just rename it to a more
> fitting name, `min_mode`.
> 
> Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---

Applied this series to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

(Again, on a separate branch that I merged in.  It will be in its own
pull request)

- Eric
