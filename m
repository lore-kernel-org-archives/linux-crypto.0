Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C48318EDA;
	Sun, 25 Jan 2026 14:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769350794; cv=none; b=ZW0zQzqYkS5zZefWHlnCRBHj51b0TVaCcA3L7atLsCkbMRdZYnsoZvkHpbWvMM5+TpEA55p0lXonYipoV5pONGdybnKj0B8952kPgwNaDB2JosBRr9SgJZNroFRCbbHB7mq+jvcanV1OruBUeYj49vdUQo5icPpTb1vqZ2OLEfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769350794; c=relaxed/simple;
	bh=lacQGfY3ibEcNWz+KMn2ccI0cfr2Mr2bB4+KEIEeirA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiLLp4xK7yhdI/mfMruQTASQqyNw2MBrGPzjbmJJlWNA61l2dKy+6edASGuKP+DsfduxZ9Co1Tmj7WFGcrwGVlnMvzM5v6fAZxNy6npM01OMz1AdZqKyFf1EJgbhUUAzWD9An7GB4sc47rTZ7ddOcoiLUshHQOCvHm4m99HDiSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E7I0lk7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7I0lk7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD5CC4CEF1;
	Sun, 25 Jan 2026 14:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769350794;
	bh=lacQGfY3ibEcNWz+KMn2ccI0cfr2Mr2bB4+KEIEeirA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E7I0lk7owZnUxg6PSgfpSpY4cn7YN5EMD+AZ8KXWskmuktsdOimUItWuUZIx8hqqR
	 3IDymSjfFUZ+thTqMxrHGRVmdQGUGVd0woIqMIXRzZq7MCwMyCgpQ369p/0AV8905Q
	 xhbJWmrTBzv6C0dmETBjfiZxLTtdhduSOZmP5Ub4cnNZzjcKFnjtWp4z25RmAxqziv
	 xKerpWSifJYOPDcyTvrsuYlsrgskKuFDqIvo1xhnldGJj3xWrGeunBV4wx3UgM8UpZ
	 hsnJK1q9WR1fbDi8zbA7uh7cKVIkGgAunO//65bqknqtaNVA7VdVcKEOjTv1YAQd0G
	 tFW1/A1KEia1A==
Date: Sun, 25 Jan 2026 16:19:49 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	keyrings@vger.kernel.org, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v12 06/10] crypto: Add supplementary info param to
 asymmetric key signature verification
Message-ID: <aXYmhZdVtvilYMHg@kernel.org>
References: <20260115215100.312611-1-dhowells@redhat.com>
 <20260115215100.312611-7-dhowells@redhat.com>
 <20260120220321.GA6191@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120220321.GA6191@quark>

On Tue, Jan 20, 2026 at 02:03:21PM -0800, Eric Biggers wrote:
> On Thu, Jan 15, 2026 at 09:50:48PM +0000, David Howells wrote:
> > Add a supplementary information parameter to the asymmetric key signature
> > verification API, in particular crypto_sig_verify() and sig_alg::verify.
> > This takes the form of a printable string containing of key=val elements.
> 
> As I'm sure you're aware, C has native support for function parameters.
> No need to serialize to a string on the caller side and then deserialize
> in the callee.
> 
> This is yet another example of a case where trying to fit different
> algorithms into a generic API doesn't work well.
> 
> We should just have a library API for each signature algorithm, with
> each algorithm taking the parameters it needs.

This would be a great idea IMHO. I'm looking into renewing my TPM2
asymmetric keys patch set some day, and e.g., for that such primitives
would be more ergonomic fit.

> 
> - Eric

BR, Jarkko
