Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD85C3BFAEB
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 02:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789697834; cv=none; b=QfkYp+oMVQ1423MiR2o5iLxWoYjS2AOTFlxZNz2NY41/909ChU5gFtGAzwqNGlXAeIM/ZQCzQwlp2F0nYxa+/Tgp5LxyQ52COnqk7EafdLfCZvuHgr8mAJBE2nq63m5fPb+J1oxToJQuHmL+sU9gSp6AYYDT4aGYPnl73bMOBzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789697834; c=relaxed/simple;
	bh=M2nHyuU5gdjrLDzh7U/zR+Ad+9B3Xrf0Jwhj6DusBHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLeIr1/RsZdDHWZKvK/fVcjbgf57U9Cijqp9o0L3JosexHNm875oNHh/apv10MUSKwJscIE8I35xqXAmx2LwuyRHYj4kLa7E6xybOhPmdICyvoXvfgLSWyxicRx2aF/iZ7hh1/w20YNeIdMQV3KwASbyRdSpPL5HTdfYVd8osYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YCjz828T; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YCjz828T"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccb65437so195917a91.3
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2026 19:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789697827; x=1790302627; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vW0Y3swTiioWAd7nzTHn4G51gEl3jxVd3j9M10H0xqA=;
        b=YCjz828TUeqR1Z6rjvuVzUt+SkLJueTzJOThp/H3drE9wIjTsLOVrOSyVuxjBSmkIT
         9kWP7hX0g77NNR6jjp/TFdDmxTuEdM4D4y46G5IBAonMk8SzepVCO9/hiPtj4BiA2oRu
         Vb+nUWUYKmpl3wpjy6UoNabsJVrnzaCwZWvKFP3h6oRKfOeJecYXR9OxM3NmxLTntMLN
         bZrzBEbSrvz2+OR5S4hTRHrkBeNngwAdeTxKkvXOR+YQHCkL9VHWZkUWtN00/ak4Rbjc
         ugKreYOTpL6Wbc7L02T4oBOgmyN2ckRAE4buJ6y/mxjmH/i5HWlh27zPi2QJim1ACfg3
         qOEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789697827; x=1790302627;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vW0Y3swTiioWAd7nzTHn4G51gEl3jxVd3j9M10H0xqA=;
        b=PpywBW2+i+ZNbpnYupSSXYnfF7et7/i3aWqYyYlE6WkQcuVG1MtarAqeZNo0vbbir/
         FjbXhtl7S1dPZfAYjoaUVagVLdLSqniwOb7DfpGRr0cUYqj+mw1ThYXgtRixnr1H9qUj
         PAepenhpbzOes+f7EECE2FChq4hJlclBmeP4+Mc+QOKb8tHXLvOwsGap1PsOHdz8rzyr
         wAOxctVlF0ZaQzJoCXi1SYuQIShfYZmqHkziaRhoyFz6Lw52O1XqBTcdchmw5Q8NuSZU
         Rr1CcORL61lxr6VbeJg+1UQz/D2deTNA+K+8eHlci8EB5L9z1NkpT469fXfmaSp+T8cP
         qHnw==
X-Forwarded-Encrypted: i=1; AKwUvBw0GtXhocppzImjdH8E8xJ+vZSgX4GTrTrPr4NifLOP7XfWL92lDb/Bravde56xR4bVFxE/k0Dy/IiZnXc=@vger.kernel.org
X-Gm-Message-State: AFuF++nzrm0FHXBLTouGi7WVGrZ6w+D7VQuJK1qD3Q81v5XZhKZ5jGKL
	N8cyQHcwf+KBqpXUIQzkkshlayT+u2gERP4XeUiq+RzoeZXzJDMUKE1r
X-Gm-Gg: AYBFou3S9Fzd5y7iaZJsM/7JusN9JQWdZLqfJE9RHYk0omt19Va1jmw+sm/Kjk8MjAg
	wSuKn/MonqxZpsz0lsA0e6LbvqRqkzEtGCcUGGRwQF7mici0yc9wXQlzyLPCR2f2d6F+4LYuqYE
	cvYM4R7KsgJzwcTWocqOqKjmNfhsrW9WdhjRzq7iRrlqSEgM9xfRPLeDB4p8eCpAgyV6SbbmWmi
	iJkgeJUCNWz7aPpIO0y2pqY5RTpiYgqNs56pNV1QCb0LL4UEB2VoBS+n3DtbMLe7pBnO0JwvF4r
	eNsyNsqoJ/SSbitot55hiWfkxXNxsbAYXSva0eC52WZUO33Fh6LlLU0kTNO5lY9UZeBwWkyzsvX
	VV1aGy7R0wbS3/hNC/Au8ERjOrqewxsnVLn/IpNxxOGE63qDXk4/CNrh25lCjVv2eJgZpYEagtp
	Yw8M15hzlc9z1pyfwC+4CxyZptJ5zPTUioMnNBlCBJTol2YQgmTOKgU/PnOWk+KxbcJhhdfWwhz
	NrIpd4vcpYGZYjLxf/o
X-Received: by 2002:a17:90a:d443:b0:398:d132:ba76 with SMTP id 98e67ed59e1d1-39e54f9c08bmr2061562a91.21.1789697827210;
        Thu, 17 Sep 2026 19:17:07 -0700 (PDT)
Received: from kernel ([103.219.206.124])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144cdfc2346sm715786c88.4.2026.09.17.19.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 19:17:06 -0700 (PDT)
Date: Fri, 18 Sep 2026 07:47:00 +0530
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: clabbe@baylibre.com, davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org, jkoolstra@xs4all.nl, lkp@intel.com
Subject: Re: [PATCH v2] crypto/amlogic: Use devm APIs for clock management
Message-ID: <aqyfHB1xBWFSvOl9@kernel>
References: <20260901024302.5407-1-raizudeen.kerneldev@gmail.com>
 <aqpmOzURNFOm78ls@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqpmOzURNFOm78ls@gondor.apana.org.au>

On Wed, Sep 16, 2026 at 07:49:47PM +1000, Herbert Xu wrote:
> On Tue, Sep 01, 2026 at 08:12:52AM +0530, Mohamad Raizudeen wrote:
> > The driver currently gets the core clock and manually enables it using
> > clk_prepare_enable(). This requires matching calls to
> > clk_disable_unprepare() in the error paths and remove function.
> > 
> > Switch to devm_clk_get_enabled() instead. This lets the kernel handle
> > enabling and disabling the clock automatically, which allow us to drop
> > the manual cleanup code and keeps the probe function simple.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202608310329.QgxCCMs1-lkp@intel.com/
> > Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> > ---
> > Changes in v2:
> > - Dropped the devm_crypto_engine_alloc_init() change due to build
> >   failure reported by the kernel test robot.
> > - Kept the devm_clk_get_enabled() clock cleanup as the sole focus of
> >   this patch.
> > - Link to v1: https://lore.kernel.org/linux-crypto/20260821151303.8150-1-raizudeen.kerneldev@gmail.com/T/#u
> > 
> >  drivers/crypto/amlogic/amlogic-gxl-core.c | 16 +++-------------
> >  1 file changed, 3 insertions(+), 13 deletions(-)
> 
> Please take a look at
> 
> https://sashiko.dev/#/patchset/20260901024302.5407-1-raizudeen.kerneldev%40gmail.com
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Hi,
Thank you for pointing me to the sashiko review. I have addressed those
issues and a couple of other bugs the bot found in v3 and sent the v4
here: https://lore.kernel.org/all/20260916174227.5581-1-raizudeen.kerneldev@gmail.com/

Thanks,
Mohamad Raizudeen
