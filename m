Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17C12C6B0;
	Thu,  8 Feb 2024 04:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707366972; cv=none; b=XWLoFpFVev5B8ZVEZEupMhATwnaqpEkHKZo6EjctA/FyBB67kSBlKicaT0e0E9+H5PXpVALkwV0WmBfvo7Kin6z1aU/PyTGqp6mYOI2kofaEB2sd8eJbCT8dBubVXqxypNc7RkDaLEFeqIG1RkEYf/PkvWPFG7um4Bd8T/5IGfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707366972; c=relaxed/simple;
	bh=eRBc1wEUZT7QcGKf0MvMI/BhD33ksuk1JOQTxl5173Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DJvUs+FGAK/AyLfKzXOih3cZ8zGxyZABzZNYDnonL7SVeZIQyS4HdnyX5Yh67NTe1sHYAtyzl9/pPnJ2qNaOuY1nJVW7t3nezJqXdPhln8A+nbXlRHW168CM6pdQx8TzrCQ6eIJwzoqQSdUUz7y5P7DFYfSTDDvx9iHu2NXX0/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ey4rpNhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ey4rpNhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09625C433C7;
	Thu,  8 Feb 2024 04:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707366972;
	bh=eRBc1wEUZT7QcGKf0MvMI/BhD33ksuk1JOQTxl5173Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ey4rpNhGYVZde/rqWa5A9iC4sEuMAn+buoWy2+57ZsLy+3O9sbQLY3lRklLB+Q1bj
	 F9eudHJziSzYNIYsFQebhQGsZEv+CzXJthkoRE8lXXWztmHCbfY5Ja3Sf7o4f6C5bz
	 XEohWoXkbLVynIb0Gj3iPxG0R2mpx3EXfb7kDgok56wT0PJTRcm5ee/tBqtKLh4GuM
	 z+urj7dpXFzgOxQ2gDUC2sBvJrEwqHPRXQJeX01GlVsE/QHGWzHVddwLNS6lwMrWRE
	 l4NR6OVZszWq54QyiE2T5kzZq5vwVgHlgeJhlpds1o0SkcZPivbyeMk9P4CH6QHjXA
	 +JkiGReyjpeuA==
Date: Wed, 7 Feb 2024 20:36:10 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: A question about modifying the buffer under authenticated
 encryption
Message-ID: <20240208043610.GB85799@sol.localdomain>
References: <f22dae2c-9cac-a63-fff-3b0b7305be6@redhat.com>
 <20240207004723.GA35324@sol.localdomain>
 <1a4713fc-62c7-4a8f-e28a-14fc5d04977@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a4713fc-62c7-4a8f-e28a-14fc5d04977@redhat.com>

On Wed, Feb 07, 2024 at 01:51:51PM +0100, Mikulas Patocka wrote:
> 
> 
> On Tue, 6 Feb 2024, Eric Biggers wrote:
> 
> > On Tue, Feb 06, 2024 at 10:46:59PM +0100, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > I'm trying to fix some problems in dm-crypt that it may report 
> > > authentication failures when the user reads data with O_DIRECT and 
> > > modifies the read buffer while it is being read.
> > > 
> > > I'd like to ask you:
> > > 
> > > 1. If the authenticated encryption encrypts a message, reading from 
> > >    buffer1 and writing to buffer2 - and buffer1 changes while reading from 
> > >    it - is it possible that it generates invalid authentication tag?
> > > 
> > > 2. If the authenticated encryption decrypts a message, reading from 
> > >    buffer1 and writing to buffer2 - and buffer2 changes while writing to 
> > >    it - is is possible that it reports authentication tag mismatch?
> > > 
> > 
> > Yes, both scenarios are possible.  But it depends on the AEAD algorithm and how
> > it happens to be implemented, and on whether the data overlaps or not.
> > 
> > This is very much a "don't do that" sort of thing.
> > 
> > - Eric
> 
> I see. So I will copy the data to a kernel buffer before encryption or 
> decryption.
> 
> I assume that authenticated encryption or decryption using the same buffer 
> as a source and as a destination should be ok. Right?
> 

The crypto_aead API allows the source and destination to overlap, yes.

- Eric
