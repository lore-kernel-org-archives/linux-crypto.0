Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A764EEB3;
	Sat, 14 Mar 2026 00:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773446611; cv=none; b=r+JD4ZUZQNr50tVimB6eqa8lTjlhDDAr2xZKtM/z7ePJThUOBbGj6wxNLdX2bwP5+rqIvxGvD42gHlB+Mj+RpBH6cAFjsh+o/2FNWuKPv3sKRFJcQ79WUM+7qJa7bHT8ZtithXyRVkCleOcsVoflXqHzHOwAOD/1OXTc4u4z1ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773446611; c=relaxed/simple;
	bh=UxoF3WL4ZHyLRICrjyRI6WOcSEigs+JBBqDcJb43mRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksiKLYR84xiZoVCwijEFs0s2ooRuvGYfQgDyjLsuHxFCpRApAcVNBHPOBnxymP12jTVXmiXwK1PN0XXaEBJGK7Gtz7NeUeEfIGKpoJ+8GIO8KFn8e1WZPS3l5CUXBgfeeB1gzAa1kSqeqMSZZmb7GgeokKcbEB1pcNv7dxqFgN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4cpKWz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4cpKWz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C2EC19421;
	Sat, 14 Mar 2026 00:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773446611;
	bh=UxoF3WL4ZHyLRICrjyRI6WOcSEigs+JBBqDcJb43mRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y4cpKWz3lyhdNmia9AQ5Hgw9Yah5d0pkAZHCwganyarZDx2tkoJIQh5v9zUJ6ORrU
	 gDjoONDCCEyxgxT2QgIuIcvulcs8LExtR1eA/4e5BuKqROBhi5nYbhSXd5+bdvkZIf
	 p537U3/Sr8eLm/AOschRK7z/816RTtgmqBNVvRgxDvsqsGLInNfdlJzY21nQU2MlYV
	 HF/jR7+veDQHBOtm1i/Dl+ZmFohTA6Erhz7joC69lB01tjeaMavNBY4gxfciRXWXvC
	 YHK0aT0nvrHx1fuCxe+Agn7hmDCDRMZHkFXhzvUivd4UzmFUlRwHC2v0QiQ6AA3LZC
	 ZZN2ELxwx4z5A==
Date: Fri, 13 Mar 2026 17:03:25 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	kunit-dev@googlegroups.com
Subject: Re: [PATCH 0/3] lib/crc: Fix crc_kunit dependency and add kunitconfig
Message-ID: <20260314000325.GA6574@quark>
References: <20260306033557.250499-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306033557.250499-1-ebiggers@kernel.org>

On Thu, Mar 05, 2026 at 07:35:54PM -0800, Eric Biggers wrote:
> This series fixes crc_kunit to follow the standard KUnit convention of
> depending on the code it tests rather than selecting it, adds a kconfig
> option that enables all the CRC variants for KUnit testing, and adds a
> kunitconfig file for lib/crc/.
> 
> This follows similar changes to lib/crypto/ (except lib/crypto/ doesn't
> have an equivalent to CRC_ENABLE_ALL_FOR_KUNIT yet, but we could
> consider adding one).
> 
> This series applies to v7.0-rc2 and is targeting crc-next.
> 
> Eric Biggers (3):
>   lib/crc: tests: Make crc_kunit test only the enabled CRC variants
>   lib/crc: tests: Add CRC_ENABLE_ALL_FOR_KUNIT
>   lib/crc: tests: Add a .kunitconfig file
> 
>  lib/crc/.kunitconfig      |  3 +++
>  lib/crc/Kconfig           | 17 +++++++++++++----
>  lib/crc/tests/crc_kunit.c | 28 ++++++++++++++++++++++------
>  3 files changed, 38 insertions(+), 10 deletions(-)
>  create mode 100644 lib/crc/.kunitconfig

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
