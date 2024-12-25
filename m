Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E881885AD;
	Wed, 25 Dec 2024 13:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735134518; cv=none; b=gwP5ylGDcz7m2qEe/4ouIYs6XkU5DVFbSp34LNJkz914e9q42EPb0swzF5k6maZEFrxU80Gbhn9PGoQ9KZwgS5nB5m0E3CDNHNBaJU9cb9GwFqXmRAvHYNREZ1lySb0gg4NayJLqWjVmjx3ajeQLOsrlImPdPGXSH1vrlqz8n7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735134518; c=relaxed/simple;
	bh=1OWu3pqGKhAobUwMbP9TzU+i6GX3Y49KGAqFEqR6tn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wxu0fwH6WnM0E3cg/Fi/Ip+NaoOiyIbFzn0PVvhiNlQWN+7qZKV/2CIzUTQAtJHUp2s0zyr9/jwiT6jAmsE08qfOVYQnXmhrUwfNQWSf3hFPWGbj4+LStHetYa6+Cg+zkd6jR6j5WH8bkcFYEVhN2OSGVoY/p7a2QeyBc0WjZVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hrPTIDFi; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hrPTIDFi"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e455bf1f4d3so4806503276.2;
        Wed, 25 Dec 2024 05:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735134515; x=1735739315; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2bjyxqSeQTYb8o5MoTj7YDQu9hyF+9bcGcLVbgmWZvk=;
        b=hrPTIDFiVKRQz21NauM1EBGkr3d14h6HPcQFwR6udKdK5WiAkiFTREd/UHKUzBRgKe
         x0iHJRLyVlr1ckJhE1vDWzeLuuHa/6M3qJGIrMBWnoPQQWEkKdJhl6IAcnDWElalo5II
         pyijRTHv2vgIHC110H0zRvuIOldbK87xSMrAKKwfTCpQurDbpXB233Pyv3tAGZGgcOjK
         vkWRXFPIRBZbcFqRy3wBq3asFohv8+JzqIzy6tSRSKUugz6akc0w846DjTsoUycZIkFM
         Raf96Qj96fXQ9en33eZRe8Lmmgcb6M05yr8DuEZkOWDs484tthSAGMh1xJtfmUj5kxEa
         KsTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735134515; x=1735739315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2bjyxqSeQTYb8o5MoTj7YDQu9hyF+9bcGcLVbgmWZvk=;
        b=nl1U2Tc32smmjAPHPPJ3HH9QB179u37VwqcEQlmaQArqPPY3Vx7EMgjx6qpT5b7XoR
         sUKLv3uCWwsqS0wa48x84byjDW8QcEonSV2fNv2A8mkaKlfz2hG0fazs6pQQz0e4qFTi
         BMZhto19nBnBUeY5tSPbLCW2iUsU0XzmMrL2/j94KH4cSYxBFadA1zey1sr4m86d/vi1
         A6yUAMPGO3hanqtArFQWF054B3t5VYhj/vm2/j/1+NbQYOWz17jqFdSxERqp0vHdFt1t
         qftq1tkW8qWsDPoobpdxo9WEasrFdB93ttbZy8qv7zD2fEB1quV3N4imyoV/mOj6a05D
         gxNA==
X-Forwarded-Encrypted: i=1; AJvYcCW26T5iyU/VwcTRovxCMJkXQFhnh6TO/jD0GunJ1o0hK+CtKCCbmiGmq0Jh7cHNfwpTOj9sOdBhpJfiZiY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFQOGlY6kRPJ0A5sA7/B2IjtuFj6kTuPC5MyeQyMbKyR2POAHd
	TW18rtIz+wwNGBesLE2uvM4YZ2FBkTFED9QAdcdAcNfJXrCrgBthQYHdCA==
X-Gm-Gg: ASbGncv5aOTaukQKAGpUJh8tL6ANuqnnFBxdqA+UTEGYaqow4Ed0SGBQmbRwuihNSre
	ndQrGnKlEEx++ZiWI+HcGrFNUaC5QGOcLmndxI1UlBs9+zrtjedvdmKlgONr3Oby+Hpp9bzLvo/
	ghDzsUS+25FvX+kWgobBfvf7E7hBeLXO+138T5KcRik1HA4xo8cIVubGo5mwgD9MX0zcwY1RptM
	rO6tO9VUfbTPy5/aMcppmroL1acw8mW7qx0TMHF8MZc4YHx8qBS9g==
X-Google-Smtp-Source: AGHT+IHxNSU8bO6UQceQb/LROz8OrFi+/N8VyBMyHqXQ3tM3brPrGZuBySBQJrmoFx4C2lppZH/EnA==
X-Received: by 2002:a05:6902:1a48:b0:e38:b1d2:e784 with SMTP id 3f1490d57ef6-e538c26b081mr17208846276.22.1735134515418;
        Wed, 25 Dec 2024 05:48:35 -0800 (PST)
Received: from alphacentauri ([2800:bf0:82:1159:1ea9:11b1:7af9:1277])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e537cbeb7f7sm3517260276.11.2024.12.25.05.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2024 05:48:35 -0800 (PST)
Date: Wed, 25 Dec 2024 08:48:32 -0500
From: Kurt Borja <kuurtb@gmail.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION][BISECTED] Double energy consumption on idle
Message-ID: <75mv5mbkhuimqoof7xoolx5jdebaygiiy2yjgkod3wecbkt3g5@zl5ljugmb26u>
References: <aqhq6okzqa56w3x6hb6xvhajs3ce6suxfrycjcmojpbrbosvzt@65sxbbnksphj>
 <Z2vmiUyIcvE8vV0b@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2vmiUyIcvE8vV0b@wunner.de>

On Wed, Dec 25, 2024 at 12:03:37PM +0100, Lukas Wunner wrote:
> On Tue, Dec 24, 2024 at 07:42:49PM -0500, Kurt Borja wrote:
> > When I first booted into v6.13 I noticed my laptop got instantly hotter
> > and battery started draining fast. Today I bisected the kernel an ran
> > powerstat [1]. It comes down to
> > 
> > Upstream commit: 6b34562f0cfe ("crypto: akcipher - Drop sign/verify operations")
> [...]
> > Graphics:
> >   Device-1: Intel TigerLake-H GT1 [UHD Graphics] driver: i915 v: kernel
> >   Device-2: NVIDIA GA104M [GeForce RTX 3070 Mobile / Max-Q] driver: nvidia
> >     v: 565.77
> 
> I note that you're using the out-of-tree nvidia driver on v6.12.
> 
> The driver may be using the portions of the akcipher API that were
> removed by the commit you bisected to.  E.g. this source file calls
> crypto_akcipher_verify():
> 
> https://github.com/NVIDIA/open-gpu-kernel-modules/blob/main/kernel-open/nvidia/libspdm_ecc.c
> 
> Are you seeing build or load errors for the nvidia module?
> 
> If the module is not loaded, no voltage / frequency scaling happens,
> which would indeed result in the dGPU consuming an awful lot of power.

Hi Lukas,

This is indeed the case, 6b34562f0cfe breaks my nvidia module. I didn't
notice dkms was reporting errors when trying to install it. 

I'll look into it and report it to NVIDIA or my distro maintainers if
it's necessary.

Thank you so much for your help!

~ Kurt

> 
> Thanks,
> 
> Lukas
