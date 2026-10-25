Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792971611;
	b=f7PzfEiKWOlK5VRQHCZFJxzYwmCN59FbzEnBLZhESczD3g0AtHZ/NRaSxD3DavMabwmU
	 nY0AqO6tmX4ILOgXp2YNPV9HhAwaApweOibdWT/u3gsZaERsQ/ikyt2UTfpJjekU1RtFk
	 1MfNk7BLNA1uoxy4wEJFfC4StJuakT5UW0f0MVl1p4Ez143Ut/4gAtVq+MNA33vM08qJl
	 RJpqZRUimE/PhiSP2JsaKT2SBJqgSvCD/kZZfAED1V5+s9MMiZitDuyXs9s59dl/Ax9xm
	 xhDz20AwhrglkOwJw9iCZmkuBJbuzngyZH/2epSicChzhIKPSBfQrFPW/Sd51zvdFrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792971611;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=epWr+W8bCz61q+78D5mdjQT/Hj6fT8zsD/SUvbjRTeI=;
	b=kkgsCINwGq9zPRVW/h9kvgg8FtXTDT283MvrngC/Li5QU9ijLz0GNPJRpgEiuUgedrxE
	 0bEpYYe++bT/LFPns3DuEy5Ab6bqZF1HrxJBN1gEBygmfGItuLZaM1mOOlJI7+bG8Okgw
	 vHKNzvbuwFqXJDQ0kKfVY7ZRAhb3AwjvEdLzwVNUclzjDAXIdouhNYWr+ftPJRRT+H5AB
	 GMkAMiGx9Lo7RZG7Ej6QNXYdm+MwhHmDYeoLVPGd3zCCDvXW9iHqVZu12ncHtzV5Wngtx
	 VuL9W65N3TfUl9nPZ5qBDzc204J8zZvy50xhHoqzOvgHZTRGcHbIR0N9kkzwKh26wUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hlwWVDG6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8306C606A31A;
	Sun, 25 Oct 2026 23:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hlwWVDG6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98B01F01825;
	Sun, 25 Oct 2026 23:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792971611;
	bh=epWr+W8bCz61q+78D5mdjQT/Hj6fT8zsD/SUvbjRTeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hlwWVDG6p1yTfssRf1GsQhmSRljzd1wTfThvZCUyQjKFxChI8yf8+RqsgI7ygCaYn
	 6xXTx939I2Q2H0iohVy8CWWlQiAtGSqDTUyaK639eaTODttJy6Xxd/2g5y4uEPAtLV
	 qBk2IM88g8/OYm2xSNgO0eMsaO99silqz7cQXpnRL+bqCWUnevyi/TREEpgA3DVnTG
	 H4amnAVwYbohDcua73Of2Px3KD/Ch1bVPZ+jQxu+9P+/5eCO5Zq2jM3BUFWsVbMMux
	 9SJfOs/a+Ldk+7WU5Hbjd7FkUd63uHuXcl/SpGXF+yLly5fcsfLVyrF6FNy/stV+O9
	 J3FaWKWC3w0ZQ==
Date: Sun, 25 Oct 2026 16:40:09 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Check return value of crypto_kpp_set_secret()
Message-ID: <20261025234009.GC148998@quark>
References: <20261025211119.138277-1-ebiggers@kernel.org>
 <at5-ve5Ap7Oyp1Fo@kernel.org>
 <20261025224723.GA148998@quark>
 <at6MlY1kpfa01tr4@kernel.org>
 <at6QqYWELUtDqUUT@kernel.org>
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
In-Reply-To: <at6QqYWELUtDqUUT@kernel.org>

On Mon, Oct 26, 2026 at 01:28:41AM +0200, Jarkko Sakkinen wrote:
> I'm not sure if it already is but if it isn't, probably also at
> linux-integrity turning on Sashiko would make sense.

Sashiko currently has monitoring enabled for linux-integrity, but not
email replies
(https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml#L45).

(Note: this particular patch was Cc'ed to linux-crypto, which does have
Sashiko email replies enabled.  So Sashiko would have replied if it had
found an issue anyway.)

I definitely would support enabling email replies on linux-integrity
(for issues found only), like a lot of other lists already do:

   ["linux-integrity@vger.kernel.org"]
   reply_to = ["author", "list", "recipients"]         

If the maintainers of security/integrity/ would ack that, I can open a
pull request to the Sashiko GitHub repo that changes it.  Or someone
else can go ahead and do it if they want.

- Eric
