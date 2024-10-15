Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C991DD0E6
	for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 15:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729006872; cv=none; b=HES88FOsgUczBNRonelMBA/udswUGXWjvR+h+wCml/ZrPe4KFvv8xRwBqjl6QlsigGO/Hf++xDAy4M3I9OABPwZ+witWCn0ixA55TwI2exOoN5MV9EXetVgK9Sm7DlPjY60FFDhEtIkt4BY4eWxSk2EQESt6RA2WX8JXz7J8mpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729006872; c=relaxed/simple;
	bh=+jKJ64SK4ZGAg+8G5e2+KkhtdAvZb4xHyEmmlb7iVZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=maWfDwVkVGWRYjT8c7trkI+mxbrfIc2bBfBGtg1/VXzcvG9TtTWlvD0o4aKYcSYUgpT3kv1fPcD5XXLvsAEbCAHbMbGWffiy8pRJAokGvDJE5m/B48ZIBetAyN3ltpEvI5HqXO9Hj4lzhxp2wsurIh7lAHs66hqA1cL+qXIlvu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOB7/oHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOB7/oHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176C4C4CEC6;
	Tue, 15 Oct 2024 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729006872;
	bh=+jKJ64SK4ZGAg+8G5e2+KkhtdAvZb4xHyEmmlb7iVZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lOB7/oHmaVwN0NAVVEIsObSvux2XZ7DCnlQpe6JaIQ5rq23iqNJf1WA6zDgljn1zL
	 g9X/JVq8X5vC9AB0KG+N4VFb9cP5AqmqF4Ti13FLsQV8FWvTiz6IOHTrJiZ/97y4r/
	 lnp7oh/bWXyIVNtTfv/x6jmEVL4f0yM5rzdteYwpSSrn8oM/mkcmQqAsPyC2E6PK2s
	 ESS7NVodOvX95UX7AonBNSRefIaJAY7DYkt99uJe57dLZp1293okq4sQ4lFrdQGvIB
	 J6DaDsc/v0Bo/fBdITPFgtkoOfTeg8tiDZ7p3o2Mb2rP36bwnMweVs9m7WWt1YcRTK
	 d40zgG5i9eBAQ==
Date: Tue, 15 Oct 2024 15:41:10 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/9] crypto,fs: Separate out hkdf_extract() and
 hkdf_expand()
Message-ID: <20241015154110.GA2444622@google.com>
References: <20241011155430.43450-1-hare@kernel.org>
 <20241011155430.43450-2-hare@kernel.org>
 <20241014193814.GB1137@sol.localdomain>
 <e9ea2690-b3ac-47f0-a148-9e355841b6d0@suse.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9ea2690-b3ac-47f0-a148-9e355841b6d0@suse.de>

On Tue, Oct 15, 2024 at 05:05:40PM +0200, Hannes Reinecke wrote:
> On 10/14/24 21:38, Eric Biggers wrote:
> > On Fri, Oct 11, 2024 at 05:54:22PM +0200, Hannes Reinecke wrote:
> > > Separate out the HKDF functions into a separate module to
> > > to make them available to other callers.
> > > And add a testsuite to the module with test vectors
> > > from RFC 5869 to ensure the integrity of the algorithm.
> > 
> > integrity => correctness
> > 
> Okay.
> 
> > > +config CRYPTO_HKDF
> > > +	tristate
> > > +	select CRYPTO_SHA1 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> > > +	select CRYPTO_SHA256 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> > > +	select CRYPTO_HASH2
> > 
> > Any thoughts on including SHA512 tests instead of SHA1, given that SHA1 is
> > obsolete and should not be used?
> > 
> Hmm. The original implementation did use SHA1, so I used that.
> But sure I can look into changing that.

If you're talking about fs/crypto/hkdf.c which is where you're borrowing the
code from, that uses SHA512.

- Eric
