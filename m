Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEC143F08A;
	Fri, 17 Jul 2026 22:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784328150; cv=none; b=UxCM35PiyD8y6bsnYWOB71UwT9yWHGmCpQDQtUWk8zt2asaSSaXSV4UkKPP8LSgw3Zgxmezamhe67ICCBAf/k7R/Ve3b0BS9/Kj5GS/pN6/klRGSq35gZsTo7BnzcHprrUE67+ewXchDJ2cU4mcLy/9FFoprJ788EaqWwos0/KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784328150; c=relaxed/simple;
	bh=uLGxnBI4R5yW8J5bqhwh+69zyr4djIsj5sijVy+NZ1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rgE9xA2I3dfJdrQoy+OfWHThY3y+kkibTfSjKFU5/Y+c6TRW9/gbbRCOXDwDBEh2n8925BMxBPpoJEZ+zk9nR7e3QyfA24SbZ0dguMyjWeSokm49xt0mBpkIRqlDyH/bE1pn+5GjH4RFitvR63KKRCplxTWXLkdgl/+6IrcIT2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSB0iMLk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSB0iMLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A3C1F000E9;
	Fri, 17 Jul 2026 22:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784328149;
	bh=uy2sm5e/XFoUQCA2FZ+us4l0YRDwlLA7mLelC5mZjeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hSB0iMLkTuBgnNIsI2DBcnr9NT5Rim0v/hQv5g1ntSni0w0vVNC8/Npd8h9XL3Z2T
	 InbJWiS/Tx3IQZ2dddieNsHLKwwj2Ybww3DtFAnv0hzphNJ8v9Z89gaIhcMlb5iGYH
	 fa/bK8nx+UsAFL8EK7KyFahIMKnCCJcaHKzCN86GWsNoIV72mp2QcIbf+6xojA+c+n
	 0Qz3FSzzQp4eZkvV2C6wXd7+HharX+Ylvc7uskhtuyVynsdeKYvK23QuwRvw5VyOLO
	 0Xr0PRclnFThTmk4N9CX3Lnvfo1ojQCwvmhn+FDcEMFLI3gk9/ywkMybqhPWXDx7Fz
	 81VFH39aWNOxg==
Date: Fri, 17 Jul 2026 15:42:27 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Replace bottom-half spinlock variants
Message-ID: <20260717224227.GA95995@quark>
References: <20260717205028.63847-1-daniel.m.jordan@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717205028.63847-1-daniel.m.jordan@oracle.com>

On Fri, Jul 17, 2026 at 04:50:28PM -0400, Daniel Jordan wrote:
> Padata no longer runs in softirq context, so normal non-bottom-half
> spinlock calls will suffice.
> 
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
> 
> Based on latest upstream plus Eric's four padata changes from
>     https://lore.kernel.org/linux-crypto/20260713223234.24812-1-ebiggers@kernel.org/
>     https://lore.kernel.org/all/20260717171831.27994-1-ebiggers@kernel.org/
> 
>  kernel/padata.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
