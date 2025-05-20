Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BFE27CCDF
	for <linux-crypto@vger.kernel.org>; Tue, 20 May 2025 12:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747743186; cv=none; b=QBq8JOcFDTCJVhYnp2ZsoJtJVpDFhKH/i5FcWS3QAX52FMOBlbKbLI4EsXrkDVqJFX5FZP123L/UjSa2h2xY5k/vecQm29KdGHF18Gz0F99aFGjL2RnpbwvzaA1PP16kD8fUM32kqDdfQ520nwf/teZaJ1n14yAsyhagfqbqoC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747743186; c=relaxed/simple;
	bh=9jGH7pBhxzuh6crIIbm1E/FLg/jhRxyAoO82fVb6MB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hzvh+13cowI67Hz35StJWaIKf1LRqA+fM3TPusqfBQSYVqqEJhhZ3hYAptJ/ruhvioRxW8AIqmxujK4S3JiP6aGRV0RQ6fIzpXL8kmZxDBm7BpklnoYUrQmvPvFMFGdjcR1+41tZ/EUsFzK/dTKwMiOnUjB+gzF6Q6aa4YK18d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BckgQvAA; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BckgQvAA"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-442f5b3c710so44119845e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 May 2025 05:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747743183; x=1748347983; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MbMyl3/7oyXhYnNk5bCXQ5p/8U5ULGAfUGDG23y51+I=;
        b=BckgQvAAyyJY0cD3WbVKoznQejZDCr9s4o+lOlAFe747grtLBd+mgZcQfg/S7rtff5
         tCBPd7MMoamacegKvat3I5yGk3KiNGEcUSkXPcOmHZ+ENAJ1s4yi/9thjzNshuTsIHCq
         mW+XJ0Q2nL/ICr/bgMmoYZs9aWAyw5nXMg6ymjupy27UyTrThQocAzPJ6zXYY4Pz9a/U
         rOMANMlBCeppURWqjP9IDPttpeVk3V/8zBmCoxcXZUlm7iLqpQO7/gcXgkI3qmK0AQw9
         Do7HtbcEvs2JkvcrKTTIdkRO8NGfMw+rCFvEtca1MrTbkDeAnthZmBC3uKwbP0KOV9rL
         unQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747743183; x=1748347983;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MbMyl3/7oyXhYnNk5bCXQ5p/8U5ULGAfUGDG23y51+I=;
        b=vXIeovR0q1XhhKI1XKrimz9ozCJAxzAsr7e2PNnp1mh4Ems9GoCqDd/ewq1fNkx03w
         +JGt6UCUMXcskhSpmtAjcB+lyNyHIls9ocnLTDm3+m8uiSLrinAWG7mGdda2vVVbx8zM
         7DGOeFIQg3Kb3Y027x1WnaSAmf2VckU3aERlCSddc62zYR7nxyZu745/l4vFuiuK40kb
         UIlArM0kojC+IIqrEw6GQQtwPPjKV2EwcbRO486j3wIP14fjVVdh2TSS8+AG9gyypheD
         G37V8z6O1882vOgJCdNcIWu8eBjl3tKYvTlld7UX3dv+YTZhyn6dgh72OdZTsLwW3HSX
         NSug==
X-Forwarded-Encrypted: i=1; AJvYcCWkaMBG+aK/XLjQIaHSFvlSPJmX3Dwfw0wB0LENz21p03TjsnOMSY0Ut91TS1tFwXOSd6Z7zxm2EWaKe/U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrH8CkMhY0X08YFj/fs47BoAszLb4hMhKXbShOLdMDHuC3kPvw
	P+jU+XXTXapKFov1xXmvv6CSzm0N4PCIjZMWEi9Wowa/qk6GZhPhB22I
X-Gm-Gg: ASbGncs2gbHwr3yZ9lQZ9mYHxM2IgxWJC2myGZNcBCWD9y8fhMAbrhqn7231SDVoCfT
	b9Ggiyol5r7Mvrra0fvd3grMitwDp/cimYOI4QRA34mu5l+9GjFcW5s33HNZivTDVhhQAksyR97
	eVPyDR6VXatrqd0rlxth1oi3q+vfUhTw0sCjQVOxM89ItaxcvlGOkKhy6KSvThyK3anEldIO4vq
	cSy9E0tErG4+WYRazc8tRRXGr7dCan3xkUtFLpopnJFbq696j8x9qjkK4sizWtvynvz/Irn/tru
	GfxqMujA+Pf85s3WwFAume8HqKevylVrUbskR31GUep4JFc1bO8/
X-Google-Smtp-Source: AGHT+IEbFRetBMqwdm3TyylgIhcXZuGpVMatHq+n3r/yUuD1fBGdMEeLfEEaymk/8Oki+y68NvDf2A==
X-Received: by 2002:a05:600c:a08b:b0:43c:f895:cb4e with SMTP id 5b1f17b1804b1-442fd63c748mr191020955e9.17.1747743182612;
        Tue, 20 May 2025 05:13:02 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-447f7d9bde0sm28066545e9.40.2025.05.20.05.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 05:13:02 -0700 (PDT)
Date: Tue, 20 May 2025 14:13:00 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: dsterba@suse.com, terrelln@fb.com, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, herbert@gondor.apana.org.au
Subject: Re: [PATCH] crypto: zstd - convert to acomp
Message-ID: <aCxxzOa23LJxKt-Y@Red>
References: <20250516154331.1651694-1-suman.kumar.chakraborty@intel.com>
 <aCpKwjzLoqUi5ZwK@Red>
 <aCw1zDuv45AHR3YN@t21-qat.iind.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aCw1zDuv45AHR3YN@t21-qat.iind.intel.com>

Le Tue, May 20, 2025 at 08:57:00AM +0100, Suman Kumar Chakraborty a écrit :
> On Sun, May 18, 2025 at 11:01:54PM +0200, Corentin Labbe wrote:
> > Le Fri, May 16, 2025 at 04:43:31PM +0100, Suman Kumar Chakraborty a écrit :
>  
> > This patch lead to a selftest failure on qemu ARM:
> 
> Hi Coretin,
> 
> Can you please share the below 
>    - Configuration for the VM, including size of dram
>    - Kernel config file
> 
> Can you try increasing the DRAM size in the QEMU configuration and
> check whether the self-test passes with the updated memory?

It is a qemu-system-arm "-M virt" qemu machine with 4096M so I cannot increase more the memory.

It fails also on qemu-system-x86, qemu-system-mipsel -M malta

You could find all config on my result page: http://kernel.montjoie.ovh/lkml/20250516154331.1651694-1-suman.kumar.chakraborty@intel.com/

Regards
