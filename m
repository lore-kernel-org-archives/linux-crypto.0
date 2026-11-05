Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793867651;
	b=ug1hqo0LX5y7CVjetgVZaji4iGObr6KQwXYjLa82tm0tGbn0OqKhYO6vXje1n68R7V74
	 wgfJGTJukF40QRDTehNQVeECWVbhLs3n3tY5EdKFIcNV+pyevkq14wg1q3yiXkjMJ504w
	 kIGfZD+9t/RVw0Sw/JpeuABg/gU13eYPCmM86/3zTTGlPTFMOXrsMcIHxvD0m3a6cEwCt
	 Cgm/EY+GBdJpBzdJeMMk62HEYC6wpavvOCwY+miS/8wCKXJ8UfoiSjDWLOP3P9jPN/AVb
	 pt7ENBa8ywu93Asi+nV3/4176+zr3ffR3zR9Xv73td2rI3k0OxxsI1UGEBBhInDsYTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793867651;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=P6zJzHowc63hNrslPmkjJoluc08V1uJth2yk4JtAx/Q=;
	b=r29lKKYrFl46Jj2gEnOURQQRvvI/TIal1Njt3k2YSn8syknx8lgTETpc973UzPEtjwag
	 v0yjhGC8CRnvuvv7dA5RIDiL1I2gXjpBLpoSHNhMuUNZkK6fWC6XbwYB7NXZ0UlX0M2Pz
	 R0rmLOR90d6ktz9CRt9nsnOOoxbhAsM49CbXh04x2S14CRe+168t2yxwrxfEu0Y9bu5lP
	 czcOLNWAb8MrmQfS4FAUMGURimA2x7LQhCY669avxwKrKtN+BhvNOyEQP+BVKwoT1Xz1J
	 kpKd7SrP/Hsk5Q3+IcA8XE78q9jl5M9MvMobE9W191O+3MFDAQhSqbR3AfFakvoXwPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PgsB4KG+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 1D0B5606A326;
	Thu,  5 Nov 2026 08:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PgsB4KG+
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 18C8F1F000C1;
	Thu,  5 Nov 2026 08:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793867651;
	bh=P6zJzHowc63hNrslPmkjJoluc08V1uJth2yk4JtAx/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PgsB4KG+YAoQ79kF8S5BnWq41I3LxQihafA1LQ2Q1GYDgrfSetMiFusaqGsfYRoyv
	 v4uLUxCL9SEAlH3BQOLrOCFJlIeEawjUVVlO+GVJp9cNCEVwV0wrYlhYIOHOELRXhx
	 bnjHxsWG7GarO8D02mXITbOdTBrokZPEim8ynEP6g2m+i8HtcskAYfnQfhn78ZVt/O
	 nO9Cj4b2DezjsYwhySxnymrrKfutZFtGtk5Vbf3AG6SjgzmGuNCbK8mMctQkO03+30
	 SUtyhFnIuMdGYo0YiG5AI+Qht4S4WdNZn4IBi+5O9ZzOoMKSGeN9OP8OBHg3IohoI5
	 n+XP28Ae2nY8g==
Date: Thu, 5 Nov 2026 09:34:07 +0100
From: Bartosz Golaszewski <brgl@kernel.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Russell King <linux@armlinux.org.uk>, 
	Eric Biggers <ebiggers@kernel.org>, Demi Marie Obenour <demiobenour@gmail.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, Pankaj Patil <pankaj.patil@oss.qualcomm.com>, 
	Birk Skyum <birk.skyum@pm.me>, linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v11 0/2] crypto - qce: make algos optional and remove the
 BROKEN label
Message-ID: <fbcaiobhykgsgd3zyayvrkuk5lnrjtmwelxkxvbijukdbcw4i5@7e2qyfekariq>
References: <20261022-qce-fixes-broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com>
 <kh74or65txfcprntqqljabnszooj5ppuwizj35flv2r245zbvo@nfue4wdblicr>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kh74or65txfcprntqqljabnszooj5ppuwizj35flv2r245zbvo@nfue4wdblicr>

On Mon, Nov 02, 2026 at 10:58:20AM +0100, Bartosz Golaszewski wrote:
> On Thu, Oct 22, 2026 at 10:57:58AM +0200, Bartosz Golaszewski wrote:
> > This is the follow-up to the three smaller series fixing crypto
> > self-tests in the QCE driver. It makes the crypto algorithms opt-in via
> > a module parameter and removes the BROKEN label so that the driver is
> > built by default.
> > 
> > The dependencies are:
> > - https://lore.kernel.org/all/20261016-qce-fixes-sha-v1-1-3ee5a30d84f3@oss.qualcomm.com/
> > - https://lore.kernel.org/all/20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com/
> > - https://lore.kernel.org/all/20261020-qce-fixes-aead-v12-0-77a2e09abd0c@oss.qualcomm.com/
> > 
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> > ---
> 
> Hi Herbert!
> 
> Gentle ping, can these three series + this one now get queued for v7.4?
> The three dependencies have no more sashiko comments. The ones for this
> one are minor about missing module params docs so can probably be
> ignored or I can send a follow up.
>

Hi, another gentle ping since v7.4-rc1 is tagged. Is there anything I
can do to move this forward?

Thanks,
Bartosz
