Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CFD13E02A;
	Mon,  4 May 2026 07:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777878523; cv=none; b=CQbSKNReAJsxz0UIl8PmNVqbi6WSOy4q4P83XAnXoCetaUcKDvW9RrzpYq1iwR2Br8KKnnBUfNKddXs9/QyhHWcrW27fvGsOYOhbO4rQbgN3wJZhOqVN5nP7+IAlpZslaAbm+QK1anU6R+glgZFzoBqB9ENz280HPT36d20Zg28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777878523; c=relaxed/simple;
	bh=Ftv5tCXhZNUJeQD6R3XWg+ZkXzm+GTlUKkt9SUEaZ9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tyc4StcrK11VA+Z+fFLK9l13jEN4cWdCscFuI4NfyD7iXr1w89izSi4Uz866o3K6VL689WpgXka/gha0Vq5deHsfPtHRdP+m3dnW6fN1K+P7JM4rD71Wcsxs+hlAy4HqoyMagvwxF5Yt+X7okzVojhDcsd5Euxtx36bbQn10oBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHujJU2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHujJU2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E7AC2BCB8;
	Mon,  4 May 2026 07:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777878523;
	bh=Ftv5tCXhZNUJeQD6R3XWg+ZkXzm+GTlUKkt9SUEaZ9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VHujJU2Oc2E1meeweD5yHJ6rzcM2hQ80YcYl/DnM254pgXw48tNk5QndE7mYTL3Jz
	 zUi561lwJbuT+IDUhc9IyPlxzmpTZAaRkJSjhn3DontlTcTSlDbwwZi5wvtll/QnAW
	 D0B6vnAynb9KFuo95ojUx5tS3C5WT3l8yduhi0SMLsSrXYCbkePjhP1SQoF53eWSFA
	 SdUMaIftP73XUWxDJYLuCrmh+j1zpCscx15ghN1aGF9sQuyJOql4Li7BHSQ6afvNR5
	 0kDr1aAd0FDYU5qxCADFnU3CHqb3imhX3J6M3XJhvEHRl+UZUiZ2oRiJv3/EjPQcSJ
	 88wUgH0D1BANg==
Date: Mon, 4 May 2026 00:07:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	Taeyang Lee <0wn@theori.io>, Brian Pak <bpak@theori.io>,
	Juno Im <juno@theori.io>, Jungwon Lim <setuid0@theori.io>,
	Tim Becker <tjbecker@theori.io>, Feng Ning <feng@innora.ai>,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg - Remove zero-copy support from AF_ALG
Message-ID: <20260504070724.GC112568@sol>
References: <20260504061532.172013-1-ebiggers@kernel.org>
 <79b24e6f-91a2-4dd0-a5f2-c01a9247ea9c@gmail.com>
 <20260504065655.GB112568@sol>
 <75cfc88d-31ff-4412-8c5f-788032498579@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75cfc88d-31ff-4412-8c5f-788032498579@gmail.com>

On Mon, May 04, 2026 at 02:59:41AM -0400, Demi Marie Obenour wrote:
> On 5/4/26 02:56, Eric Biggers wrote:
> > On Mon, May 04, 2026 at 02:54:27AM -0400, Demi Marie Obenour wrote:
> >> On 5/4/26 02:15, Eric Biggers wrote:
> >>> The zero-copy support is one of the riskiest aspects of AF_ALG.  It
> >>> allows userspace to request cryptographic operations directly on
> >>> pagecache pages of files like the 'su' binary.  It also allows userspace
> >>> to concurrently modify the memory which is being operated on, a huge
> >>> recipe for TOCTOU vulnerabilities.
> >>>
> >>> While zero-copy support is more valuable in other areas of the kernel
> >>> like the frequently used networking and file I/O code, it has far less
> >>> value in AF_ALG, which is a niche UAPI.  AF_ALG primarily just exists
> >>> for backwards compatibility with a small set of userspace programs such
> >>> as 'iwd' that haven't yet been fixed to use userspace crypto code.
> >>>
> >>> Originally AF_ALG was intended to be used to access hardware crypto
> >>> accelerators.  However, it isn't an efficient interface for that anyway,
> >>> and it turned out to be rarely used in this way in practice.
> >>>
> >>> Thus, the risks of the zero-copy support in AF_ALG vastly outweigh its
> >>> benefits.  Just remove it.
> >>>
> >>> Note that this isn't a hard break, since the splice syscall is still
> >>> supported.  The data is just now copied instead.  So it still works,
> >>> just a bit slower in some cases.
> >>>
> >>> Tested with libkcapi/test.sh.  All its test cases still pass.  I also
> >>> verified that this would have prevented the copy.fail exploit as well.
> >>>
> >>> Fixes: 8ff590903d5f ("crypto: algif_skcipher - User-space interface for skcipher operations")
> >>> Fixes: 400c40cf78da ("crypto: algif - add AEAD support")
> >>> Reported-by: Taeyang Lee <0wn@theori.io>
> >>> Reported-by: Feng Ning <feng@innora.ai>
> > [...]
> >> In light of https://lore.kernel.org/all/afYcc-tZFwvZZo76@ans-MacBook-Pro.local/,
> >> yes please!
> >>
> >> Should there be a Link: tag referencing that email?
> > 
> > Yes I forgot to put that in, sorry.  It should go after the second
> > Reported-by:
> > 
> >     Link: https://lore.kernel.org/r/afYcc-tZFwvZZo76@ans-MacBook-Pro.local
> > 
> > - Eric
> 
> Should this also link to copy.fail or a related email?

Sure.  I'll go ahead and resend right away, so it doesn't get applied
without the links.

- Eric
