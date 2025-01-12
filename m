Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFAD1B87FA
	for <linux-crypto@vger.kernel.org>; Sun, 12 Jan 2025 22:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736721531; cv=none; b=t62zZF9zOycN2VNJ5j+ccm7+kfuYtGSOr4bvOZmhSEqVTK5Vgj47HsKdMid1w/mLxKl6NnpShz/Fj8hZR0nCu+Lm0aCR31Up+Ikbs35rOib09bOXOH1XKtx/T96G+29pzfYbjTjTVEfGrHewj9jD07DL2gQuIsf2V3xWg1J2LOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736721531; c=relaxed/simple;
	bh=L/WlMsAx9Yvm4+ufvt5prp58wny7PmlcIpSSmtlcHiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aE34J3LVzKQZs4ar7zblWJonUmzzornZYyV5zTaEDBv6haucgHA3nSwTnxHoW7p/mazKQmXLZ27PxK754XRMODnCQ/d1UqHG6VeQnUcGeU8qyAVyfOI/fWd8+hgthGqpQjqBrFGS+23oOsSIU/Z0DolBzmAnx8t8sUx/4KdzZIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWoc+oMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWoc+oMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAE4C4CEDF;
	Sun, 12 Jan 2025 22:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736721530;
	bh=L/WlMsAx9Yvm4+ufvt5prp58wny7PmlcIpSSmtlcHiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JWoc+oMiFNNlzDTb8qvgemE68/vrA8F6gHGghPvwTlCnWrc5+fP/4VHbwVcyl6NqN
	 emjaXezJiekE3fiV1AJnzNfdNzw6rPa6yWtN0Z0BOlmJkRK/gil3hrgklXx1doTG3B
	 FAA8ucwLbCjU6ZpN+sbAW7X303R1iT7BDGkJlbANJFo4oOVRdkbdLkbPFmgAUKeQ5k
	 9jB77V9fB3+kIqOsdoKlXfUWP3Xd5rQ3NywrxHYDdPL5kzsqaGML31gKxZ9MI61SEM
	 pJPs0/WRMTAAO9fFyEWwyTAl/rb2M19t2UlxR/+3XMbz4vBDP39ciiQ/yw1Ia88qDS
	 Uerap0t/ypyiQ==
Date: Sun, 12 Jan 2025 15:38:48 -0700
From: Keith Busch <kbusch@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 09/10] nvmet-tcp: support secure channel concatenation
Message-ID: <Z4REeAUzXi3z2jeb@kbusch-mbp>
References: <20241203110238.128630-1-hare@kernel.org>
 <20241203110238.128630-11-hare@kernel.org>
 <Z36o7IqZnwkuckwF@kbusch-mbp>
 <69208b76-71ac-464f-bdb9-50c9c5558ac6@suse.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69208b76-71ac-464f-bdb9-50c9c5558ac6@suse.de>

On Thu, Jan 09, 2025 at 08:33:51AM +0100, Hannes Reinecke wrote:
> On 1/8/25 17:33, Keith Busch wrote:
> > On Tue, Dec 03, 2024 at 12:02:37PM +0100, Hannes Reinecke wrote:
> > > Evaluate the SC_C flag during DH-CHAP-HMAC negotiation and insert
> > > the generated PSK once negotiation has finished.
> > 
> > ...
> > 
> > > @@ -251,7 +267,7 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
> > >   	uuid_copy(&ctrl->hostid, &d->hostid);
> > > -	dhchap_status = nvmet_setup_auth(ctrl);
> > > +	dhchap_status = nvmet_setup_auth(ctrl, req);
> > >   	if (dhchap_status) {
> > >   		pr_err("Failed to setup authentication, dhchap status %u\n",
> > >   		       dhchap_status);
> > > @@ -269,12 +285,13 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
> > >   		goto out;
> > >   	}
> > 
> > This one had some merge conflicts after applying the pci endpoint
> > series from Damien. I tried to resolve it, the result is here:
> > 
> >    https://git.infradead.org/?p=nvme.git;a=commitdiff;h=11cb42c0f4f4450b325e38c8f0f7d77f5e1a0eb0
> > 
> > The main conflict was from moving the nvmet_setup_auth() call from
> > nvmet_execute_admin_connect() to nvmet_alloc_ctrl().
> 
> I'll give it a spin and check how it holds up.

Sorry, I had to drop this from 6.14 for now. The build bot tagged us
with the following error. It looks easy enough to fix but I can't do it
over the weekened before the first merge window pull :)

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
branch HEAD: f28201922a357663d4a2a258e024481e19269c2c  Merge branch 'for-6.14/block' into for-next

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202501120730.Nix2qru3-lkp@intel.com

    auth.c:(.text+0x986): undefined reference to `nvme_tls_psk_refresh'
    csky-linux-ld: auth.c:(.text+0xa00): undefined reference to `nvme_tls_psk_refresh'

Error/Warning ids grouped by kconfigs:

recent_errors
`-- csky-randconfig-001-20250112
    |-- auth.c:(.text):undefined-reference-to-nvme_tls_psk_refresh
    `-- csky-linux-ld:auth.c:(.text):undefined-reference-to-nvme_tls_psk_refresh
