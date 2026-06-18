Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248953BFE4A
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jun 2026 09:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781776752; cv=none; b=fvJADY/dHVbbJnAIeALeRw64f5Qb0ZdcMo/MIPdAKQrNrex83htDm+rrLhgBIuwS+UO15l45OT2T65YjZ7nx3Y03gDQPbQXcpXPMIKmd7MbypIQiS54YMV0H6+1PN5pM9SQxDF3g+YbVC536L0v2Us8QOopyFjbk0FcBTxX2tkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781776752; c=relaxed/simple;
	bh=gLUutZyLJxZbKf4agxXUs15ykDIeHM9nhDCepEXWEm4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SwVLIEaV7Z/jzDKqz3u0mpEUnU/zRm2ja8qw4CgNX5dtPI36V2i+IATodh0eqIK97sUpDxae+L+KAlPnt0vxzsAkJJ6K1hq+pQH48hPMBHjpRtbDSzu2bI5uchKbxgKP0wQelslPd+hEBrxBh5iIKJtWmqjT4idJXIeBOxq4FMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=agOj3rAw; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="agOj3rAw"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490b3637b90so5064445e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jun 2026 02:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781776749; x=1782381549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pzjkYvyfaRfjDGoow7iIRFvjI6CXIQdXmrKP5JQFJ6E=;
        b=agOj3rAwyegNduo1VaYdg8EgJ44RWLlQKOCEVJOTCvAFs3jXrg/M1h6r99k6MoUcyR
         xoye7KGNvhn14ZgS0VeU3cT59+3EiKH0Z2wynr8v4FCGY/hR0wDP1bH0TDjLQ90Q8F9Q
         i0Dd7ZXcTHiL3XxXdkmbWGHPfBZlUknAn//9lAieFu40t3EeCdCKB/jhbTUMG10MVdzr
         y8i12TNBH72nVrP7M+G1DCva0JBxzFlbdAQVOzKWEnJSZI1/EYs8vKLtpj7eWo//qNib
         xy8hjLToEknbmLYBpP/+1pJk/XuSsSZetQ955PhuyjZC8PYYaYqSpMzhNULDCMncdukx
         he4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781776749; x=1782381549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pzjkYvyfaRfjDGoow7iIRFvjI6CXIQdXmrKP5JQFJ6E=;
        b=ZPJ10uA1TnGYAnKUdDSAbm4MT3IAboC9XcnJE1wRu7Qps34nFfIRzqk4o+ChUdfl2Y
         dVOU/gUbOCcw08Y29z6koLR3bx2zV1qBzD9uU3d5BN4u/aXgz2pllbs6XIqwM/VbMiid
         VCLWGd/FFujzMuxzmG9/3g1FSXW6nQMQSZayFEBrF5qHgP5foRzN54FrxAs0dg7uuSEp
         Erd61CY8fdzeVzX5eWIUgKf0EGQ5BjNTWP7J0/amn42vV6gtsrgb5zFrMsL7VkXmgQme
         uZ4vVPMAP2HP0m5Ix/z3lT31njJBjj2VFIivYcbmvhKjuKzxjOO8WsA9QEAlIpFx1kYy
         sPyQ==
X-Forwarded-Encrypted: i=1; AFNElJ+OcQ6NZk6a0qGQH8nfdIo3BQdP2mxlhFgVQd2cpyPCtggABnb4JjHzOLNP5H3fBPQXmx+bUIlc6DqK0Zc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBxWZEs36YchFCVHdDpazn1m0d0fwyuWiPiIjxAsFAMBTfmoMa
	cHYPLIBzu+Q4qlXacqFp4wjvSBgIiX4ILgGSEi85/u2Nv4O08RxnQ56m
X-Gm-Gg: AfdE7cnRx0KkHYwoWyMm/DD5i+yloo4rBclJzyprr7rsP817QdPAZIX/xCnVTcHLbyA
	ZBMY0gotWWVwCsoFNjGCNPOK1spkiI3s4jsctZuEPWKZfbuJ0dvasCqBtO9Q3u+wybIr9S4lM1f
	HIsOEUc1vPh5MyG/cCT2YR1H8j0bbVT7EdrPu7RV5iajuDHdSG0XfovYNWl5MJDmKYhV35jJbnX
	4kLdmZ72Qk3eT9rRMC8aai65TjD5OrpWZGiiESek4cNmDeIlDJA9Atlq3/pU2RTntwNu+UYEQGB
	7QkH4/qCjg6B4nLXPgjruNGoh7WDA2LAnnIhBK09eQZLlMxpaHrpsk6dXOXqdYA0RX578smVMUi
	R8rJoEbF8EMIzcs15V1lEx/3fsFcx1GnH2tuQT3pUunYtK63Dq8HKDoln7xlv6WgSQhfllBKblP
	4zykF6r04pE4TL/ImmPZKhKo2SgG94IjcvatDNzWbRgAw0IqSTlw==
X-Received: by 2002:a05:600c:4ed4:b0:492:1e36:85dd with SMTP id 5b1f17b1804b1-49238231011mr48552325e9.37.1781776749410;
        Thu, 18 Jun 2026 02:59:09 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa96f0esm261148635e9.12.2026.06.18.02.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 02:59:08 -0700 (PDT)
Date: Thu, 18 Jun 2026 10:59:06 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH v3] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260618105906.11033b70@pumpkin>
In-Reply-To: <20260618092500.GC17530@lst.de>
References: <20260615190338.26581-1-ebiggers@kernel.org>
	<20260617055653.GB19218@lst.de>
	<20260617110516.0a70950e@pumpkin>
	<20260618092500.GC17530@lst.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Jun 2026 11:25:00 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Wed, Jun 17, 2026 at 11:05:16AM +0100, David Laight wrote:
> > > FYI, one or 2 sources are basically useless as they RAID5 configs
> > > that have no benefits over simple mirroring and thus the numbers
> > > aren't too interesting.  
> > 
> > With three disks you xor two buffers (src_count == 1) to get the parity
> > to write to the third - so that is a valid RAID5 config.  
> 
> Sure.  It did not say it is invalid, it just isn't very useful.
> 

It gives you 2/3 the total capacity, mirroring only gives 1/2.
But for a lot of uses I suspect disks are cheap enough that mirroring
is usually the 'best bet'.
It also means that there are a set of catastrophic failures that can
be more easily recovered.

It is probably more important to ensure all the disks in a raid set
come from different production lines - otherwise they are likely to
fail at the same time.

At least modern disks don't (seem to) suffer from 'sticky oil' which
would tend to stop them restarting after they got cold while turned off.
Raid doesn't help when multiple disks fail to start!

	David
