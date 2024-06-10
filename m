Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8016045BEF;
	Mon, 10 Jun 2024 16:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718037913; cv=none; b=Ygzuv3NXprlh4GYo3SARXmywPzk2t9Jc5ohNxV0icddwBWKXga7xDHS1Fy1maVNosvVjEt/4lQZLLt1CxDbgufejz6UaLwWbelpZkR5OIr8Iur9UPJ6I1UpXCMyqtW+GDBPI81gLzRNRT/wbjOZUCYuzEAobXolHkZLf4lbvhp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718037913; c=relaxed/simple;
	bh=YbTVYfWqHva2fHaRAJd5/DNFJYZQDoMyf688OiN6Rmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LAdN+oOAvKvT8ra7TBNB0g67+BNvFOLAlYDXoySeFXYzanP0//tIBYL1HAD193xBYJM4gF/dMWKLYmG+vCDVfrTC3sG46474sI/mgWbCVcpyN8BA17dRyE0ddRExgor9WsB7MbkvBhfdP6F2EjyhYf/cn8kp6danEbeh8KBz9C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YYi6b6B7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYi6b6B7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18993C2BBFC;
	Mon, 10 Jun 2024 16:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718037913;
	bh=YbTVYfWqHva2fHaRAJd5/DNFJYZQDoMyf688OiN6Rmw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YYi6b6B7CTzb1pvoPdhJyHYdV/3cmh6PZJZnWQMtfrnKCeMbFk3HbxvuTZ/KA5nHY
	 p2oN33V969wdCO5XB26PtotyTDOkfDwgfRDk/cE5xjyWsBAFll07z7G4UfW9D9+8D3
	 Trad5oK+8Wa9rGKXITvM9psIYr+elLeBwOswKErJGc4UMO51zeiVBRJiVbJlzo48HT
	 lc9Gh+x4k31U8zgLenwxIiBZGk0GFQq1PTMoqi8JnpeIXjWRm4Oxjkcj16ej9JIXeJ
	 hwG/ul0ZbOOm2UbPSzxvO9HM8aoR2uWpdGF/rU/k/5S6UihHsxrFMKX5W8DlKXH7Ez
	 /SFPPcY+zv0aw==
Date: Mon, 10 Jun 2024 09:45:12 -0700
From: Kees Cook <kees@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-hardening@vger.kernel.org,
	herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] crypto: arm/crc32 - add kCFI annotations to asm routines
Message-ID: <202406100945.599B5267@keescook>
References: <20240610152638.2755370-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610152638.2755370-2-ardb+git@google.com>

On Mon, Jun 10, 2024 at 05:26:39PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The crc32/crc32c implementations using the scalar CRC32 instructions are
> accessed via indirect calls, and so they must be annotated with type ids
> in order to execute correctly when kCFI is enabled.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
