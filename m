Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575363;
	b=5Lv4O4oyoYSJzs+KNck/PDvwxHrNPSBeKwNQPtFZToRZeCeyRZVtC6EsJiWVF51VLtY0
	 bs0Rk+4eMMTiNGDHrvJPJd+8Ka/TsuysItYlB4i5Uwv/fnpYyImoyexvbvOZRVbAPlJyX
	 wOFvmwRelVJKJBZP2ZPeUplQgM8sCtwBr+NtckWzoe1u+ZtmuRbHu5EWnKQtAym1Xl7hL
	 QUocVsnvXVysm1p2tLJFI9dzz9bnS3GdfxSra01c9lWD/ol4AxOGryaFRZdLPamtloFJm
	 Sck+fYJgwa5gAO1cDvQ4y6gZdHX6i6YWfqXSfIgWlO6H0EPrg4MM0WftN9AqFFC1sJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575363;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=DH81cZ1eyz1/7SJqQfpOk5ZTwtVQhG4pC9JipOcCQVU=;
	b=qZDXirub/wP5MHtEjcNVLMmcUNmbN3nJpA7mLuNkScDXg3osxGBAJQNcA1x117AFUrc1
	 aotc4mCM+xwuIWCyKsjGWUls3Rohl+f6ESjiNhHW/C8hd/nPhMZ9I7Qf/RH03A9kF3ZkJ
	 txMUREc6T5O3LbbiTHY60fLfpzqtROfgPcLzhNwaU4eHXGsCr283BsD6Q97Rp0lIU6JwW
	 ztXauQZtQm1XYy0eOx5sxeetwqQ5rEg8WxJGoxTJpl7pfZZlWgtKMAhUEOdhdV7qDaHuO
	 AxpcYIWyAA/PsVlpBU1gtnxen5JAqMJBlh8GzDmjqSkZs0WlqsdXaNL9vuvUQVErzoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=DdTjKDm1;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810D0606A331;
	Fri, 13 Nov 2026 13:09:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 810D0606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=DdTjKDm1
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DH81cZ1eyz1/7SJqQfpOk5ZTwtVQhG4pC9JipOcCQVU=; 
	b=DdTjKDm1fSbSdhzkPTroSJG4+J37yIBQD752tBLOcpQ407N9FBHnCy/XdVCVTKT2pI5Pb2Wv/++
	vUF0Deivk6NeqPGhyM1fdYuV7CWYiud/Yo2Ea96zB56SsUj4Vjt0Ni0H91I+8+BF5HMsYjPLwoUge
	MWIoCkHQuvW7oO22KNVQ7RMj4Hnihh/h6bC45WHHX+Hab1NrRR5Wi3U1vo8tgA5eaw+iviKVteyOR
	6tNnSftksTlsZHucu+a0rOsXiwns2QubZJnh78kj1FqgPa/NSeu1jVR8/kY4l68nyzdjDXPfUma3R
	9aax4UWVo62srVqEVUIe4rgG1QzcbUFNGt0Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRr1q-0000000EfMy-1ErO;
	Fri, 13 Nov 2026 21:09:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:09:18 +0800
Date: Fri, 13 Nov 2026 21:09:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Manorit Chawdhry <m-chawdhry@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
	Colin Ian King <colin.i.king@gmail.com>, Andrew Davis <afd@ti.com>,
	Pratham T <t-pratham@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Udit Kumar <u-kumar1@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/30] Clean and improve SA2UL driver
Message-ID: <avcL_qGCSs4dA_zJ@gondor.apana.org.au>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>

On Wed, Nov 04, 2026 at 11:14:10AM +0530, Manorit Chawdhry wrote:
> The following series focuses on some cleanups to the sa2ul driver, it
> starts with very trivial cleanups then goes to fix some bigger cleanups
> and migration to crypto_engine which help fix the broader race condition
> problems with the driver, thereafter it adds the support for AES CM as
> per SAxUL 3.1 IP. KASAN is also run alongside to fix the issues caught
> by them.
> 
> https://gist.github.com/manorit2001/0c005603f1a2da0e82c760e209ab0c4a
> 
> Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
> ---
> Changes in v2:
> 
> * Sashiko (visible web review)
> - Improve some commit descriptions
> - Map contexts at allocation and remove the redundant mempool
>   allocation check
> - Prime AES-CM before registering algorithms; fail probe if
>   priming fails
> - Wipe the temporary AES-CM round key
> 
> * Sashiko (API-only concerns) [0]
> - Make the probe register mapping local
> - Validate context IDs and AES keys
> - Check scatterlist errors and handle unaligned IVs
> - Synchronize DMA using the recorded mapping direction
> 
> * Pratham
> - Use fixed hash/skcipher request sizes 
> - Migrate to init_tfm/exit_tfm
> 
> * Self
> - Rebase onto linux-next
>     - Remove Assisted-by tags
>     - Drop few patches that are irrelevant after rebase
>     - Remove redundant algorithm IDs while preserving digest sizes
> 
> - Remove unused SA_MAX_AUX_DATA_WORDS
> - Preserve full authentication-key lengths
> - Propagate DMA completion errors in a separate fix
> - Unwind fallback transforms and security contexts on init failure
> - Stop the engine and quiesce DMA once before teardown
> 
> Link to v1: https://lore.kernel.org/all/20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com
> 
> [0] https://sashiko.dev/api/patchset?id=20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162%40ti.com
> 
> ---
> Manorit Chawdhry (30):
>       crypto: sa2ul - remove dead code
>       crypto: sa2ul - remove totally unused structure fields
>       crypto: sa2ul - remove unused fields from sa_cmdl_cfg
>       crypto: sa2ul - remove unused context fields
>       crypto: sa2ul - remove unused macro definitions
>       crypto: sa2ul - remove unused base register pointer
>       crypto: sa2ul - remove unused includes and defines
>       crypto: sa2ul - remove unused line
>       crypto: sa2ul - remove redundant sa_sha_digest() wrapper
>       crypto: sa2ul - fix struct documentation for match_data
>       crypto: sa2ul - keep the probe register mapping local
>       crypto: sa2ul - zero out security context on free
>       crypto: sa2ul - preserve full authentication key lengths
>       crypto: sa2ul - validate AES key sizes before indexing
>       crypto: sa2ul - remove unused SC ID range tracking
>       crypto: sa2ul - copy command-label inputs locally
>       crypto: sa2ul - consolidate encryption offset definitions
>       crypto: sa2ul - handle unaligned IV buffers
>       crypto: sa2ul - remove redundant algorithm ID fields
>       crypto: sa2ul - handle transform initialization failures
>       crypto: sa2ul - reject exhausted context IDs
>       crypto: sa2ul - validate scatterlist setup and unwind DMA mappings
>       crypto: sa2ul - propagate DMA transfer errors
>       crypto: sa2ul - calculate DMA metadata length from the command label
>       crypto: sa2ul - correct scatterlist DMA ownership transitions
>       crypto: sa2ul - use a mempool for security contexts
>       crypto: sa2ul - use synchronous fallbacks and fixed request sizes
>       crypto: sa2ul - route requests through crypto_engine
>       crypto: sa2ul - report SA engine hardware revision
>       crypto: sa2ul - add SA3UL_CM AES support
> 
>  drivers/crypto/Kconfig |    1 +
>  drivers/crypto/sa2ul.c | 1265 +++++++++++++++++++++++++++++++-----------------
>  drivers/crypto/sa2ul.h |  172 ++-----
>  3 files changed, 854 insertions(+), 584 deletions(-)
> ---
> base-commit: 7649ba73f9e7e1e04d0b46213e39c79ae09dd55c
> change-id: 20251106-b4-upstream-sa2ul-cleanup-ce85d40c7eb8
> 
> Best regards,
> --  
> Manorit Chawdhry <m-chawdhry@ti.com>

Patches 1-6 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
