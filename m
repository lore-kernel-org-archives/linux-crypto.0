Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9583E299927;
	Thu, 30 Jul 2026 01:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785375431; cv=none; b=UxvSREkkq6UEzIwreW5vmfAQxqu6Q7GXDjRFSVjq/x/jPZqDt4ak6ydLuQCLPuiGEeg5/zFKsp46n1eMvCoNz9JhZ/NX5YaKwsulbSNMHOdJefmNNIMdY+Vo+h+RF+PZ5Z9PH3Kub3/ssJcC+dEf6xPV3cXdl4JzBxwyy4b3NPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785375431; c=relaxed/simple;
	bh=dzfwZEMorp3rwc8GLzOEGrJDWlEkp+50HSLBhi1DLVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MUmaeUjZmt8jaEOE2Z9LMKiscPtXnPH8GKNqzR48+3V3vPqbif6Tcub1hPD2U3JikpDtrg4fa5imsbh+eJNeGktAIkqjvtocv6ZoEKp0uk3cuzwvNSTCktk07+yWnQcYC1WmH97szgZhTnSEtNf4eTEAofOLDg8yOAtFtex3W2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msHaxw4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msHaxw4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDBF1F000E9;
	Thu, 30 Jul 2026 01:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785375430;
	bh=Zq3CZ7IZhoO5PtDVC80BskmA8VGPxrBAbm/2ceBWPYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=msHaxw4asxse1Upwl11ZJz6zKOzEACiEjjb/x6CLKYgZlOk8Ohxqiuhq/P329/qfT
	 zo+pl3iZtG47G0Wqvk2I8jYDNn5wXcrdNydrqCDDfcjfnZoNw43E+468hLeUaK/l7L
	 wJVASXf/7298QuhP60XtAUkNSL/TA75lKq+UcmbfGGqbcBrnlVq9Di3LJMPdT86mOm
	 PLSjF+CIa+7b921kOkvlCMermS4YipCuge6cR37hO3G8+DQZjwsZa5Gj++0ADKPDm9
	 UscuCtoxg/X3X+9m08+n9dVAR5SMN5URu2nzRdvTEoNa9JpQr2kEbc8gSuI4YPJTuZ
	 zI5dKHNqegrtA==
Date: Wed, 29 Jul 2026 18:37:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Carlos =?iso-8859-1?Q?L=F3pez?= <clopez@suse.de>,
	Alexey Kardashevskiy <aik@amd.com>
Subject: Re: [PATCH 0/3] Remove old AES-GCM library
Message-ID: <20260730013708.GA91995@quark>
References: <20260722025338.33354-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722025338.33354-1-ebiggers@kernel.org>

On Tue, Jul 21, 2026 at 07:53:35PM -0700, Eric Biggers wrote:
> The old AES-GCM library code is being replaced as part of an overhaul
> that is adding support for all the common AES encryption modes with
> consistent conventions
> (https://lore.kernel.org/linux-crypto/20260715221153.246410-1-ebiggers@kernel.org/).
> 
> The SEV code is the only user of the old API.  Update it to use the new
> API instead.  Then remove the old API.
> 
> This applies to libcrypto-next.  If possible I'd like to take this
> through libcrypto-next for 7.3.  Acks are appreciated.

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
