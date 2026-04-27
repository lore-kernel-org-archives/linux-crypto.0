Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02612116F4;
	Mon, 27 Apr 2026 22:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777330540; cv=none; b=KkzH3I0kBWEwDW8NTSOXacVmMSCVYH3R7A4r2MoUVw4TjCd1gpme4Via++D8PkJblHsgyg8WGnK5vyHph+7Bk3BUOPfeqO2U3dsSAv2h/pbfvPp2jEDQh+qvHgX1P6bhlR5ij4ojZztJk/QRN6jd28A9syRu5c8f6Q6o9EZyyL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777330540; c=relaxed/simple;
	bh=u4TmU67f5hhwJf1I4i/d/XWbjxi0EHQ0omutGz+1/+0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VL8h2r9/HKLAw81IZZxKzI30+2pOLwklXc1GgYmLhmDDZ2yMwoT4CUnH8wzEwLCIsYFPvM0SufX1RHb73bmRUmNepcW0HaioCvJofGquInB+e40CjLQmfKgF0mtksVtwK9cSdEI+Pxo/RUi2Xl30JpC4Ct7A0fhFZON17rzbiVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H3J/zqSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3J/zqSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1CDC19425;
	Mon, 27 Apr 2026 22:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777330540;
	bh=u4TmU67f5hhwJf1I4i/d/XWbjxi0EHQ0omutGz+1/+0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=H3J/zqSUWdQG+2g7LezoYT1Gqql7aJLVtVhJE+MpKGOj8nEeazSr6wWT1/TfIZr8B
	 YyED+LEVseeNaCLB9x3bqnDlElbTjMCLoXh9XtNqIDPhI6bJYC9opsxPlEL8DgDpZQ
	 UdjAx3dS6pyfI2GgQRbbBrNtGelK0bwqDRE3pQBqLFw2EfaRCA3MB6HiCngBbq66+X
	 Nhn4Nzc4mDj2MOuKkc2uksSXoX35BmPtYCu/V6KcmuARBL8jQDD60HmqzB2uFT7JvI
	 ouGeJIXeSI4w79oz+2A87q1CnnUojv4WE0VdOWm4shBv5aSWiuEfSadDcO8q4/UKb3
	 p8y8PpIUSvnIw==
Date: Mon, 27 Apr 2026 15:55:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, netdev@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Eric Dumazet
 <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, "David S . Miller" <davem@davemloft.net>,
 David Ahern <dsahern@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, "Jason A .
 Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Dmitry Safonov <dima@arista.com>
Subject: Re: [PATCH net-next v2 0/5] Reimplement TCP-AO using crypto library
Message-ID: <20260427155538.2e1b8488@kernel.org>
In-Reply-To: <CAJwJo6Z9oJSMMBUL_pbYWN6ha3n4MRpKV_aVut8E+af3JUDFkw@mail.gmail.com>
References: <20260427172727.9310-1-ebiggers@kernel.org>
	<CAJwJo6Z9oJSMMBUL_pbYWN6ha3n4MRpKV_aVut8E+af3JUDFkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Apr 2026 20:09:05 +0100 Dmitry Safonov wrote:
> I do like these numbers quite much! Yet, as I mentioned in version 1,
> removing a fallback for other algorithms' support does not sound good
> to me. There are two reasons:
> - Ronald P. Bonica (the original RFC5925 author), together with Tony
> Li do have an active RFC draft to support the additional algorithms
> [1], potentially in addition to TCP Extended Options [2]
> - There is at least one open-source BGP implementation (BIRD) that
> allows using the algorithms that you are removing [3]. Without a
> deprecation period and communication with at least known open source
> users, it implies intentionally breaking them, which I can't agree
> with.
> 
> I don't feel like Naking as we don't have any customers using anything
> other than the 3 algorithms above (and BGP implementation is
> [unfortunately] closed-source, so that would not feel appropriate even
> if we had such customers), yet I do feel like it's worth and
> appropriate to express my thoughts/concerns.

What do you want to happen? You are the maintainer of this code,
you don't get so say "i don't want to nack it but also no" :)
Like Eric says if there are no real users code can be deleted.

Adding deprecation warnings upstream is quite slow, IDK if injecting
deprecation warnings to stable has been discussed..
