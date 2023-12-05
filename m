Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3725A6DCE7
	for <linux-crypto@vger.kernel.org>; Tue,  5 Dec 2023 20:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sFOoFwCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D17C433C9;
	Tue,  5 Dec 2023 20:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701807479;
	bh=+sOVuGQTHakB8VRJfxizueBU+kU+hnIPPk6ZDFu2jqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sFOoFwCUMlw4eoBMqBmvRBvk8taIahIEAGV0JvGBPP7v1xrAmZj1nMD6ylXD2kDDH
	 0GAHaeqygoU/v6nHkgf8e5wdF0b/+uXEFnebtGGtsyG2ObT5Qd6U1pPoPImjTB/nIX
	 BROtoRk6NI/QBSeZkSvO3c33QRSs0TtMHvC4meWrZXirTwAsk2fWgctG3CPsOpheCz
	 Mscs81D0yenr+lumrxgNNEjM6HBwSVLCmZEp/JL/klPHb4DGbBqDjcL8jiQAj+5hPc
	 BsrTt9zadc7KxKWgoBbFDese0XYQXOrcTFfGnmZZnN4ZwRWTC3PweskiIsLeFHKUzV
	 yN0G+kpoQSRXg==
Date: Tue, 5 Dec 2023 12:17:57 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 4/8] crypto: skcipher - Add lskcipher
Message-ID: <20231205201757.GB1093@sol.localdomain>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <20230914082828.895403-5-herbert@gondor.apana.org.au>
 <20230920062551.GB2739@sol.localdomain>
 <ZQvHUc9rd4ud2NCB@gondor.apana.org.au>
 <20230922031030.GB935@sol.localdomain>
 <ZW7iKEs+GNOrkvxf@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW7iKEs+GNOrkvxf@gondor.apana.org.au>

On Tue, Dec 05, 2023 at 04:41:12PM +0800, Herbert Xu wrote:
> On Thu, Sep 21, 2023 at 08:10:30PM -0700, Eric Biggers wrote:
> > 
> > Yes, wide-block modes such as Adiantum and HCTR2 require multiple passes over
> > the data.  As do SIV modes such as AES-GCM-SIV (though AES-GCM-SIV isn't yet
> > supported by the kernel, and it would be an "aead", not an "skcipher").
> 
> Right, AEAD algorithms have never supported incremental processing,
> as one of the first algorithms CCM required two-pass processing.
> 
> We could support incremental processing if we really wanted to.  It
> would require a model where the user passes the data to the API twice
> (or more if future algorithms requires so).  However, I see no
> pressing need for this so I'm happy with just marking such algorithms
> as unsupported with algif_skcipher for now.  There is also an
> alternative of adding an AEAD-like mode fo algif_skcipher for these
> algorithms but again I don't see the need to do this.
> 
> As such I'm going to add a field to indicate that adiantum and hctr2
> cannot be used by algif_skcipher.
> 

Note that 'cryptsetup benchmark' uses AF_ALG, and there are recommendations
floating around the internet to use it to benchmark the various algorithms that
can be used with dm-crypt, including Adiantum.  Perhaps it's a bit late to take
away support for algorithms that are already supported?  AFAICS, algif_skcipher
only splits up operations if userspace does something like write(8192) followed
by read(4096), i.e. reading less than it wrote.  Why not just make
algif_skcipher return an error in that case if the algorithm doesn't support it?

- Eric
