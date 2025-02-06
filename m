Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F4519F130;
	Thu,  6 Feb 2025 20:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738872526; cv=none; b=EHy/757XtyfJpOqsvIErDO5W9FZnIQ0dN/e/iuhU3trejDctSupGZitj0Gs5ea+Ft7BEvS4jjYQCpKmmlbZX8g6HjflcNvlZ5Vbq3LeTt+Pn9MjXP/KZqH6cA2chytcmTVvV8J6vGe+AIG/KRaUYjXF+nINIhnONRPgHgiTn0f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738872526; c=relaxed/simple;
	bh=u/QIXJeop5o5I8El11vS3bzPXtpJvCeLgqhra0aH0m8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YTNMPH390Q4ivdCyKQlJRAg/ixo0J8n52k1Sls/h0steM5aIk7Av6mQ50aNN1CksTtQ4Ow2wJbSFbHc2bPHmj6S6Eye28VEfDyq/+TRb4VDN4NN5M8vuBO+UzVJEtAdl/Zmq94clEX+Uvqr9cS+khg2MQN7Os8kEIvlelW342yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L6338piQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L6338piQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D256DC4CEDD;
	Thu,  6 Feb 2025 20:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738872525;
	bh=u/QIXJeop5o5I8El11vS3bzPXtpJvCeLgqhra0aH0m8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L6338piQodTpgNu8A0idKJTWqs8a2vUUNSK0BqtXXv2pj/8zcqx7mixUHqWmnmbSk
	 ltFopAjL8QFm9oruDT0zTVGEP7bHQ3o8/nVsWurzs63Ga8SqNopS7kB2rCWHTogzKz
	 tEwZIuulqg7ffzRLwARV4M7cUGHZeOOQjRxaDZkPBpesN8mw9k9TvdvK7hqygj19JR
	 3XRRkwaiIkwsAWq9Pdczs0UCKhcbUhQ/KFv3qgnYHjNlFIpKV+B0KYG6T1/9UGUSI8
	 LwwY9o2Y8HxgrMiLRE6zGMuUGYslx17UR3uFtMatDGgZUb1feg9G7n2HHuSiP38K3c
	 fxdjo5VATVa6w==
Date: Thu, 6 Feb 2025 12:08:43 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org, linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 2/6] scripts/gen-crc-consts: add gen-crc-consts.py
Message-ID: <20250206200843.GA1237@sol.localdomain>
References: <20250206073948.181792-1-ebiggers@kernel.org>
 <20250206073948.181792-3-ebiggers@kernel.org>
 <20250206193117.7a9a463c@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206193117.7a9a463c@pumpkin>

On Thu, Feb 06, 2025 at 07:31:17PM +0000, David Laight wrote:
> On Wed,  5 Feb 2025 23:39:44 -0800
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add a Python script that generates constants for computing the given CRC
> > variant(s) using x86's pclmulqdq or vpclmulqdq instructions.
> > 
> > This is specifically tuned for x86's crc-pclmul-template.S.  However,
> > other architectures with a 64x64 => 128-bit carryless multiplication
> > instruction should be able to use the generated constants too.  (Some
> > tweaks may be warranted based on the exact instructions available on
> > each arch, so the script may grow an arch argument in the future.)
> > 
> > The script also supports generating the tables needed for table-based
> > CRC computation.  Thus, it can also be used to reproduce the tables like
> > t10_dif_crc_table[] and crc16_table[] that are currently hardcoded in
> > the source with no generation script explicitly documented.
> > 
> > Python is used rather than C since it enables implementing the CRC math
> > in the simplest way possible, using arbitrary precision integers.  The
> > outputs of this script are intended to be checked into the repo, so
> > Python will continue to not be required to build the kernel, and the
> > script has been optimized for simplicity rather than performance.
> 
> It might be better to output #defines that just contain array
> initialisers rather than the definition of the actual array itself.
> 
> Then any code that wants the values can include the header and
> just use the constant data it wants to initialise its own array.
> 
> 	David

The pclmul constants use structs, not arrays.  Maybe you are asking for the
script to only generate the struct initializers?  This suggestion seems a bit
more complicated than just having everything in one place.  It would allow
putting the struct definitions in the CRC-variant-specific files while keeping
the struct initializers all in one file, so __maybe_unused would no longer need
to be used on the definitions.  But the actual result would be the same, just
achieved in what seems like a slightly more difficult way.

- Eric
