Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4070320551C;
	Sun, 29 Jun 2025 18:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751222260; cv=none; b=RKO8c66nzA3X/MJv4cBLKOYE+orGserw2/9V7pE8X2lZO8i+cvZvnN+TbAUimb8sFDld+19G0w8ruAEWGzSEW28CrTmiUVkp3tyME05Gflo+GY2TWkGVB+jyXytpx/0dv/yY+QLAcelFeXjGlq4U33vz6y7o+Wb/kQJr2kdXj7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751222260; c=relaxed/simple;
	bh=KanBzgbYjUGn8O9OHjq1zRnau02IuNRheXp0DCUghdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfHNZvcJdNoqFoWvIeDbAud0ORZT0p2lu+G/vBKdcq82GCmnL6BXwA5GpWKb8XKmer5JN3DUtP0BNvp0XWdc1EWqVvPGcLU33i6uB3+PoYy90hfr0z/QWnk3lYF5e4QJC2uUqFoSHSMNqPzdZ3pVGzn36zqA3014oNzEQKRldZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N9CAHg41; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N9CAHg41"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-453398e90e9so10513695e9.1;
        Sun, 29 Jun 2025 11:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751222256; x=1751827056; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j8592xP+JE6KeCXGDCqNX8dsf7ApqXKNRZpKKe+gG7o=;
        b=N9CAHg41hmZ3nolXxqu+c1V73K//mjKHZkOy7//4ebnMGryivMaX0Hmt5aBB1vjCR1
         cgu6kvslbnjX7qL7ccNHuKCOS0hMIYXBXvB50F8l79LufiKSzQms9ioX74ICwwsaQDzN
         RKKhMb2x6Boi/XCPzQIifPEhWW2thBW3Cd+yQb2itdp18c0SBeJdSjW5QXTPY+z6Qajz
         Uz47iJQJnqlZ1dtj7sObTQ8SNDiNSRsf8mlaZUYZUswI07ZNdJ5qH0RBMt94yGYOq9IZ
         qbER30z08Dk7vVEVqaxmRVCnocAh2cmBjFi/HiNRJ5IoN0xc4LG0rjEpsH5zGM20SlU7
         0Yuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751222256; x=1751827056;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j8592xP+JE6KeCXGDCqNX8dsf7ApqXKNRZpKKe+gG7o=;
        b=LNqH9XlV2fnjOXyI+xdLumhMUtVfbjv91xWkRC2jk3FJFM9qc9vUAMRcim0UtjfqvY
         zDzAAW0f2GIaOhylYpU2Op646tGgB9v6zjLDR3fsBcBl/doHErjOoOB5dRRpTXi1rHXP
         6onSeOAJf0TOCdSGLPKVn44/OGIVeTah2pTFZDNRSg11+t4CXsLIsk+ZLm/CkFKQhbul
         KSelI5J8Uk3rSG/R8MdoQPsnz02F6GdTQR5V5MDdwlJf7X5E77Pblqm4/9PTCWOhnvjx
         rwsfk1DBA9KdFNcOK/PyXk8PD/Ajj/PCzzBI6VPtkyyayDs6WCeqAy+s3v39I2GS9Abx
         iQqw==
X-Forwarded-Encrypted: i=1; AJvYcCVukMV3ppta74pXsmLjcLLBnVwuUJCgOZ6t3iLCSHsMGqqS6W/8ZghA8lRan8ZBHVMUUq0cMEVChRHe1lub@vger.kernel.org, AJvYcCXdRWkClDQaJw95oMNyFiGtdxkUEfozRN0EHsbXuZ6vJAVYijjJ5N4ghx+Pe+8k5hSJdS088WevWXlS+zc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw41OzwfBNJeTUBl93aVww6s0iWyCCD4wSZ7mK4xFpYHh4fwMU0
	uGm3CdEHIAQZXJMTrSWF1TJWxoUej7+Pj2K1BVhLkP2hU4kprvrE5sQC
X-Gm-Gg: ASbGnctCCI8fgvm4yR1v8u1s/x0mpSgjt8jie8KT8jvirTwklv74GQjpSR7+KOQ75Wt
	7/sckWFRyPRNlc7DEncbV1dDo6k+nsdLk8Oov15/KssrFLDkX95uHcng6Iv9LsaU7j7Bfxuk9jS
	tci5o4B/BmTgHX1Of55MHMVDcVM8Lac36okZuk7F+cdMDI1pehUhdwffj/DIf/DlnAqODRh+bKl
	ygH2mVWRQs/w9lTu4EySD2W8p+H4C3n1GJU3dlIS8hGBhvslRUXH3k7ikypzynzxH5t7y//BAjW
	/XckY02rbJWYSkD3AwK4eL3aAHiPVZJdv0E3lzUYfmk2QPzaxjtovPA9AqJTB1Y=
X-Google-Smtp-Source: AGHT+IFUvGyHpZ0G55OgsZ+L5rcXJKuJV0BFFbxOe9Gz1CCPK1gH8KNx/GR6MT+iyUETgIG6fe7iHw==
X-Received: by 2002:a05:600c:64cc:b0:43c:f629:66f4 with SMTP id 5b1f17b1804b1-45392b98066mr92287515e9.0.1751222256133;
        Sun, 29 Jun 2025 11:37:36 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4538233c523sm141486835e9.6.2025.06.29.11.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jun 2025 11:37:35 -0700 (PDT)
Date: Sun, 29 Jun 2025 20:37:33 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/10] crypto: sun8i-ce - implement request batching
Message-ID: <aGGH7RH8-yHVVz25@Red>
References: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>

Le Thu, Jun 26, 2025 at 12:58:03PM +0300, Ovidiu Panait a écrit :
> The Allwinner crypto engine can process multiple requests at a time,
> if they are chained together using the task descriptor's 'next' field.
> Having multiple requests processed in one go can reduce the number
> of interrupts generated and also improve throughput.
> 
> When compared to the existing non-batching implementation, the tcrypt
> multibuffer benchmark shows an increase in throughput of ~85% for 16 byte
> AES blocks (when testing with 8 data streams on the OrangePi Zero2 board).
> 
> Patches 1-9 perform refactoring work on the existing do_one_request()
> callbacks, to make them more modular and easier to integrate with the
> request batching workflow.
> 
> Patch 10 implements the actual request batching.
> 
> Changes in v2:
>    - fixed [-Wformat-truncation=] warning reported by kernel test robot
> 

Hello

Thanks for your patch, I am starting review and test it.

@Herbert, please me give me time for it.

Regards
