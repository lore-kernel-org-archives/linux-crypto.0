Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD4A1C68F;
	Mon,  4 May 2026 14:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777905176; cv=none; b=kiURkDum1ZifHbsBYJPbAgZW6YnJjJcfexL8QgJU2IUF/eIIgFKRI1yJJ8yzmalV24RA6JrG0O4mh13uSPYBZKQ6ge85p8CuXzFDY4ABOTRREuQ0eiToLa5+aM6mDQ6SMv5crzZuBC90/7ucI8qLfCNpexHKpqctvru4VR6gkd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777905176; c=relaxed/simple;
	bh=TnJP/izr7dE1Z7AMSQjNxeTgP5zcgPXsdrR5ISmWgfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZN/PrFbMN0Pw90ememeE0fdOxUd0qWKTEZ7LckZX+6cZoXbGckofpJhYz+8fzYItMl0wDSITatiNFHrDgIYD5ytgcLWEZEK+p+qbjffzeWkF0gPUwYDErazkzUPVF6EpC8qaR0wwX6P5UEFOmSxoMOzMN2JS3OZAETJmoj2A9Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ESgWLJrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ESgWLJrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ABFC2BCB8;
	Mon,  4 May 2026 14:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777905175;
	bh=TnJP/izr7dE1Z7AMSQjNxeTgP5zcgPXsdrR5ISmWgfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ESgWLJrNBP2tcgnLjHKA6WPh1it/zjbFLiXklCc6OJ6PvtmewljilJ/r3o7qrQHqf
	 aXEOowWI+S++pPvwf47/r6U7BZ9qR0OLU+uJ33PceO8v7sveOTPz4zMHTeX9y0/LzA
	 AnjL2ri/YPImcUc5poKdjFyyo1SCa+LY6JbqhKesLDFwWMTOWV01OrysfSZDtxhlao
	 hV/pAcy6pgF/OJmbTJc4I2dusLvEb2EahfrE4PJAkeVqz5NaCTKWOzotZHmSlUkQ0M
	 u1IpCMqPq9TroozxUPJZRXfDFJTanLjDEPkjADcy1b6Dp9Ioia4zvOvWbACN+wWQfX
	 GTSf4SjjjOWvQ==
Date: Mon, 4 May 2026 08:32:53 -0600
From: Tycho Andersen <tycho@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, aik@amd.com, nikunj@amd.com, michael.roth@amd.com
Subject: Re: [RFC v2] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
Message-ID: <afitM-Ub50JsTCHz@tycho.pizza>
References: <20260501152051.17469-1-prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501152051.17469-1-prsampat@amd.com>

On Fri, May 01, 2026 at 11:20:51AM -0400, Pratik R. Sampat wrote:
>   - failed_status (read-only): firmware-reported failure status from the
>     last operation, as returned alongside the status vectors

"from the last operation" is not quite right here, it looks like it
re-runs the STATUS command and reports that error?

> +		failed_status: Read only interface that reports the status of
> +			       the verification operation.

This should probably also note that it runs a fresh operation.

I was trying to think of a nice way to report the status of the last
operation short of caching it, but I didn't come up with anything
good. I don't think it's important enough to cache, the failure codes
right now are all for things that would persist across runs.

Tycho
