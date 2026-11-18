Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017930;
	b=e9Imj/yhlSEgKIM5O4RMfpLOF3OXNLlBS0p9wpiyNnsH9l3oAi/pUWSQYyR7VRzKT0+H
	 k0/y9I7mbhbEJmbxJNiFvCHCb8dA5g7PerqWItBAK7g1eYG80/wLiXw4QzTAxnjCsN30V
	 hNdLOT85349cmC49hwvmHhEy8s0Ch4H8Jm71QMpL3jMKqIvb9O5WFEbz1utnm5fnbLsrY
	 tDkLiw/ufjXzuA/klwue6ojarwaqjJWOSLS246prwLGEgHtB5f2qmST8BY/PYZfglz1T4
	 fxfJXtXrQFQQa4AE7vLODCa/9Oq6HflA9OgpvgvCcK7B/cJ4yqEYDlGYc6vKagWfX1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017930;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=HRPLTzRrv6fW92M9cJ9cmOC6B1lii9nz4yl+pVUSZMo=;
	b=uEKy7pcJztadS9IUbc3a67W15vbH9TQBtuKMGzMZIYfPo5Z2CR9pdYU1+HZDSie7tBGb
	 8HfSdghHdYzT2EYUpfcX4t2ICcflXnjHQ8lahc0odhXoJ56fJg7l9BtbyLYEiJVyXkR2Z
	 CWRb8ORwvEb8v72O8of50vFE1xdxVRHtibZ2R0uxmiyEveU/I4KEJxbH5d9VR86D5sZHJ
	 o4yr2JC37gIUEEeSFM2mGGuwSEtenWHviBXJv8EpxyepvSmSyBvJjPbhkrXJ2bThxnpDy
	 sZFiiYnd2QObhJDGAOtb7ctEuzHFnRP93Dd3Z9DHkgZ6pNgf0FSsEKgr39OKO/H7HbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aMdTnBOn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C50606A330;
	Wed, 18 Nov 2026 16:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aMdTnBOn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C0C1F000C4;
	Wed, 18 Nov 2026 16:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795017930;
	bh=HRPLTzRrv6fW92M9cJ9cmOC6B1lii9nz4yl+pVUSZMo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aMdTnBOn7BZx3f1c4qgSwoVvjMJaTayBxmi4P3UkT7TnMM/iJv8x2xEdcIsJo+x8z
	 tMbCL4heAIMiLzwrsfM/WSReHyVwienwz5th5/5HOmvkOcktKP+oQ1iHyYE7E4Cg8B
	 k8SAmQcCOodgOovdeuFUQ3H1f0BdxX5I14K0MmCjZmTZm3+04ccfbL9rCcGk4/KFLC
	 a/wThZRyEqYb3tJ8padldJDYUvj6dNzWC9KIsiAsPQQcCEmdWkZC6gb8hUlM5c8cd/
	 YfBpWgrBTWuYYXXPBkM9Q97yz6vxyd/w6C4xu7x3KbGLlNBy2nF01m4mYs8OmJuiuN
	 vVrp/jEkokpbA==
Message-ID: <8dc563e1-b5f4-49d3-80bc-5bd54e58392b@kernel.org>
Date: Wed, 18 Nov 2026 10:05:28 -0600
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] crypto: ccp - fix misc_register() failure paths in
 SEV and SFS
Content-Language: en-US
To: Kim Phillips <kim.phillips@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
 Rijo Thomas <Rijo-john.Thomas@amd.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261117221901.746427-1-kim.phillips@amd.com>
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20261117221901.746427-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/17/26 16:18, Kim Phillips wrote:
> sev_misc_init() and sfs_misc_init() both publish their newly allocated
> sev_misc_dev/sfs_misc_dev to a file-global pointer before registering
> the misc device, then return early if misc_register() fails.  Neither
> frees the allocation nor clears the global, and the early return is
> ahead of the kref_init(), so the embedded refcount is left at the zero
> from kzalloc_obj().
> 
> Both features can be detected on more than one device, and a failure
> here only aborts the probe of the device that hit it.  The next device
> to probe therefore sees a stale non-NULL global, takes the else branch,
> and calls kref_get() on a zeroed refcount:
> 
>    refcount_t: addition on 0; use-after-free.
> 
> The count stays at zero, so the matching kref_put() on teardown warns in
> the same way and never reaches sev_exit()/sfs_exit().  What is left is a
> leaked allocation plus a device whose ->misc points at a miscdevice that
> was never registered, while the driver still reports the feature as
> available and no /dev/sev or /dev/sfs node exists.
> 
> Both patches free the allocation and reset the global on the
> misc_register() error path.
> 
> Note the differing Fixes: tags.  The SEV stale-pointer half goes back to
> the original SEV support commit, but the allocation was devm_kzalloc()
> then, so backporting the kfree() that far would turn the leak into a
> double free; the tag points at the commit from which the fix is safe.
> 
> Found by review of the equivalent bug reports; no hardware failure was
> observed, as misc_register() only fails here on minor exhaustion or an
> OOM.  Compile-tested on x86_64 with CONFIG_CRYPTO_DEV_SP_PSP=y.
> 
> The two patches are independent of each other, and of the pending
> 
>    https://lore.kernel.org/linux-crypto/20261116203622.615371-1-kim.phillips@amd.com/
> 
> which touches psp-dev.c only.  This series applies on top of it, but
> also applies cleanly to cryptodev master without it.
> 
> Kim Phillips (2):
>    crypto: ccp - fix leak and stale misc_dev on SFS misc_register()
>      failure
>    crypto: ccp - fix leak and stale misc_dev on SEV misc_register()
>      failure
> 
>   drivers/crypto/ccp/sev-dev.c | 5 ++++-
>   drivers/crypto/ccp/sfs.c     | 5 ++++-
>   2 files changed, 8 insertions(+), 2 deletions(-)
> 
> 
> base-commit: 26ca5f34841f0a86d0883664a1c13be89a01d351

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
