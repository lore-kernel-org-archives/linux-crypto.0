Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52804435514;
	Tue, 22 Sep 2026 05:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790053913; cv=none; b=o7IHzwpyQnawunFF+wAcVLTz6XSEg2ZD7SCqe5ubF1AxgfFw6Gemvzj1OAFnrmPB9oNVEQeK1/Tg0Bs2jllaVAQ4PCRzygQVMBqUEzVAcIcTHCNggYkQ1LneEPK91wHMlngwUYKah/2JskSqyMGEH2aylbgwbe4WCDPGOCQDaPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790053913; c=relaxed/simple;
	bh=1pq1nYEo3ssExuXyYvHc+c/oL1tdGtu8bUmaII1bkuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOxFTSrDWrX0Up6DCSrcGtHUHhTB9OKjVwOsjf2/WmUb9WWnaMEFksuaT2W5Vbp/A7IQEoB8di5G1pIAqVG4+Tywlx56NNqQDDHINhqcK2tctXVkHsjIuODkCnHG27JndSDMCjrhbyKgYGJmtF4ZikE3mVRQ4wml2nMmjQaDXz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=om++4iho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="om++4iho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06D11F000FF;
	Tue, 22 Sep 2026 05:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790053911;
	bh=JR64kojB8IEX61+Qa2f8PD31EGcnoUNy72lZHou+CSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=om++4ihofHdwtzLuf2/bKsFvqszIYpGtQMboKeozFc31uZGOwVPNN5yxb5G8DSkqt
	 3HtUIQCDa0E/Hhp6aokAMYakD31KTsvhIRvS1ZeDwZu1sJdei1QaChLYm/mKVFRK+f
	 OKKnOK+NdsAj+wLxb6PwGHBvFm06xMkvzzczNsTRQa31rQ8DXqZjn9bFdRdqU1KXI5
	 hrp272+cSlTKP/4shbNuad7s5ak1NgE4mbw7YfJKqmDUEUIu/ByrleJwr4uqAgNRMq
	 gI6dMOEZ9jWrRxjMeS+ufnbi33iyNMq8mt015KTzBcz9zuEArLLhYsD5Atb2ghYk5h
	 Qk39gy/FdO6aw==
Date: Mon, 21 Sep 2026 22:11:50 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH 09/20] crypto: x86/aes-cbc - Remove superseded CBC
 skciphers
Message-ID: <20260922051150.GB14616@sol>
References: <20260921050910.296144-1-ebiggers@kernel.org>
 <20260921050910.296144-10-ebiggers@kernel.org>
 <20260922041519.14996-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922041519.14996-1-kmehltretter@gmail.com>

On Tue, Sep 22, 2026 at 06:15:19AM +0200, Karl Mehltretter wrote:
> On Sun, 20 Sep 2026 22:08:55 -0700 Eric Biggers <ebiggers@kernel.org> wrote:
> > Now that the AES-CBC (and AES-CBC-CTS) library functions are optimized
> > with dedicated AES-NI code and exposed via the skcipher API via
> > crypto/aes.c, the similar implementation in aesni-intel is redundant.
> > Remove it.
> 
> Hello Eric,
> 
> This breaks the 32-bit build from here until patch 13.
> 
> After this patch the only callers of aesni_skcipher_setkey() are the
> CTR and XTS skciphers, and those are under #ifdef CONFIG_X86_64. On
> i386 the function is left unused, and WERROR is on in i386_defconfig
> and allmodconfig:
> 
>   arch/x86/crypto/aesni-intel_glue.c:104:12: error: 'aesni_skcipher_setkey' defined but not used [-Werror=unused-function]
> 
> Patch 11 does the same to xts_setkey_aesni(). Patch 13 removes both
> helpers, from there on it builds again. I built every commit of the
> series with i386_defconfig plus CRYPTO_AES_NI_INTEL=y, gcc 15.2:

Yes, I'll rearrange things to stop building aesni-intel for 32-bit
before getting to this point.  Thanks!

- Eric
