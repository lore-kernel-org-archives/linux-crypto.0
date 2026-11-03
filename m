Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698109;
	b=cgTwdo2DK5Fl4++BT7fNLJ/15jA4bMv2WLbsjnDu85pNlJ87WKhRPkxIVgucUeVLt0nW
	 3r7M34XoMSp2nsCMvYsLYoNlxsMmb4qUsXTxrtkw0EZvVrtjwRHD78DPqAWSZvyw6Tt/u
	 OkRbkMhmsFQkLYnxGSi6330lZ1zfqIrKcTXI+Jt11BjHeqQ52kVYxWYHEPZq4U9Of8Kdy
	 B3SqnhzUTGphc76Ny3bhFjmwOj6pY8H8mTu+sBgHpeFAfWcjAiVr38KEdKGxznk57C6c/
	 20/Rv2lanhT4jGYGB4Tf2lHyfcpFZQhopa9K997VSJCx0ssXFuLe2YMV3PYlWSNIQMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698109;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=f2H/3oZ7talPKu4IwRTirXyAjOhyT78W2zuNpCksym8=;
	b=inFsMSWOx+wX571+x98qSVaXWlv9MLDUGgw/UCtfx/Gb/GRKWGWbQI1+qtZ5/vs9U6hg
	 DWTfgsB4MPKeSvqqjHMNJEZgQzoTo6n7RpMztCzZnb+1ocVYo5iqotOjAjCza0DZ1/CG4
	 GUMizUbxhufiK9hPFsWx3Hk+K2uulKhiguJmb7BvR6adz0NZ04p6w02Wgjl/LTw0VJl5U
	 eOw39xkMiLX29ry8aee7b6jOvJSjLQCdOZt4FxXNbw9Gact4BLeXhLKrKnyUlxuutS0Xo
	 3tFoxkZUgEw2BUDYFoAy6qeKErYojeRU+KOv4IF5dXVQwM7KDMRT29L8iJx/xbAjUow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RZd+Kt5c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E8C606EE86;
	Tue,  3 Nov 2026 09:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RZd+Kt5c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036CE1F00A15;
	Tue,  3 Nov 2026 09:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793698108;
	bh=f2H/3oZ7talPKu4IwRTirXyAjOhyT78W2zuNpCksym8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RZd+Kt5cfjkN4wHrAx0u1jiI7IPL1iurQsNupbOcVjS+OLpSh1S3alHTye2qK2yOn
	 qTQyYotcN/oe9qeW83s1LztL6oOCof93g8RfERZQygK1cuoRFedirhGVC8FvgbvfKx
	 M1FiB/d7f0OLpWvJfftcO4OjkAEHCQcUQT/zyB2/hQuAvI+dkkNJAdZe6SdHkVsc3N
	 vYpl9DBYvPa27KljMzChd03jovRuz6jJQM6WOBrNc0yxtilHRxwbVtZpTBKbvD0VRT
	 gc7e0DRk2tEEr8rQ8Rr2J+w1jr9MyWJywu+IndYhiylOmHZu5IhVdKx0s4VUGmvWWX
	 9YVsaPDOCTLgg==
Date: Tue, 3 Nov 2026 10:28:25 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: davem@davemloft.net, ayush.sawal@chelsio.com, stable@vger.kernel.org, 
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: chcr - Balance inflight count on invalid RFC4106
 AAD length
Message-ID: <20261103-ludicrous-private-gecko-ac4ca8@quoll>
References: <20261103075255.1114171-1-vulab@iscas.ac.cn>
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
In-Reply-To: <20261103075255.1114171-1-vulab@iscas.ac.cn>


On Tue, 03 Nov 2026 07:52:55 +0000, Wentao Liang wrote:
> chcr_aead_op() increments the device inflight counter before checking
> the RFC4106 associated data length. If the length is invalid, it returns
> -EINVAL without submitting a request or decrementing the counter. No
> completion can balance that increment, so device teardown keeps seeing
> an outstanding request.
> 
> Decrement the counter before returning from this validation failure,
> matching the other synchronous error exits after chcr_inc_wrcount().
> 
> Fixes: d91a3159e8d9 ("Crypto/chcr: fix gcm-aes and rfc4106-gcm failed tests")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 1 +
>  1 file changed, 1 insertion(+)
> 



Multiple things here:
1. Your team ignored completely previous feedback. Multiple times.

2. You use multiple identities with this email address, thus I doubt that we
   speak with an actual person.

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
letter), how to document the issue discovery method and what was
or was not tested.

Best regards,
Krzysztof




