Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D310C377EBC;
	Thu, 30 Apr 2026 07:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777533290; cv=none; b=j1rByj2UurfIh28qt4kzt6xclU042V/k0ueBqQT9KdIPDSgml9+L/NuzhwMD+I2lwwevq8XbVuuVeQesIU7cUVFg90o3B9rCR0e5g1ZCX9VsA6bRIHHeDXHVnk/LQcUg5oWMYAkEgRiEiSbwdkI9xe1ISjaIOBHysm/L6LWmAyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777533290; c=relaxed/simple;
	bh=MEcjXTzZlyjt2PeKQfm2/w4PEMRUiDCmw/7DBOXvbF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BA9WCcD+cS9r3y3MFyqvKmxpBNSMxprH1lf2FruOOF1ZruweFbYo5NeCZClIcX5box+Ebqd36ktZCIId6KBBqaiv8977JBKSJQXGE10OWxwSZhixIJmlOH213l8xMLJe7xz36466HdIk93GCcMb6c/EGAjRuw+mjhjBPgfzBWfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=UaoP2Ge6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kYBcSMOz; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="UaoP2Ge6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kYBcSMOz"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 0EC2B1D0005D;
	Thu, 30 Apr 2026 03:14:47 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 30 Apr 2026 03:14:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1777533287; x=1777619687; bh=u6LrQpJaPC
	0YlQY7hm45cbsv7jFqX5wenKOhGdaP7OI=; b=UaoP2Ge6AGzXaTpyAGI86hVvet
	03zSzBP/ZG88/FW4JNlp0u/DYxQ79IZnvlac1lEbs1UpvclJFfQp7FxrGIhkexBg
	KBFJzsIDn1kFvlPlxmd1xLTh3HXrNnC94w3G+43m2xKhLGWi/3YV/ELX/ef8Xm0d
	p6dU2uOLU17vYnyO/rUtR36ZePGAZ5MSnjO06sXNrhzCnxwgvMvb1klgx6/N2pWd
	0wYf3w3q2LoyRC1xeblRFrxAWij8zEA9+vCSkz/Hx2OsKmuCmtiIffeMwTjncNWv
	caAcsOdLD5jd9w1WSI5qU3xHjE+TbR/ITV0Q0oYmKp6HVhrGApjqPFQNmpPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1777533287; x=1777619687; bh=u6LrQpJaPC0YlQY7hm45cbsv7jFqX5wenKO
	hGdaP7OI=; b=kYBcSMOzz+ufsZd/zsq38N01h6nb+b2WohbVe8ZLkjHBL4aQ7NN
	3GU1Pc62RmqgzmzOR6YZsVTCwidhsN3HG83WfFHHt0272xjm6H4Dm+hn43xSgQS4
	QW+jlJg2a9g8Qts0j66HZ6HL+PZ4LqY1hMYQhT9Dl52vmiXjJYFyAJCXPWoAoKMJ
	COjDKCApAONp0vXxYyNWLyafdL0fhBLrZclpZxESw2AUxnWelkNzoRr7iK9oFkfi
	/n95DM+F1RF6j5JxR0p/5+cujCRv4BCJ/e/vSfTY68qBO0d4/bjc1NsUG/eec06D
	78f4yVjcHUmSPfFuxmw1hktU0jXEVrQvKBA==
X-ME-Sender: <xms:ZwHzaUYJKvx7-ObFp81QVrxzndMv_wIHw0L1k3OZ4Md6P63IhY9Dvw>
    <xme:ZwHzaSfYN5NBfQGsYhBrDcmuYywXaCGSqTA9YGD004qMuk8Z9_yVNdepy0xSakU88
    UJ9gWxivKxAgaKM-OrC9X6pC40OdPUn8UmAlnbrF6KcE_pvpg>
X-ME-Received: <xmr:ZwHzaZnqC01lxYE_TxQ3vzXXlZzVei2diraGQCasxGf-y8RKZgwZ2K8Axb0pZL5YxOjtcQyaqJmUQvUA9zqHyR4j8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekieeilecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcumffj
    uceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefhjefgffekie
    ehteekhefftdefueehudevffeiheevheeltefgtdeuudfgffekudenucffohhmrghinhep
    tghophihrdhfrghilhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhdpnhgspghrtghpthhtohepkedpmhho
    uggvpehsmhhtphhouhhtpdhrtghpthhtohepvggsihhgghgvrhhssehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghu
X-ME-Proxy: <xmx:ZwHzaa3Q5k4WPR0vSZ-dXQPjRlRYsZnAPCjF3VCsyqZCXE9joXzK6Q>
    <xmx:ZwHzaaew_vDZFqR1Km_MzEwYiVxEELhMBMgs2dJwW7uDxZuxQ4LRYA>
    <xmx:ZwHzacZRjd0tqyQYtxACpQSGC00mzAzJH0IjmZJ0McwQ30HuzKvgMg>
    <xmx:ZwHzaXF3puw7LlqTwWFidf9LPyKfX9Fiw1AkI93A87jzGnQxloV3dw>
    <xmx:ZwHzaZh0d08byDmckFhSz2ldSiZwbn-n7dw0bZ7kf9QAMysIByyUMAiN>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Apr 2026 03:14:47 -0400 (EDT)
Date: Thu, 30 Apr 2026 09:14:00 +0200
From: Greg KH <greg@kroah.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6.12 0/8] AF_ALG fixes
Message-ID: <2026043050-drainpipe-salvage-07c1@gregkh>
References: <20260430060702.110091-1-ebiggers@kernel.org>
 <20260430061120.GA54208@sol>
 <2026043052-juiciness-dreamlike-e33c@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026043052-juiciness-dreamlike-e33c@gregkh>

On Thu, Apr 30, 2026 at 09:05:02AM +0200, Greg KH wrote:
> On Wed, Apr 29, 2026 at 11:11:20PM -0700, Eric Biggers wrote:
> > On Wed, Apr 29, 2026 at 11:06:54PM -0700, Eric Biggers wrote:
> > > This series backports the recent AF_ALG fixes to 6.12.  These include
> > > the fix for https://copy.fail/, fixes for that fix, and some other fixes
> > > that went in at around the same time that seem related.
> > > 
> > > To enable the 5 actual fix commits to cherry-pick cleanly, commit 1
> > > copies the latest implementation of memcpy_sglist() from upstream, and
> > > commits 2 and 5 cleanly cherry-pick a couple cleanup commits.
> > > 
> > > I didn't check older kernels yet, but this should be usable as a
> > > starting point for them.
> > 
> > It applies to 6.6 as well.  There's a conflict on 6.1.
> 
> There's a conflict on 6.6, let me see if I can fix it up...
> 

I think I got it working now...
