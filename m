Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D801F199949;
	Wed, 14 May 2025 04:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747196515; cv=none; b=Jg760UsmYtx9c4cjX2AnK6ZwriwRkHTal/PYwzV5jx2dffqTkE1yWZSRPBDH9YafcvU9orLEH4MyhV2tY8fOg2CQNo6GDjrJr+dlugK8jm51XW/2W1Ludi66sdVoyBVIcMiCbOrMEdejkSJGJUHvcYp/Qa2pPy1Jq4Z8B5CcraA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747196515; c=relaxed/simple;
	bh=kFNifEdU9vK17cE0kAQbwPu9PQByr7qi+1yENQ9qdYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HLkOUGEZVOUorSO4+y9CBmeilbHAeMBPQWLrFvjCgx4xwVTm+QKUtr0hGNpAMLBoi9AAPsX/kDUM8Mm+LraqwPXJihGaw4IcxSFOmo/cExWzpj7TVXYu77mS/RFeUKrU2af6cS6sQAaXS8AmgWwIPcExSTZU5ZGfC3GGrbJ0f1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/CX/ILn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/CX/ILn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A01C4CEED;
	Wed, 14 May 2025 04:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747196514;
	bh=kFNifEdU9vK17cE0kAQbwPu9PQByr7qi+1yENQ9qdYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X/CX/ILn5JF7yADlLuiFG07dpLZ6AvV4756g9Zv52MhftNSrShRkUGfFRJcGOa7by
	 qAUaMtujKfD561uEK7I7GuLaqew4snvDagU7tT//Rd+wt7f7dYFHopfgMFZ5fNefui
	 nJRS2HYG/kGXUeSws4Yf/BCeLWBIpUKIUnl09ZOizj6u4r3byyG0E2PpjrOxuEZfUZ
	 4ATlzdnCT8pPqJMg9QsQ7eWewe7mQtB/LstICjVakcLlIUGSU2fU4fB06p20r7b+Ha
	 53FQ9cK5ChEvawIGbfoPa0Lf2G5uWdVf3KlyVjIifCOXUwtu8RT4jQPmDoHk5Pwdpo
	 Vr2bLHAf4jtnQ==
Date: Tue, 13 May 2025 21:21:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: John Johansen <john.johansen@canonical.com>, apparmor@lists.ubuntu.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] apparmor: use SHA-256 library API instead of
 crypto_shash API
Message-ID: <20250514042147.GA2073@sol>
References: <20250428190430.850240-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428190430.850240-1-ebiggers@kernel.org>

On Mon, Apr 28, 2025 at 12:04:30PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This user of SHA-256 does not support any other algorithm, so the
> crypto_shash abstraction provides no value.  Just use the SHA-256
> library API instead, which is much simpler and easier to use.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> This patch is targeting the apparmor tree for 6.16.
> 
>  security/apparmor/Kconfig  |  3 +-
>  security/apparmor/crypto.c | 85 ++++++--------------------------------
>  2 files changed, 13 insertions(+), 75 deletions(-)

Any interest in taking this patch through the apparmor or security trees?

- Eric
