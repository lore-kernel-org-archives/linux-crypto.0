Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E622B2628D
	for <linux-crypto@vger.kernel.org>; Thu,  4 Sep 2025 02:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756953467; cv=none; b=Y8aE4D89E4i1A+ID42Vyc+Z2xnhK04wKp9mWFfpnJNkn0sNlxqSUZYF2iTBkgjsc7erpg8HyHcCrolwrC6H8f4he1KxZ6qe1W0LcVgcKmMC1ieH0qpeZRmcTJRjmYgwtUQk4ftwQXzqKfgTMhyG+op1zLPacA1wzlDOYVMgxRlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756953467; c=relaxed/simple;
	bh=bGGamGC/v1xDdqp+gzyDAlxjoS50x3wJ7xGmH8xSejY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UC1VEtlgsXOKBO8s4nd7fKM6ka7LMU9eG4tQTS2EPKExBKGZBSN8BT5K/yPeLYGJoI2QK3n5g8KGrYSI1Hew+bguMjqNIjnFKxQPl8fiYCGalrF0FqwIMf2rk2nzZLj6CW5RUdq+SdprvDWW6dEf340Bncq1oPLtw8twKQRt44U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=isABCT4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="isABCT4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37414C4CEE7;
	Thu,  4 Sep 2025 02:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756953466;
	bh=bGGamGC/v1xDdqp+gzyDAlxjoS50x3wJ7xGmH8xSejY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=isABCT4LgbDKXvqgX2w4ieBibu6DLFXmgb/ktYmZWmX6Fufc8b94+Bm+947LK5xGa
	 JSXxGWz421RRHg1wURcSXPxHyAQtcT2vFUNFmvPleoutcUOe8vbzdxMVYcQP4+HdjE
	 mjssz7uidKb4BvrODpmx4A4L8vYZ+X8ho2rZaW2/ezzzsz9+OtNVJvaklAbphKMUKe
	 3GtAVpCrRifizDwFD9ndXx+bK/6s/RXzRFqJY3/1LGTauAIpgq8ELXu9G3NFvSzNa0
	 fvKb7vifi2xo+LsSPR4WOa24NKgD1oKHUcWvRCFzl7n8DN548t0hST8kd5s9PqtXCs
	 EoaWBXkxiTFcQ==
Date: Wed, 3 Sep 2025 19:36:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Chen-Yu Tsai <wenst@chromium.org>
Cc: dri-devel@lists.freedesktop.org,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH drm-next v2] drm/bridge: it6505: Use SHA-1 library
 instead of crypto_shash
Message-ID: <20250904023636.GC1345@sol>
References: <20250821175613.14717-1-ebiggers@kernel.org>
 <CAGXv+5FxXcJxfCUcX2SY-agbi-sr+btXq2-sDx6quwGF2vu8ew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXv+5FxXcJxfCUcX2SY-agbi-sr+btXq2-sDx6quwGF2vu8ew@mail.gmail.com>

On Mon, Aug 25, 2025 at 04:55:17PM +0200, Chen-Yu Tsai wrote:
> On Thu, Aug 21, 2025 at 7:56 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Instead of using the "sha1" crypto_shash, simply call the sha1() library
> > function.  This is simpler and faster.
> >
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> 
> Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>

Thanks.  Can this patch be taken through the drm tree?

- Eric
