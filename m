Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795522639;
	b=L9VRodQg3u1E0mYTZoeEhvecMTAwX5r2BjKjFKyLzx8Ev56dmRSJ/OUuxV3GxwXNN9aV
	 9gWXG9JZ6Rbe6nGBhbPOU9mpA0pUwsonFxi3GIrF4DE+n/szuwxZd5KNWfQVKgs8nQbOh
	 VQtkaHvRPqe/4gDRT1lOYfbIlsHVdypvNig/h1TR1h9zp9cEHY/PqvKjuMLkfQvoi/JGU
	 +rRAkyBVCUuKuubaO7SJdbeOh9fP4SacMgJ3p/k/bM4WqEU85+x2Y6fElC8LeS0vVcGRx
	 +PsDTAcUtTwmsrSeopIBUMIu5+LkSXoTQmX7fRl4IkGM5zj/XfdaV8L9pgiXfYNjAlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795522639;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=K4EnFxFC4PDvd8ivvt8rNRDO8iCMImH8zv+uN9ufduc=;
	b=1PRyWCk4R5/SFx/SgPoBIIzFck0geRBldKca6ukbOOV3k7BTGadVMtTmxmpBbo3ntmRl
	 RFeBWUcgn7AR/8GvzRtMeyBC/pOkVCeddMTFqxsEVJgw26JFpe5rKl/kt140tset+8iiW
	 ZFyPsYYYAtdKUf7qdt1qfcMNz2PXEJAjj4E+FdEdwQiVjOd0l8OqrvctCRl+PF1m4xouK
	 OBsDfszLn2o3exj7D4KgjtfVGhOxvpkn/i5PoW3CD03i8QCtgCy2lAR+pKkWecx8JlLM/
	 TyDgc1CeZW0v8dojzBWv7pRklOISIH8eTzqjWmv1hcXRg2WWwYF86/r/YqiP/8c0cKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WnAoqbFz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 5DDE6606A31E;
	Tue, 24 Nov 2026 12:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WnAoqbFz
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 710EC1F000C0;
	Tue, 24 Nov 2026 12:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795522639;
	bh=K4EnFxFC4PDvd8ivvt8rNRDO8iCMImH8zv+uN9ufduc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WnAoqbFz+YLrbfP0Zrozx4Qcqp/gIvbX9LIVPuj0g1isdPOWXose5KpPxYG3Sepkz
	 sOs3C1dEV+1QhmmeNn/q9ajSZDth6iQrx7JyHZsMTVQJy9uzZTQ+dtEOKUkqoj6gTu
	 x8A3b1v4Uo3OB/w86CpjXA+bQq4ztCmYwCMIQTu44qYx9MhmP07L3XPJVFyeNRBHoM
	 89FlYjbhO3kBLdduuI//QsVaHtDXfal7MGtF2pvKzN1eNwTE2C5r9V+KzTOSFjHrtO
	 1yA3zvtoBBAY8VJ/i2L4AxHY9JO+A0cL8aOSYPcEe7XaUGvh75sqG38bJThbpSIYi0
	 V8CdALnbCGFlg==
Date: Tue, 24 Nov 2026 14:17:15 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: dm-devel@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Lukas Wunner <lukas@wunner.de>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 6/9] KEYS: Factor out KEYCTL_PKEY
Message-ID: <awWASz8TBV-tFh93@kernel.org>
References: <20261124120044.1481752-1-jarkko@kernel.org>
 <20261124120044.1481752-7-jarkko@kernel.org>
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
In-Reply-To: <20261124120044.1481752-7-jarkko@kernel.org>

On Tue, Nov 24, 2026 at 02:00:41PM +0200, Jarkko Sakkinen wrote:
> Factor out CONFIG_KEYCTL_PKEY from CONFIG_ASYMMETRIC_KEY_TYPE so key
> types other than asymmetric can select keyctl public-key operations
> without pulling in crypto/asymmetric_keys/.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

This is really the only "innovation" in the new series. Everything else
follows from this change.

E.g., the very last patch is relocation for the most part, when compared
to the previous series.

Br, Jarkko
