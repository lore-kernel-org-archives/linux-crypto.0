Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53542301002;
	Thu,  6 Nov 2025 19:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762458705; cv=none; b=BPxGFUDuzEXuBXY4wRlG+MwVxI309RmjSQqpD8sbEkAVYMNaJsUPLAgMradSKpdzC2NVPEpVz032pUUHBApvhEZrBvhktXjPlXCV9+/gSw0+QCIJx+qhsLCOR6oqTYoL5QSCgS54j73xEuaFbQPXNB3SuRiYW81OCtSD3lUyLzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762458705; c=relaxed/simple;
	bh=j1nqThs17GwNA3HQ/A0bAO+y61WfI0vCdvNcpIIVI0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7cQhNMep1ydZX3Kp8LjjBYKQT6HTWfTCZMpAKRrwTk0yYjv4aDybcAmGLSW1+k0W0u/s10aFg9ZWajeWwLwA2pDA+/iXKWpzDfwpDXLsy9OPz0a8Yd09rBAjvbhKAcTFR2Oy2X+5OeyuXMAO8Wi3yB4PkAvst40YaugSfloqNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ku8tjLpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ku8tjLpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C217C113D0;
	Thu,  6 Nov 2025 19:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762458705;
	bh=j1nqThs17GwNA3HQ/A0bAO+y61WfI0vCdvNcpIIVI0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ku8tjLpZn9OPHJbydRU7gLzhb71B7VOxwwhTuM+6D49u01Eypvvg5berXffNnTRSM
	 XrvByyKlFst/3LSbp27p2/zQTcMTdDrYl4b+8xn1WxRhCiyaYKUNFTXq+/CE+jvFw4
	 AJiRpUk0rWqEE8JaKHOLf6HK/bR+JzQSEDHrY5VZjS1JJ5Bgt51BtyNB8Zku7hhS0v
	 EIOT8kLgmaxP243njyF+UaPfj2OK1T1gvGRNrLREalCh4xbj9SjvFjLmfFX7MfuEDB
	 IhzJl2nZkQ7dHakk2z7neV839/0V+BGXiItOON8gu6ZCq6pxoFVz+YM5/wU/mHZ8w7
	 x9Mojx8MuyjZQ==
Date: Thu, 6 Nov 2025 11:51:42 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/15] SHA-3 library
Message-ID: <20251106195142.GB3318@quark>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
 <20251103173404.GE1735@sol>
 <4188d18bfcc8a64941c5ebd8de10ede2@linux.ibm.com>
 <20251106043340.GC1650@sol>
 <20251106072233.GA117499@sol>
 <55ec60661fb672bdd0696a3bd92e21bd@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55ec60661fb672bdd0696a3bd92e21bd@linux.ibm.com>

On Thu, Nov 06, 2025 at 09:54:59AM +0100, Harald Freudenberger wrote:
> > Also, I'm wondering what your plan to add support for these instructions
> > to QEMU is?  The status quo, where only people with an s390 mainframe
> > can test this code, isn't sustainable.
> > 
> > I already have s390 in my testing matrix; I run the crypto and CRC tests
> > on all architectures with optimized crypto or CRC code.  But most of the
> > s390 optimized crypto code isn't actually being executed.
> > 
> > - Eric
> 
> Well, there are no plans. However, there has been a decision some while ago
> that "we" may support this in the future. But as there are currently no
> human resources available and working there I suspect a qemu CPACF support
> in general will not come soon.

Great to hear that you might have someone work on this in the future.
It should be noted that this is a significant gap that puts s390 behind
all the major architectures (x86_64, arm64, arm32, riscv, etc.) and
makes it much more likely that s390 specific bugs be introduced.

We need to have higher standards for cryptography code.

As I've mentioned before, I don't plan to accept code that uses new
instructions without QEMU support.  The SHA-{1,2,3} code is allowed only
because the instructions were already being used by arch/s390/crypto/.

I see that Jason actually added support for CPACF_*_SHA_512 to QEMU a
few years ago
(https://github.com/qemu/qemu/commit/9f17bfdab422887807cbd5260ed6b0b6e54ddb33).
So clearly it's possible to support these instructions in QEMU.
Someone just needs to add support for the other SHA algorithms.

> Please note also that this is really an implementation of crypto
> algorithms then and as such it needs to apply to some regulations with
> regards of the EAR of the US Bureau of Industry and Security...

Like Linux, QEMU is an open source project, published publicly, and
which already contains many cryptographic algorithms.  Check out
https://www.linuxfoundation.org/resources/publications/understanding-us-export-controls-with-open-source-projects

- Eric
