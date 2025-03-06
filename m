Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131F626E16F;
	Thu,  6 Mar 2025 17:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741281751; cv=none; b=WbFUrGL783yIozMSLvMv2XiumHYLhkyl2ElW36iSMdygGvPZWkzXkHrtwm56uxUCJyxci5yz2MwfqvbwquvS0vXmpgihwZCJQecJcKeihdt5pXbYfQxl4f9E5paUIOotroe/Ta5yQ6OQg89FHeD23lM4DkNHtAnDnhMHPXibrbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741281751; c=relaxed/simple;
	bh=AFTey6kcvQB+x5Xt78k6oINdM05Fyq/dhsy9nPs8fjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZT2YVfHqMPMP7xtvpARlFhyaNMXVyOH+SJyl+8aWFT728QE1HbX4UkBpQbtHhNVz19Mv7tf/ALB5ihWI0IexT+wXhVAoiIRZFrGLxGCb4xU8Kpvj6Epd0H1Yjd2Fw/r9x0xctIGuYtCYDAUdd+yBz2mB2om9kB8DrBEwjStA+94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ei7dTjmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ei7dTjmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A652C4CEE9;
	Thu,  6 Mar 2025 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741281750;
	bh=AFTey6kcvQB+x5Xt78k6oINdM05Fyq/dhsy9nPs8fjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ei7dTjmFkCvE0Q4Ml0hfAFyt2v+GxaHWGhhOlIE7DhD3B9nf07OCSUi0y14JCDil6
	 TI0VyF3zVuUXRYGIJhQK6elgj/pUFlXDI4daZHsdPsBhxAjWI/U44WUe6brQnc9/DG
	 kT7dZ3tLsBj9uKJ2qcJ8PEvA/wUlaub+vUqUiAm9fsmaabLkzBfZJfv8kum3y88mps
	 wmCcDkII1ohft2J9T5DBr1MhzB6wp+xL8aTPpApQgHj69BrE6TeCjLJi7/mX2d+1kv
	 S6XLQH3cWFWeIas5qHHqb0cjd1D7DTw+eC6AT2KYTW1TDW9rB/RB6O7njz6YLTCU1o
	 3YlomU48iPxsw==
Date: Thu, 6 Mar 2025 09:22:28 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 0/5] Remove unnecessary prompts for CRC library (batch 1)
Message-ID: <20250306172228.GE1796@sol.localdomain>
References: <20250304230712.167600-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304230712.167600-1-ebiggers@kernel.org>

On Tue, Mar 04, 2025 at 03:07:07PM -0800, Eric Biggers wrote:
> Library functions are already selected when they are needed, so there is
> no need to ask users whether to enable them or not.  This patchset fixes
> this for the first batch of CRC library options.
> 
> There will be a batch 2 later to handle the rest.
> 
> Eric Biggers (5):
>   lib/crc: remove unnecessary prompt for CONFIG_CRC4
>   lib/crc: remove unnecessary prompt for CONFIG_CRC7
>   lib/crc: remove unnecessary prompt for CONFIG_CRC8
>   lib/crc: remove unnecessary prompt for CONFIG_LIBCRC32C
>   lib/crc: remove unnecessary prompt for CONFIG_CRC64
> 

Applied to
https://web.git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
