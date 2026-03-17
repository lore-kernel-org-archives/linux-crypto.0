Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026DE31353B;
	Tue, 17 Mar 2026 03:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773719142; cv=none; b=aXXt1eejTRBXdEPuGi4zOH4EBsKvcdqSuQOmgwbizXjxI93lj2ubKK4z/h8PzAq+IBenkLMJJ3Fl6MCBOX0Li8akCpXBeLf4G15iieiJCC+wStZrfjHqkZ5Bc7CxALhjTOmvnhRaVhP/Ngex9d2J5smTAjWelW3xrhA8YvnMZWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773719142; c=relaxed/simple;
	bh=yP//LXP0yhYsMTrCo6kiuueFfEOJz8sdsLEYQ85ngj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGUAB9gIoDpm+8Pk9LTmJ2l5N9cezfL+1YICUL8OnBNso4OSWsnSwCZctHUJQdcmhG3HgLZYtfoKxJN0urK4/kaDFGCuchBIhAX+dyEedBNPnc/vdkpql5E8+kkfYy3TfA3x9jg0tra+Je3AzjBIX4UTlh0VjjABl4Wrkk58Rx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWzM+OJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWzM+OJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DED4C4CEF7;
	Tue, 17 Mar 2026 03:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773719141;
	bh=yP//LXP0yhYsMTrCo6kiuueFfEOJz8sdsLEYQ85ngj4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nWzM+OJxjMu86d6mcSF25H2FT2DHr0/3GWsfoESHGgG3r9IGDu9Qg4ffKNcnmBJ7d
	 semjD3o4S9JyzdUDcJYJluxcdeD4AIbsIZKVBJxbaTu8j3QgD4WQtSLc/7Yfr+2pBb
	 hmYQKNgfnD1HJHW9XGjEQ2BXjY2cDi9oRGOeuVgb8nfs+5gHpIlEF/3k6kDcltDOTU
	 eap24m4ebZcRF7ckjk5KCFO1QRT1KNlgP75BRplQGSeGGF6ANqMAkhgGkJd9LlQX3B
	 FVstmMyQj2Y01ZgggSZGUf8lBU79eWjrQE/e5f5qnbDff+VG0/lVmNXL+454WM2A16
	 ZHajepEgZHO2Q==
Date: Tue, 17 Mar 2026 03:45:39 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Nathaniel Roach <nroach44@nroach44.id.au>
Cc: Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: Does the SPARC optimized crypto and CRC code actually work?
Message-ID: <20260317034539.GA2705965@google.com>
References: <20260316204211.GA2661@quark>
 <ca9ba2ec-849c-4f86-8ac9-274ac4b5f885@nroach44.id.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca9ba2ec-849c-4f86-8ac9-274ac4b5f885@nroach44.id.au>

On Tue, Mar 17, 2026 at 10:48:52AM +0800, Nathaniel Roach wrote:
> I've been testing some of the PCI changes that have come through on my T5-2.
> I'll happily add some tests for the crypto functions, I've just got no idea
> how to do so.

Well, try enabling all KUnit tests in lib/crc/ and lib/crypto/, as well
as CONFIG_CRYPTO_SELFTESTS=y and CONFIG_CRYPTO_SELFTESTS_FULL=y.

However, will this be a regular testing run, or only a one-off run?  If
it will only be one-off, we'll quickly be back to where we started.

We need regular testing on either hardware or QEMU.

- Eric
