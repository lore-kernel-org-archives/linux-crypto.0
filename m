Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB992EEE66;
	Wed, 19 Aug 2026 20:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787170386; cv=none; b=XRuJ9KD8X2hNm33JWYzTNb+DN8FGdLca7xDi3gmvL8oISknrv8a3MuAvWyeK4pzuKothCe5mOJqcoAVIwUx+Dhptya4FDPY1Vf73igmBH7VIS5H8Enhrg4RCfa3hbBucrSSs62zGx9jepXaxOf9eh7yxuDBRXLUtWBXvpu0yYAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787170386; c=relaxed/simple;
	bh=8ez+qKirDM6VniJHUT7jJju4YM5DmduIl4wmXDfMROA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItBjNZiqHpNCK6Pwf61knXAnkYansbzUxddWGc0YrsJ/qq2xPX8DB65Uhig55eMuwxo75ujLa7T6MCS4b9tVLo7/X0We/bjrX4uiAleVhyfwOhMlo68lBoY1+Mm8lfRuin+nvCzZP0HGESULqQT/t3NPbe9MHvtcAxJtg5urj3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ez5vr7uX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ez5vr7uX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA2F1F000E9;
	Wed, 19 Aug 2026 20:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787170385;
	bh=jfPhFrAlZ1QN5eRyTMyV/+u4CPeWu9l/un3pn+goY5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ez5vr7uX1hXfbbKcu6/lvVEzhXj/ZfWp/LSyIwcFp2d8yEp8jY2On3udJmTEGcUp1
	 XQqpopBOGr+WQyAeeHxPsTGCjTbMRnFU7cSq9EKlDQ+r7x+59gVzXAiNhtAxU9NV1L
	 KWn/E3om3TDFg73my/Xi5ri9WHDO50cQhEs/e4R05EURFSrZb7ZrQbauKnMD07ZSRR
	 ZP3CpZq2SFuycnz5DBxXPdcqTB6uQoHs+shrDF28r5rVDRWdOEJoY2yd61UOa/FijL
	 NGlMzP1JUQJ1+mjWqyRyl9PpBANdpGjxPI2Dd0AjBISnVbtJ1Fu75laawjUedV6zkX
	 MIZ84WIc97T8Q==
Date: Wed, 19 Aug 2026 20:13:03 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>, linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add Qualcomm Inline Crypto Engine entry
Message-ID: <20260819201303.GA164716@google.com>
References: <20260819-qcom-ice-add-maintainer-entry-v1-1-60fd2a7ccae7@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819-qcom-ice-add-maintainer-entry-v1-1-60fd2a7ccae7@oss.qualcomm.com>

On Wed, Aug 19, 2026 at 10:59:02PM +0300, Abel Vesa wrote:
> Add an entry for the Qualcomm Inline Crypto Engine driver and
> its device tree bindings.
> 
> List myself as maintainer to keep an eye on it.
> 
> Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)

Acked-by: Eric Biggers <ebiggers@kernel.org>

- Eric
