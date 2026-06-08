Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A1F330D22;
	Mon,  8 Jun 2026 17:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780940364; cv=none; b=JTtc8bnJywOx0zuhBmAKmamfCdkXcOF0LfqLhZor9Runr/F8k9Z9qQOvQqFlqn0pnVMvgMlYc6OXaQo5LSKBmDnff0DHNN6ZWX9BKJWDM1Iw2T4U2apg/6dU1v/kyNi16qLFdS/gzsEW6e3vd+4vEEkERRfTbFaIekdw6FHn7nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780940364; c=relaxed/simple;
	bh=kjuuTA+2zo1Sy21QxYhdYY38lkqEmpjpG2N3F2vbpu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uAVhqo82UrLeDYuM31aODvtMhxZGLWl+6LfB2o+PTyKiIMpbSpCdH6dL0zEhopQw4a8HBl7pwFo9dtuQNQcIvl6RCizD+Mkaha77ZDnlFM0AvKdC3Da376BDxSZi4a3R669btJjlUVyR432WKC0p8gp2uTMCF4sGX50ifSVZxrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0y6iulC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0y6iulC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25A61F00898;
	Mon,  8 Jun 2026 17:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780940363;
	bh=+8PPMuj7dGYYt4XZ8QyUH+ZS/fjh7w4LNN1e4bdDYcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F0y6iulCxiJ7espj/aaFftje5GZg6sp2tjcFwRkbDbfaPM+/3sSSo7iOZhSKV9rPo
	 7ChEDOcNsIocJxqW6NY6eh06k24Vn3JxAMzwyK6LIN/DGR7GrxLFxuwwPGen8Ey9L3
	 M8k9eIA/Y+q85DF3MxzULE8Jwm5pysZnDt6SAiZ6dqdtAxndTsb1alN1VPcttrFU/J
	 9vdPMI+yq6vWNclo+TDVkN7cwhaj4iW3PfQGv7E6e6yf1Eab9oGiU3Kty5dkul4PCP
	 S450grpOsUe8+zHvrlZR8tVZyCCjCr5BiOfSwiD/mubG1DWVvZ9ssQK/9kEXb3x+jw
	 s/0oGmkljGNdw==
Date: Mon, 8 Jun 2026 17:39:21 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org,
	David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next v2 0/5] Consolidate FCrypt and PCBC code into
 net/rxrpc/
Message-ID: <20260608173921.GA434331@google.com>
References: <20260522050740.84561-1-ebiggers@kernel.org>
 <CAB9dFduBir-41_Ef4noEJPHsFU-++JHDxMU-6S7B8pBYynvadA@mail.gmail.com>
 <20260603050557.GB18149@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260603050557.GB18149@sol>

On Tue, Jun 02, 2026 at 10:05:57PM -0700, Eric Biggers wrote:
> On Fri, May 22, 2026 at 10:06:49AM -0300, Marc Dionne wrote:
> > On Fri, May 22, 2026 at 2:07 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > The FCrypt "block cipher" and the PCBC mode of operation are obsolete
> > > and insecure.  Since their only user is net/rxrpc/, they belong there,
> > > not in the crypto API.
> > >
> > > Therefore, this series removes these algorithms from the crypto API and
> > > replaces them with local implementations in net/rxrpc/.
> > >
> > > The local implementations are simpler too, as they avoid the crypto API
> > > boilerplate.
> > >
> > > I don't know how to test all the code in net/rxrpc/, but everything
> > > should still work.  I added a KUnit test for the crypto functions.
> > >
> > > Changed in v2:
> > >     - Added missing export of fcrypt_preparekey().
> > >     - Write "RxRPC crypto KUnit test" instead of "RxRPC KUnit test".
> > >     - Rebased onto latest net-next where decryption now happens in the
> > >       linear buffer rxrpc_call::rx_dec_buffer, simplifying the code.
> > 
> > Looks good in testing with our kafs test suite, forcing the use of
> > rxkad with encryption.
> > 
> > Feel free to add for the series:
> > Tested-by: Marc Dionne <marc.dionne@auristor.com>
> 
> Thanks!
> 
> If there's no more feedback, could this be applied to net-next?

Any update on this?

- Eric
