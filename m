Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DC53164D9;
	Wed, 31 Dec 2025 09:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767172508; cv=none; b=l9FQ+xvTN3odbkGkih7eR8TKQviLFgQpuS5VA+ChVUceMgfuEzD7tTPN03AQBSW2x5MFd+rcv2mcZlRwSUx0pzHAcj83P30ZRcYmUrPyqj/YnTvvK53TNyCf+O4UeAfSUShBzhhG6fl/IGwucCH88brwNyyBZbhBru/WbMlW8L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767172508; c=relaxed/simple;
	bh=uZmzez1T6S0fBcGIezUGYNQA09lX0Gmu4FE7Smv2TMQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=YJ4P1u0QWpwDou88Hpt2N3oqz7at6ep9SrnoA6riPDnHhNM0ebgY26mn5ZSFWyQBr7fmUQ4cFV+ef95vMGLSIIpVHCa+97wuE50pvxCzVvBlK2m901Tc93BhLcU9b+YlosV1aFFjF5ee3tBC6ircarOib5FEXZukdzsiKm6etsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=OIph+V/F; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="OIph+V/F"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 5621A1A255D;
	Wed, 31 Dec 2025 09:15:04 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 206C260744;
	Wed, 31 Dec 2025 09:15:04 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 05415113B0755;
	Wed, 31 Dec 2025 10:14:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1767172502; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=0063sSsioo5ahiIjYE6TqPfIYj5Bo6k+tEWffoXGQJI=;
	b=OIph+V/F3Y1bjGywnpWRPDI58cuEHLeLvz2ZmVj8NSw63tGOtIhdMHPT7+ENbrF26Akrde
	vHDGQYv5Y9heKah/Wka3akEjYl+2T3YiyuTXXn9ZI219Qn30s8WpFtUeXFftiCiZd2fyJ0
	G7MgbXFxkgWHBo7mIPHWNeYuAxO32DXuQd56wrMKhUPxdONPhT1qo6YFIrpaR13WEW1bbg
	Tjpe1k9KC1rQZx+3aPMbXd1ZuFk6+lbGJ5F3CIxPkF/Tu9QuUx5D6ggvH8G419uEd//NYy
	iMq4ta1KdagYePHUS2kmz0G/GSK0SWABA7ZZ9JT2G7NYZFAYV+g9Fwczpn9BEw==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 31 Dec 2025 10:14:59 +0100
Message-Id: <DFCADAUEQ81L.MTQZKYR0C33S@bootlin.com>
Subject: Re: [PATCH 2/2] host1x: Convert to bus methods
Cc: <linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
 <linux-media@vger.kernel.org>, <linux-staging@lists.linux.dev>
To: =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>, "Akhil
 R" <akhilrajeev@nvidia.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, "Thierry Reding"
 <thierry.reding@gmail.com>, "Jonathan Hunter" <jonathanh@nvidia.com>,
 "Mikko Perttunen" <mperttunen@nvidia.com>, "David Airlie"
 <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>, "Sowjanya
 Komatineni" <skomatineni@nvidia.com>, "Mauro Carvalho Chehab"
 <mchehab@kernel.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
From: "Luca Ceresoli" <luca.ceresoli@bootlin.com>
X-Mailer: aerc 0.20.1
References: <cover.1765355236.git.u.kleine-koenig@baylibre.com>
 <dd55d034c68953268ea416aa5c13e41b158fcbb4.1765355236.git.u.kleine-koenig@baylibre.com>
In-Reply-To: <dd55d034c68953268ea416aa5c13e41b158fcbb4.1765355236.git.u.kleine-koenig@baylibre.com>
X-Last-TLS-Session-Version: TLSv1.3

On Wed Dec 10, 2025 at 9:31 AM CET, Uwe Kleine-K=C3=B6nig wrote:
> The callbacks .probe(), .remove() and .shutdown() for device_drivers
> should go away. So migrate to bus methods. There are two differences
> that need addressing:
>
>  - The bus remove callback returns void while the driver remove callback
>    returns int (the actual value is ignored by the core).
>  - The bus shutdown callback is also called for unbound devices, so an
>    additional check for dev->driver !=3D NULL is needed.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>

Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com> # tegra20 tegra-video
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>

--
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
