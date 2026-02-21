Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D9232ED20;
	Sat, 21 Feb 2026 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771692381; cv=none; b=gh/8NYsIv2Hi4L8Sqyj4WzDCQYaawiPsAYVGPf3SXQjkgB41DAF5aFPSixtUm+SLponu2fkl+KbcZp3ud0ZK67+n+z1W5NVDHWnZqbvbtGIsWfsOpwbc+YSjoJ+0ZJrIkFFGlm89Zn5zlev7cmV7kSU0SsZF8PjNvL/eqPj+T6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771692381; c=relaxed/simple;
	bh=sNnQ4sopjYQ1yJKmMLbRZIuVu0+ZJZ5N+cxYWsYodvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=URy2LzECr/zVYQmJghxUQzhknpJA85TR4y0hv7Ibjgjpg84C8N3mNVFyxnS+KOvF6JO/1HqWlFdruX8kOPno26Zm9RoNsewUCTQKSbFpTzxAJXejh+w58v1N5zo+eziCZ6tUeqisG0TC9/CXSdOPsvN5w+rRTgcW1eKyDuH6Zmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkBjKWaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkBjKWaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42549C4CEF7;
	Sat, 21 Feb 2026 16:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771692380;
	bh=sNnQ4sopjYQ1yJKmMLbRZIuVu0+ZJZ5N+cxYWsYodvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bkBjKWaQ7jo0dp7VzuKfGImYauJIiE4j2DPgVRgIXsu/kTwSfiE9lNzyx7JQPcNGD
	 cg4SrKBmE3XsynC3n0+ia+OTb9ODGWNk2gno3pgYLUoORgoDhuQ74lq08VBj0LQCmN
	 7kxrzoLEsfyx4Jypp255sly8OmC3R7jnczkjWwbM=
Date: Sat, 21 Feb 2026 17:46:16 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Manas <ghandatmanas@gmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Rakshit Awasthi <rakshitawasthi17@gmail.com>
Subject: Re: [PATCH] Crypto : Fix Null deref in scatterwalk_pagedone
Message-ID: <2026022123-happy-unsure-b638@gregkh>
References: <20260221151041.65141-1-ghandatmanas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260221151041.65141-1-ghandatmanas@gmail.com>

On Sat, Feb 21, 2026 at 08:40:41PM +0530, Manas wrote:
> `sg_next` can return NULL which causes NULL deref in
> `scatterwalk_start`

How can it return NULL in this case?

> Reported-by: Manas Ghandat <ghandatmanas@gmail.com>
> Reported-by: Rakshit Awasthi <rakshitawasthi17@gmail.com>
> Signed-off-by: Manas Ghandat <ghandatmanas@gmail.com>
> Signed-off-by: Rakshit Awasthi <rakshitawasthi17@gmail.com>

Reported by isn't needed if you sign off on a patch.  But you got the
order wrong here for the signed off by lines, please read the
documentation.


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
