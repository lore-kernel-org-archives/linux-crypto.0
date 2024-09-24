Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5BB146A7B;
	Tue, 24 Sep 2024 22:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727216921; cv=none; b=jJ1t06ZNqu2Y8qfyvUkSrjabl1kRWEpmStZfKFggm8LmxjUWwc/atC9HAGLqNMHn4x+B+oFAX0R6vUNyY474guFCHqoarlyI+O5IwYFugYbSccKdTxj2qqF4nGlDuBsR9AWRvPgEEVxBiZPrlPFYAuiFiFYd7/GmiVguy8eRSrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727216921; c=relaxed/simple;
	bh=GsVkTtyX/rc3JJKceprQUMQw10UNBAbWAkdmH00ea+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b2byGVWqnfFKvdxJ6cytK84WUkoAq56dJDMHGVcZYnGMo8BhdqsNhMi5IVXkQRtCB+Ylgmz9GoBQ5PuwEECOAK/yRW1ISz/GkyyqsNlVc+5RIYyLASGNDO/xxHxCioGeBetc1lifhF6pbEoEpWGg75oCy4cpj1CEB2HfTHLey0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nkyw7TgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nkyw7TgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF30C4CEC4;
	Tue, 24 Sep 2024 22:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727216920;
	bh=GsVkTtyX/rc3JJKceprQUMQw10UNBAbWAkdmH00ea+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nkyw7TgUrMk8k6+AAj4dlvo0Wf6I9ClSsmADp20hCwN5zP6jyECmqYdCVAyE+yBvP
	 C+szEw6AKUep9mgcNK4F6TAO1/Zq3OA0ZOBBwnP8Z1puOiiiFduOHRME8495UOR3pM
	 EaYiogikueTz2QTg3pL6NLk8Stcqhpg6XDfCi+kH5g951Fnb4oufus6d8/LVjMKzt2
	 IW7ELaKsWCwCW2aKtvKJeyVZubRIJqbnoO3+2jypZzqfrpStw2NDzNkJuQl9Z10h4O
	 OqmeRNWk5rpcl3RhsSZ/9RtU6qqRceCwp+egpt42f2Y14AH24xENro7vTO7oqmTEei
	 2Aswcn+zHAgYQ==
Date: Tue, 24 Sep 2024 15:28:39 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	LTP List <ltp@lists.linux.it>,
	open list <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	lkft-triage@lists.linaro.org,
	"David S. Miller" <davem@davemloft.net>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, chrubis <chrubis@suse.cz>
Subject: Re: af_alg01.c:36: TFAIL: instantiated nested hmac algorithm
 ('hmac(hmac(md5))')!
Message-ID: <20240924222839.GC1585@sol.localdomain>
References: <CA+G9fYtu-h_pp_hNfmx1pBg48oGeRiEDnEc4b-r3AiC_QfWiKg@mail.gmail.com>
 <ZvK-_5QKQ2e0S2Sd@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvK-_5QKQ2e0S2Sd@gondor.apana.org.au>

On Tue, Sep 24, 2024 at 09:30:39PM +0800, Herbert Xu wrote:
> On Tue, Sep 24, 2024 at 03:16:09PM +0530, Naresh Kamboju wrote:
> >
> > Warning log:
> > ----------
> > tst_test.c:1617: TINFO: Timeout per run is 0h 02m 30s
> > af_alg01.c:36: TFAIL: instantiated nested hmac algorithm ('hmac(hmac(md5))')!
> > tst_af_alg.c:46: TBROK: unexpected error binding AF_ALG socket to hash
> > algorithm 'hmac(hmac(md5))': EINVAL (22)
> 
> This is expected.  You need to fix the test to not treat this as an
> error.
> 

So the error code changed from ENOENT to EINVAL.  These particular LTP tests
(af_alg01 and af_alg03) could check for either ENOENT or EINVAL, and it would
preserve the main point of the tests.

I do feel that the previous error code, ENOENT, was more logical though.  From
userspace's perspective, these invalid algorithms don't exist and don't need to
be treated any different from other algorithms that don't exist.

Has it been checked what else in userspace might need to be updated as a result
of this change?

Looking at libkcapi for example
(https://github.com/smuellerDD/libkcapi/blob/master/lib/kcapi.h#L125) it passes
the error code up and documents it as part of its API:

     * @return 0 upon success;
     *         -ENOENT - algorithm not available;
     *         -EOPNOTSUPP - AF_ALG family not available;
     *         -EINVAL - accept syscall failed
     *         -ENOMEM - cipher handle cannot be allocated
     */
    int kcapi_cipher_init(struct kcapi_handle **handle, const char *ciphername,
                          uint32_t flags);

So that is now wrong, as "algorithm not available" can now be either ENOENT or
EINVAL.

I don't really see the reason for this churn.  The kernel commit which made this
change (795f85fca229) provides no explanation either.

- Eric
