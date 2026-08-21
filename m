Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6133330499A;
	Fri, 21 Aug 2026 01:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787277240; cv=none; b=e0xRpI/Afck5D9jW9IZbIWRC6K41yqwadQr8IDuO16NKu27ArCkHkbtXUmLGqU72VK6F+T27rSAZ2C2NJzZVPAgoxWZN/ZI4PSck+yaGD6a0R9CMjbx4+cW47dr0DdFbsfezvmdC7UpWstQI5uzgv8Q5LUGt6AKYXaIkYWBZXqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787277240; c=relaxed/simple;
	bh=Kl6p14KIJN9dIaBMlLZ7Wd2Bl/BYpaayduXoQLMLOSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QKbNwHnGrvASgx+gAkYpBc7hIbyhcfqPvuw2VjwcRQguTE5pB/LMF5DroFNuxgVuQE/r1QqkEtJx1T2HrDfzoffUYkDyt62/u3RgvweBu+rHEra6GpizL0WWzYWpKlDEkPRZzIzTvpBxz91rxYovJC+vv0yBG087hEUJpQnSlpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TEo2f1jL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TEo2f1jL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 733241F000E9;
	Fri, 21 Aug 2026 01:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787277239;
	bh=14U/fs94sVMRvY3XL7S4w40EYcljlaorvl4K4l12ol0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TEo2f1jLuDpAdUwJjDhzgEPxYkp0uHxcAxzgrebksqAgmNYP1w4ab8s8Fvd3FlnoV
	 kIhQLCvwCTg1sWuYspqbG5uCXjn+uXHlRGSWZ5Z0AAUh0T4Jjx2/4LAk5rNBZOP3Aa
	 5LLd+yrbmWq2jO7ul3Y9DCrkhR8i5rllmh4cSW33oWyWKk3Jk7K3X4b1OV+pBt8mcR
	 wc8YqvQZtjGzdWt6r1+oQM/xhFPCtm4DxUFwY0UB2ZZ658dVObqfikk5tJYfpAyuh4
	 9eTgbeaZrZbvGBZOV3UvzXKUqD9uwfIrk32XYfEoWFsWsBjkBBJIYfrF9nx1u5bMsN
	 KBpy90qKtqysg==
Date: Fri, 21 Aug 2026 04:53:55 +0300
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
Message-ID: <aoevs3z1EnTNg2vJ@kernel.org>
References: <20260711160110.267780-1-ross.philipson@gmail.com>
 <20260711160110.267780-11-ross.philipson@gmail.com>
 <alKI9mUBTOCjPbbG@kernel.org>
 <f85782ed-efb3-4045-9d37-2ed4847e1500@app.fastmail.com>
 <aoen10sB5zflLFRw@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoen10sB5zflLFRw@kernel.org>

On Fri, Aug 21, 2026 at 04:20:27AM +0300, Jarkko Sakkinen wrote:
> On Wed, Aug 19, 2026 at 03:50:42PM +0300, Ard Biesheuvel wrote:
> > 
> > 
> > On Sat, 11 Jul 2026, at 21:18, Jarkko Sakkinen wrote:
> > > On Sat, Jul 11, 2026 at 09:01:10AM -0700, Ross Philipson wrote:
> > >> Extract all the functions and definitions for TPM buffer handling
> > >> and separate them into their own header.
> > >> 
> > >> Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
> > >> ---
> > >>  drivers/char/tpm/tpm-buf.c |  3 +-
> > >>  include/linux/tpm.h        | 34 +--------------------
> > >>  include/linux/tpm_buf.h    | 60 ++++++++++++++++++++++++++++++++++++++
> > >>  3 files changed, 63 insertions(+), 34 deletions(-)
> > >>  create mode 100644 include/linux/tpm_buf.h
> > >> 
> > ...
> > >
> > > I would probably ack them all as I've seen these many times and
> > > there's not much anything new. Just waiting for additional
> > > feedback before applying them.
> > >
> > 
> > Will these be going into v7.3 then?
> > 
> > 
> 
> I can piggyback them with to my PR and see what Linus thinks.

Added:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=for-next-tpm

I'll send v7.3 PR once these show up in -next.

BR, Jarkko
