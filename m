Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D095420EB;
	Mon, 20 May 2024 16:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716221770; cv=none; b=dNYP8MC0TmhhyEa10TIKOjNCf1Z4TgvWT5rFG3ldoGrcyTzFZ+OyZ7G/J2JxcYCaHzf52XnjtSq2glEBBZP9S9ClIW7ly8CGYorIp0b52k+WZOsY4SU6hupCOcSfJGaZWYjVzav5SdiRxQZMxDnwW7z0GTfvwR6aUnJV1XQdG2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716221770; c=relaxed/simple;
	bh=SttX/DO61CoJnVDpAsUBeGqr9cNviZAdiv65U5Z6Mic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OVnYtaD7DCS23pZlmo75nOzZS5NMcPis+jqYYzDiqyOvQmnw3BL9Qb6GcZ2+ZNTmbN04KmThDohUybcKAJpaTFJ9M8F3hDkSrCeYC5RLjgxaDQHIs3yT0XGnsVyIcStgzPtTg6akWcO1ISD28TnHoHG+ACIPAz8alwWGnmLRgDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDnsWQoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDnsWQoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40658C2BD10;
	Mon, 20 May 2024 16:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716221769;
	bh=SttX/DO61CoJnVDpAsUBeGqr9cNviZAdiv65U5Z6Mic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IDnsWQoQQ9pI5xxfjIze/9eiBVEuAxiVVokXjSXPdrC9hLx3ZCtdebL/h63WRZB1t
	 IjLZNINCDleziVR0x4FYZtBHkWc+DndCkd8q6oWxDPRq1esV6jYQiSlXTgJ6lcrsd3
	 k5eJd8GqBJl76w04o194vvPdKlLs8KCS1z7E40swePmJWfiILLDrmJzYGIza4avazy
	 GMjEc+tyRgyypWHfWOC6bj1JWjNW7raDymRhsMy3UHP/5A5nb2AkqkXt2iBD+kvfUT
	 d//sAPDBEIa8PfsoPRESedloYgQ3Clnw1pC7cnS3tm1mKTBOCFK6//vrcjaeAYj0aV
	 M59bcSFQUfH8A==
Date: Mon, 20 May 2024 09:16:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2] crypto: x86/aes-gcm - add VAES and AVX512 / AVX10
 optimized AES-GCM
Message-ID: <20240520161607.GA1269@sol.localdomain>
References: <20240512073124.53568-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240512073124.53568-1-ebiggers@kernel.org>

On Sun, May 12, 2024 at 12:31:24AM -0700, Eric Biggers wrote:
> Table 3: VAES-based AES-256-GCM encryption throughput in MB/s,
>          implementation name vs. message length in bytes:
> 
>                      | 16384 |  4096 |  4095 |  1420 |   512 |   500 |
> ---------------------+-------+-------+-------+-------+-------+-------+
> This implementation  | 13139 | 12070 | 11466 |  8999 |  6949 |  6048 |
> AVX512_Intel_OpenSSL | 12927 | 11499 | 10976 |  8375 |  5386 |  5853 |
> AVX512_Intel_Linux   | 12656 | 11263 | 10779 |  7958 |  5592 |  5029 |
> AVX512_Cloudflare    | 11120 | 10186 | 10075 |  4856 |  4919 |  4786 |
> 
>                      |   300 |   200 |    64 |    63 |    16 |
> ---------------------+-------+-------+-------+-------+-------+
> This implementation  |  4709 |  3512 |  1787 |  1765 |   714 |
> AVX512_Intel_OpenSSL |  4157 |  4071 |  2493 |  2132 |  1042 |
> AVX512_Intel_Linux   |  3535 |  2686 |  1416 |  1203 |   572 |
> AVX512_Cloudflare    |  3062 |  1110 |  1042 |  1028 |   169 |
> 

Note, some of the AVX512_Cloudflare numbers were slightly off, and I've fixed
this in v3.  v3 also includes another small optimization.

- Eric
