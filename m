Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AF028C01D
	for <linux-crypto@vger.kernel.org>; Fri,  6 Jun 2025 17:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749231910; cv=none; b=cO69ndG0XLai71PJtt7qEZ9o+cYVOWcBr5Dx52O/zSnx+Gsa5LQj16qu3xWEFWxxLJMHXzlr+F0NFRXB6xz9YMlv8ne8TFMFIkqADOEgDtXoTPyYHTr6DfmE5RH0nG/N9Jovwbiw9poe1ivNxMD+ddBpnA7Y9XaZwLiay6vN5Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749231910; c=relaxed/simple;
	bh=+ORhVlnUGeFNmOctuLzQ6BAGRWACw/WrPIscqZyupug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EI8yaTmtBIRB74Ej0L3T2Dhgd90vDp+fgT2kblK9Ds6kbCvO1pnnmeb1QHy+xKZ8dnZqr3RCYC1lT+gn+ZkjONLXKk0dfTMxx+hO0ENtTzGp8olMQ7Ya+6hE01NTIQ9cSGciFwPWFdhzEm0GLVN1nI/EpVW3sPFRB2suzHHn2kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVnIxulq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVnIxulq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10809C4CEEB;
	Fri,  6 Jun 2025 17:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749231910;
	bh=+ORhVlnUGeFNmOctuLzQ6BAGRWACw/WrPIscqZyupug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mVnIxulqsk0Gb6fb7z9YjY9UPVpc5N2ymadio2syJX83Xji1Esbwi5P4rGwxM9g0z
	 Qq66Y4kykYn2uuXee7VDECksrNNCW4w3TgKG0OxdON3Kutyvx0ZrnMJQ1EAohhq+xf
	 4pThRTQz8MtNzT/g47l1aOF2t1BhwGcDhYIxuu7Ku1Kpdz6HbEgo4cLeo5SQfc3X9V
	 xrmblxRev7WtEdxkrfLsYExCDL1Ljilj4pIbOjhrJI2tEb7vm61EwJePKfhmdkIPUS
	 kaux2OImiD9supSHAJf7XfdfICZWNN2EEyoHF3cgEuNR1buEahLVHTX+k2LmJDs6wZ
	 zgTdwAncym5VA==
Date: Fri, 6 Jun 2025 17:45:08 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, dengler@linux.ibm.com
Subject: Re: CI: Another strange crypto message in syslog
Message-ID: <20250606174508.GA53397@google.com>
References: <d4520a75-c765-406b-a115-a79bbdf8d199@linux.ibm.com>
 <20250605142641.GA1248@sol>
 <66d4c382f0fbe4ca5486ccfa1f0a4699@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66d4c382f0fbe4ca5486ccfa1f0a4699@linux.ibm.com>

On Fri, Jun 06, 2025 at 09:19:18AM +0200, Harald Freudenberger wrote:
> > The crypto self-tests remain disabled by default; there's just no longer
> > a
> > difference between the "regular tests" and the "full tests".  The
> > warning makes
> > sense to me.  There should be an indication that the tests are running
> > since
> > they take a long time and should not be enabled in production kernels.
> > 
> > If this is s390, arch/s390/configs/defconfig has
> > CONFIG_CRYPTO_SELFTESTS=y.  Is
> > that really what you want?  I tried to remove it as part of
> > https://lore.kernel.org/linux-crypto/20250419161543.139344-4-ebiggers@kernel.org/,
> > but someone complained about that patch so I ended up dropping it.  But
> > maybe
> > you still want to remove it from arch/s390/configs/defconfig.  There's
> > already
> > arch/s390/configs/debug_defconfig that has it enabled too, and maybe you
> > only
> > want tests enabled in the "debug" one?
> > 
> > - Eric
> 
> Looks like we have no other options than disabling the selftests in
> defconfig.
> We have debug_defconfig - with all the now huge set of test running in CI.
> But for my feeling it was making total sense to have a subset of the tests
> run with registration of each crypto algorithm even in production kernels.
> However, as wrote ... there is no choice anymore.

There's still a command-line option cryptomgr.noslowtests=1.

If you really want it, we could add back a kconfig option to control whether the
self-tests run the "fast" tests only or not.  I thought that the only use case
for running the "fast" tests only was for people who are misusing these tests
for FIPS pre-operational self-testing.  (Which has always been a poor match, as
FIPS requires only a single test of any length per algorithm, for only a subset
of algorithms.  It's totally different from actually doing proper testing.)
Those people should be okay with the command-line option.

I do think the idea of running the tests in production kernels is questionable.
There are enough tests now that you can't run all of them (and indeed you are
not asking for that), which means the production testing will be incomplete, and
the real testing needs to be done in the development phase with a build that has
the tests enabled anyway.  The same applies to other kernel subsystems too.

- Eric
