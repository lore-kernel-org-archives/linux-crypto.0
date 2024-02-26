Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A1E12880A;
	Mon, 26 Feb 2024 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708957156; cv=none; b=P1dfYoOq+tOkzuSECf4V4RPzY8vSrlUW7fm7ewGSGm677bTv2MUXal9gdBy28TKcNRUHnLNmsqP81afpACUy7nZzkE/pgsmScrmdhi7B+5LQuGWBm62kubS+K5s9FLLFWdsmqVm61ZuGgkj5xW/UUX5qAhitKw63CqP7x/gIFNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708957156; c=relaxed/simple;
	bh=PVAJUbXl+WR8D1faMaGi1Ysgf3Mnd/Ie+kj5VIe/UII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gHjwoI8xUZFBZ+0iVf0C7jmv3ZnnvNuHoWjWKouWt8+2hAq92M37CZc9b460oUUrtVETNUSFO4VjlfwYagxGN50d55XuWNhXqNJF78kI6Nnw7ykHsv4I9xlaHwCHtfvnQqY597NUwVXdWQtHfIB1E+NYQPlsHf2DYvPsvK7EJBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWfNUk8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWfNUk8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A484FC43394;
	Mon, 26 Feb 2024 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708957156;
	bh=PVAJUbXl+WR8D1faMaGi1Ysgf3Mnd/Ie+kj5VIe/UII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SWfNUk8BwPSS4qdLJ9PsMDzkDLfh40YS2dEWd062VZ/yBuEFXmKLlu9Wz4s7qam96
	 4Aytf1ccQjB3D2bAhYAEslPXqKIgyT866PHcnMuK9JVOhyrSTlgIIzN3/vPPnRtO9W
	 V6MNH8k3tXOPOGLg3ZLca5Vb0QMBibV1j7F8g8Gretnn9yaRlK082i422gNsguJAZu
	 SBpoxnM3Y02MmBCuBLEw+WvWlW8YxQdmzwc0dN4BYuPrCSyKJv9ZGCCaGzzgiG0AZR
	 TPN2Yc6kF0GqEfSwIT+X/RqLbrXm4gmanTSos0ezVgV+LmNRLBaAC3lmF8RIgj1jF3
	 Dxon4YSGaplyQ==
Date: Mon, 26 Feb 2024 19:49:12 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: claudiu.beznea@tuxon.dev, nicolas.ferre@microchip.com,
	dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] MAINTAINERS: Remove T Ambarus from few mchp entries
Message-ID: <Zdyd4LKFA2jsCrjA@matsya>
References: <20240226115225.75675-1-tudor.ambarus@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226115225.75675-1-tudor.ambarus@linaro.org>

On 26-02-24, 13:52, Tudor Ambarus wrote:
> I have been no longer at Microchip for more than a year and I'm no
> longer interested in maintaining these drivers. Let other mchp people
> step up, thus remove myself. Thanks for the nice collaboration everyone!

Acked-by: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
