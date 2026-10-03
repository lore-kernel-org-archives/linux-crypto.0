Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F17306498
	for <linux-crypto@vger.kernel.org>; Sat,  3 Oct 2026 17:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791047137; cv=none; b=C9EYKLBn6f/6inngEIq5wb5KrW9Ir+EABSiJ68GW7wT6PfTmtFTONSdOppNAw7QGy8BHTQpXUWyrsmhzxu8iHIJULVcmHxJebWkJi4XyhL5tGpHnngWdkTzrYldujZmYRYBo3IhVySYFzg9FusKEMuPf3mQDlssELEHA+Y9dZQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791047137; c=relaxed/simple;
	bh=oNyg1sumQDuKlsQ3+kKQmL/LbIN0o4s4kxT6Go6YTxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/Li3GCcg7bG03ZtbI7z+oHM2AyC12k1fk1MegPL2WGiPSZKGHJKVyhoBrsZJJ0Z8XWiH202W7VeOcxfHt/6CHVEOtT9cxtz/AtyiWmJYDrIEeBQlceQkbRnHQrLexBT8EHUMUJatQfh871RD3AxwdnfYl46BBkV9HTz9xJYflM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Bux+WquJ; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Bux+WquJ"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5350c1b9e0dso8703701cf.0
        for <linux-crypto@vger.kernel.org>; Sat, 03 Oct 2026 10:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1791047134; x=1791651934; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=X8TPVwZiR3zkMo2v3+7OD+ay1QVv3kHT+rk/lDuOThQ=;
        b=Bux+WquJAirvH5CaU/vX1Q8kmRp3JQIcypFMbiFeFbWndR8zs2rte7o4EVIrmuoEV8
         J0cPGwRCIgSi+fYyoY+VjPXiTET9x/cDifJN06dFRNrWCHhTQ5AIXY3dshUcJUvod+hM
         GA+vrKtvo/JqEnGbmq9xA1N7wSULwl+xGGJ1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791047134; x=1791651934;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X8TPVwZiR3zkMo2v3+7OD+ay1QVv3kHT+rk/lDuOThQ=;
        b=hAiUXGzTOhddtYdblO0LAgCsveKXrSRHzxrT/1BphBOtPMcbTJJQCv09mlfP4eAgmU
         DqN9z5/LDw2WAum/UaVyfH3qfRFB+z5YlzGe3qt5megR1xAVUgOzb00ZBzdJGvBBS6+E
         uBY0+SJU7tcoV6kiGfWix4vDXYFVOcGF7O06NUXSP36bRSEhUaspTruFfEU9jGotmdiC
         boixZjWIVrTnwR53+uHqusuboszucKLNMMhAIY3058R2zlwLlCNqsE8M8GEYqWAC+tT5
         R8RAX53qnQTPQNsiLcd+NWmeM/hPnSB7/pTEXtNCoCFWPvpe7TFW4WSqOjM8RCSGS0W0
         55zg==
X-Forwarded-Encrypted: i=1; AKwUvBz8ESbgOGjndmyP2YEooQiUWRbQ5BSRUP1T7fdSoOHiJNbWoCASLUg/ZGD8R6hqImzFfbBq8cqwilZ0RZA=@vger.kernel.org
X-Gm-Message-State: AFuF++njhZvNf4TJPQjZYdkR30LemvFdcqVtycjZkDipprEf5fkSbCWA
	pTth9MmTB85Owwn2nFfgFKlyxqxWSwgEgUuHC7k72umXMSAtS925Hx1jygi7IECtGlvnO/rLq3r
	jao/g0g==
X-Gm-Gg: AYBFou3Aw6YLx26WRBxYeSMwbIs11+CF/xOXPjvfhIS8AXRfK3uZTYmQNCVI6lHhtvj
	ruFWaTGLesmVs9jl7bvwrrKfA+mHwGounzFbWD7vukPOLI7OjLMK4PJ2gjanXBupv1/dfE/sLgI
	BzrlyA+lDo/F8gcem0MjtmrgqDJNVYLnKwWPunNyTcKEeT1B8sDD0985fRMWevX0fxJZDuh7I92
	+Fa/lDc2JiyBh3jc/IweEWSpxeIlXzsfQo71rHbO8VaJgnnqC2bXUhmD3jKchRHKUepX2wSu9CV
	fKQUWsHK4Wea7MeEFKQIjxHnb2kfzT9r5cw1M4FY6L8NO9gR0dhyng5YP6ftL+2YxHbgHNA0d87
	pnWkCPlouC1Lc3H3JuDrlu52SVC++LFS5Gp5d4vfT3IJFq9RJ7In6xdPtBQunRPFZYJ3sxH4sOR
	v/RAJ5A8M7PW/NNALAUz+JE28TVBF05UFZa/KtRJLpNohub2acg2j+uljUwoz132FH85eFlHnZQ
	ocWrMkvPUg9xv6UWA==
X-Received: by 2002:ac8:5d0c:0:b0:532:bda6:a48b with SMTP id d75a77b69052e-53511e421ffmr55165391cf.12.1791047134114;
        Sat, 03 Oct 2026 10:05:34 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.107.167])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-919442ce1c4sm40150236d6.3.2026.10.03.10.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 10:05:33 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Sat, 3 Oct 2026 11:05:31 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow hmac(sha512) for unpriviledged users
Message-ID: <asE128W4CxHDCFiB@fedora64.linuxtx.org>
References: <20261003160302.3000325-1-jforbes@fedoraproject.org>
 <20261003161859.GA152469@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261003161859.GA152469@quark>

On Sat, Oct 03, 2026 at 06:18:59PM +0200, Eric Biggers wrote:
> On Sat, Oct 03, 2026 at 10:03:02AM -0600, Justin M. Forbes wrote:
> > By default users cannot run sha512hmac with the current set up. This
> > is problematic because our kernel builds call this for FIPS compliance.
> > Rather than have anyone turn off af_alg_restrict all together, let's
> > allow a common use case.
> > 
> > Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
> 
> The fips hook in dracut was taken into account already, and it runs as
> root.  So this patch shouldn't be needed.  Can you clarify why you think
> it is needed?
> 
> - Eric

Specifically for the case of Fedora and all Red Hat kernels, we call
sha512hmac to sign the kernel, and a couple of UKI images that are
created during the kernel build. Users on Fedora 45 and newer are now
unable to build the kernel from spec without turning off af_alg_restrict
all together, while any user can build a kernel on Fedora 44 or older.

Justin
