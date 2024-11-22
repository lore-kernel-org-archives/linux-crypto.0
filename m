Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BD61DF98E
	for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2024 19:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732303728; cv=none; b=Q/IIwsZ3jTtL5qyfMd8k7LEZoyS06Lp5zHVp+G//SYk8WNX4Nqd+SpEWtkaNqerpuup5Ayx+lQoTjuY56p1mPAlSOq85oW+IrU+chlXNKcNNAVgkjE94XM8e14FdmuhgOetT6O8JAYY5YEg5g5VVSUcGjsB7YI3iUIrAuOfyEjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732303728; c=relaxed/simple;
	bh=CIirRwIqXxswoKYw/C0vt7jhR+LbI6hwoJRM9Kmjx0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oa/rXdagsT6SlRUHvpuUQYIhwdElmB8CweTX43JEh1CLdqPuNDl43e1t/ADlXkcqkE38W6SOmjet5tPDxI6v+SwQqn3DtkUNQdg35BCh0aXw6EGX6YA9iwr8HENEs2lhOhhJHv/ME/0yfH8fZGSNWz3/KBVp4/mIJ5DjgLwrqj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OIM1pZ7n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OIM1pZ7n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732303724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FcvGsCpkjrQ7syvCrJLvbT9jNNGJMzuDnZMicFV+YWE=;
	b=OIM1pZ7n6qM1I8n8w2XJ68TKo38u8k6Q1RRPbKSwolwLjpcMOCDPd5c3LwP2dhMxFHONLb
	i3hBT1ibE/BPs7OkfL8BNEu5MVCrzqM15hEnOYoxpiPGI9uXcocfcuvI2n+7xcnjCliITa
	NRS59KwX6Myx1iHZ0rQpLFclv+eY4B0=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-wTEpOOJuNdC3c2nSGnGhkA-1; Fri, 22 Nov 2024 14:28:41 -0500
X-MC-Unique: wTEpOOJuNdC3c2nSGnGhkA-1
X-Mimecast-MFC-AGG-ID: wTEpOOJuNdC3c2nSGnGhkA
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-211fcbd2325so29529395ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2024 11:28:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732303720; x=1732908520;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FcvGsCpkjrQ7syvCrJLvbT9jNNGJMzuDnZMicFV+YWE=;
        b=cBLpzoFU5MPMP/Y0w1A5AXQwNUqmlFnqP1EvT2x5fc1iK7VrHMCLDRo2fB91qjGtMw
         8KdM7R6Rb2yyfkFSaHreoPE40d8zH6M4B8xaUPKZW/zfVuepqx/4R0XiAa4Ht8LuecZQ
         sMDzhCVAJ76nUTvR7Xm5FmORABlhZzccGkb+WUKwZkbaxkMmXloz7/Qf616Tqlbw2Coj
         UrsUV4Q3EsEM/Qx4M1Uq6R/9GatBUu/4BmnO8ekowh2x9ecUQTfUfpqYcWtJOFwEbV5T
         NQZGrWV+GIVuULROLZimheJH1thgm4w97mHMWUCLK6SV/jgckXe6Ew53wqvC8MAB5zI3
         oi+w==
X-Gm-Message-State: AOJu0YwEEMxuEjgwNGwXPz7CQRMnS/kYMt/IDRK8nvMFdyh4t15AzvVl
	vPItQ2EV195hmVd5X09FYwDYvr2K5fMRGjsnPnRq4zDmR0mBg+YqL/RpvEGqjd45kytU+uGIXwP
	3R4Y+gXIX6Yaa6YOA1UM35WT+zyH7TiTdx7tpb7hhWFlV6HbHPRKf/JHBrJcGEQ==
X-Gm-Gg: ASbGnct6IS8186ZpImsnI+6b5LnyDVFd8xqlhvXyeLCXU1g4Vm/Y62J6J8aIcbPV+ur
	eyi6fcWPufN04B9IwwTZLm7ef6EEjdwRPQdvKDEfOS95ey1W/Dmhf3Vz835wxXzXk/ONxuMI6i4
	ZxqbloW69SivrZaIIQnUbBnIQYW46mzz/uhGVGzF/3jVKGWZbn3InD8LAfQXVfE5O7Lo79piV7X
	14EmsPHc0xXUQgAplpoEwwLbaXrMLpIkwWJHol33G9fXBagAj0JVK0qu0wYYF8GAzgHq/nQ7x0G
	XuQ/62krAc0XxeQ=
X-Received: by 2002:a17:902:d2c2:b0:20c:a0a5:a181 with SMTP id d9443c01a7336-2129f22647dmr50381765ad.19.1732303719888;
        Fri, 22 Nov 2024 11:28:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiZUUX5sdsIBj7jPZBEqjq3sJYV/CnWD950OlpmmREi6SjKqkBB0USD/fBz0GQhMfKIDS+Vw==
X-Received: by 2002:a17:902:d2c2:b0:20c:a0a5:a181 with SMTP id d9443c01a7336-2129f22647dmr50381615ad.19.1732303719599;
        Fri, 22 Nov 2024 11:28:39 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129db8f7c5sm19899885ad.44.2024.11.22.11.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 11:28:39 -0800 (PST)
Date: Sat, 23 Nov 2024 03:28:35 +0800
From: Zorro Lang <zlang@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bug report] kernel BUG at include/linux/scatterlist.h
Message-ID: <20241122192835.rsryoifhczqgmjf7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAMj1kXGAuJSdDWvu7D5-PT6mSbNG9FeLObnYmpHeT08eNxaJWQ@mail.gmail.com>
 <Z0A2W1FTTPt9PeI5@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0A2W1FTTPt9PeI5@gondor.apana.org.au>

On Fri, Nov 22, 2024 at 03:44:27PM +0800, Herbert Xu wrote:
> On Fri, Nov 22, 2024 at 07:42:54AM +0100, Ard Biesheuvel wrote:
> >
> > Does this help?

Hi Ard, thanks for your quick response, do you still hope to test
your patch?

> 
> This is a bug in the API/driver.  Users should not be expected to know
> what kind of a virtual pointer is acceptable.
> 
> In this particular case, rsassa-pkcs1.c should be fixed to use the
> crypto_akcipher_sync_encrypt interface.

Thanks Herbert, feel free to CC me after you have a patch, I'm glad to
give it a test.

Thanks,
Zorro

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 

