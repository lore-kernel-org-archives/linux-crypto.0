Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F022417EF;
	Thu,  6 Feb 2025 23:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738885262; cv=none; b=t3bkU7rp/uM2M7uqKwMybMrI3seLYUYzd3rlGX67KlpxORzCeDf46RoseblE8vls7sb3/a6Lu1+ni0VNsJ1wMvK7fy7DSkGBX53Ad4YU4G54Ue2fGYGiEMWVJLpA/IZ5Dz8mv4lZcdhtJY2j1JXPyQv6Hj1butg3WPHFBuFzYzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738885262; c=relaxed/simple;
	bh=ltfuyNhdWl4e6tB5cb6tu2xTiV8jlDxP3SA4YXI2rB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EpJx42QWRkC3m2F8KrTDqsHIbcgm7ErcfMIMXgRCCQpgrsRGzuiWhJxUZcyj67bk/p5l3m64SNOtP2l5muJw1v/m7g5ZsG9jPXB6mw5H/lr8WspzKj3wnQh6WBBtbC3kqVdX4Z9CVQNOBN9XFZAbNJ2/KT2yhujKE76PuY9/hcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDaePLSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDaePLSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E074C4CEDD;
	Thu,  6 Feb 2025 23:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738885261;
	bh=ltfuyNhdWl4e6tB5cb6tu2xTiV8jlDxP3SA4YXI2rB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WDaePLSCpEQGbwjYg5BcVXYGsSsqnSwD/FLaD4TPnbNxAzAq3V6+JzmNx1scaVeRb
	 eD2FQ+9Q6P/vqvZ+lUHYQwxLs32klrcltQDjzfLGV9k1QrRS3EdxmZAzsBA41Fx0V4
	 9Gb68oJ9bP3UV+H0x49PIGlqNYRKiCSOEn9S+ozTLS85/QD9Xe1JksIrVQax2mfBoN
	 gsI1sKi2Mw+cF3MAwDtRj1HHXG9fUIcsDZDTJnV19JqoorndeJ5eAyh6GkRHIKdOgP
	 sEiSjznzcjWM07BYCy4mZJWo4uXWBdfFkV49kpXwswbPtMxpB9TqNhGz0wgg44c+xX
	 lbqtfSn5wR61g==
Date: Thu, 6 Feb 2025 23:41:00 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org, linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 2/6] scripts/gen-crc-consts: add gen-crc-consts.py
Message-ID: <20250206234100.GA2582574@google.com>
References: <20250206073948.181792-1-ebiggers@kernel.org>
 <20250206073948.181792-3-ebiggers@kernel.org>
 <20250206193117.7a9a463c@pumpkin>
 <20250206200843.GA1237@sol.localdomain>
 <20250206222853.1f9d11c3@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206222853.1f9d11c3@pumpkin>

On Thu, Feb 06, 2025 at 10:28:53PM +0000, David Laight wrote:
> On Thu, 6 Feb 2025 12:08:43 -0800
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > On Thu, Feb 06, 2025 at 07:31:17PM +0000, David Laight wrote:
> > > On Wed,  5 Feb 2025 23:39:44 -0800
> > > Eric Biggers <ebiggers@kernel.org> wrote:
> > >   
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > Add a Python script that generates constants for computing the given CRC
> > > > variant(s) using x86's pclmulqdq or vpclmulqdq instructions.
> > > > 
> > > > This is specifically tuned for x86's crc-pclmul-template.S.  However,
> > > > other architectures with a 64x64 => 128-bit carryless multiplication
> > > > instruction should be able to use the generated constants too.  (Some
> > > > tweaks may be warranted based on the exact instructions available on
> > > > each arch, so the script may grow an arch argument in the future.)
> > > > 
> > > > The script also supports generating the tables needed for table-based
> > > > CRC computation.  Thus, it can also be used to reproduce the tables like
> > > > t10_dif_crc_table[] and crc16_table[] that are currently hardcoded in
> > > > the source with no generation script explicitly documented.
> > > > 
> > > > Python is used rather than C since it enables implementing the CRC math
> > > > in the simplest way possible, using arbitrary precision integers.  The
> > > > outputs of this script are intended to be checked into the repo, so
> > > > Python will continue to not be required to build the kernel, and the
> > > > script has been optimized for simplicity rather than performance.  
> > > 
> > > It might be better to output #defines that just contain array
> > > initialisers rather than the definition of the actual array itself.
> > > 
> > > Then any code that wants the values can include the header and
> > > just use the constant data it wants to initialise its own array.
> > > 
> > > 	David  
> > 
> > The pclmul constants use structs, not arrays.  Maybe you are asking for the
> > script to only generate the struct initializers?
> 
> I'd not read the python that closely.
> 
> > This suggestion seems a bit more complicated than just having everything in one place.
> 
> It'll be in several places anyway since the python file is only going
> to generate the lookup tables.
> 
> > It would allow
> > putting the struct definitions in the CRC-variant-specific files while keeping
> > the struct initializers all in one file, so __maybe_unused would no longer need
> > to be used on the definitions.  But the actual result would be the same, just
> > achieved in what seems like a slightly more difficult way.
> 
> It would leave the variable declarations in the file that used them - making
> it easier to see what they are.
> It also gives the option of minor changes in the variable name/attributes
> which might be useful at some point (or some architecture).
> 
> I've got some similar tables for a normal byte-lookup crc16 (hdlc).
> And for doing the hdlc bit-stuffing and flag/abort detection on
> a byte-by-byte basis
> The whole lot is 11k - quite a lot of memory inside an fpga!
> I started with the 'header' containing the initialised data, but
> later changed it to just #define for the initialiser - worked better
> that way.

Again, for now gen-crc-consts.py is only used for generating the structs of
constants used by the x86 pclmul code.  They are indeed all in one header file.
They all need the same declarations and attributes, and it is convenient to
generate them all at once, and name and document them in a consistent way.
Please take a closer look at the patchset (if you are interested), as it's not
entirely clear what you're attempting to comment on exactly.

gen-crc-consts.py does also have support for generating slice-by-N tables, which
it seems is what you may be attempting to comment on, but that is not currently
used for real.  It just seemed convenient to include, since it is just ~20 extra
lines in the script, and it is sufficient to reproduce any of the existing CRC
tables that are hardcoded in the kernel, and the table for any new CRC variant
that might get added in the future.  If we decide to start using that part "for
real", we could always tweak the exact formatting of the tables a bit if needed.

- Eric
