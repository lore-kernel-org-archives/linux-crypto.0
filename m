Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C5E18FDDB;
	Wed,  5 Feb 2025 15:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738769643; cv=none; b=gGkTkPFxFAPauSlr25qa1QbJh7GYIokaoWviG62W3XixcD5dRbg7tnlvF0QHrsJ+obQiB2e2y3w+z/woy+KhAywLkAAxN2U8DfUhNFDim5GKSRM/xSjrZ4WKhl0JdBsSEFqkd/+CWdbyOgqFeRNf4w7DcRVZ/3oF/QZ0wF6/C4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738769643; c=relaxed/simple;
	bh=M12Nqqv9nkqPky8w1t3lEr6Xd/aFGaPNlTvqIAysKiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m6Bj0fS/LW69yQZKs4Xh0eF6+WVE1BptvLaITEvpWnOE89yAjHHSpilNrlKCnmWjn8HXh5n4HA+z/7PABl7wjRZSj5z4Jc5jt4A42q3Js9c/tU9LzwSLMNKU/oe3N3BYQabeaiAxucg0fCsoC7ZfE2VzqQf0DySJhX8FFBdumm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TsTkM56M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TsTkM56M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7215EC4CED1;
	Wed,  5 Feb 2025 15:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738769642;
	bh=M12Nqqv9nkqPky8w1t3lEr6Xd/aFGaPNlTvqIAysKiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TsTkM56MzvAwlMNLqN5RGgL1umJ8Kwj9usCi05sMoobKyE4pZjxQYheCebJKRPGuS
	 wZuBmVp/8RwUiYiWfDRUsAiObHbI0IW5BuxHnpnZdKQtcoiUG+cYtvqBwoeTPC7yrT
	 YyXdQzG4mCEF/RVAvV7Q18WBSwQdGzQ7VtI5CCDuPBrRnPHcIJ/dyU/iupnbywDh+i
	 qJ/41lzqivR9S8HayGVyjn9sTPOBjTKTShNSSg8qiTC/5wILnNVL/WUKS098nbw/Lz
	 42FanaAmSztg5P8RQsukHse/j1UkApmjiU784UW0QPofxuMxY+4HxU75dzAmfCCsh8
	 NkH6brsmJDjBA==
Date: Wed, 5 Feb 2025 07:34:00 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Lukas Wunner <lukas@wunner.de>, Ard Biesheuvel <ardb@kernel.org>,
	Stefan Berger <stefanb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - drop unused static const arrays
Message-ID: <20250205153400.GA1474@sol.localdomain>
References: <20250205121342.344475-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205121342.344475-1-arnd@kernel.org>

On Wed, Feb 05, 2025 at 01:13:15PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The ones[] and zeroes[] definitions were previously used by the
> rocksoft tests that are now gone. With extra warnings enabled,
> gcc now complains about these:
> 
> crypto/testmgr.h:6021:17: error: 'ones' defined but not used [-Werror=unused-const-variable=]
>  6021 | static const u8 ones[4096] = { [0 ... 4095] = 0xff };
>       |                 ^~~~
> crypto/testmgr.h:6020:17: error: 'zeroes' defined but not used [-Werror=unused-const-variable=]
>  6020 | static const u8 zeroes[4096] = { [0 ... 4095] = 0 };
>       |                 ^~~~~~
> 
> Drop them as well.
> 
> Fixes: dad9cb81bc30 ("crypto: crc64-rocksoft - remove from crypto API")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/testmgr.h | 3 ---
>  1 file changed, 3 deletions(-)
> 

Thanks!  You must have tested today's linux-next.  The fixed commit is from one
of the patches of the series
https://lore.kernel.org/r/20250204195456.GA1385@sol.localdomain which I applied
to the crc tree yesterday.  I've folded in this fix, so it should be fixed in
tomorrow's linux-next.

Would be nice if these warnings were just on by default.

- Eric
