Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2C92D0606
	for <linux-crypto@vger.kernel.org>; Fri, 22 Aug 2025 09:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755855281; cv=none; b=eAmGBxol7KFckv1p0viEw394KHvNxvjiT4cIP5Lwcqm8lKanGabAlYfF0dEfmnvBiyQ0iPZmewylhRL9GiWrghBYdY7gFfAulYq0RRjzF26ofdX6NNLTbYIEe1z+/8Igb8DqR5LEOuIT5OGZsqqnxhGVME17uthGztvlPmtnni0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755855281; c=relaxed/simple;
	bh=e5R7eghflsk1piijHRAlbwlTjoAnUnduLUtv5FtDdKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TB4oOYhkB4Dd8vS/pO1DGG+tPghuxncPQ0K85pF5OdKt76UBEQp3ZwhgqonnDr04GsOTTq9y573s1jgRr4Tf8m7VtX0ghq32ND7aGZm68FO/vplCAHv/mQnrge96R/k8xHHEKEThJ+zcRMJ2bmiFWHEgCvD25rETpKmn6/5ZHto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dEEuTv1H; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dEEuTv1H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cPPLgqCLkLJksa9/WiL5Y1gp/vubHHnq/ftdwrKY7Uk=; b=dEEuTv1H2ECKyoGsCCHd8nMlOr
	bqJGpYjXGUvnHS4dxPnrB8pjZF+vzqMbrV3/IbIcCTitwCirTjJyY2FHZ9zWRJez4Wb3O3hO3a5hu
	YwbqNwRxmfQZ2UiCD02ldMYKOswq0wgGrtu3PT/xno7opYINIvnId29nGeCO7hx0DvuRL6Ko+sm6f
	G/0eI0GnjKl9pkFIedryTuK8K6j3Iu1RW2LH0ZXK/vRzi0lpqiuhNvv+VSL3FmOQdZLejKmP2jqdt
	13MvH+Kttr3mK0+a03O6N6SMjvydkgl35Fk71AIWneAUZ8c8SVlVvnHDJwalmfiYTosU1WUq8A73W
	WMd/fDqQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1upNuv-00GN7T-0f;
	Fri, 22 Aug 2025 17:34:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Aug 2025 17:34:33 +0800
Date: Fri, 22 Aug 2025 17:34:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Fabio Scaccabarozzi <linux-kernel-h80g23@fs88.email>
Cc: linux-crypto@vger.kernel.org
Subject: Re: Bug #220387 - 6.16.0 CFI panic at boot in crypto/zstd.c
Message-ID: <aKg5qUBqzVY7VHj1@gondor.apana.org.au>
References: <0e568af0-7eb7-4b19-bba0-947e95418c56@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e568af0-7eb7-4b19-bba0-947e95418c56@app.fastmail.com>

On Sat, Aug 16, 2025 at 12:44:18PM +0100, Fabio Scaccabarozzi wrote:
> 
> I reported the bug in subject on the kernel bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=220387
> 
> Kernel 6.16.0 crashes with a CFI panic at boot in crypto/zstd.c (am compiling with Clang+thinLTO).
> I bisected, did some digging and managed to produce a working patch (I'm not sure of the correctness of it).
> Can you please take a look at the bug and apply/rework the patch as you see fit?
> 
> I guess this could be added to stable in 6.16.2 then (patch still applies cleanly on 6.16.1).

This bug is already fixed by

commit 962ddc5a7a4b04c007bba0f3e7298cda13c62efd
Author: Eric Biggers <ebiggers@kernel.org>
Date:   Tue Jul 8 17:59:54 2025 -0700

    crypto: acomp - Fix CFI failure due to type punning

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
