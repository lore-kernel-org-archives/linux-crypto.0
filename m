Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D37610E9
	for <linux-crypto@vger.kernel.org>; Sat, 14 Sep 2024 08:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726303837; cv=none; b=Qld1DgTvIKACCNURTtKbeosDwHWhxXWXO6egq1wsWvQHVH6vc0NhDaDC2agjCfeBEDhDocqVaQ0FPSpMFdh2+5ObRYfLAkcosvFVGyoLz5drKnMYUONXr7qbHWV+rTilJDFqRN3d8i5RudXOGl1r12RgKyk29jvcuZ04LY8FZVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726303837; c=relaxed/simple;
	bh=gd+9LppoYpyr4wbbldXUqIltiNIW7G606YSOcX9+lBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/ND/AzU4orfDGE9SDYymncCtxZPDU1fWlehtu98bCcSMwck+Ba42zdhv3qM5e1kqNPGpR44ccGMAC46f9u4LDqxMjkzKN2Zany1odLmSFqRe2CT+c7iXDo6xGWV4yfuhV64PYDoTZmc58xy9xLe4p21QaWwfB4PK8FdnadlJ3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OhX5Sk9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OhX5Sk9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD310C4CECC;
	Sat, 14 Sep 2024 08:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726303837;
	bh=gd+9LppoYpyr4wbbldXUqIltiNIW7G606YSOcX9+lBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OhX5Sk9mpioweVdJXs9tz/0EiJ6VA/I1Ouh3Q/iMN9h2nWfqMBAnSUdn6f84r8tdr
	 kUrGuVRBbXIRn8C59AmgxZkR19qIlXaVW+Gd9biUh1ID3N2uAcvzZFNq/HxR2DMRBR
	 5XKieIDaz0j6LoOpMNwBT6Dtj1ndI7S6RhFuJvBY=
Date: Sat, 14 Sep 2024 10:50:33 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
	Li Zetao <lizetao1@huawei.com>, davem@davemloft.net,
	lucas.segarra.fernandez@intel.com, damian.muszynski@intel.com,
	qat-linux@intel.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: qat - remove redundant null pointer checks
 in adf_dbgfs_init()
Message-ID: <2024091452-freight-irritant-f160@gregkh>
References: <20240903144230.2005570-1-lizetao1@huawei.com>
 <ZuQRqP9CgDp7cuGi@gondor.apana.org.au>
 <ZuRRxIjK8WMvStJ+@gcabiddu-mobl.ger.corp.intel.com>
 <ZuVL5buxgkqSEzPU@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuVL5buxgkqSEzPU@gondor.apana.org.au>

On Sat, Sep 14, 2024 at 04:40:05PM +0800, Herbert Xu wrote:
> On Fri, Sep 13, 2024 at 03:52:52PM +0100, Cabiddu, Giovanni wrote:
> >
> > As I understand it, there is no need to check the return value of
> > debugfs_create_*() functions. See f0fcf9ade46a ("crypto: qat - no need to check
> > return value of debugfs_create functions"), where all checks after the
> > debugfs_create_*() were removed.
> 
> Right.
> 
> > In this particular case, the check is present only to avoid attempting to
> > create attributes if the directory is missing, since we know such an
> > attempt will fail.
> 
> I think this is still buggy.  That if statement should be removed
> as otherwise subsequent calls to debugfs_create_file will provide a
> NULL parent dentry instead of an error parent dentry.  This causes
> debugfs to do things differently.

debugfs, if something goes wrong, will return a real error, never NULL,
so any return value from a call can be passed back in.

Ideally I want to make debugfs return values just a "opaque token" so
please just treat it like that (and ignore the fact that it's a dentry.)

thanks,

greg k-h
