Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDC421E094;
	Sat, 28 Jun 2025 06:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751091148; cv=none; b=RLFrjY5EkoFEoRfXkCwyo0jOPRj0jQfN1OcYzgYDHMSjeMLL5aaZ8wLotYKVPvsA8b1IXk1yjf6R8xFbBAt0bPDFIq5NNdE7QmIYZTVnYiLVn6sJB3tRy1zFmML5Z7aZboYMhvk6Xc+ngt8fhlci2TtYcgxN3B5DEYM/ippXdh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751091148; c=relaxed/simple;
	bh=I0UnKnIOyFdO9he0tI/KBTUY7OwNtgUXnIsI8XHGyG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ukN9HWXYVplGLaw+kU9cIY2XtiWMqvAzGJKfz5ufWWpX14IYDzU0Q82mhUGIiPfvmHI1A6rsDHZ870gFhGj+++ZtH/hf0hXisoDNN83+7pjuY4pnYOKLuUmDouuY6KvQt6V6BmUCasySo6yIqI+bGRLfNLjwstLRdauC6NXXpI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6G8U7g9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6G8U7g9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECC7C4CEEA;
	Sat, 28 Jun 2025 06:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751091147;
	bh=I0UnKnIOyFdO9he0tI/KBTUY7OwNtgUXnIsI8XHGyG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=w6G8U7g97Ko1jhzaJ+VhIJVUcU9OmVyxNMdcyx38BmI2IkjXeTigE2bO335CUBf6T
	 DLBy8/GvkRzD+5/CoeT2Z2ImFk95mX3dKijZkNuBV2xHeHhAwjElU410WqrD349tG6
	 u7vxVZPZ00wanBbft8roT7Tq1yxHr2y7BgGMIACQ=
Date: Sat, 28 Jun 2025 07:12:25 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jay Wang <wanjay@amazon.com>
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Override drivers/char/random only after FIPS-mode
 RNGs become available
Message-ID: <2025062806-strife-anger-2867@gregkh>
References: <20250628042918.32253-1-wanjay@amazon.com>
 <20250628042918.32253-3-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250628042918.32253-3-wanjay@amazon.com>

On Sat, Jun 28, 2025 at 04:29:18AM +0000, Jay Wang wrote:
> This commit fixes a timing issue introduced in the previous commit
> "crypto: rng - Override drivers/char/random in FIPS mode" where the crypto RNG
> was attempting to override the drivers/char/random interface before the default
> RNG became available. The previous implementation would immediately register the
> external RNG during module initialization, which could fail if the default RNG
> wasn't ready.

Why isn't this just part of the previous commit so that there is no
regression anywhere?

thanks,

greg k-h
