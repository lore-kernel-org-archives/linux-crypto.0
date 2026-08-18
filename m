Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EBE3A7F58;
	Tue, 18 Aug 2026 08:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787042086; cv=none; b=KnjYh65gNGfla/RjEz0KZnibTyuxTvP6BgrXqdM3MQ7fPZ/BUz3iauSI7+SD1tUQQXE//KIvt3Ts6e5XDEcIve5To0Fiby20kc4T0R1nrpybzyByLn5X3uSv19+Q+3ciHm9Vu+rFsw3aUvi5LhLvoKhNLJY1ob7u+djHcGpMbHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787042086; c=relaxed/simple;
	bh=/SHpumL8XnflaWHkrgNgFNLrVp22DGpsDzVl5tqwsAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T/bAYsfWYsMnWX/wNV5sOsJcKtexCVgCpV2Cqnl5yAT29Ou27EGJ3W3Zxm/ftTQh6CFQypGF85Sna7nMLQmzM5uOO0nxDY108VVV7IK0NSKu58CP8RON06R9hql37GTXqHGHo6+z5hgkGHZsGWwyTgvFfbKP/P0yNAKG6NGnGW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rjw03WU7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rjw03WU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9119D1F000E9;
	Tue, 18 Aug 2026 08:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787042084;
	bh=z2NRw7oXuFmGkhvpIk4m83GsNqHGQw4DU5RTD7L/qQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rjw03WU7p695jmXcQvyAV6U4Ki4VLPqVn3wQCkOQjpsIFaGxZ+5EAAT6q5Myu6Min
	 SGpSIun+feYWvNia1lgQsYW6iaJL7pIdaY332FT/NvSGpoGkmzF4CRZLaG4OWAq5g5
	 OXrKlnJCOMgRMbX4tiDbxMdga+BJM+z/VlEaiZjRWL7umT23hNfhKYO7i6D3NMBwqX
	 96mhKskviVSMd3BqkqXBctUiNP2xeqY3hS/URtRIP8MwZPSkuFRq9apuE3yrpo0nF+
	 ETqIBYNDbjqxdmtJ5+/itHKsRbpLZVqn67K5mf47PObzbnwsamTF4XMKKE5boA8sdH
	 z9UV4vjpUTYDA==
Received: from johan by xi.lan with local (Exim 4.99.4)
	(envelope-from <johan@kernel.org>)
	id 1wwFHO-00000000nUc-19Vj;
	Tue, 18 Aug 2026 10:34:42 +0200
Date: Tue, 18 Aug 2026 10:34:42 +0200
From: Johan Hovold <johan@kernel.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Mark A. Greer" <mgreer@animalcreek.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: omap-aes: fix autosuspend cleanup during teardown
Message-ID: <aoQZIqPofaVmOk7M@hovoldconsulting.com>
References: <20260808083612.2698779-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808083612.2698779-1-lgs201920130244@gmail.com>

On Sat, Aug 08, 2026 at 04:36:12PM +0800, Guangshuo Li wrote:
> omap_aes_probe() calls pm_runtime_use_autosuspend(), but neither the
> probe failure path nor omap_aes_remove() calls the matching
> pm_runtime_dont_use_autosuspend() before disabling runtime PM.
> 
> If the autosuspend delay is set to a negative value while autosuspend
> is enabled, the runtime PM core increments usage_count to prevent
> runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> during teardown, this reference is not dropped and usage_count remains
> unbalanced.

As I've explained elsewhere, this is just misleading. There is no usage
count leak here as the count is balanced whenever the user re-enables
autosuspend through sysfs (by writing a non-negative timeout).

Drivers should clean up after themselves and disable autosuspend, but
this is more of a clean up than a fix and should not be backported.

You've sent upwards of 60 of these in the matter of a just a few days,
some of which have even been picked up. Please send follow-ups (replies
or v2s) as soon as possible to prevent further of these from getting
merged.

> Add the missing pm_runtime_dont_use_autosuspend() calls to both the
> probe failure and remove paths before disabling runtime PM.
> 
> This issue was found by manual code inspection.
> 
> Fixes: 5946c4a5e770 ("crypto: omap-aes - Convert to use pm_runtime API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>

Johan
