Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A0D35B65D;
	Wed,  8 Apr 2026 07:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775632480; cv=none; b=f/x3OMMoN2ukFuJfLApZlwjc4JvVzFyjE27dNnGNhJfpjhEFd+GBCR1qi2GTetUMfI+tUVBe48XEiCxIQVt5WJ1xkoRZ/9OI8N/+5HqhmcF8VaI+7a9UG+PtI8E3CiRjnjvkjcOi+mRnLTL7Ucd86pS98SQbUwS16g1FxeJWOzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775632480; c=relaxed/simple;
	bh=m7Yz2p3aVCXKQqlcwtRMbVyXwo44caQVriFS2/9CDvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/qrJseu5Oeu4pQPLtUosLu3UgeQc3ReJoe/iTBMiJYRNpqgehJWyC3tQUrh78pZxbsjelcdOjj07bWULD8Lm3JNVULmpjzvVrZCklakDoPoi3RzPHPqApqk8Npj2sS/ud7uhJhXcQ0Klgha7fjkZVcHcSyALE3Btn4eKIyjozE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HwdsTKgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HwdsTKgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBCDC19424;
	Wed,  8 Apr 2026 07:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775632480;
	bh=m7Yz2p3aVCXKQqlcwtRMbVyXwo44caQVriFS2/9CDvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HwdsTKgBZRw9wturcZ5tigyzMZnVfdYzixNLS8z9wjJowxPVQH8g71fkeUpbDsXRn
	 edlb9X+k7H41+wmuGzOij6bqB7+o9LehDWrkGeG7oKMjKXWyaddXUt84kz0TsBRIlc
	 ZvRAJSGMl4xD2DyDjFv1WOqAamb46Bdqt3H1ZDC7k4goFJ2xLFjRgCBPJHTmb07AaX
	 nL/6edwa6T7TttfmQx4IauQqPAp7pCE1Uzr4L9MnoSNEbifvRgznFYNQgRO5TwzCBo
	 e6mcU5ZaWgbS42WzThryRMmgs3Gt9qB4icOyt0SCpRyhtxLJYIktV9SVyoBo1CPXUG
	 NPwMLm/4G51Ug==
Date: Wed, 8 Apr 2026 00:13:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH wireless-next v2 0/6] Consolidate Michael MIC code into
 cfg80211
Message-ID: <20260408071323.GA157920@sol>
References: <20260408030651.80336-1-ebiggers@kernel.org>
 <56798292be29f3e76e88c837d41eff0cb9f8b36a.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56798292be29f3e76e88c837d41eff0cb9f8b36a.camel@sipsolutions.net>

On Wed, Apr 08, 2026 at 08:32:12AM +0200, Johannes Berg wrote:
> So five out of six patches are wireless, should I apply the crypto one
> too?

It doesn't conflict with anything in linux-next, so it would be possible
to take it too.  Maybe wait a day or two and see if Herbert acks it.

- Eric
