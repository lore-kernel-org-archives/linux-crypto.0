Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37F84C33D4;
	Mon,  5 Oct 2026 15:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791213615; cv=none; b=R1COrHqZ/I4HmgY/cY5/zltP0TRiBDp1efC+1gibQzxliAcJPTD32KKpRnE0dFRjTT37NiGzt64yLPAi5TYrVCha809b3IH7tAvP2mUIoSWjk9vAaCwjdnPD99oh9GCXOfN2DVzD4cq9h5Z4wuj0dsyRxDSPWuFgyC864R8+wvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791213615; c=relaxed/simple;
	bh=SN2sjLeMzBi8JN8bUuyl7I3IvXWKUMYwkIku8HlMDto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MWXvJd5UKkMEv4HBp3WWEGdz2c5c3XwD8c/7SkWHjPIan1o0pFOEFlFmuMUcJbfm8KlZLCX3yihDbtJZ4sKJxDQqgbhbrbvwJolr/B+Usk4q9bkgNI8aDBi790P9Kyf+BjM6Cx4NHz4AFywueesHnLdd4YMTYki0cxeYs3VU/j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z7KT+SBa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z7KT+SBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718051F000FF;
	Mon,  5 Oct 2026 15:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791213614;
	bh=K0qXB4vAC4gf948mH+PomxjxrvQPIzaFQRjZjWTfvBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z7KT+SBa7Q2uRegoGeAf13j2H8h0b9xwgDGgSg1So7OvloE0NrqWD332U73H7Ux3j
	 ozjR41YVjvoNEZbUys07/Yobon0APVhtGuLqIM7xFoFHVDxyOCPol7coqhq63nW/8X
	 wmh1ioqAA0ErMek7BlKc6L7dopBcJPnAfjQhwXd7pIZTwleuFEfq4SdSpTAi8LgC8g
	 DzYeR7BCNK4XYzU59uwplUMvDCdQrTVR8aYa4kDSJzYgkM7LBp4lXcWHKc3bZlP68L
	 qUIpchF4sFxFTXb0/wvluP152ZBI0uc/0QIBd70A8WVaXhOKmswl5+y/VAzdRVrxFc
	 zECCOMeNHzc7A==
Date: Mon, 5 Oct 2026 17:20:08 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: ardb@kernel.org, Jason@zx2c4.com, skhan@linuxfoundation.org,
	me@brighamcampbell.com, jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] lib/crypto: chacha20poly1305: zeroize state in
 __chacha20poly1305_decrypt
Message-ID: <20261005152008.GC3436@quark>
References: <20261005150324.5621-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005150324.5621-1-raizudeen.kerneldev@gmail.com>

On Mon, Oct 05, 2026 at 08:33:24PM +0530, Mohamad Raizudeen wrote:
> The `__chacha20poly1305_decrypt` function does not zeroize the chacha
> state, unlike its encrypt counterpart. The regular
> `chacha20poly1305_decrypt` function handles this by manually calling
> chacha_zeroize_state(). However, `xchacha20poly1305_decrypt` returns
> the result directly without clearing the state, leaving the derived
> chacha20 subkey on the stack.
> 
> Because this function is EXPORT_SYMBOL()ed, this is an ABI robustness
> improvement. To ensure consistent and safe cleanup for any future
> callers, move the chacha_zeroize_state() call into
> `__chacha20poly1305_decrypt()` itself, so the helper cleans up after its
> own state just like `__chacha20poly1305_encrypt()` does.
> 
> Additionally, moved the src_len check to the callers so the state is not
> initialized on invalid inputs, matching the logic in
> chacha20poly1305_crypt_sg_inplace().
> 
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
> Changes in v3:
> - Remove Fixes and Cc: stable tags, as this is an ABI robustness
>   improvement rather than a fix.
> - Move the src_len check to the callers so the state is not initialized
>   on invalid inputs.
> - Fix whitespace and ordering of the chacha_zeroize_state() to match
>   chacha20poly1305_crypt_sg_inplace().

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
