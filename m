Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249513BE155;
	Fri, 21 Aug 2026 08:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787302335; cv=none; b=AQ7dgRIN6afN2NV8XRXgOuuG2y9y6RB1EowPLx9yfB6N54sPdl/mGLq9YMKYZW885og7bf0L+9EkVvO/voD1Xeo2rC9PUHbrnhI6813bjW22uK0BvgjlD3/ieJd/cv31TBmWLAHo/Gtg05h4TaRJOyrniZjtKbE1w4Jq0eJpGJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787302335; c=relaxed/simple;
	bh=0kYolRfjhfBL7Kcx86cYGYpBiaWwgF97poYMRwYFUA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N1l+qedl70qpZu3mJHe49ctGogfCw60Oynv//tjtJswYvQrwztefF4xS4DuUuJoSwlpUPNgOZMeCMVu3a99PUm6takM3y+AjUKiBQadCQokRxPOzIJ0IvGx+WeDXabB61rL2Pp9oMmkMxTWJ7HXNu1FT9wMn37vcGp5RRTpszoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWC4oHmz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWC4oHmz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4BCCB1F00A3A;
	Fri, 21 Aug 2026 08:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787302333;
	bh=XoHUqrSeOP/PVEAYqp4D6liGUEiEi36cwId27AAG5sI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EWC4oHmzR5Su8pEEdQ1fxgybBz2JMe+f/cmQDUKK1KZP84f3jUojRiPb1IPlPpVZD
	 DE2yiMUSuE9M/Sa1zSOHoE0jHzvx5Jy0dYJQZUU2DKdCxjm5jqK9y21k4JqvfD3rc/
	 ZUmDDfB+XSl2jmOaZhC3eY3XrrN6YHbwnaVz70YTOHc5+es4lPr1+1y+XMW9u0wlke
	 +ETiS1Z+BRKBxZ7cfENqt+Qmfjan6eFrAQ93lPoywHO0kFEGnBY3qu5aCrw9f+9eeK
	 bBI/gavUCZiryO6cf7kprPJy5YSFbQJw69KwubrkORIAoLf9Wua9+qcX7o+rlEkukh
	 /PqM3tGma7odA==
Date: Fri, 21 Aug 2026 11:52:09 +0300
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
Message-ID: <aogRuZJhIZblfUXw@kernel.org>
References: <20260711160110.267780-1-ross.philipson@gmail.com>
 <20260711160110.267780-11-ross.philipson@gmail.com>
 <alKI9mUBTOCjPbbG@kernel.org>
 <f85782ed-efb3-4045-9d37-2ed4847e1500@app.fastmail.com>
 <aoen10sB5zflLFRw@kernel.org>
 <aoevs3z1EnTNg2vJ@kernel.org>
 <d853a1aa-49b6-46ae-87e6-62ec038c648a@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d853a1aa-49b6-46ae-87e6-62ec038c648a@app.fastmail.com>

On Fri, Aug 21, 2026 at 09:31:23AM +0300, Ard Biesheuvel wrote:
> 
> On Fri, 21 Aug 2026, at 04:53, Jarkko Sakkinen wrote:
> > On Fri, Aug 21, 2026 at 04:20:27AM +0300, Jarkko Sakkinen wrote:
> >> On Wed, Aug 19, 2026 at 03:50:42PM +0300, Ard Biesheuvel wrote:
> >> > 
> >> > 
> >> > On Sat, 11 Jul 2026, at 21:18, Jarkko Sakkinen wrote:
> >> > > On Sat, Jul 11, 2026 at 09:01:10AM -0700, Ross Philipson wrote:
> >> > >> Extract all the functions and definitions for TPM buffer handling
> >> > >> and separate them into their own header.
> >> > >> 
> >> > >> Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
> >> > >> ---
> >> > >>  drivers/char/tpm/tpm-buf.c |  3 +-
> >> > >>  include/linux/tpm.h        | 34 +--------------------
> >> > >>  include/linux/tpm_buf.h    | 60 ++++++++++++++++++++++++++++++++++++++
> >> > >>  3 files changed, 63 insertions(+), 34 deletions(-)
> >> > >>  create mode 100644 include/linux/tpm_buf.h
> >> > >> 
> >> > ...
> >> > >
> >> > > I would probably ack them all as I've seen these many times and
> >> > > there's not much anything new. Just waiting for additional
> >> > > feedback before applying them.
> >> > >
> >> > 
> >> > Will these be going into v7.3 then?
> >> > 
> >> > 
> >> 
> >> I can piggyback them with to my PR and see what Linus thinks.
> >
> > Added:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=for-next-tpm
> >
> > I'll send v7.3 PR once these show up in -next.
> >
> 
> Thanks Jarkko

Seriously: thank you. Had a blank spot and I would have failed
this with 100% certainty otherwise.

BR, Jarkko
