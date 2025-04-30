Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492072882DE;
	Wed, 30 Apr 2025 20:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746043705; cv=none; b=XPaBWb2T0jivksa4H2DqCET8Pu/jrappb8DILgQ0KdHvfmRuAYPw2xdOIXHT21S2MAnuYGnZGharYzMNEPogL20/zP6U0IZv7gyV1NVnBhjWtckaN3/K/CogUqUeDDYLjHYbcx6qBWrHJJJqJgkLt/qtTiNz55sPu8DeftQCgGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746043705; c=relaxed/simple;
	bh=Le9+VPRIUnY+YfG/D+zzeJrkFX03EAlnLc353Qtd68k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gzIXl9n7/7tcpfIHaaYGrYF3maH7YVyKWh1A+dE4Ny4yvq9u4mlqHQJKH2KGWL3DZVWmWJM0o3LOAp7ApIetMhGPp1CG9O68YG7iPARGICtBzxZlBvMTC6MVqgUVnZ6P3CCeJFz3kE0srfR8VEWNkwi+E0eGeLAtOIcHRl8hASE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iE7etJUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iE7etJUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FB1C4CEE7;
	Wed, 30 Apr 2025 20:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746043704;
	bh=Le9+VPRIUnY+YfG/D+zzeJrkFX03EAlnLc353Qtd68k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iE7etJUrBuz5g4+VojdRaPIDuslaV0dzssPS4rsmlemw+eok7ULniur16FrpBQCvK
	 ALNBMtpS9gghiv7fhfzYpkJyCguT11GNpviQD+/llkXW6LkrjYsfap+neDQ/Vb/NPa
	 VelPsa88ZpNlbmqUTjxcUkv6mu4nIkqBxY+pylqPhTGm2+XgJuzHacfNsyRiijxbxN
	 AMiL2YgvyQyLJsN/jWg3Mw+ggIblnu/vB/eS6FYEKfVOYNzmhZB5AsgOPCxQ31XQuD
	 jRERekQQOD2ElKWSm0TbdlzmUnN3Vl4svAVjsS5jGzlqfSAxnsCl4OTlijL2hAVMj1
	 HrcWX0wVVJ/og==
Date: Wed, 30 Apr 2025 22:08:19 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
	Russ Weight <russ.weight@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Amadeusz =?utf-8?B?U8WCYXdpxYRza2k=?= <amadeuszx.slawinski@linux.intel.com>
Subject: Re: [PATCH] firmware_loader: use SHA-256 library API instead of
 crypto_shash API
Message-ID: <aBKDM2Trj7m-q5lR@cassiopeiae>
References: <20250428190909.852705-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428190909.852705-1-ebiggers@kernel.org>

On Mon, Apr 28, 2025 at 12:09:09PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This user of SHA-256 does not support any other algorithm, so the
> crypto_shash abstraction provides no value.  Just use the SHA-256
> library API instead, which is much simpler and easier to use.
> 
> Also take advantage of printk's built-in hex conversion using %*phN.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied to driver-core-testing, thanks!
