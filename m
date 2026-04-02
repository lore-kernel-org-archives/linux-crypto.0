Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891F03D904B;
	Thu,  2 Apr 2026 23:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775171689; cv=none; b=Of98O5xt+RY5hHArb50aiwAQo4NablYmJWr3BZvmy8yWQ5W+JLWfPLeAxDqsR78iz30rufS99SMl3KC3YFuyTTQkPIW5DDPbF/zZtkzwmi17PGXXycFcf/R115OApwx9ad/pgKHJkBbkH15T4CDSqqNq6/YTRyjwfGe/sh0FMOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775171689; c=relaxed/simple;
	bh=/uT9Mce6mkl+PL12SNZSUWwwgCcvkjFSyAR12j7sSvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HESxg34cQNcxto1OjxUbQuPuWUx7o/ts67/BK05X2TEq3Jq8demF8IYd+6+pGSWH5icsDaU/Aycagvkt6au5oP7l/e39o7xXtc+Z9Ku1crogzrUMz5lkQAE7oPDL5PXtJoymEY6EwpUDmdCs2izhh8YeutYR5OOpHxZ3v+JqFQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C2sUW5hB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C2sUW5hB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1577CC116C6;
	Thu,  2 Apr 2026 23:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775171688;
	bh=/uT9Mce6mkl+PL12SNZSUWwwgCcvkjFSyAR12j7sSvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C2sUW5hBB3EJknLB8XqL/i7dhB1ZN0fIq282kPMiyg9xuxEMCaeIwvwX9jDg6+ZPI
	 YQ6hM9lVUQ2xrEse5SRQhA1OeyVK02zLLvIPjumB5RJ/oVvdm67lshpYllEZ0/eBCQ
	 /ZyYiq7Q0KFPrnDIyVKS6xXhT3dHIV4IhRwPRuLAkgU80PTJVkCcv9XWOfe44QvsMV
	 VX6jWFDhuU9ijYvbDem9w0M3Go2TVvmisc3767xQ8vNvMZg3wPGmrtaKt4iU2QAYmX
	 MwKuJ0PVQwBu8s5t6RYsdZ4BqGhS7LoP+NfC7w8/tqWT6CHlMhKnkOEjiELdi4RG1N
	 AWv7AzScOISBQ==
Date: Thu, 2 Apr 2026 16:14:43 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] lib/crc: arm64: Assume a little-endian kernel
Message-ID: <20260402231443.GF2910@quark>
References: <20260401004431.151432-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401004431.151432-1-ebiggers@kernel.org>

On Tue, Mar 31, 2026 at 05:44:31PM -0700, Eric Biggers wrote:
> Since support for big-endian arm64 kernels was removed, the CPU_LE()
> macro now unconditionally emits the code it is passed, and the CPU_BE()
> macro now unconditionally discards the code it is passed.
> 
> Simplify the assembly code in lib/crc/arm64/ accordingly.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting crc-next

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
