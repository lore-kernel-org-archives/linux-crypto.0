Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1581154723;
	Thu,  9 Jul 2026 15:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783612036; cv=none; b=TH6vX6pQKRop0POy9opkDYtiHMaoH8z8vfeBUq8rXB+CpWatXB+d/P/glpBHdC6ZcnCziDjIpLjLcwUm2SzvpvjQ2jUIDmdVOHjDqSzIcy6vieGCgQGxkzNCJR1wxBJ9SewMEtj+c8tUoFb4P0/hcslxexYXxlxa48KKyegpan4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783612036; c=relaxed/simple;
	bh=GVCbjF+A4VSV4RiKd3PnGb4Zfkm9Eg/koEAbHJbvzDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8eDhFYx66qc0n1vkurUelbVvgy6IirewabWw+MR+dFqTI5gWJIZUEMzPvrimG9n7pj9LH4rhM6WX8lEBtnjBqrdu/YMDpLUnDtsBXVYTlHrSTwmbSsAcsagEGjNwZfh6DvqWIgEGQd78j/XznEJA8wLFVmXqhJORHt0rnpo7oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LKsuqrl4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LKsuqrl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68991F000E9;
	Thu,  9 Jul 2026 15:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783612035;
	bh=DDBTZE6NaalyA2hbP+96rCdb52x67RTX0930I1VznkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LKsuqrl4VNkM812QBSwyAAHx/zksQk3ssvSSg3/kI/w9H31LFOxTc2VKsgfu0e9+C
	 Mu+BdBTgWHTKZrOKtoOKX5Hzc0zR9c+Zw7j1sY6qEbVkxTC++FVzwCqOBlQ9A0+H1o
	 wYKZVaiYx65iVT55zK41q8Awp6jfpSx4tZdRXNHGqFzhVEUUBqVxp4cpnaHOiZdSh4
	 ZoHILkAp7HW2KCxaOLdYZUjC8EyFdjz8bmEqdMsrYovHdibrWaBRkxLIZzKZvgXoji
	 QvdxNewJYwMsmaaYiA08P3Czom3nqctQ0Zo+/C2PvnoA16VCKB66pNjBGBumOzYSid
	 j+z67Am5ElW0g==
Date: Thu, 9 Jul 2026 11:47:13 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH 29/33] bpf: crypto: Use AES-CBC and AES-ECB libraries
Message-ID: <20260709154713.GB6853@quark>
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-30-ebiggers@kernel.org>
 <10eafa42-1142-4ed2-a485-f46c496bddfb@linux.dev>
 <20260707182049.GA2238@quark>
 <d1cdfc23-b336-49a9-8833-29f05b5b9fec@linux.dev>
 <20260707231652.GA2264445@google.com>
 <5f9c3aab-5339-463c-a86d-edac297e1e95@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f9c3aab-5339-463c-a86d-edac297e1e95@linux.dev>

On Wed, Jul 08, 2026 at 12:47:43PM +0100, Vadim Fedorenko wrote:
> On 08/07/2026 00:16, Eric Biggers wrote:
> > On Tue, Jul 07, 2026 at 11:50:33PM +0100, Vadim Fedorenko wrote:
> > > > Does this mean the AES-ECB support is unnecessary and can be dropped?
> > > 
> > > Let's keep it if it doesn't hurt.
> > 
> > It kind of does.  It is "bad" crypto that would have to continue to be
> > maintained, and someone might start using it accidentally.
> 
> AES-ECB was introduced as a cipher to use in QUIC-LB draft,
> draft-ietf-quic-load-balancers-21
> 
> I know it is expired draft, but it may be worth keeping this cipher
> as QUIC WG github is still active

Sigh.  We shouldn't implement Internet-Drafts that have clear issues
with how they use cryptography.  They're likely to change when they
undergo cryptography review.  We went through this same thing with
TCP-AO, where I ended up joining the tcpm working group and getting the
draft fixed.  Do I need to do the same with this one too?

- Eric
