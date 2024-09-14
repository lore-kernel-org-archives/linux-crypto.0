Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4B64C83
	for <linux-crypto@vger.kernel.org>; Sat, 14 Sep 2024 13:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726322307; cv=none; b=pWSpdW0BqweZxMmMKzxYj87rXeiPeQSa3IqwC37giPy/aEUTEQnaBbXhruj0ztSCXAwtUyA+D36NV8zA9ErbaxCN8oh/FfhY4zM64XJMHmROcxwFOnEijNUcnEmRxbSeGkpfBcHhLk50PTpfMa6ibb3NgQzE6JYTlhCVb7+O0PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726322307; c=relaxed/simple;
	bh=VpK8Dm9AktFl9wlvolpt2HDdajA+d5H76nyTmATw7Jo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZIpEX7Ks7Wy0RJEUGIUTtOyCpC113PHW+KsdAoY4Pj6KGMiSuXkSbRGE8nGaDIErxdO1BfkDAd8Xf19d3t+Odpu2kqaxo3HNzLL02sgTUGioUDniktYJ5RF//FHDqlxycU45zXsL1zfbJMvNnTRX3WqBirVWCW79tl73sT08ex0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSNvCV8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSNvCV8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C588FC4CEC0;
	Sat, 14 Sep 2024 13:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726322307;
	bh=VpK8Dm9AktFl9wlvolpt2HDdajA+d5H76nyTmATw7Jo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zSNvCV8inW3gIGfm4pi5VaRdtYxoV85zHyNAk+K/nfK3AzBsqIYDZmPxKeuv7yMpj
	 ydzL63LPwOa5phiWO1dAKArsxt7ybCMR+3WHCtG/jVFlQunmxmutbGLXsrijoq7b6H
	 8Pvm/M3M2ZEmNoq6kGhG6kF/pUrftWsjwanVuoR4=
Date: Sat, 14 Sep 2024 15:58:24 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
	Li Zetao <lizetao1@huawei.com>, davem@davemloft.net,
	lucas.segarra.fernandez@intel.com, damian.muszynski@intel.com,
	qat-linux@intel.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: qat - remove redundant null pointer checks
 in adf_dbgfs_init()
Message-ID: <2024091453-champion-driveway-f9fe@gregkh>
References: <20240903144230.2005570-1-lizetao1@huawei.com>
 <ZuQRqP9CgDp7cuGi@gondor.apana.org.au>
 <ZuRRxIjK8WMvStJ+@gcabiddu-mobl.ger.corp.intel.com>
 <ZuVL5buxgkqSEzPU@gondor.apana.org.au>
 <2024091452-freight-irritant-f160@gregkh>
 <ZuV2L2WQXSEgcsy6@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuV2L2WQXSEgcsy6@gondor.apana.org.au>

On Sat, Sep 14, 2024 at 07:40:31PM +0800, Herbert Xu wrote:
> On Sat, Sep 14, 2024 at 10:50:33AM +0200, Greg Kroah-Hartman wrote:
> >
> > > I think this is still buggy.  That if statement should be removed
> > > as otherwise subsequent calls to debugfs_create_file will provide a
> > > NULL parent dentry instead of an error parent dentry.  This causes
> > > debugfs to do things differently.
> > 
> > debugfs, if something goes wrong, will return a real error, never NULL,
> > so any return value from a call can be passed back in.
> 
> Right, that's why we should remove the if statement so that the
> error is saved and can then be passed back into the next debugfs
> call.
> 
> With the error-checking if statement there, the error is discarded
> and the next debugfs call from this driver will simply get a NULL
> parent dentry.

Sorry, but yes, we are in agreement here, sorry, been reviewing a lot of
these "clean up" fixes that were wrong and got them confused.

thanks,

greg k-h
