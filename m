Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726886;
	b=1SK9yoOFmC6uYg3dE60+/t7UZ5yFJfS5xpddTLHECrQ4YS/8mF+7DhfRFJwk72alvkwM
	 0bX4wKOgtl4KiUTj2UEYxVz9WG6bQoJ0EUIrZIRIE1sJkXizablKpIAADVdF7O9cP4ROi
	 gLTyf/ES/jFlG5lGOS0X9mu4gNAOW9bvQaljoIgmzU7uYZn1DxJXV8p3plz2exWlxgbK7
	 GGUTUnpGy1hnNCnQD1SHPRrAcdF7AHUIzXSCe3mctMGqcgEx3pzgtUXhrQ6YOvpPoiUS2
	 uHF4Uubu0yGp1HCBl7V3/uHjYaX9WT0zfW5HezDXdKR/36hoPP1eV0SZ2njeeJCuZmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726886;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2PDYyeUwnj6Av3J+sN96MY6jXwEzqAUTZ4EhuMvBT3Y=;
	b=1PZjhINB2abpgibqjXwr8JCk/w4v4m3qbEwv5nn9wHkakmCLym4Tw4Yo7cnZLJeRBkwt
	 Dcp5KEF1ELFiRp13FTwDMjH6mkcSGn/hgOq8d1zpobM0OJSO1Q3SVGhx+7hGaPFFEiZjP
	 CrWKiALzp4WKBxfzw0R8mrh7kHD/Sw4YK54LgmtVi4kUqXnRJMRxCjrAb/6VlLSB6sXK2
	 H6sUz8CTk3h+EH/7B2VcxGyBQewoGJlygw/7HAoVOhEARVa8LbcKuvrN0n9Uf643MmkT1
	 6xBlS87/bAhjfsBfe5zOipk5XPYmKFu+X9ZIpxorlaz4cyw677izBjgAbSqxE915scQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jilE55Yv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EA619606A31C;
	Thu, 26 Nov 2026 21:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jilE55Yv
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 14D411F000C1;
	Thu, 26 Nov 2026 21:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726885;
	bh=2PDYyeUwnj6Av3J+sN96MY6jXwEzqAUTZ4EhuMvBT3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jilE55YvAq1XkaWp4+W4IKFMT21gKHPEvPdTNFmeG+NtyavadMFUJZ1VP3s4ENUZM
	 MPDfFArKRmVfNOXieX8Jg/5Ar9hYRh52Vhej+/INgPjOMtY1DnlmjMLrNV8HU0n6aU
	 ZiAqOrQe53k9wRXZX56CP3S3Ohc6Mkozu/QubIrRhqsZAjjsXPwesRXXEY+OOMXHwK
	 IhsTC+jynF++RzSJ49BPFBtx63EJxNnS4BCM45KT7IbMjAsFnEZxNz9MLptvktSKFS
	 HfS/5Vg7HrLRx8tPYXS4P/z1HtRoFMdJk6EaT3fQW9gmrd/yMsC7MLdctlv032foe2
	 gJ+a9nLHDeWJg==
Date: Thu, 26 Nov 2026 23:01:21 +0200
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
Subject: Re: [PATCH v4 03/11] KEYS: trusted: Validate public_len before
 reading key attributes
Message-ID: <awieIblDHu4iF4Wl@kernel.org>
References: <20261126205021.2200819-1-jarkko@kernel.org>
 <20261126205021.2200819-4-jarkko@kernel.org>
 <sashiko-outbox-236180@kernel.org>
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
In-Reply-To: <sashiko-outbox-236180@kernel.org>

> > KEYS: trusted: Validate public_len before reading key attributes
> >
> > tpm2_load_cmd() reads the 32-bit objectAttributes field at pub + 4
> > without checking that public_len is at least 8 bytes. Reject blobs with
> > public_len < 8 before dereferencing pub + 4.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> [Severity: Low]
> The unvalidated get_unaligned_be32(pub + 4) read in tpm2_load_cmd() was
> introduced by commit e5fb5d2c5a03 ("security: keys: trusted: Make sealed
> key properly interoperable").  Should the commit message include:
> 
>   Fixes: e5fb5d2c5a03 ("security: keys: trusted: Make sealed key properly interoperable")

Yeah, I think so, and it can be detached from the patch set, if it
receives reviewed-by tag.

Br, Jarkko
