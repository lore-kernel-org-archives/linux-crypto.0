Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58983330D25;
	Fri, 21 Aug 2026 01:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787275232; cv=none; b=S6ripbcYR1UJNNtx5chMC9NdaNYjQCJNNeRb9MXZlKg04Q6Rg+S8qUwfDKjxzhP5W8sIIkHGcSWojky0TkmL6CjWdeAxRfXUrg/mJFa7cuM0h8c9uD0Dbqo8DunItbWMPoJ93BXBOR9kDepR1B91qQnWe5LyvG/3bjLfb6INILM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787275232; c=relaxed/simple;
	bh=Tyc9xvTio0v6Z4WuF62UIJtZ90pdoGGzafGUhqEO2V0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m2gmMD0JsID1yFnr3m4YhONAzRn1ytbm5r0RKV4t3JepJFq9YoUfgNoRxt0l8lQ0ZUM/AO51DQoe20PzWAKSOuTg0EOZe59FbYhNa8VGhEKMMrd548aiU9P5BvUEGWYT6R3Q21ZF3L5jNHhJGrWR3O5bB2wXfW4/91Mzxf+eS3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iO6uyp1i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iO6uyp1i"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 871E61F000E9;
	Fri, 21 Aug 2026 01:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787275227;
	bh=CiKh4CxYC2laF+imBxYpz0FBf3Ank6thUDKWKVrQS14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iO6uyp1i6+dhb7CBqosQ0fDCHtNbLkeUaUA4ug10PyzWx0yPRYORo9Y4oP7427jaw
	 eQPiGMnTpgI7+UcQGYTDqhAK7PrRsUkK0r/yGU9GQ2dTV3VZ2CJeGXw2CHAee9kcCX
	 R8hCRQiMm7bFsK4J83aWikzlz5zkgw4Hl3bi0n1Ol6StfwNKuxXGmPoBE67S6PmdYB
	 D+5snVDyn7magYyg/nRgqXyPB7vXaMZCw0QlNEpOi8CdGood4kVs09nfvlSapaut4n
	 FTKAd1PPuLrffKU7IH5l3fdz2Dw17wfviFarlP5jeqqCgBhZrIDha0+BgjnLZL6+ne
	 FAPBNAYC7BOcQ==
Date: Fri, 21 Aug 2026 04:20:23 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ross Philipson <ross.philipson@gmail.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-integrity@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-efi@vger.kernel.org,
	"Daniel P. Smith" <dpsmith@apertussolutions.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>, dave.hansen@linux.intel.com,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	peterhuewe@gmx.de, Andy Lutomirski <luto@amacapital.net>,
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	Jonathan Corbet <corbet@lwn.net>, kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com, Andrew Cooper <andrew.cooper3@citrix.com>,
	trenchboot-devel@googlegroups.com
Subject: Re: [PATCH v2 10/10] tpm-buf: Add TPM buffer support header for
 standalone reuse
Message-ID: <aoen10sB5zflLFRw@kernel.org>
References: <20260711160110.267780-1-ross.philipson@gmail.com>
 <20260711160110.267780-11-ross.philipson@gmail.com>
 <alKI9mUBTOCjPbbG@kernel.org>
 <f85782ed-efb3-4045-9d37-2ed4847e1500@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f85782ed-efb3-4045-9d37-2ed4847e1500@app.fastmail.com>

On Wed, Aug 19, 2026 at 03:50:42PM +0300, Ard Biesheuvel wrote:
> 
> 
> On Sat, 11 Jul 2026, at 21:18, Jarkko Sakkinen wrote:
> > On Sat, Jul 11, 2026 at 09:01:10AM -0700, Ross Philipson wrote:
> >> Extract all the functions and definitions for TPM buffer handling
> >> and separate them into their own header.
> >> 
> >> Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
> >> ---
> >>  drivers/char/tpm/tpm-buf.c |  3 +-
> >>  include/linux/tpm.h        | 34 +--------------------
> >>  include/linux/tpm_buf.h    | 60 ++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 63 insertions(+), 34 deletions(-)
> >>  create mode 100644 include/linux/tpm_buf.h
> >> 
> ...
> >
> > I would probably ack them all as I've seen these many times and
> > there's not much anything new. Just waiting for additional
> > feedback before applying them.
> >
> 
> Will these be going into v7.3 then?
> 
> 

I can piggyback them with to my PR and see what Linus thinks.

BR, Jarkko
