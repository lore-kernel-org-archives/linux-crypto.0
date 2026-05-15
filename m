Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339B53E1721;
	Fri, 15 May 2026 07:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778828643; cv=none; b=A6mdoK1wXycqh6r+nIJyj8sZ/8VX+QsfGhhMF0XjZWcRrhnOQbX4ZeE5fJ7y5k/Avz5Q7qzj5uA5qKlZYi+hZAOWFV8jz4xWzC//Auuqw2BsfPT7cSNj/iy+dvrJFJB9VeXzBGuszLEMY5bbDvUZnPf0n54jY4Top2XpvyrIeNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778828643; c=relaxed/simple;
	bh=VHpZwYfNEozDI+mmX5fvgkM6Qsp2KkrAn2XfYL3rH+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iEgGnuvB/3NMYoJTqI2CFo1esT7+yjbKi8sDobBqRakDQbtT5QgYbV0H8qyNBGRKkHK1+ahZ2yn9Bn97zSFJKUL3equ7q0+guCyjCgjRVgKWfvkTMlOQWHHSiJVasThTM2LN4hueWsAcIC1iN/C40h7bbZ5nEJSx0ekD/wotzvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVQsGyhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVQsGyhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46380C2BCB0;
	Fri, 15 May 2026 07:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778828642;
	bh=VHpZwYfNEozDI+mmX5fvgkM6Qsp2KkrAn2XfYL3rH+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KVQsGyhyrGGTy+Ynv5DH6pAAqYEA2jCqX1HE6J2Zy+bU/rKztBgV2tbXgEYOy+3y0
	 RvPkZml7s+M+u88HySPw4RVc1nVqGJB/ZyHCuOJ/iYrMtgQiL6Fs0VIA5+PNgLukyJ
	 F/iJFdLCnXIA4O/XcNADnKp2nG8cV9mWwqYgPy0xqxQDIDT5Nx6tXch8lsHc9hwW8S
	 UAHV2bm10zN8DzRTGPpiYFp0R8E2suFrFyv1RH7tA9FG7v/YZ2jcFhsLiYT/Nwg5iL
	 egx3sPx+4I8kZoMc3y2likVcrd+kWWsIqCjO9LMEnsjJgpHlLqxXepTN+lrQXzQNPU
	 WCbql5NIOsSYw==
Date: Fri, 15 May 2026 09:04:00 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
Cc: andersson@kernel.org, konradybcio@kernel.org, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	davem@davemloft.net, neil.armstrong@linaro.org, maarten.lankhorst@linux.intel.com, 
	mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, 
	jikos@kernel.org, bentiss@kernel.org, luzmaximilian@gmail.com, hansg@kernel.org, 
	ilpo.jarvinen@linux.intel.com, Douglas Anderson <dianders@chromium.org>, 
	Jessica Zhang <jesszhan0024@gmail.com>, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v2 2/7] dt-bindings: crypto: Add x1e80100 inline crypto
Message-ID: <20260515-pistachio-mongoose-of-engineering-dcd29f@quoll>
References: <cover.1778822464.git.harrison.vanderbyl@gmail.com>
 <14cd42e3d3af4b2591c9dd8dffde11ef18666751.1778822464.git.harrison.vanderbyl@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <14cd42e3d3af4b2591c9dd8dffde11ef18666751.1778822464.git.harrison.vanderbyl@gmail.com>

On Fri, May 15, 2026 at 03:41:47PM +1000, Harrison Vanderbyl wrote:
> Add compatibility string for the x1e80100/x1p42100
> inline crypto engine.
> 
> Signed-off-by: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>

This was posted, please do not duplicate work.
https://lore.kernel.org/all/eggp3un5ufbw2mjamxmpfccq3cs2luxabpa2sucofydzoak4vg@hy7mx3rtqfko/


Do not attach (thread) your patchsets to some other threads (unrelated
or older versions). This buries them deep in the mailbox and might
interfere with applying entire sets. See also:
https://elixir.bootlin.com/linux/v6.16-rc2/source/Documentation/process/submitting-patches.rst#L830

Best regards,
Krzysztof

