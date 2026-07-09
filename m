Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F541AA780;
	Thu,  9 Jul 2026 14:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783607258; cv=none; b=Wvn315z10cWYCxvQ4APGyNe4KzXoTml1qEQ8g+BEmh3/7vfP/kfBcvwfKLvfJG/nvQ6WZz9UEms6v87LcvJdqS4e/h0Ci1VOwG7cJId+J+4Fb0o6nbDA8XSFBfbnacXE686ilU9iyo0kSZA6VArH7XWrCrk/I/NaRvQ4DeINuwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783607258; c=relaxed/simple;
	bh=XgcPfTh9E+25t08NFhk2qKYKRxiIW0zesYLtJEAOtbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oegZJXKmee4QrL7s+Y0VRVBVEVFdx4lJLxGJh1rGzejxsd7JeQNXat6T8P8jYYTTpJjbc5wBmwRbRWL7QGx4LMoZJpEGC23xJ9iCKvkp52616aB5J4QThyY9DwvL1HEBFSCdNHeFg/mXYW8tb0mkfik99hQN+/tvLFY26IfA30w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBQ9t4F5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBQ9t4F5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771231F000E9;
	Thu,  9 Jul 2026 14:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783607256;
	bh=XgcPfTh9E+25t08NFhk2qKYKRxiIW0zesYLtJEAOtbM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VBQ9t4F5pEbEKNt60Qv669QNKzVt19DHjVXQ2NGngjPPwbXT+MvCi4SzoQQRNIL0z
	 fBRxw5nAIF6blJ1hLGvRL+VbpPPa2rN9bew0Mywug3kLzU3rkjbp4uqSIQNBEfTWAA
	 GrSMu7LrrjxkYYoaNI85a7OQLIRM5Ce52TDnwpSo=
Date: Thu, 9 Jul 2026 16:27:33 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Goetz Goerisch <ggoerisch@gmail.com>
Cc: herbert@gondor.apana.org.au, herve.codina@bootlin.com,
	linux-crypto@vger.kernel.org, miquel.raynal@bootlin.com,
	paul.louvel@bootlin.com, sashal@kernel.org, stable@vger.kernel.org,
	thomas.petazzoni@bootlin.com
Subject: Re: [PATCH 1/5] Revert "crypto: talitos - rename first/last to
 first_desc/last_desc"
Message-ID: <2026070912-pluck-bagful-2a71@gregkh>
References: <2026052212-aged-amply-7bd8@gregkh>
 <20260523151048.14914-1-ggoerisch@gmail.com>
 <20260523151048.14914-2-ggoerisch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523151048.14914-2-ggoerisch@gmail.com>

On Sat, May 23, 2026 at 05:10:44PM +0200, Goetz Goerisch wrote:
> This reverts commit a866e2b1c65edaee2e1bb1024ee2c761ced335f8.
> ---

We need a reason for a revert, AND a signed off-by line :(

Please fix that up for the other revert in this series and resend.

thanks,

greg k-h
