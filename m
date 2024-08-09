Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880E818C918
	for <linux-crypto@vger.kernel.org>; Fri,  9 Aug 2024 07:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723189869; cv=none; b=a6cVcNChUnXo+FgK6tE4qMOjUKdEgZ2v5CsjHWW/6ZnTWY80MW3OqFC223p/UJ8M4hmJXVi+mszLtcJo56mQpoysHkGRXq35v2jG0y3t/G5e9FH1sRbmaUynW3F+y/KuCiIpgAD27g0U8cLu5oOd8HMStBMqJrrVbfXls9eq2Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723189869; c=relaxed/simple;
	bh=hoiU4a1oQrUBAui5PkzZFqg7eOEu2MlqArA2OshzXPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rZPRxo4c0EtnHP5tPFm8vSv+AyZezk9BYKOGSUT8JhDuNwITpLbz+6VO3RRBxvSKAL6MgKwnfyNEBNF+3yqB1FxQCzAjxFtc4hmMvJDHfHRS+LGFJEPmSMAHCVH7eNE3tjiQ7If7pPH7h2Ux8RfFq9/878D11bpDyeUN0NxubT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=XA70Eo0u; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="XA70Eo0u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Wsd9ykEhgVw9TK6u4wF5mxFFMCdLdtUgV8Gkl74zv4Q=; b=XA70Eo0ulDL+L6bFhGAvq2UAzV
	zqmCn3ZNidxJm3DyeqM7tjqoTCYtr6fppMegUzSkbPZpeigHt5eZW8fDfuAVV3FVMLmFP7axiTBCr
	CSZn5zfHL7fuwfWKUrlsiMEiW08vplz6OmrpjNN74xaEEeAFrhvuIpHB8aDLtKRSepe+DuWkpsvH9
	lGa01+kKfpLZwTstw4WM5mq4W6Fe1gYM5K25Po+WC9XqLnXR9CbzkgGQL/8XVcB8uNJ1fF6ZRE+XP
	TN2156RfL6R8QfN259z3VsezdJmjRINOelZPqQeZaxLrcjjTRosd2/nGn6ZV3MImeGpn0PqbEw0/5
	PVhJRgow==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52812)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <linux@armlinux.org.uk>)
	id 1scKOg-00034d-1d;
	Fri, 09 Aug 2024 08:50:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1scKOi-0005yX-5J; Fri, 09 Aug 2024 08:50:52 +0100
Date: Fri, 9 Aug 2024 08:50:52 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [BUG] More issues with arm/aes-neonbs
Message-ID: <ZrXKXIQ6loxE7msT@shell.armlinux.org.uk>
References: <ZrFHLqvFqhzykuYw@shell.armlinux.org.uk>
 <ZrH8Wf2Fgb_qS8N4@gondor.apana.org.au>
 <ZrRjDHKHUheXkYTH@gondor.apana.org.au>
 <CAHk-=wjLFeE_kT5YHfHsX9+Mn10d2p+PQ0S-wK0M3kTFe37o_Q@mail.gmail.com>
 <CAHk-=wgzTrrpY3Z2881FAtz=oLYzAPhbVxd8hdiPopsF-pWG=w@mail.gmail.com>
 <ZrWdx5cL1vKrMBbs@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrWdx5cL1vKrMBbs@gondor.apana.org.au>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Fri, Aug 09, 2024 at 12:40:39PM +0800, Herbert Xu wrote:
> On Thu, Aug 08, 2024 at 12:54:10PM -0700, Linus Torvalds wrote:
> >
> > I don't know the crypto registration API enough to even guess at what
> > the fix to break the recursion is.
> > 
> > Herbert?
> 
> Yes my plan is to fix this in the Crypto API and not do any recursive
> loads as we used to do.
> 
> The immediate cause of the recursive load is the self-test system
> (if it is not disabled through Kconfig).  The algorithm registration
> does not return until after the self-test has successfully executed.
> For the algorithm in question, that involves loading a fallback
> algorithm which is what triggered the recursive module load.
> 
> We had an issue when algorithms were built into the kernel, where
> due to the random of registration calls, a self-test may invoke
> an algorithm which is built into the kernel but not yet registered.
> There it was resolved by postponing all self-tests until all
> algorithms had been registered (or when an algorithm was first used,
> which would trigger the self-test for that algorithm there and then).
> 
> I will extend this to modules and let the registration return
> as soon as the new algorithm can be looked up.  The self-test
> can then complete asynchronously.
> 
> Russell, is it OK with you if we only resolve this in the mainline
> kernel or do you want a solution that can be backported as well?

That's fine - I've blacklisted the arm-aes-bs module in modprobe.conf
on the affected machines. Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
