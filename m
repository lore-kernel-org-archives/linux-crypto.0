Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1843C1F76A0
	for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 15:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729007018; cv=none; b=AeaPcO2fYCayJTSsiuslfIvWSa15JTI0wpcJ8+/aLg6sY2VFneQNZVNsHRC/wq2hvIc8O5OtKLIhJ9cWxUFKnnnapxmpnfTxwaYxIL18tVrja3imnQEW/6fLoLbCa/l/Gs5tja+id9J+hBnMk5QoWxMMY9ylkbzMsqI1MxwXF/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729007018; c=relaxed/simple;
	bh=JZsZEu8a63nqxWxE7uiFHZDVVOMB8AmaqWq9XBvDm/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8w0cKEcW38Yq82EjNFOoWD+1afDnDcPW6pKiQW8eErRsYOb+Xs/2s2cln/xrDfTJO5EWVArHN4vA7TOWDaX+YJQz55c88TH2Eo4sY+NFUhUbpkv3J0KcjvfADawSCmvetoJxID7ToMlVPXFWJJvhqBWskrGzcFRCPv1j+Va1NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BWpCJEG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BWpCJEG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C7EC4CEC6;
	Tue, 15 Oct 2024 15:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729007017;
	bh=JZsZEu8a63nqxWxE7uiFHZDVVOMB8AmaqWq9XBvDm/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BWpCJEG75PH7wkHEjafLzuOjttjBUOPhlx8Es35I/V7axH4snu6yF0c19brLgqRhU
	 GfF/4sYe6djz+fyDOl0Xo8zhbvADMOiZMYhrK3hdJFxtEmSDKMJF9EZr3C5314aMre
	 mEfVELz9jQ6LBI9V14+zDVawDRWdOO1tnWUny3m/3a1yqlwh1iIWxw1+cL+Of+JW34
	 axuoxmUYZD+XZMdSerckQbwF1QM9q4od44x1AjA133NGgLhHruHtgaNPTuIjtQKO/I
	 GbGlUfZVJ5Zvkt+pYZ/4J2x+g1W/GHewaxYk2GeUuZ/rH1rHkMDQcrTOtB8/hLNNcu
	 IdvhfoRo8stDw==
Date: Tue, 15 Oct 2024 15:43:36 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ondrej Mosnacek <omosnace@redhat.com>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 03/10] crypto: x86/aegis128 - eliminate some indirect
 calls
Message-ID: <20241015154336.GB2444622@google.com>
References: <20241007012430.163606-1-ebiggers@kernel.org>
 <20241007012430.163606-4-ebiggers@kernel.org>
 <CAFqZXNsoJdJi51CiTxCzsk3Xpt88EeVYDRAzAk8Jgph_DoFKOg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFqZXNsoJdJi51CiTxCzsk3Xpt88EeVYDRAzAk8Jgph_DoFKOg@mail.gmail.com>

On Tue, Oct 15, 2024 at 02:41:34PM +0200, Ondrej Mosnacek wrote:
> On Mon, Oct 7, 2024 at 3:33 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Instead of using a struct of function pointers to decide whether to call
> > the encryption or decryption assembly functions, use a conditional
> > branch on a bool.  Force-inline the functions to avoid actually
> > generating the branch.  This improves performance slightly since
> > indirect calls are slow.  Remove the now-unnecessary CFI stubs.
> 
> Wouldn't the compiler be able to optimize out the indirect calls
> already if you merely force-inline the functions without the other
> changes? Then again, it's just a few places that grow the if-else, so
> I'm fine with the boolean approach, too.

There's no guarantee that the compiler will actually optimize out the indirect
calls that way.

- Eric
