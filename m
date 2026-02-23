Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF1D125A9
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 04:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771822001; cv=none; b=QR6mJIt3sZOaQrqsO62w5tAi/u75qbWpWgkK7NWQ2gvny0iPJNP4YMN3+ac9/8wGD6SPmZpWPLVMjJjDmxV5AixOVOg2FBRYPyLu5gQ+b+QV1O7nep3oaJQM7AKfXXppBfWkvTjQLkB7HhhNuWcwnvkFpn32KGscs4uAe3rxk38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771822001; c=relaxed/simple;
	bh=z6EgHj0RhN0MwewS0wFDPuOmfnSGCGIMiPjxDhbbsog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dVC5v0RHVb8mvbR4Ro9VYY2Z20DRO78kgvM41QWaZM9iJtTFNCqNIzcVzUFzixnfaVCcnjSUf5tfFHQuBgcldue8V8Nnjp/1+gsavktCxDFo8877BodbU1en9JDMh7q4P5SdYtpM1eIjQYqiJIZ/sPtm20YTzjNZBBGfkNIhOqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dRFOf6d8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dRFOf6d8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226C4C116C6;
	Mon, 23 Feb 2026 04:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771822001;
	bh=z6EgHj0RhN0MwewS0wFDPuOmfnSGCGIMiPjxDhbbsog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dRFOf6d8Jllc9NUW9qrWOjYwZLF8ppJCMGCYVp/muRjUgkqVK0KMZjeG7VyZZfZ11
	 HAxMj0qkM2eNVzsr7x27lUuqLbLWUvieWkGO6aRTi0KhJk8J9WOXnWS+RVnhRIurA5
	 INkc0ay+Wv0cJYRims1ZQv0NuQgp2QzkuzoQ0wlM7poUeOekk6v7qaUS0W/UAHvGWS
	 Bl4hP15mwm61b43XCr5BC2O6+K2iKDkhy+1YKHTYJy6uztjyokgUbwmU276gv/wrHp
	 /Fo4DJySzWuoiJg9WX3UJI8F5hOg9pMdhF0WdqhQXoH3gmn0ES5zD84hLOod2zAkS5
	 mUiF6TJm6Yd2A==
Date: Sun, 22 Feb 2026 20:45:51 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Manas Ghandat <ghandatmanas@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	herbert@gondor.apana.org.au, rakshitawasthi17@gmail.com,
	security@kernel.org, linux-crypto@vger.kernel.org
Subject: Re: Null deref in scatterwalk_pagedone
Message-ID: <20260223044551.GA58799@sol>
References: <e3044be2-1f05-4cfb-99e4-39dc09e4aeb4@gmail.com>
 <63fdfca0-5165-4307-ae8e-c25cbed7f8cb@gmail.com>
 <20260222202123.GA37806@quark>
 <1205234f-6ddd-4369-834c-6415f8fe0265@gmail.com>
 <2026022305-handoff-maverick-13c5@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026022305-handoff-maverick-13c5@gregkh>

On Mon, Feb 23, 2026 at 05:14:05AM +0100, Greg KH wrote:
> On Mon, Feb 23, 2026 at 09:32:17AM +0530, Manas Ghandat wrote:
> > On 2/23/26 01:51, Eric Biggers wrote:
> > > What kernel feature are you using that does GCM encryption?  E.g.,
> > > IPsec, TLS, SMB, ...  Is the code in-tree?
> > 
> > I was fuzzing the TLS subsystem when I found the crash. And yes the code is in-tree.

Okay, the issue is very likely there then.  Once you find a reproducer,
you'll need to report it to the maintainers of net/tls/.

- Eric
