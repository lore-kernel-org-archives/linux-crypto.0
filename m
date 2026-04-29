Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFCB389DE0;
	Wed, 29 Apr 2026 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777471768; cv=none; b=nSlvTsJOO+7TEZgCI7Xqh9cGTq5dTmFS58JSHQhFNAZuY+DOe858klqc2kW2xYqrtOpO4zcZ19W3k9MVeNgk7ORkERcfOtCiyE9MKp+/gLFrB1zek97w9SOlmQryI2HN7KGWPTdceF54heqQiQYm6iQOFfSAl4MVGIvy5VShfN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777471768; c=relaxed/simple;
	bh=At8x4x70JMAWTLH8C+gapwWgCgl6LcR6wPc15TsRUqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pEWoQLSCqNsL8ZIoQshtuUil4d78qNufcJqN6TUi4gZ+M3OdUk5KFCEBCy2BPsD9l9xWGLnj9VWoOmE1/ZdDN+IzcRvwUYUTMq4+JuN2gNiaPuo4hpT1SrwrPBTSbMMzMYvYVSAxTmoXEeVnOga5Oj4Fz7BvTLtBm+C72Xoutcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I7xM1r+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I7xM1r+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7D2C19425;
	Wed, 29 Apr 2026 14:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777471768;
	bh=At8x4x70JMAWTLH8C+gapwWgCgl6LcR6wPc15TsRUqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I7xM1r+sbfS0uwFeoTU1uFJJskn0eRh+pXwMkUaNiyKt7aSm3cLR9OwtUah2XYYID
	 Hz7NdD8w5kOKlFasXhVGdvW5OdSt4fAxp7CaShCwAUjo7CFXFwKN92UH4sV4rYIaml
	 kIQSsbi7QOI2N4rGfUcYoEFZ57cM0kswdnR74hHYt8xspWXFoJCJcR8Ls6IOA22AjW
	 8X1Fwn31+StnmfkjXnyMIAnXdPpY73+AQJVU/1LiLejxZ7+L5TXfsIj/6OjHDumDia
	 p5BPamTi4ShZaazctv5Dzzq0sxbqBz4ej7GK0+rorGZIieU5MFkrCLl/3f+9Kie2Ww
	 3e8L0g+FY1buQ==
Date: Wed, 29 Apr 2026 08:09:25 -0600
From: Tycho Andersen <tycho@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v1 3/4] crypto/ccp: Do not initialize SNP for
 ioctl(SNP_VLEK_LOAD)
Message-ID: <afIQunYhEmaFxaNp@tycho.pizza>
References: <20260427161507.32686-1-tycho@kernel.org>
 <20260427161507.32686-4-tycho@kernel.org>
 <6846489a-4553-47f8-ac32-97fd07736cb4@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6846489a-4553-47f8-ac32-97fd07736cb4@amd.com>

On Tue, Apr 28, 2026 at 05:02:53PM -0500, Tom Lendacky wrote:
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > index 572f06368d4b..e8c3ac6d989a 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -2481,9 +2481,8 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
> >  {
> >  	struct sev_device *sev = psp_master->sev_data;
> >  	struct sev_user_data_snp_vlek_load input;
> > -	bool shutdown_required = false;
> > -	int ret, error;
> >  	void *blob;
> > +	int ret;
> >  
> >  	if (!argp->data)
> >  		return -EINVAL;
> > @@ -2497,6 +2496,9 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
> >  	if (input.len != sizeof(input) || input.vlek_wrapped_version != 0)
> >  		return -EINVAL;
> >  
> > +	if (!sev->snp_initialized)
> > +		return -EINVAL;
> > +
> 
> Should this be moved up to avoid the copy_from_user()?

Yep, I can do that.

> And should something other than -EINVAL be used, maybe -ENODEV, to help
> distinguish the error a bit?

As you noted in patch 4, this is an ABI break as well. We could
return 0 here and make it not an ABI break. Given that any use of
this is almost certainly a bug, though, I think -ENODEV is good, I'll
change it to that.

Tycho
