Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D94A8BEE;
	Wed,  7 Feb 2024 00:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707266846; cv=none; b=ZSrz6DYHRz/7HAF71IXARsnYz4gmY6ouCJk+69NY7PjxJYd/FDNhRgzgRwvgUUk9gBGD4Tu59DoecMtgKp7GhiTtMwMgA4WT/cu2o7DHlmByO9U2agqPMiQkmMfrR2jgdeLbi0yMWzm6sBxC432O1ZgPguAHdo4iJgmlA14QZMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707266846; c=relaxed/simple;
	bh=iqHxgOHuYFmk9YND73eU0cO+vCD/4trx3LeVLF6gEa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hQptI/RFkt8HvpVIdpv3n7rwFvNcCiiW8k0GgrNIhAhmpY/2tbOQfFOlFOGHst7p0ZlhWKiF+PvxMkGch5wbmgRWgh01L+sU+rhB0HhI+0y6QUtzdTJXroiweWxqg00ujJsaMhZ3VHbVZbkVznOEzkzdMsEGCKWFYak0/bpi6yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IgWpcCRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IgWpcCRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAB3C433F1;
	Wed,  7 Feb 2024 00:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707266845;
	bh=iqHxgOHuYFmk9YND73eU0cO+vCD/4trx3LeVLF6gEa0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IgWpcCRLQhkVQtpOkfg/qGEI4J2qtrzW0bdMNunzjROZxeOQ/OD3+soNK+E6gYd6V
	 NU+KW9AHJGg1GSKDukeeoGxEHzefuUZ7ejTpVSPSkucR9/05xrfbrXlsDHXG4xbYCx
	 ZVW8RelbRk88iiGisT8knwuJi4RAOLMpTnABx8vG5xP/o3Hh5ww+zoz6QcvPTFSkuo
	 CGnhSXiEgbdTNom7SBTZN2W2ro54td1SSjbBsLgxOZ0V9cdPi0mMds+dC4FnoB85eu
	 uY6S39REIprg28NgBMrfSbGz5GO/aCy4affm1JBCUHGgrXAGRy4DJ8tfTrOfAaeT9X
	 wKpaEKwOcKN/A==
Date: Tue, 6 Feb 2024 16:47:23 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: A question about modifying the buffer under authenticated
 encryption
Message-ID: <20240207004723.GA35324@sol.localdomain>
References: <f22dae2c-9cac-a63-fff-3b0b7305be6@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f22dae2c-9cac-a63-fff-3b0b7305be6@redhat.com>

On Tue, Feb 06, 2024 at 10:46:59PM +0100, Mikulas Patocka wrote:
> Hi
> 
> I'm trying to fix some problems in dm-crypt that it may report 
> authentication failures when the user reads data with O_DIRECT and 
> modifies the read buffer while it is being read.
> 
> I'd like to ask you:
> 
> 1. If the authenticated encryption encrypts a message, reading from 
>    buffer1 and writing to buffer2 - and buffer1 changes while reading from 
>    it - is it possible that it generates invalid authentication tag?
> 
> 2. If the authenticated encryption decrypts a message, reading from 
>    buffer1 and writing to buffer2 - and buffer2 changes while writing to 
>    it - is is possible that it reports authentication tag mismatch?
> 

Yes, both scenarios are possible.  But it depends on the AEAD algorithm and how
it happens to be implemented, and on whether the data overlaps or not.

This is very much a "don't do that" sort of thing.

- Eric
