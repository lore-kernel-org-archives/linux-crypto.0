Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96A730EF7D;
	Thu, 26 Mar 2026 21:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774559231; cv=none; b=pMBCs6QCr6AIkb8XJZ+jriK4r3dykynZvk2N3wzDtNV1rdUEikjD9815BwQpzhxKOczHqJHPm+htvcKyZZBG0zowngoOuBkEaP4h5QqMLwMiupabhsALbypLJsjXoSu7O7L3fmjETEJ7/ugd2XgLIJkMqwGsrsZLAyWaxn5xgeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774559231; c=relaxed/simple;
	bh=3svQX6qc5PxiXPOem8MaoHy/6R/4uF3gAu03wT1Xy/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9cEHLA5X/4yIv0DVbNUq8BWLNoxrcAYh772QwTNnIgWdWDC1P5dGZzTRh1Uz6PQ7kzbmD8PPDfjt25CPaZUI13Av1M72oTIaGhHQb+1yw+Frz/oqwVdYzlTbXUWx3WKpvyfsizgWo/W9Lmrdnqdc47EfKbTq3qkcllmU5iOaHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HSiv81Ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSiv81Ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10135C116C6;
	Thu, 26 Mar 2026 21:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774559231;
	bh=3svQX6qc5PxiXPOem8MaoHy/6R/4uF3gAu03wT1Xy/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HSiv81UiNCklEtRboUIrwAGIULMazqPbXTV3+7tNmC9ltD1NgwlFAYSfOYM4a3JyT
	 cct4VZcREbG986HX1a3GA/9Nrgq9/uB+Va0XPxw4w2dN2/MoBj9RDwu1OI735b+Eb3
	 jg7LyKwCH9hvFNLzMveIrAtDnlyJ2KS1H5HGM3VvwebP/af+q9+qA+YoJN1OOwg7X0
	 zs0M5aoV4wYQZ/LHvUyWfizxw2YfFqvfFUc/cIEfh5KiNdJeTyqj1Wmjd9VqH3S0ZH
	 Ld9b2KfIKpqFbpoNGgvmPqXniaRADDbViBhqwbNoE1IYEi077BqdxOBj0aTVueBm1q
	 v1gKLFqFRRdzw==
Date: Thu, 26 Mar 2026 14:07:09 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: Re: [PATCH 0/3] crypto: Remove arch-optimized des and des3_ede code
Message-ID: <20260326210709.GB2657@quark>
References: <20260326201246.57544-1-ebiggers@kernel.org>
 <0982d4341f58e2f1181bc472dc9c9d8542148e3c.camel@physik.fu-berlin.de>
 <20260326202733.GA2657@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326202733.GA2657@quark>

On Thu, Mar 26, 2026 at 01:27:33PM -0700, Eric Biggers wrote:
> On Thu, Mar 26, 2026 at 09:20:51PM +0100, John Paul Adrian Glaubitz wrote:
> > On Thu, 2026-03-26 at 13:12 -0700, Eric Biggers wrote:
> > > DES and 3DES are cryptographically obsolete and insecure by modern
> > > standards.  Continuing to maintain highly specific, complex assembly and
> > > glue code for them, especially when the code isn't testable in QEMU
> > > (s390 and sparc), is unnecessary and risky.
> > 
> > We're working on getting crypto instructions added to QEMU though.
> > 
> > Adrian
> 
> In general that's good of course, but DES and 3DES?  Really?  Why is
> effort going into these obsolete algorithms at all?
> 
> - Eric

I would suggest focusing your efforts on more modern algorithms, like
AES (which has its own SPARC instructions and code), and not worrying
about DES and 3DES.  It's just not worth it anymore.  Note that I'm
proposing dropping the x86 DES and 3DES code as well.

- Eric
