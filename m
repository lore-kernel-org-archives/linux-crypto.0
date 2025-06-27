Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D070378F4B;
	Fri, 27 Jun 2025 21:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751061410; cv=none; b=KoUH9vCjTKdvegzBp1m9SsTOXZcykEmVTu2/7oUlVW9OUDXf3YRwTFDgX2jrFAZJbXe/FTeGWTzT3JO3DgXlZFpoagsJ77yztQFylyAKjFr3Wk4B+Kpv1lqOwqhql4fxd/uRZ3mVSvYXKkqNhkvr3kzud/i87QOpTDPArP92uuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751061410; c=relaxed/simple;
	bh=fJfOTBalcEEWkOC5aarHtfyPRxfrxltOmb+0XGTxoT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gq8Cbba8cWjj2zA2dduaIC5XPoHFVoWreZefeuuAIz0P5WsEf50hd50rEOAKJglAFE6t+zJcEh7lnVWpO01jvalwSUiN0guvXW+QrDX2ftCOaZR4O94DPvANz/XrepcWxaVLTqckTqZrR28z3J6nU8ZphhkV7mcMG1lrJoT14qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YinUy5XG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YinUy5XG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80C4C4CEE3;
	Fri, 27 Jun 2025 21:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751061410;
	bh=fJfOTBalcEEWkOC5aarHtfyPRxfrxltOmb+0XGTxoT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YinUy5XG4xaXy4s80tfAQMQVReqNeMcSIJ2TQzeuo49TLoWOa6IaJiFzCbXddDijS
	 6A0oVg8m+KDmlGTKKGCE4K6CsWcTUYayUZaG44TC6PLvUlGaKCWf/2NfsNtdX0MxN+
	 ac0tPcZWGfupVDtgSaqG0tmFkf2LAF5uh2+8Iu5/v6lbpi3YCvwk2q89oAhPqcoOPn
	 xEjJj2Ny0RHovr8JZMIP4GTC0VtWCDtlVfh828o5m6MtEKqL1YCcNBoIgtzqyCrakB
	 GDQWeFwoklM4hgD/7ADHL2z4G8LfvEKInf1TLF7VF+AL4E8A1BxmEYGFcJTkS41nOj
	 brMDepzUyEtyA==
Date: Fri, 27 Jun 2025 21:56:48 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Joerg Schmidbauer <jschmidb@de.ibm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: s390/sha - Fix uninitialized variable in SHA-1
 and SHA-2
Message-ID: <20250627215648.GA1196803@google.com>
References: <20250627185649.35321-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250627185649.35321-1-ebiggers@kernel.org>

On Fri, Jun 27, 2025 at 11:56:49AM -0700, Eric Biggers wrote:
> This could cause e.g. CPACF_KIMD_SHA_512 | CPACF_KIMD_NIP to be used
> instead of just CPACF_KIMD_NIP.

That should say "instead of just CPACF_KIMD_SHA_512".

- Eric
