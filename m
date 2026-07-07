Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EFE42087C;
	Tue,  7 Jul 2026 23:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783466215; cv=none; b=fXcIpBANk6bcCz0XCtUjGin9okbuwYgOYvAlFXNuw645pVsuTE5yrLRFvKYhqZ9N2re3ZCJPoAiDHA3HGYP0xEyKbik4WmW+L/YIuD3UxpdbvRxPp6tywgG0p7OdR/MX5jnWd0j5mdyRV2fy61AofT6FYoYnmgJAwSf1UpNRTJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783466215; c=relaxed/simple;
	bh=wthU+LDSXxv0cmhMsmKWTUc9MccmOLfsHSJemEijgTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nD6um1/hxgGBg3EiZaBaDfX2qHihj5BvVe/bTxQUJCkfY6xeBNW90kPfvEbbB4Qd2CF+0m45G9/Rxev6g3hfPOnIOb3QusgQSQ9pWPvcxmQcedsseqZhM6jbIr4y46Ix67v473R+sXrYANC9Kx9oAjJmNg+wLlrBUz2kgLFXvVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIjTl0Qr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIjTl0Qr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6771F000E9;
	Tue,  7 Jul 2026 23:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783466214;
	bh=ouySJp4PTPWTHvPnwqW1vIzSFsOuSkVDaiPP8I2u+Vs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SIjTl0QrH4C0s1T74xhE5e/8Rr6gDKqmjLlMcb4R86o1GsPDhfQsBaUmYsGATDhaS
	 lkEtUScBjlunSUluNClKqQRAusX6J3CCqz9sTRnd1DjPtVaCrWdWhayLyIJ/BvIghB
	 ORnhILsTpz7f3DKOOOLoBPnzvAD/MWpFn7fuyD/IDUHt3RSMHcI/aKFZBU1Yg7KvqK
	 vQQkEPal5M/HHPfXfY2bcq/xI8K5hoiEpEsaRYa/oJavIkT+l+XPXnJ8Qssxu1edTW
	 /m5LVcbB2QRCbk23xOg+eI4XEdfk1gNTZjXrN5AlAHm+WwUbH0rm5w1CaDtkIfwuR3
	 1F0D9kwmF8mYA==
Date: Tue, 7 Jul 2026 23:16:52 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH 29/33] bpf: crypto: Use AES-CBC and AES-ECB libraries
Message-ID: <20260707231652.GA2264445@google.com>
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-30-ebiggers@kernel.org>
 <10eafa42-1142-4ed2-a485-f46c496bddfb@linux.dev>
 <20260707182049.GA2238@quark>
 <d1cdfc23-b336-49a9-8833-29f05b5b9fec@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1cdfc23-b336-49a9-8833-29f05b5b9fec@linux.dev>

On Tue, Jul 07, 2026 at 11:50:33PM +0100, Vadim Fedorenko wrote:
> > Does this mean the AES-ECB support is unnecessary and can be dropped?
> 
> Let's keep it if it doesn't hurt.

It kind of does.  It is "bad" crypto that would have to continue to be
maintained, and someone might start using it accidentally.

- Eric
