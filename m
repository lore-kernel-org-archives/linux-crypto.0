Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87D7482EF;
	Fri, 27 Dec 2024 09:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735292758; cv=none; b=sTyeq79C0DhhR8b1my3XeG/jPybwC2B/4fLTNk0euYp+Vf4dQtAtxK0b2MwnbgreffVEn7NV9gSRsM8xufD26cn3l/DdN9wamYP8Ud+9dyrd93+4BnPXZRCFbeHgJ8PUEqZD7ICHb18sRtDKZrwQgIOv9Ry+sfXMFZhgI+zgvE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735292758; c=relaxed/simple;
	bh=vHlQQnU+bqVDI4lWkt/oE7heuDIim1iT7qJ2fTbaNbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HyIUxc+34uC4XXtowjUnZY0bjmD8oaXGURZQSkyC5wT1NSoKbinEsBWDtwbmhFk4PqQACZFnZRuN8jb1mFgr5KB4WxdMnlGvC9hFZoFHGwnpZy8wq+2UdS+36jtzmV5EZQd/t1E1eEMGjUIPXM0puWn5EvqbRLNz1ccLglbD8vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.78.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout2.hostsharing.net (Postfix) with ESMTPS id D7E112800C7C2;
	Fri, 27 Dec 2024 10:37:21 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id BBE96533CE1; Fri, 27 Dec 2024 10:37:21 +0100 (CET)
Date: Fri, 27 Dec 2024 10:37:21 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Kurt Borja <kuurtb@gmail.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION][BISECTED] Double energy consumption on idle
Message-ID: <Z251UYBvt5yk4tUB@wunner.de>
References: <aqhq6okzqa56w3x6hb6xvhajs3ce6suxfrycjcmojpbrbosvzt@65sxbbnksphj>
 <Z2vmiUyIcvE8vV0b@wunner.de>
 <75mv5mbkhuimqoof7xoolx5jdebaygiiy2yjgkod3wecbkt3g5@zl5ljugmb26u>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75mv5mbkhuimqoof7xoolx5jdebaygiiy2yjgkod3wecbkt3g5@zl5ljugmb26u>

On Wed, Dec 25, 2024 at 08:48:32AM -0500, Kurt Borja wrote:
> This is indeed the case, 6b34562f0cfe breaks my nvidia module. I didn't
> notice dkms was reporting errors when trying to install it. 
> 
> I'll look into it and report it to NVIDIA or my distro maintainers if
> it's necessary.

There's an issue open on GitHub:
https://github.com/NVIDIA/open-gpu-kernel-modules/issues/746

Nvidia folks commented there that they're already tracking this internally.

Thanks,

Lukas
