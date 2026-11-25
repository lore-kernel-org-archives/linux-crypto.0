Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795633186;
	b=NaXGojI+Tzty+i8q7SuN0rk0CacaS9cFo1+jXIAckzl5rvM6nZygzhqk+IG5aYp4jNfq
	 c4NGpj+QYWvkAMqwLfmh/Q0lHCG9+CbUhcmP7bXATzsEJUdPikKFM6l/hk55lDWetQBQW
	 dp4MPGL/lr+WKReZ+DGTJKuOe0V28leLWO2YBh+FzT1hbOYcdRIPzuyBeR0y4p92oe/GN
	 +DqIxtE1iJVaSMnM+Leu4mnONEoOAeYlcjF4/e6sGFjU/AwRRywPfxvLCy+qlNq5Nn5kB
	 YkY/++4aWkaQcfUpPF4ogvjN8wVRexcYeG9WPGX60ZPrr1T05Mmhl0hpq7lDZ9J9rsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795633186;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=tlxCWQBSOfLaIkqbJkuleLMV7UzZ9eUHNUiYI43mmOU=;
	b=vtr2xk9Xx9SpirNlx2SdrGFbkhzxrXBw4pyMd50LEUBuezXmvcuuypk2W6rHH9ZdluTX
	 3l+8ZsLxti2cd0pdnLEK/jvoKcZ5ySF2Jl4R9VCuDkFN0f2J+k2t5K3IQJtavnWrQHUzH
	 WDlNhNzuNyOnavbsnrUMIirQYW7JcZwBhytxJr2RPPljWqKQBODch7LQ6NjmeAVPcJY95
	 Xbx10C+brmUeDE/kNtgajV8hatEuQshdF54cf874V6JaT5/mmuweguwTcj92dyBaH/uet
	 qRzlWJtYxrlDxBuULTdx7Ixwqtg1+hNAzElfkcwVYHJ+1k9rakxDOz6Y4LnCXAsOPaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGEk2UiV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EAEC1606A32E;
	Wed, 25 Nov 2026 18:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGEk2UiV
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C87B61F000D1;
	Wed, 25 Nov 2026 18:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795633185;
	bh=tlxCWQBSOfLaIkqbJkuleLMV7UzZ9eUHNUiYI43mmOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OGEk2UiVKEGVyneJYuqBzFTo6lkVd7Lwtpr8gSaml/PpxVhXws9yDTj24r52toJzr
	 oQJTljVafg0gzJ4XrGMQsVwXjSfk8n/580jZImkrbhN2dlYYR6+ef1+G7AmXog1lfd
	 ojwZNk4hLYDRsDIeB0qbQ2noCTjybvY5YJKAoVlx/M5E1nyo4Lo/CopOSd3Nz47MHc
	 XczfAGp5TzjdEAaUZiq8B+FxnPDcYOszkr6Ian6vklTIwh+Pt68nACXaJiSaMM+rDO
	 jnXMjE/wQXtw0duvOeCR9Vx1sSlut60R1Kjuj8BtRFurnFddjpDADE8g+4NFKyTnZg
	 fW+uwazlQB8jA==
Date: Wed, 25 Nov 2026 20:59:42 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	David Laight <david.laight.linux@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v3 1/9] KEYS: Factor out opt-in KEYCTL_PKEY
Message-ID: <awcwHuvFhr7yfbgO@kernel.org>
References: <20261125180616.1854753-1-jarkko@kernel.org>
 <20261125180616.1854753-2-jarkko@kernel.org>
 <sashiko-outbox-233977@kernel.org>
 <awcvqLlRgAoeG8iU@kernel.org>
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
In-Reply-To: <awcvqLlRgAoeG8iU@kernel.org>

On Wed, Nov 25, 2026 at 08:57:48PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 25, 2026 at 06:22:49PM +0000, sashiko-bot@kernel.org wrote:
> > [Severity: Medium]
> > Should TURRIS_SIGNING_KEY, TURRIS_OMNIA_MCU_KEYCTL and
> > TURRIS_MOX_RWTM_KEYCTL be updated to depend on KEYCTL_PKEY instead of
> > ASYMMETRIC_KEY_TYPE?
> 
> Yes, and it make sense to add a level of granularity to this i.e., to
> make on/off subsystem specific choice.

In other words you want to have it "default on" for Turris while at the
same time being "default off" for asymmetric keys.

Not particularly complicated to implement but this was pretty useful
review comment from Sashiko to point this out.

Br, Jarkko
