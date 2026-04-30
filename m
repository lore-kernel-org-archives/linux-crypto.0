Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ABA374721;
	Thu, 30 Apr 2026 06:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777532264; cv=none; b=ChAYqtmBodfjaKdR8Ljm+j3sSQf5MxKkfVpwKtMormJCi+kNSeWwvTjMWWms2UtIgG7KNPQeAt8sPhPRpegn57RJ9Jp1mkYKqu2tdwKlKqzAlW1p5x3Ktqi761tnNURjPCoOkg0tWDcQc9h2/zUzel/iMVBcwfvFMHZuD78qNps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777532264; c=relaxed/simple;
	bh=BTQISJ5R6SumSil3t6TJags3aAwmNx5YKtm/aTi3NRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/PDMOjBlfVHXZrwSltrw5XJSgSjgpIrPUpKNMz3TlyHBPmHy+MUyyvGjr881Lk+7wp2Q0M/bgJKPHKJsPjtX42jMueDF4HITcLd9/w/iQqCbB+TMWwVHzFjwS8EcMfdrF4bWebjmrLM7uMeF3o/W/9CGttAq/rIEJ1eeG8BRUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5mZPMzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5mZPMzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D489EC2BCB3;
	Thu, 30 Apr 2026 06:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777532264;
	bh=BTQISJ5R6SumSil3t6TJags3aAwmNx5YKtm/aTi3NRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H5mZPMzrwMmGU7RYys4WFigXLXtMupKuRHelZnwbDHEK8e0PUTfih/724no5NcNpd
	 IcJdzIOhNq/sVLSnqwOHni/4xfQO3Yj9OfBZ9flftQ7lH0TekQkP3J1t2Wy5JTp9y0
	 9DdnLBemTmWaUrwCPmmVLedMvoQRFab4cmlUyiK4=
Date: Thu, 30 Apr 2026 08:57:04 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6.12 0/8] AF_ALG fixes
Message-ID: <2026043038-unwilling-slogan-a20e@gregkh>
References: <20260430060702.110091-1-ebiggers@kernel.org>
 <20260430061120.GA54208@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430061120.GA54208@sol>

On Wed, Apr 29, 2026 at 11:11:20PM -0700, Eric Biggers wrote:
> On Wed, Apr 29, 2026 at 11:06:54PM -0700, Eric Biggers wrote:
> > This series backports the recent AF_ALG fixes to 6.12.  These include
> > the fix for https://copy.fail/, fixes for that fix, and some other fixes
> > that went in at around the same time that seem related.
> > 
> > To enable the 5 actual fix commits to cherry-pick cleanly, commit 1
> > copies the latest implementation of memcpy_sglist() from upstream, and
> > commits 2 and 5 cleanly cherry-pick a couple cleanup commits.
> > 
> > I didn't check older kernels yet, but this should be usable as a
> > starting point for them.
> 
> It applies to 6.6 as well.  There's a conflict on 6.1.

Thanks a lot for these, let me go do some "quick" releases with these
fixes in it to tame my inbox a bit :)

greg k-h
