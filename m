Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E76933F394;
	Mon, 13 Jul 2026 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783963808; cv=none; b=RDqggmIf/b1cU4CIgpOg3aL8WJf7lu7UxJA9U6Tm1MzGTTolR1zxjQzZ6istVsGpuAKuOA7Ex2E41Vq1l4unS+Hi/whSYBr/ZWkEOod9F3daYLHd7NTKbe1dPDEptPj5vF1fLS1DnP6x4Nvm04YU7BZ+/seflY/02rxEyl90e1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783963808; c=relaxed/simple;
	bh=nCBADfPl5UsjVCRyiNTCceL+P86FRzL33UOwfs8iADs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emyvNi+gBVdQ2x4xxX8Tcud1VZDrlxSgG5GZKZXatFCpD9Bm+Q2kNkfsBTU4ouwzxTaGfJa4hppVlsyoP7pb7Me2KW66wTO7x0qGCpDk/pW6rwtT3MduvHBFV2JXd94zPA4WVtnKgxmlxHKxiFUrmecPhbVknKQfUm1aGCn3Si8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQpHgpa6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQpHgpa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F4D1F000E9;
	Mon, 13 Jul 2026 17:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783963807;
	bh=N/4PU6ql3rOySt5KicKXIt7AV1IpkBb2vzqjVBjyUR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SQpHgpa6Bddqrt5e4wZBV5qUJS3Mhqs53xW1KXK4/OcQaWxYSrlffGG0+7RJ7Ff5P
	 Ilr/w47ByeZ1JoKIacFgU18uOHaDmXxfIFNJ2cipARFf8egODA7qnw8Yts2sakC5TK
	 esMNDaPE4rdcf/jk1JKik1hAZ/Kq1yhOKl+zjMl0=
Date: Mon, 13 Jul 2026 17:31:08 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
Message-ID: <2026071320-encode-modify-6193@gregkh>
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <2026071312-uncover-refining-8cac@gregkh>
 <20260713130745.GA2254@quark>
 <bd5821b9-7459-4db4-86ef-bd67fb645753@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd5821b9-7459-4db4-86ef-bd67fb645753@gmail.com>

On Mon, Jul 13, 2026 at 10:42:04AM -0400, Demi Marie Obenour wrote:
> On 7/13/26 09:07, Eric Biggers wrote:
> > On Mon, Jul 13, 2026 at 06:47:07AM +0200, Greg KH wrote:
> >> On Sun, Jul 12, 2026 at 05:31:31PM -0400, Demi Marie Obenour via B4 Relay wrote:
> >>> From: Demi Marie Obenour <demiobenour@gmail.com>
> >>>
> >>> This driver is harmful:
> >>>
> >>> - It is much slower than the CPU [1] [2].
> >>> - It Has a history of bugs [2] [3].
> >>> - It does not have exclusive access to the hardware [4], causing races
> >>>   with the secure world.
> >>> - It register its implementations with too low a cra_priority for them
> >>>   to be actually used [5].
> >>>
> >>> Therefore, disable it to ensure that nobody builds it into kernels they
> >>> intend to ship.
> >>>
> >>> In the future, the driver will be used for processing restricted media
> >>> content.  However, the kernel does not currently support this.  Since
> >>> the driver will have future uses, allow building it if COMPILE_TEST is
> >>> enabled.
> >>
> >> Why not just delete it now, and then bring it back when it is needed in
> >> the future?  Otherwise this will just trip up the static code checkers
> >> who will attempt to "fix" things in it.
> > 
> > That makes sense to me, but Qualcomm pushed back on deletion:
> > https://lore.kernel.org/linux-crypto/20260602-qcom-qce-broken-v1-1-a4ef756089e0@oss.qualcomm.com/
> > 
> > But I've still not seen any evidence that this driver is useful for
> > anything or has any users.  Even Qualcomm seems to be unwilling to make
> > such claims; they only claim that the IP is used (i.e., not in Linux)
> > and that new features are planned.
> > 
> > - Eric
> 
> Here is my reading of Qualcomm's statements:
> 
> QCE is currently used by the Arm secure world.  In the future, QCE
> will be used by the kernel as part of restricted content playback.
> Qualcomm wants to add the needed features to the existing driver.
> This will not use the crypto API.

Why is a crypto driver not going to use the crypto API?

> I would be fine with the driver being removed, but not if it means
> another out-of-tree Android driver.

It's not another out-of-tree Android driver if nothing in Android
actually uses it :)

thanks,

greg k-h
