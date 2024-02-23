Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A8C125A7
	for <linux-crypto@vger.kernel.org>; Fri, 23 Feb 2024 06:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708668045; cv=none; b=Z4+XsCzjSzQYCpFeu1q0LMnqxEulppMILL9MjbxHm/dnhnGvj60DpqER/WLcVjNIIOE1owmK4DbQ6A+jM/TRA4UAFZaBl/dyv185EkCfiRQ1lK/TDDKS8xEeYViWgQDS1/pZoL3JQS+fd3OwF36XR3JEguYBIWpkkBiPqgezKso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708668045; c=relaxed/simple;
	bh=MVbqms9Wq34Hcxix5HL6lF7A4qEYOuPN7eJTVqses0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uEnwB3u4yWiccf2232OKaNfRUP2TN9jf3lBdFcI+g6bi8e1mzAkpVx/lV1bESP4oqxbrw1k+GzzZZMlojeEIF7TGGHlWcSPd4JrW52mdpL+rkZghPVTcLFcefVmn3eToanO9GbxQJbpvz6JNKCPpujoTKQJXkOqBQD/Ob8tYHMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BtWwvyJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BtWwvyJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E086C433C7;
	Fri, 23 Feb 2024 06:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708668045;
	bh=MVbqms9Wq34Hcxix5HL6lF7A4qEYOuPN7eJTVqses0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BtWwvyJ+kjOGiTlMbKRS5fkgjN1Q6zuZSAD/3gCzaKQwjfFicP1g+Uy8fbJuB8+MM
	 l+hQEgt3Tua1yIb5Eef8QMqW/6Fym2IpZlvb+gtlAlOCjBWjqED5volZrbf61TYMbJ
	 cu8wDFZm5ZUdFoOGdZvreOyb0QNA030gfA2GtTbH1Uh1CiOCjyd5Cn4NPZc2nvC4wN
	 q2xOTEAgC87/j3MZJeut0HIyjlltg58vCr4xHQEex8d+mOb7C5DcqrSEYSjtYBLvdK
	 shrdv04xCdpOjgyjSx1sZP64xvvJAfwGtGs+YJqJC7lZDXvnDZABwooIGR511AOl8O
	 EhO/0XCComM6A==
Date: Thu, 22 Feb 2024 22:00:43 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 06/15] crypto: algif_skcipher - Disallow nonincremental
 algorithms
Message-ID: <20240223060043.GF25631@sol.localdomain>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <a22dc748fdd6b67efb5356fd7855610170da30d9.1707815065.git.herbert@gondor.apana.org.au>
 <20240214225638.GB1638@sol.localdomain>
 <Zc2za7szGC+nxEHM@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc2za7szGC+nxEHM@gondor.apana.org.au>

On Thu, Feb 15, 2024 at 02:47:07PM +0800, Herbert Xu wrote:
> On Wed, Feb 14, 2024 at 02:56:38PM -0800, Eric Biggers wrote:
> >
> > Shouldn't they still be supported if the data is being read/written all at once?
> 
> It is supported, or at least it worked for my libkcapi tests on
> adiantum.  This error only triggers if we enter the code-path that
> splits the operation into two or more (because the user didn't
> write all the data in one go).

Great, that isn't what the commit message says though.

> 
> > Also, ENOSYS isn't really an appropriate error code.  ENOSYS normally means that
> > the system call isn't supported at all.  Maybe use EOPNOTSUPP?
> 
> Within the crypto subsystem ENOSYS means that a particular
> functionality is not supported.  I'm happy to change that but
> that should go into a different patch as there are existing uses
> which are similar (e.g., cloning).

This is a user API; it's not "within the crypto subsystem".  The usual
conventions for system calls apply.

- Eric
