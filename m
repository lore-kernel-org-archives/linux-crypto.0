Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795641469;
	b=G6w2Nx0i/HyQ+UHUAJREeiwqvxUS99cFeN5jwdvsZPoH2I6ViZK3yohcHyOB4sOaqLO7
	 7zjq/uHp0CVg7KMYFhNC3mcDqfXCMpdfPu5hPfQrjvOtuIyHkmyodTqC+aIXxWPaCvbla
	 mR9/XyH+qmOQs8rA4Pmk+Aeu7FmbzHz71VrlTYOlp5Wc8dcAD0A084V6waPh0jGltBNb6
	 LVDGrvqQtiup1Qs6/rRlSqr/rzBtXtw2jDf3VV7SZbSUH2AEY2s5CisZU9fUMkKmZAcGG
	 K+45Ie3z5NPm/PCpv0aX5mb7uwhwSJ7tdOND8qbuF0R5d8Uyj/6iuZPmNGw4+b+JDLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795641469;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/j2dpwT9DgEGhQ+9CgVh2jw8bR1RkMQV6ntgfFSXjCk=;
	b=ybzI+5LKY6+/bMUgfsO/FCq4fkXeNhoZK+hedj0IksMGhh3iw3uAGqbneX2y+DxbboCe
	 FoLjrKSuRbI22VzhfwUFz05tEeE5FH7ITd+71Q5M/eSXBY/+rCzGvaPGVNL7nXStWOt8N
	 lrh6crLPGLS8+371o9dPIEs0Og5//134wQe/QCgey4re1sC3yUPrXGMmYzURv9tEyubyP
	 7E34nglHqJKn0vU6Q2bsHkm/gKkPq7w1/TRuxyHeaZFgL+ECzUoONdRg3Ivg580J4i7x0
	 vcZ0ikeK6P7Q/SOjI9P5NeLgWvwQG4biON1gcUjEAcjMkt0Zgmg7Zsgg754Cp5ICrPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vqm1q5tZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id F3145606A31E;
	Wed, 25 Nov 2026 21:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vqm1q5tZ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 709B61F000D1;
	Wed, 25 Nov 2026 21:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795641468;
	bh=/j2dpwT9DgEGhQ+9CgVh2jw8bR1RkMQV6ntgfFSXjCk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vqm1q5tZRk1owGRMwYXknJp9OcGt14l5f/BQ+7MSasyBjtBKCZwn5N9YBaH9XzoS+
	 y75syj3FsxdF0phx6ezClvmXtmNjydMIyhC9sqmSUFGk9WybEx/aAXbxeGW14F9rOY
	 kvwbscHuzgEVxvIJrHiBLIVGSPVsWqEAAi+6gwiyY6BPozpNHYskpSwoA8ynKizfzE
	 lP/Apm0KsD2MfnRlAj+9YiSUzKNSaS448PHkul/ald8UCKwBZtxncpDgkmnZBPVfR4
	 j8za1t5OG/IgKDFO/00qUYHFJcOpawZX3wA/f+64xysG7b6EP+GTsT0uv5ejv4Pv0V
	 /Z8GrrA7Bacqg==
Date: Wed, 25 Nov 2026 23:17:44 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: keyrings@vger.kernel.org
Cc: dm-devel@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
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
Subject: Re: [PATCH v3 9/9] KEYS: trusted: Add asymmetric key support for TPM2
Message-ID: <awdQePZNGZQhNP5K@kernel.org>
References: <20261125180616.1854753-1-jarkko@kernel.org>
 <20261125180616.1854753-10-jarkko@kernel.org>
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
In-Reply-To: <20261125180616.1854753-10-jarkko@kernel.org>

On Wed, Nov 25, 2026 at 08:06:15PM +0200, Jarkko Sakkinen wrote:
> Extend the TPM 2.0 trusted key backend to load OID_TPMLoadableKey
> (2.23.133.10.1.3) RSA (2048/3072/4096) and ECC (NIST P-256/P-384/P-521)
> keys and expose query, sign, verify, and RSA encrypt/decrypt operations
> through key_type_trusted.
> 
> The feature is enabled with opt-in CONFIG_TRUSTED_KEYS_ASYMMETRIC.
> 
> Co-developed-by: James Prestwood <prestwoj@gmail.com>
> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

It might make even sense to make TPM user space device opt-in through
kernel command-line option in the case if these ops are useful for
other backends.

Thinking more like embedded busybox space than enterprise systemd
space. If it is possible rely keychains only to trusted keys, then
the software stack can be translated between hardware platforms,
even with different security chips.

Br, Jarkko
