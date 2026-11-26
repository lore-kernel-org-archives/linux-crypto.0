Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795729732;
	b=wqiRTa4om9CVVs6F1yTBYjB7Ju9yhU++SpNchrxY2uXeTrZlBG87+dcdB2WLyUVl+gj6
	 8xyUzplTHs234a9qdxvjPbhVF//bMlYOUoWR6wFq0nHDkBGl56KVIEVXJJKSI6RbKAQSl
	 kUKP0CtlnUq23f6dBw/2wLBR8Mlk2QgZgBHd00hIbAp//gfJqI+LrFDWA+rBb4/rD/c8W
	 +2Wk5mDco7xVbzv9kNB/a+MdvqvFVVifjw169OQWdZqFf8sM1Yu5ASAU3w9bUr121zMlJ
	 Z5ln1IVuRV7+Z2BNXw8NXmh3fhuN0NFxP1wepXSPpJfQpp+DC1wPDLDPIYTJtEuAlKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795729732;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=tL0KPYsNWllSt9PJYMsgt65v9WSv0udE9SrH0WwMrhs=;
	b=oV5i8FARgxuqbg5iTGEi287l1pNns8y8n/F6lNRrJjzQ3SKpZi3Z+lBxpLjOygETDbGj
	 Pi12/2x5cwc7u+nok2gnlo8XLZi5jwBWLZaa29OUIbYY94TfiKLeIwtdR+Vgn+djksoj9
	 wTdG3Mnx/jR0b/3Wa98t5pUncOIdlXnmllUc4EMHbeZO4o+jj6OxSLxI6qB5OeF8EhHbr
	 fbTY2Y44aGsaIlRTTHmrfHR0offFLtqEl06A8S2Ax+frpP2cVbMar+v2TVuMK8je1nIRp
	 yFvAXvZuxNRTHeK9d/GS3ciqhDfsRJYaYan8iKiC8C/44a5cck3kgzwudoaywyhppjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RAkCes5D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 387ED606A31C;
	Thu, 26 Nov 2026 21:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RAkCes5D
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 062E61F000C1;
	Thu, 26 Nov 2026 21:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795729731;
	bh=tL0KPYsNWllSt9PJYMsgt65v9WSv0udE9SrH0WwMrhs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RAkCes5DFSaAtw4DkHNa8po00T3CUA9LuNiAo7vxqx9pEWdnOVaFVjE5FDiDAWzuq
	 /7OfC8Aa3YgB58YCdjYP6l5FLtnE0HcV7R2GiMYpHkVxcjPaQZqJXcCz/NISRo+zuN
	 8MnDhrjj4oen6sua/XKyG6mCS2smispXGRHDzO1uNG04VR42CZcH4eDajgpKAFetiW
	 zqKyrFHx9BRGKmX0hP/zl5OsYVYqaN+nUdTT/VrzersyJzfeOjLT57fxKtg2E9GveK
	 fnsecNa01LfwD/pPPHMEEa+MyvCmKC+gubI3XAMwjd9Xcgd/hr8T52oqmJ0W6lWcoi
	 LxuDTKFE+mdqg==
Date: Thu, 26 Nov 2026 23:48:48 +0200
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
	Lukas Wunner <lukas@wunner.de>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v4 11/11] KEYS: trusted: Add asymmetric key support for
 TPM2
Message-ID: <awipQFkjoBSEXnLh@kernel.org>
References: <20261126205021.2200819-1-jarkko@kernel.org>
 <20261126205021.2200819-12-jarkko@kernel.org>
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
In-Reply-To: <20261126205021.2200819-12-jarkko@kernel.org>

On Thu, Nov 26, 2026 at 10:50:21PM +0200, Jarkko Sakkinen wrote:
> Extend the TPM 2.0 trusted key backend to load OID_TPMLoadableKey
> (2.23.133.10.1.3) RSA (2048/3072/4096) and ECC (NIST P-256/P-384/P-521)
> keys and expose query, sign, verify, and RSA encrypt/decrypt operations
> through key_type_trusted.
> 
> The feature is controlled by CONFIG_TRUSTED_KEYS_ASYMMETRIC, which
> defaults to y when CONFIG_TRUSTED_KEYS_TPM is enabled.
> 
> Co-developed-by: James Prestwood <prestwoj@gmail.com>
> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

By rebasing this on top of these patches, I could drop tpm2_read*()
from this and use tpm_buf_read_*():

https://lore.kernel.org/keyrings/20261115233156.1485238-1-jarkko@kernel.org/

See, also:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=tpm2-asymmetric

Br, Jarkko
