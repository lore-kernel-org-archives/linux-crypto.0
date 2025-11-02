Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D70F1D555;
	Sun,  2 Nov 2025 12:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762087239; cv=none; b=DAMGuSO1dUyROb64GjLa5JtSiTo+8urEGEr7gFCS+QCOAIOnCB16aeJGWkUQcJw/lEeQJomvg35Q5IvM3YJ28TETUYJ+rb9i9+sxHIi6UGd0vLdk4Z0O0OFJwT7AigNSGImszFhyCjSIybg5K7/rt7OLQMFShZOenbBIv8VSdX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762087239; c=relaxed/simple;
	bh=UiLGkKxUUFQd12okXQW2VCO11UtQ/Tqwtz5NydhJwoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZtDQ8Ajtr1rqSYsfcNmQKRddyzaoCnh5q3KeHWSgcuKVmCQLy+5ji93qz00WmxEtd5J/T2dWFWUmG9iZgCiVRqZsOCQoQOvYSxRZvtl+WgFkzNMjKR6GwdmNw9rlhc1S27sDkeAhONaw+2GMjnIEfKK7AjxDV+uW8R3ktxP7lBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=gSsuL0aJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gSsuL0aJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCEEC4CEF7;
	Sun,  2 Nov 2025 12:40:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gSsuL0aJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1762087236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h9MKNLoYzbnhsIIihKOGhPJkdpll2fUCa9lDyB4xrtA=;
	b=gSsuL0aJfaGRUaPx0rDl30EMfbI3oGZihRaBYHf47O38cp+jVTpQTbGJ7Ib8f+b2zoT+NT
	14DXCFdxKXY+n/FuOi8VqqkV1CedCRa0KZWAzl0A8RgfB9dz7CQgmu1YNx275zB2xQIo+j
	0FxVZ1+sC8Jze7+jfCJHnzscrP6c9rA=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a2971529 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 2 Nov 2025 12:40:36 +0000 (UTC)
Date: Sun, 2 Nov 2025 13:40:33 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: remove unused get_random_var_wait functions
Message-ID: <aQdRQWiOpnt_RGX0@zx2c4.com>
References: <20251102041941.74095-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251102041941.74095-1-ebiggers@kernel.org>

On Sat, Nov 01, 2025 at 09:19:41PM -0700, Eric Biggers wrote:
> None of these functions are used, so remove them.
> 
> This renders the two bugs moot:
> 
> - get_random_u64_wait() used the wrong pointer type, making it provide
>   only 32 bits.
> 
> - The '#undef' directive used the wrong identifier, leaving the helper
>   macro defined.

Applied, thanks. And nice catch.

Jason
