Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793690835;
	b=z1cyJaR5ZWYj6fVD9Ib9jKaRL+gacmmLYmIZ2OLM6ZoFGgIAw+lNulpyQ79DR5klVj1o
	 tZDcdX/R5PMWS4/biXbWWq0IDDMcPcHTK3sYcLrWSlpQ7hnQfRu4K84TrtYfMiu4qzQwR
	 qj5Q5aOFKzZi2W+gTBYZqmgj1jCErNYYAytFbXCgNt7vTQLbtOQD9m41hHIm+lyMTFVuy
	 tkRpPOS7YCdjMBlJNkl2YEqeCSdd68dDi6Bdu5e+M/7omtY0H2gSJKpDzQ4NtZW+/aAyn
	 Mam4qA/M2pwMkWCl8FFJLiZg8zQnIlOFcOgSd9edFJ0R+uTYjUTA73pYdXjyrvfDOyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793690835;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=7eYOmf5dnuYvytTS8GHoY52pownLnSNNMv8lMZb1qIg=;
	b=tFErCLwj/KVeqBGbTcbZRcdNKr7GMH9ShZJnhrbSyNfCGFsDgCdUd6K4F2UT9qwWfLhy
	 bZjnNeglb7VR2bMfKa1uwM6Il2IRXoYkdr5Z+KTLXV3xaPQWhtkr+5wj7ehO5K6rOtU61
	 jvUwtMfw//+u9Jdd43qrSauBZ4Pz15qivmEyZtAuUND+dijMNySTADLREagduosRxcKSv
	 ePg5f9JgICPZxfYmvk6TfWozCZAZ9hptVbxqVytKHMJSUMh/7UK8J+EFx6bhepyc83owk
	 2q6DGVroF47AKmf1IYte7x+gGO6tSPdUx+oJjcb3yqFhPUT/AEq+sK8THbbGyAkzHlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QtbMin2Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13718606D80A;
	Tue,  3 Nov 2026 07:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QtbMin2Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6BB1F00919;
	Tue,  3 Nov 2026 07:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793690832;
	bh=7eYOmf5dnuYvytTS8GHoY52pownLnSNNMv8lMZb1qIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QtbMin2Q+rShsnO2Ieyj8ZNr+EH8M4NnWDL3OR843nlfdPCs5ERJrvR+daBe/8Ka8
	 pw80kUdxPCfzxantXdBothBcWRg847ImmcL6wi1mnedB0PF4PO3Fae3pvq39LBC7jq
	 PdruqxWERNxKsGNsvl4sTFjAXN+ochJk4RMUdIK8b4enI492L0gojmeh8FkftBU1DJ
	 umVZo4tJCXU1DZAxrAQP3ZaqAMD1Whw8rHuiZqGiPiHyrRCkQrCMNjaT1/1aASK9T2
	 v/OF4ZPT9gYrw7XYN5xKlQwBiDEuLnVjp3uGN8OmoBcxRFxWhLf/Kf9tsoyG7ypx2N
	 rmgNkEpY4BtkQ==
Date: Tue, 3 Nov 2026 08:27:10 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	davem@davemloft.net, linux-kernel@vger.kernel.org, ayush.sawal@chelsio.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: chcr - Free fallback transforms when device
 assignment fails
Message-ID: <20261103-groovy-lyrical-chinchilla-8eb9fb@quoll>
References: <20261103063850.1033008-1-vulab@iscas.ac.cn>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103063850.1033008-1-vulab@iscas.ac.cn>


On Tue, 03 Nov 2026 06:38:50 +0000, Wentao Liang wrote:
> The skcipher, RFC3686 and AEAD initialization callbacks allocate their
> fallback transforms before calling chcr_device_init(). If no active
> device can be assigned, chcr_device_init() returns -ENXIO and the
> fallback is leaked. The crypto core does not invoke the algorithm's
> exit callback after its initialization callback fails.
> 
> Free the fallback transform before returning the device assignment
> error in each of these initialization callbacks.
> 
> Fixes: b8fd1f4170e7 ("crypto: chcr - Add ctr mode and process large sg entries for cipher")
> Fixes: 0e93708dabc0 ("crypto: chcr - Add fallback for AEAD algos")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 



Multiple things here:
1. Your team ignored completely previous feedback. Multiple times.

2. You use multiple identities with this email, thus I doubt
   that we speak with an actual person.

3. Your bot does not even bother running checkpatch, right?

4. Nothing of this was reproduced nor tested.

5. Finally, the same feedback:
You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem (so a patchset grouping multiple patches with a short cover
letter), how to document usage of LLM and what you should not do
if this was posted in a good faith.

Best regards,
Krzysztof




