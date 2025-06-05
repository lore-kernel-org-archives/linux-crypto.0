Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221B21F956
	for <linux-crypto@vger.kernel.org>; Thu,  5 Jun 2025 14:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749133620; cv=none; b=XF6qxqos1yGbyTIxeq1hJo516k+1j9ReJUkuYb6xv0sdJIj3pSh8vpmjPXquAYd6604rdwDnRpcggvOBD/5GhVSZdBQjCnYX8f8k6go/zB1aBER31lA184g7r2+zFolsfAisAoIk4snesuvjm/VlPxYgtZS6ufWp6VqqeL84Zck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749133620; c=relaxed/simple;
	bh=9fk/3Oz9gPgVIBGOnImSXDZRYWS8R1Y9PTaxKv3SZK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGTjWfLOTeNbf4MBfaPjWuIgY+As8DClbkg4Ac95RLocYCg5rvTRpVZxOso5AuFRwHOM1GDnamhPK8M1fMsmicNtCmvxNHQvfRj073LLnt0EoOUCNPpKoMDHDvYEoU8qOsG34Difw9opLdP54BNmQm8k8bI+XWyWicUzJk8PTO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QYfmLHQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYfmLHQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692ABC4CEE7;
	Thu,  5 Jun 2025 14:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749133619;
	bh=9fk/3Oz9gPgVIBGOnImSXDZRYWS8R1Y9PTaxKv3SZK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QYfmLHQN7pp96OLm+u3e2mGl0psx680Dq28osy6lNES0Ryda0kYM7cBISUNtHiUW+
	 DZTIBaZLMHTHvx0NLxgOONYGZHYxw1kuciH5LdUfpWLm66q/9kTIzLJRWTpuJ6m1PE
	 oPeFpNyZo2qWiu/v+YD1VTNbTYPnWx2cOMeyuw9mHk9FY3chLK4yiY9UayYhVBZnzv
	 JXCMUxlqvtZxuL6b1NZ53YYGJPbzBDtp7eAKSh6PVCJLvWB+GcIcAZGBfvfUkvZd1X
	 fEhmDyLrOzrmvIfYldb+8MZ9VgOk6aIH6UkVdWpef/xyQY++hljxRBS1Fd4foanEsF
	 uffFOBUyVaR5w==
Date: Thu, 5 Jun 2025 07:26:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	freude@linux.ibm.com, dengler@linux.ibm.com
Subject: Re: CI: Another strange crypto message in syslog
Message-ID: <20250605142641.GA1248@sol>
References: <d4520a75-c765-406b-a115-a79bbdf8d199@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4520a75-c765-406b-a115-a79bbdf8d199@linux.ibm.com>

On Thu, Jun 05, 2025 at 01:26:34PM +0200, Ingo Franzki wrote:
> Hi Herbert,
> 
> we see the following error messages in syslog on the current next kernel: 
> 
> Jun 05 13:15:20 a35lp62.lnxne.boe kernel: basic hdkf test(hmac(sha256)): failed to allocate transform: -2     
> Jun 05 13:15:20 a35lp62.lnxne.boe kernel: alg: full crypto tests enabled.  This is intended for developer use only.
> 
> The first one seem to be failure, but I can't tell where..... I don't see any other typical selftest failure messages.
> -1 is ENOENT. It might be related to the recent changes with sha256 being now in a library...

No, it's from the following commit:

    commit ef93f1562803cd7bb8159e3abedaf7f47dce4e35
    Author: Herbert Xu <herbert@gondor.apana.org.au>
    Date:   Wed Apr 30 16:17:02 2025 +0800

        Revert "crypto: run initcalls for generic implementations earlier"

That moved the crypto_shash support for hmac and sha256 from subsys_initcall to
module_init, which put at the same level as crypto_hkdf_module_init which
depends on it.

I guess we just move crypto_hkdf_module_init to late_initcall for now.

> The second one is probably because the full selftests are now enabled by
> default. Does it make sense to output this message now anymore at all? 

The crypto self-tests remain disabled by default; there's just no longer a
difference between the "regular tests" and the "full tests".  The warning makes
sense to me.  There should be an indication that the tests are running since
they take a long time and should not be enabled in production kernels.

If this is s390, arch/s390/configs/defconfig has CONFIG_CRYPTO_SELFTESTS=y.  Is
that really what you want?  I tried to remove it as part of
https://lore.kernel.org/linux-crypto/20250419161543.139344-4-ebiggers@kernel.org/,
but someone complained about that patch so I ended up dropping it.  But maybe
you still want to remove it from arch/s390/configs/defconfig.  There's already
arch/s390/configs/debug_defconfig that has it enabled too, and maybe you only
want tests enabled in the "debug" one?

- Eric
