Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6F928640B;
	Fri, 17 Jul 2026 02:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784254819; cv=none; b=mjFtYLrKd5rd97r98d4lLgwV/WLBIx7KemOXLpgyIw5E63PU0gTxZgKsUUkuN31DBxHHCURNkPE67XAfsZ+IbrjINLg0mZ4J5nX8NL2QK3XVaXNP2Z6PWt3VtfVmfkkmpLIh0B+TNn2wx4x7cg3JE4xqhSBgXK3u+j9NCJHBT3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784254819; c=relaxed/simple;
	bh=hrEn/OZi/9jwMhLu80r6hicvtIuedUbqlnCPMAlbb6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pt+QnqfQ1PWwKLwOw3tqXgfX43ydX2W7wQZxn1Jy5pLt9v7Pmd+HN0tSvDalKf4Bk4DNRwfIiBwyKw9K8zSfltctWVEXxhaIn89QcqCshWr2VltzPlKUiIDvpRjwgtKqbfC4DE6gJOpEu99shPaXIaFSVb1fKACcrRGa4DfRokQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vlu9igKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vlu9igKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03CF1F000E9;
	Fri, 17 Jul 2026 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784254818;
	bh=ULKhLFxHQvXb/t97SQ4ARnMCFQ4+Jwi3pjyCy1GBllI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vlu9igKlZKletzZhjdPK/w7AzD1SbtzCwAXIhwv7ePMWG+ehpCSvTyY2jxCs6pAfJ
	 56X9ng1rXWfFnfQfJx4WtJGLHwqu9ucB+zziGtGw5zwtvGHn0iGgcq2B42/0vnR1Xw
	 VlfAYJoE5jJUcRuxFLH9F5OxLGg/6VQmPnWnvXdf7KhwWBdJRKZb/q+krGnozi2vm/
	 uHy7FPbaDPSjPb5Xl0FCaJ6YJqg/ANmliD3DbpMDBpPv1nS/mIvKizMBD7j7htlVmR
	 XEl34u/i0WON8K+XrRt4HigCv2pBERKXxVkPsfx4pVTesA/Fbijh4YCPJAbKZ0BuJ5
	 fqSBZTi+/QJEA==
Date: Thu, 16 Jul 2026 19:18:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: gregkh@linuxfoundation.org
Cc: herbert@gondor.apana.org.au, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: xilinx-trng - Remove crypto_rng
 interface" failed to apply to 7.1-stable tree
Message-ID: <20260717021831.GA1847@sol>
References: <2026071501-handstand-curtain-592d@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026071501-handstand-curtain-592d@gregkh>

On Wed, Jul 15, 2026 at 12:16:01PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 7.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> To reproduce the conflict and resubmit, you may use the following commands:
> 
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-7.1.y
> git checkout FETCH_HEAD
> git cherry-pick -x 32b4d29280ed2a991dc196d5845b892acedc63b8
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2026071501-handstand-curtain-592d@gregkh' --subject-prefix 'PATCH 7.1.y' 'HEAD^..'
> 
> Possible dependencies:

It actually cherry-picks cleanly.   And you also failed to Cc the
subsystem mailing list.

- Eric
