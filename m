Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC52E3537FE;
	Tue,  4 Aug 2026 02:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785811151; cv=none; b=u4I2S76UycXUzW6r9V00LXrNIKYAkR8Rzgd5jJjv2LgkG5+OfCdxaKxtEFFn7rVSl53QBqVZd8vDZQn44BGoCInywgngqN/2sC0QarpA6Z4exticsQlJn/QtBZPmVNSQh/eOlCGvxy/YND7+rSUKxgnjAdnhD4ElRqeSYXrKdm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785811151; c=relaxed/simple;
	bh=5Sz+UIzMJknJRCsScb18f+qEmeSvidcY5NImWB7y8No=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XE6so06QBNCiBCa1xIaa18eF1WiOYgyUJjkLqM+IUbWx0sWQKi0HM+WZInaPc9tBshTXp5d1R8C+QCPvBjXGADu3p+xbzGQ9F5rX7kzGkNJ5QhFSD4cEZAg0dKOLCHbF9okqTTQnft3NT06tUQ6Gz83mDBFjrOaWr44rhz0mKaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2QB2kwF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2QB2kwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9851F000E9;
	Tue,  4 Aug 2026 02:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785811150;
	bh=iEtDHlOQQGA//wjq9N2BKS6xSS6jZ9+JrUvB3oEe2Yc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T2QB2kwFbsTVTKaiENfN8hbuT76A72SvuhaM03m5I84FGHKIYyZDj0dSQiE2QWf8K
	 MqgbseWzzxSpyX2hxkcRcWF38uhiFWZgv8oGy0LlJGV6+ID4W9AbbCYQC5LjPeNqFA
	 HW9hoDaMBHy2FWdUhFWZHe7C0f6YRk/0zNajapv0tzMnA77g/46CNJdFF2sh+tpRfQ
	 Qlo1auT8LAZnalb7tq9gHzmLV+3vb39NVHbjuLTjQNd6UZIzqPExZdpT9ySJFRkk3o
	 9Oklfe4lwKb6W4/fK+seJVlovS+oNrrQmnPkODW9pJG12kJoAjGhgKaFBuLULNN1Ab
	 EMJ4DZwQ7+Iug==
Date: Mon, 3 Aug 2026 19:37:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Simon Richter <Simon.Richter@hogyros.de>
Cc: Thomas Huth <thuth@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Simo Sorce <simo@redhat.com>
Subject: Re: [PATCH v2 1/9] crypto: Provide a wrapper for zeroizing
 crypto_aes_ctx
Message-ID: <20260804023714.GA1940@sol>
References: <20260803094432.70505-1-thuth@redhat.com>
 <20260803094432.70505-2-thuth@redhat.com>
 <20260803190540.GD2062@quark>
 <d7764cb3-152e-4b52-bed3-d23b45fce540@hogyros.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7764cb3-152e-4b52-bed3-d23b45fce540@hogyros.de>

On Tue, Aug 04, 2026 at 11:21:30AM +0900, Simon Richter wrote:
> Hi,
> 
> On 8/4/26 4:05 AM, Eric Biggers wrote:
> 
> > I guess we should start using __cleanup with type-specific zeroization
> > functions like this more often.
> Frame challenge: should key material be copied that often that we need a
> mechanism to keep track of it?

This seems to be yet another case where you are responding to some
thread and trying to start a mostly unrelated discussion.

There are many cases where data on the stack can be sensitive, and this
has always been the case.  If __cleanup helps to manage such data, it's
probably worth using more often.

> My feeling is that this wasn't a conscious decision, but is the result of
> two other decisions (that individually make sense): contexts need to be
> self-contained (so need to include key material), and context creation
> should be cheap (so stack contexts are allowed).

The entire point of "crypto_aes_ctx" is that it is an expanded AES key.
The callers of it are using it to compute the round keys.

If you're actually referring to the contexts for per-message incremental
calculation (e.g. sha256_ctx) offered by the library API, those are a
bit different.  Sometimes they contain key material, sometimes they
don't.  Even if the algorithm is unkeyed, it may still contain key
material, since the user could be hashing a key.  Either way, the
finalization function for each algorithm zeroizes it.  The caller needs
to zeroize only if it abandons a context without zeroizing it.

> 2. allow contexts to refer to key material stored elsewhere to avoid the
> copy. That opens the lifetime tracking can of worms, but the on-stack crypto
> context is rather short-lived.

That is already what is being done in most cases.  The exception is the
HMAC library code since the 'ostate' is not very large.  But again the
per-message contexts are supposed to be zeroized anyway.  Also, if the
one-shot functions are used, then no context is exposed to the caller...

- Eric
