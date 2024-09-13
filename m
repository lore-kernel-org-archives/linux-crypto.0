Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A0252F62;
	Fri, 13 Sep 2024 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726240935; cv=none; b=DMr+moUAzL/tleeBRiTo8ID9KZydn4/e3md0QjTKqlv5WooqpAYj4TYoZFRPdXsZNwrOIaTWdG+DEtt6s4U1ebcKvcZQAIZ89A45NDflb3S7gd8ae4gS923xW2jt1B6TXzxL/xXowJ3MkITsfj62BacnDRtgP62o4W69o4e7ITI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726240935; c=relaxed/simple;
	bh=E1mAweoM0WQOrjoYMtIBQojN6tZpium4G/xGGuM7V2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zi3H9tET2uWH3mKP069pozWwQ4hUO2qhJEyXHvHhrWo+n/e0fSPZPGRr+GkutVDLsPfI6hglH8Fq5Wi1pGOxSf7dl3mjb1FoWwGLzMNIj95UEmM6AlqkfYxpC8xcMs/reZgPSF49Mcnb4ltVn2DUCN1S4CI4jYOsKqInGlPJK68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=EIk2OQPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EIk2OQPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E814CC4CEC5;
	Fri, 13 Sep 2024 15:22:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EIk2OQPJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1726240932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zJNOY+OFeNaq+GEaxuUUnHVqXgthaEYmHO3M63EiYSM=;
	b=EIk2OQPJ07gsqhPcawn38Igi1aKldCOpPJlVNHIVh6qvH/CB3GLk5vIanf0uTpm80X2F8t
	wPw959I3fXAwToxkEuWYFAKCzL9bp3l2nxMNHkkjEXwaI6beJt1SKPp3bbDQlAK335Ak0b
	c138e/RyQBBNqRBmsPqbZY8eA8pBnQo=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a465ab60 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 13 Sep 2024 15:22:11 +0000 (UTC)
Date: Fri, 13 Sep 2024 17:22:09 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 7/7] s390/vdso: Wire up getrandom() vdso implementation
Message-ID: <ZuRYoVIrg28kBKqb@zx2c4.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
 <ZuRWmJTWqmD92D8d@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZuRWmJTWqmD92D8d@zx2c4.com>

On Fri, Sep 13, 2024 at 05:13:28PM +0200, Jason A. Donenfeld wrote:
> On Fri, Sep 13, 2024 at 03:05:43PM +0200, Heiko Carstens wrote:
> > The vdso testcases vdso_test_getrandom and vdso_test_chacha pass.
> 
> I'm trying to cross compile this but I'm getting:
> 
>   CC       vdso_test_chacha
> /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/s390/vdso/vgetrandom-chacha.S: Assembler messages:
> /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/s390/vdso/vgetrandom-chacha.S:147: Error: Unrecognized opcode: `alsih'
> 
> Any idea what's up?

Looks like I needed `-march=arch9`. I can potentially rebuild my
toolchains to do this by default, though, if that's a normal thing to
have and this is just my toolchain being crappy. Or, if it's not a
normal thing to have, do we need to add it to the selftests Makefile?
