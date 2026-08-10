Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2F03769E9;
	Mon, 10 Aug 2026 10:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786357488; cv=none; b=m+TFQB0gba+jDrf3ls0Z0WdA6dUocthsL5WWv0pyytuDsH/ZTM8IENr/zxehIq+TnagP5PwbvcylNgO1cJ2jGstUHd9XHdd+bpySz+CdrgygOnJ8oyuYYS4sQppPt2YI9YZ98hI9tC2oe0of51WTLzDrijl9eK77D7lYMOpzuSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786357488; c=relaxed/simple;
	bh=WazNDq4Z8LqvQHL2gXnm4xgXylJmDc+ma+/Exk0iOlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9dzoQnBtNq+bDKV6Ifnhj4dCkW4QpEdLTTekR+EB59hvmVGrryMHcvZ0XmhrefGyXRPE8dIlFcjOwv3JphWSRjC+IdqblKx0Yy2al/T6ox5QPcbJF+r5eLSe4TNwgbzyaP7j6nHi8bsBu36UNAKeKVf8+TTe3siZLSbVbBjHJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=etsQ8MNT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="etsQ8MNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDB11F000E9;
	Mon, 10 Aug 2026 10:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786357486;
	bh=WazNDq4Z8LqvQHL2gXnm4xgXylJmDc+ma+/Exk0iOlw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=etsQ8MNTgwheodsLfdo2mfhxmVDM75H1cROYhRtJN4P0P4I2HAYJ/gLkhJ6/1cYco
	 L9WpSdAeUqRPAe0F7BU6qz0KZYSpE+4k90++6fZdBK8WOXvd0b75jHz+KwTEsoEuNo
	 NatQDbeqWLOHDX51PXKlk9TzrBARzGnoS8RSqnG/NshgLIe0J4iNsj7+Ga8rf5QB1k
	 GEE6sKadlwvITmV8FY0YBi/4PmAF6ULDeXChDCuY783HihtyemCzE4dCxUCjUzh5D2
	 h0uKcLaCyigjSrTF20EoeX4mkLvRFIVg7EQTi4azwjashAagMlSRJj/K4640Ll9fzb
	 PI9fySMY3Lu4g==
Date: Mon, 10 Aug 2026 11:24:41 +0100
From: Daniel Thompson <danielt@kernel.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Linus Walleij <linusw@kernel.org>, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] hwrng: stm32: fix usage_count leak when
 autosuspend_delay is negative
Message-ID: <anmm6X4MLpyIH8K1@aspen.lan>
References: <20260808074510.2655473-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808074510.2655473-1-lgs201920130244@gmail.com>

On Sat, Aug 08, 2026 at 03:45:10PM +0800, Guangshuo Li wrote:
> stm32_rng_probe() calls pm_runtime_use_autosuspend(), but neither the
> probe failure path nor stm32_rng_remove() calls the matching
> pm_runtime_dont_use_autosuspend() before disabling runtime PM.
>
> If the autosuspend delay is set to a negative value while autosuspend
> is enabled, the runtime PM core increments usage_count to prevent
> runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> during teardown, this reference is not dropped and usage_count remains
> unbalanced.

If calls to pm_runtime_use_autosuspend() must be paired with
pm_runtime_dont_use_autosuspend() then I wonder if having a
devm_pm_runtime_use_autosuspend() would be worthwhile?

That way stm32_rng_remove() could be entirely replaced with devres
cleanup.


Daniel.
