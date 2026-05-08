Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371CE36F419;
	Fri,  8 May 2026 18:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778265615; cv=none; b=HpmoS7uKb+xJKlcWLr4EhuArqtwOyXChky/XXSO+eRajeX8Jo+6wJ3pMnn7+OIefyTGWJW6u2o/wBTA1RkkfnxXLaHxG2ZZyR/k97nKADj+HdqTABsmIfYASMjXbAjUF/7TBrjZmCYg9hNF5+ceVukpgHwANEEV9PtH1E/r8eyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778265615; c=relaxed/simple;
	bh=QvLiaJYAHrTdQGvAEo4QzMnHOMDZrTiNrZZC2IJ18Io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FLcEnJ/UhUMmZPy1QkIAngDMyDs3HlK8fYkAPDVuVMDfsJ9N/6By5LMeBsi8YJv+OHgO1pG4pPkLUKraa4+XGw+hrtKk4a7l/cTR6OMYaucbHtws9pBkr51KcNn5YEf4DbTDox2QDO2PQ0gOEb9U8lxH3eOyjXanw/tFy7/aNLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M3t3p3//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M3t3p3//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F89BC2BCB0;
	Fri,  8 May 2026 18:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778265614;
	bh=QvLiaJYAHrTdQGvAEo4QzMnHOMDZrTiNrZZC2IJ18Io=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M3t3p3//NV3BhSZMRx4r2YwJFYl+nPyzxb729C4kXJ4I7me8SdZISNIQUwzBYbhEW
	 YJaY0PSdSJ8Yl48EPxcNIvrU9yaXTSF76ra/jY3UmI3KMYDh6XzChEIh7ogSH+oMmm
	 LOLOrDO8KLUeEn1eYxTCb3vofmhL+QQCoy9abI8HnUkuOm+i8Shh1ob76ACZ8csryv
	 TTfSNUpiDCf3MjFsh+4AZ+o5uNwSVjjm26omt6Krts7dxHJaUTg1CsWsf/n1tWZUxV
	 7BpAxdFEEmUkuXczdxPzkXFSLHjozqoJAh1cNxqYKtwO+49pB0vlswU8PJbHlz71CL
	 BvvG/M52X7DwA==
Date: Fri, 8 May 2026 18:40:13 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: use designated initializers for report structs
Message-ID: <20260508184013.GB4145640@google.com>
References: <20260508105717.472043-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508105717.472043-3-thorsten.blum@linux.dev>

On Fri, May 08, 2026 at 12:57:17PM +0200, Thorsten Blum wrote:
> Use designated initializers for the report structs instead of clearing
> the struct with memset() and then copying fixed strings with strscpy()
> at runtime.
> 
> This keeps the structs zero-initialized, lets the compiler diagnose
> oversized string literals, and makes the code easier to read.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Did you verify that none of these structs contain any implicit padding?

- Eric
