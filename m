Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B18ADF60;
	Fri, 13 Sep 2024 15:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726241061; cv=none; b=uqlHgrgCV1uowwFilPhhdg3sfg4IevKLpFSZpsLJKk2JzgBO4K9xBYhruS9GqGcRiHATocNQyySRkel8oYWY1+KI6SdpeA/4CTN68VrYJtRU/49pVlvbY6phPTcq3OqUwVDqyjFhPTxLxN3QdAAnREYLOTNRJ7jFXtWC6XGVTME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726241061; c=relaxed/simple;
	bh=TMNMs4HtYJvT6NaxwWsmzpLmeJxFJfj5zW4IvRl5s9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f027HhCi2CRdQ0NDzER4XqRyYxtFlQ9kQbm/wyElzKj+Dn0ubmfseZgNZiDbJLV8cfgzE6AAlRwvSPYIpTguiNP8e+B87LaC3xPpzJ31uyP4ZMgLyiYH7uRVxE7hy9tKTJngBgKbLsN+W+19KvwnGoCF+dYVqiMPpsRNUrY5vnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=kcj+StYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kcj+StYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB2BC4CEC5;
	Fri, 13 Sep 2024 15:24:19 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kcj+StYk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1726241058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6kImf0YUfHWU4wjUSEueON/4b/Zh/8CSocVTzKpWd90=;
	b=kcj+StYkkcTMCbpR8WtjaAX0JckGaUOvQ+4jkXuz8aU4z+bCwCM9mWtQcgBqxRaCoptbHt
	kcJlLxMkXx2AaDRQE6wuFOnGIk6yzfjE9/YTHxCEcK1F8zjKAi5Re30iEbB+5gCjMpTG26
	JQD+grpCggNPIMbZYrLOgqHq/x8TJuw=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e581d9a2 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 13 Sep 2024 15:24:18 +0000 (UTC)
Date: Fri, 13 Sep 2024 17:24:16 +0200
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
Message-ID: <ZuRZIPNBO1BMznUL@zx2c4.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
 <ZuRWmJTWqmD92D8d@zx2c4.com>
 <ZuRYoVIrg28kBKqb@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZuRYoVIrg28kBKqb@zx2c4.com>

On Fri, Sep 13, 2024 at 05:22:09PM +0200, Jason A. Donenfeld wrote:
> On Fri, Sep 13, 2024 at 05:13:28PM +0200, Jason A. Donenfeld wrote:
> > On Fri, Sep 13, 2024 at 03:05:43PM +0200, Heiko Carstens wrote:
> > > The vdso testcases vdso_test_getrandom and vdso_test_chacha pass.
> > 
> > I'm trying to cross compile this but I'm getting:
> > 
> >   CC       vdso_test_chacha
> > /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/s390/vdso/vgetrandom-chacha.S: Assembler messages:
> > /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/s390/vdso/vgetrandom-chacha.S:147: Error: Unrecognized opcode: `alsih'
> > 
> > Any idea what's up?
> 
> Looks like I needed `-march=arch9`. I can potentially rebuild my
> toolchains to do this by default, though, if that's a normal thing to
> have and this is just my toolchain being crappy. Or, if it's not a
> normal thing to have, do we need to add it to the selftests Makefile?

I can squash this into the commit, for example:

diff --git a/tools/testing/selftests/vDSO/Makefile b/tools/testing/selftests/vDSO/Makefile
index af9cedbf5357..66a825278b36 100644
--- a/tools/testing/selftests/vDSO/Makefile
+++ b/tools/testing/selftests/vDSO/Makefile
@@ -43,3 +43,6 @@ $(OUTPUT)/vdso_test_chacha: CFLAGS += -idirafter $(top_srcdir)/tools/include \
                                       -idirafter $(top_srcdir)/arch/$(SRCARCH)/include \
                                       -idirafter $(top_srcdir)/include \
                                       -D__ASSEMBLY__ -Wa,--noexecstack
+ifeq ($(ARCH),s390)
+$(OUTPUT)/vdso_test_chacha: CFLAGS += -march=arch9
+endif

