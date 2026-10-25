Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792964279;
	b=1H5sTAGAcO7rWpgiCdn37mHMRWXBdi0Xn2gCO5J6kqfUGzvAWPUfLouLo9OD7XpccFUj
	 /Etb8gr7cGJ37GiGsP3h8Tw3cxEqPzr3aX2G2FeKOdOkyKRq7bp1SVTzWkLSvB2mTjkgE
	 PxZ+SasxTd/0tr6P84R7YxkSNUdLWLQt3L5n3U7A+N4cqQ02ZWwgmx/j5+S/kzi6i7FD8
	 FmyFheaWRBAqzANedXZF+077j+cyFnQqcRWNM9gNaqA8fyZ9HX3HlVv3ldb1hqHFb2WvH
	 u1LE82x7+feNB2Guf5VFf31hhGO7s7YhNiSKL1XU0vY8vr/1ZF5ZgmfxiOZSUIIS8zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792964279;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=Wemrv9pWqZuiCjN004cJnH2yBeY7+jCDcmEYdpu0Xb4=;
	b=XzEml+XTEPBZePH0bscVALJLdCzrn0/27Q8ofpMnU/B48fvQbkaBDhZ+KWZ68F5Q3xfw
	 k35WWzAIspVgmyw87dXZKeDnNOKXKtaV5ytL14Mu0yiYyHQgnrfUMmHxQUeEo8dE8CFPM
	 yL55bFq9l/XclcxynJi0z5Dut4MRRmy57cMIwy5zCmcdMQHaMxSlQyFVEmhFHCFZRH2/s
	 zvsbcbBRv0BDSs8RSy4EmkA8/+/ZTjBOzHEOVa8PFRQrSDHp58u+FUBF6h2stOpvyecGv
	 FUU2R5GUO5o2VCqOM373jw8SLK5PoIYo5D5Gm9TmnJ0Y7P3mKJsbqdxF1/RGi6Ikydw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=QQHcXoGb;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF30606A31A;
	Sun, 25 Oct 2026 21:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=QQHcXoGb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Wemrv9pWqZuiCjN004cJnH2yBeY7+jCDcmEYdpu0Xb4=;
	t=1792964277; x=1794173877; b=QQHcXoGbnZqceLv7OJffiPX1PIhUQrb8fFgvWJQbbZjC8wh
	oaCSlUwpl/qnADG47U3N2mrBmq4QCH4QeDlXlhG0gNnOwYD9sFae1BZaFXlrYSvbwZHW9Em65zbje
	zjQDpH5OH7pj18+Vm5o2Ajc/RcCbpdm63joFcWW+oyUQQAucrC03iOTCNc+yUJ5CYiRxQVPtizHc7
	pniwIFEWDcWAGMmU5htKYrLDJtzzk8+VE7PAD+OWdQRuzxKU4JUeJ541JQOcaZUQAesLY6Zg65gCl
	eoaJnoPTbPFTPXkyDtsZkwGBTrYzkf/PxHI2lj143nTfrq7xdjExVuz8qXcBOrUg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xL5uW-0000000ASCZ-0xTV;
	Sun, 25 Oct 2026 22:37:48 +0100
Message-ID: <676effaff715929da980158820833c18a3a2845c.camel@sipsolutions.net>
Subject: Re: [PATCH RESEND] wifi: mac80211: Fix cryptographic MAC comparison
 to be constant-time
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Biggers <ebiggers@kernel.org>, linux-wireless@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Yuqi Xu <xuyuqiabc@gmail.com>, 
	stable@vger.kernel.org
Date: Sun, 25 Oct 2026 22:37:47 +0100
In-Reply-To: <20261025210032.134911-1-ebiggers@kernel.org>
References: <20261025210032.134911-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Sun, 2026-10-25 at 14:00 -0700, Eric Biggers wrote:
> To prevent timing attacks, the comparison of cryptographic message
> authentication codes (MACs) needs to have data-independent timing.
> Replace the memcmp() with the correct function, crypto_memneq().
>=20
> Fixes: 39404feee691 ("mac80211: FILS AEAD protection for station mode ass=
ociation frames")
> Cc: stable@vger.kernel.org
>=20

I'll apply this if you either come up with an actual attack, or stop
pretending it's a bug.

johannes
