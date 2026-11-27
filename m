Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795762122;
	b=wUgYoYYi6w8iXwAzRKkW4lzZ+zinHeip4Fy3YErn+vX/loJuRd+IevuLoXQxRCggX/55
	 U3eGDCbSvjCZ4a7/aSPPEetvinLsHinjWuh+h7vXZCSpt2Trtp8zLo1kvPUhmlhKGlvdz
	 GEofM9Xjr8nsQVb54ZyI1cu4XGG6KqBGG/Mw66OP/5XJSHl7UE05R1i1ETBMBXJ0DG5l5
	 xtLo0IKlFZl8+QeHZ1OCAxjIku8vUqTz2H47ooJRTtY74hTWenx1LufVakSpB9t8iTSek
	 9LHcjrRh/stCBt3duWi9sQUUPjhbwiOiyhK306EXSXvkxElHFk5dkC1hj0ntUrByHfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795762122;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=D2qAvffQz1/Kmxq2R231WWzgGRVz04WJrtHpdL6qOoA=;
	b=5chvar1Vx1iXUIWYw32pFN0CKbTgQHak/CHK7fWaFvV3dOppwo1DepFhLxe7OB95CZk6
	 ytlTTB/eCvJvL3d1VWJr+G2Xfvi9mYAZHKdBIw5tmU8T9ThqV/f2xiZMMDF8y4Dm6ADRf
	 9pX54PknM491HjUy2+eIdt6SzU60OhW6wi63xFRZNqCyoaCX0E5nqZJuj1qXF4isVhKkv
	 gb27DizTEbAXYkWbf4xAMjqW0EQVEkB+5o+Ol6uhjjaAUoq2IEZOT7l8RMaC7DdQS5R97
	 fvBdJd0UWi/xq4Ue9bAbDWp+j5KtDxeZeJQ2GXpHdzPmUWD3QYE7qoI1RhHodpLvuTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V41pLXPv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CA902606A323;
	Fri, 27 Nov 2026 06:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V41pLXPv
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6362B1F00897;
	Fri, 27 Nov 2026 06:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795762122;
	bh=D2qAvffQz1/Kmxq2R231WWzgGRVz04WJrtHpdL6qOoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V41pLXPvWT6oPTKTANy9bd9W4sNgLSL+0i5tp/MR1tMtCmOFp0DO9rnlY0D7oe6Rd
	 /p9O0pctXPxCKz6vB8sw36rTYwcjiY3I1wpHJZXlGKL1e6odFl93Pm8Oij+zz2iYjV
	 vfDYN4hMkQfIEqhFKoSHexzAN7vjI4Dvy1196UXc9tPVBYWEnJI//51smoO6sd0huz
	 Wb8NF4Clb4BOC+GUY6ZI2wUdj6W/oMYbV3F6aAzIyZc98DR88EE8s34U13LFq3B+OS
	 wBMfwkHep26ELC67urdD+x76WHLjeRaXuNC9VzDZJuzE7hiuhHFF9qD9fIdNvv6gEQ
	 22w29sWexd2Ow==
Date: Fri, 27 Nov 2026 08:48:38 +0200
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
	Jonathan McDowell <noodles@meta.com>,
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
Subject: Re: [PATCH v5 17/17] KEYS: trusted: Add asymmetric key support for
 TPM2
Message-ID: <awknxh-Q0eHKt2ZY@kernel.org>
References: <20261127055602.2357884-1-jarkko@kernel.org>
 <20261127055602.2357884-18-jarkko@kernel.org>
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
In-Reply-To: <20261127055602.2357884-18-jarkko@kernel.org>

On Fri, Nov 27, 2026 at 07:56:02AM +0200, Jarkko Sakkinen wrote:
> Extend the TPM 2.0 trusted key backend to load OID_TPMLoadableKey
> (2.23.133.10.1.3) RSA (2048/3072/4096) and ECC (NIST P-256/P-384/P-521)
> keys and wire query, sign, verify, and RSA encrypt/decrypt operations to
> trusted_key_tpm_ops.
> 
> Select HAVE_TRUSTED_KEYS_ASYMMETRIC when CONFIG_TRUSTED_KEYS_TPM is
> enabled.
> 
> Co-developed-by: James Prestwood <prestwoj@gmail.com>
> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

This should be in fairly safe grounds because the patch has been
manually written (with TCG specs), both TPM2 protocol and ASN.1
shenanigans, and reviewed and tested countless of times (over the
years).

Further, it has pretty much passed all Sashiko reviews so far, and
thus this patch likely is not all that wrong.

Br, Jarkko
