Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C189E2BFC63;
	Thu, 22 May 2025 20:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747944516; cv=none; b=uKp7k/UKWib7qtqCyBid/bdF6mynfWn4cM09qD1o9muBNskVxVzCIXKntNVw80llJD042smt2T5BSn7eICIowYL8yh2w2bFWtZ4+J2WuTZwJ1zS4KkbIhmOx19RmjO8+/eB1MKPm5JBIL0RGRyEa/8L6uHRDl+q/zXp0qa5q7zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747944516; c=relaxed/simple;
	bh=mPy3mr5xya9Xi/dBCEM+pZNQ1mF/W0TXhY8/tZkQ64E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDBCrrXy3sUSDgeAVYlud0yzqcGOvG6Y7HFtGg5844ZCE8v7plp3uGfw4to6VMZd8kmphp9lBpgfbFXwEw7+V9jTGGdiV7sxegBeBsRups08HRFZqBbiswTxqXeSaP5zlgF4gVcPMli0TIkJ8vhYUzBqrTHGNjN9vZS7Rg5PkT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TpD7najd; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpD7najd"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-442ec3ce724so70873695e9.0;
        Thu, 22 May 2025 13:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747944513; x=1748549313; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+Q7aOB7ZFwI1gM59UHfpkuTc2nYqhOAspif1GidZ49Q=;
        b=TpD7najdGGZLq+7bZOAzONUb3J9kuxxymTsL5HoQeKbjlaLtT2uj8tATX4MbPTN1VO
         9u+hjx+FFyzq5s2aMa5AOpC+/HLJpuhBSdPLHHOVWKdQ3pR2tIK7GknbNPKC3l7PjR1d
         PlEx1yhD+TX/6XrQZ1lPPrzez8sK0yatEBVhTePaozjlJk4PKV5W1ff39r1rdAuOVcum
         1408bQoVzTPCjk3yJfCHzY844IJA4AOR0kc9iMQEC+aoK1xEeDVgE8KqAnWdMtxcEc36
         CEBI99wFwAu9YPA6GMNHZMKusXs+xLsoOcAnpcKuUzdEQ2g5+MR7qknR8dpcw7T19/VQ
         rMcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747944513; x=1748549313;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Q7aOB7ZFwI1gM59UHfpkuTc2nYqhOAspif1GidZ49Q=;
        b=QJjbPjfoGe7hay4FTJgRFOHYqPp4ERpWQK7H3Ihd3/cJ1LIhzvz8nFHU5zHHlrG+0A
         VYiuufmDr/FSf/ajj12hTWxzsNhy9dc6hyIrdX4SKwgRvZMZ6d2j2s2qjvSo4wVA4MSx
         F82OAvPiBS1ygWpIt7HC1gcUPhS36qh5RtAp2fmv0Jhxz5M93zzhsXXfMT9IEnmiLU0/
         5HMmoOD08srtGUOkMmkiYmhnehpVNdQhdGFvo81N1OSJ17WSCS9JIaSEiiT0Ux2QuozF
         yPCknrkkWsbQXBW7F+D1p+h29gZ6dwaxYAraxAg95lx9Lv3FjwZtrBsSGNd18ueIY+1Q
         P3Yw==
X-Forwarded-Encrypted: i=1; AJvYcCVzrzbOaS9igFaF3tVLYSmMIQZh6rLVapoHKQdEUjRB4PplMd4dHcgseKUI2eNw5CJ4iXJvQClcmh+/DOA=@vger.kernel.org, AJvYcCXKBWLO3vyugzidb94R94EK1qVbh+IAYHBY5s7Gg6maiboqsD7gWhocDZqoUFDit5ZhJuAgXztRLlVKzx1F@vger.kernel.org
X-Gm-Message-State: AOJu0YxLZ3UmlylGXtmXKPH9FcBUK8EpbdIC92vBtEdajeg7x1qz7T6i
	qua4ctrKrT3gOyb2efdQK4Aqjqrr2P+KzTKXtf1bMqHnmFek6m0tVvhP
X-Gm-Gg: ASbGncvRzJu5jxzZC+Zmx+2iTvazyGtDV+J5HQ7B5BoPlv73ypgKW4f6dyW/Y+1vysJ
	8BHbpbytp2kZdiGzt5j8WzmofVj0aY0dSuI8hxvH7UVktAVMmg/rz/2WWFlwNv7xUmG5ZXOTVPB
	mdo0FapmJuKlevxp2Kcb5Y3i75q00lM2ayP2ZUJ7iBfuAA6PHiyLsgSXI1J9g+/nAZUIRrIeMWy
	btNYZM7E37kn0TCWLmoWlE4kEWN6yhZ3J//WIiVdE9sKItWKnaeArXZgj7AEbosA60i1cNHk+i7
	rrPU4lnZ/V19nmTAbV6BUBIc5oUa5ExT6Nb+UI+U6U5qRGN7cBuV
X-Google-Smtp-Source: AGHT+IGFt/N9FVg1AtimaYyUbC30MJQyk1oygFeM95h2FVPn9Aj6j/wU4BgvD3UFticCry9NDEBr8g==
X-Received: by 2002:a05:600c:3c85:b0:43d:fa58:81d3 with SMTP id 5b1f17b1804b1-442fd6790f4mr233602095e9.32.1747944512781;
        Thu, 22 May 2025 13:08:32 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a35ca5a03fsm23846036f8f.22.2025.05.22.13.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 13:08:32 -0700 (PDT)
Date: Thu, 22 May 2025 22:08:30 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"'bbrezillon@kernel.org'" <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aC-EPvRG8oBND0wA@Red>
References: <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
 <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au>
 <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <23fe1dec-032a-41fb-8e60-3a1b6c098c4e@app.fastmail.com>
 <aC2p6xkMz4BtzPYH@gondor.apana.org.au>
 <1024b1b7-9d58-4db4-a71a-108f6df7b623@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1024b1b7-9d58-4db4-a71a-108f6df7b623@app.fastmail.com>

Le Wed, May 21, 2025 at 01:36:06PM +0200, Arnd Bergmann a écrit :
> On Wed, May 21, 2025, at 12:24, Herbert Xu wrote:
> > On Wed, May 21, 2025 at 11:58:49AM +0200, Arnd Bergmann wrote:
> >>
> >> I did not see the entire background of the discussion, but would
> >> point out that this is not supposed to work at all:
> >
> > We're trying to find out why this driver fails under concurrent
> > load.  It works perfectly if you do one request at a time, but
> > when you hit it with load coming from both CPUs, it ends up
> > corrupting the data.
> 
> Ok. Which SoC exactly is this on? Armada XP or Armada 385?
> 

It is armada-388-clearfog-pro
