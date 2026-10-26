Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793058932;
	b=YQViq9JxtW0mJRfHg9AXPnSQ8scZKMAldrq6I/yjNqkCfq++tlC70zgJs+G09ZpQRZIE
	 uNxHhfxZPoqf1vqWMpfl9iP85Zz3Tw5FsgvzH7eOULnZ6T/TSjhdO+wkayB9Mm+yrnqIZ
	 HzGAzg/uA+i7QyH4gS1tphWaGJ5UJMlyrgDV8E9vN7RwXysicGT4gWI9wtmSEnMZgqosM
	 VHpbm+sM/fmxc2mevC3yg/jGJYiSx6WHkNuIAYAeHDt1vXm2ZRokWVixyzkBcjXM9X1K+
	 z8/CGQLLLs+qK4Y0a+TI9obAkgZ03xhI0EXuGaCx34u3fEHNVSpk2G4a4ndg74sHY2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793058932;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VynIgSurKHQaOCUBkhJuuPI91r+51atCbpgVjkqWOnM=;
	b=RXVz5+Ur6yKBAlXpUg8OjjqL3XJFS8Ke3TFwruzDSWvarhpX15Wb6DXGg6RkfzZr/ZT/
	 h4bdS1k96mgvPKZZ0U6BcxTjyQQdVw0/xjeplY70cwgCnh05xO0Ffs9MpdHLhn0TkXsbX
	 zD7aa9HotBkOtTSOsnF6T1QK+xMajQN6BI8rKdLArCnU0f7lmkhQa4Jn8d5xqA7cFM/Px
	 RETfugZh7Bxn03xgIhhn8qa8wIbav1G3M37foPR1edBvR7I9+ln+LPrtyRzlYIeD+pUBD
	 66cd7cdFV1YESi/tZyUDuGPSIhaU2TWWfiXlZvKnBFsh12Aisw+PixnALE53oQuLC7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eoGYorJ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD925606A31B;
	Mon, 26 Oct 2026 23:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eoGYorJ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0371F01825;
	Mon, 26 Oct 2026 23:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793058931;
	bh=VynIgSurKHQaOCUBkhJuuPI91r+51atCbpgVjkqWOnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eoGYorJ7zvT8PcPJ1fs23u46Fhju/bkcw33/56WLZauBwe0CiVgIPS8uq+13xNP5C
	 iq287Rm5RDqUJFitdyuCVhomIE/WZxYUqYATsKVhYXZcNQUS4KP0YEmQJj7qG6WKps
	 PDCpiAmlYi9tzUvXrefuWbc8nNUNnuEBdIMZZ+dgPJbxn0TVSjD3SuSkEBInURKZhE
	 u3XnjUZWPAZJP1V1uueG5Ov36zPXbNG2rhU+/tz6f/e2mxAlgaYMlLOtUpU0XEAvXM
	 tz19eiItvTGMLR1d5YYW/reWzyBkD8WETi5UE0n/nD9TEqp4DucpujBbl4v3l4VQ11
	 1HpjkOIbBDhog==
Date: Mon, 26 Oct 2026 16:55:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>, Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PRO..." <fsverity@lists.linux.dev>,
	"open list:RHASHTABLE" <linux-crypto@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] KEYS: Introduce keyring_is_empty()
Message-ID: <20261026235528.GA2395@quark>
References: <20261025001105.1824178-1-jarkko@kernel.org>
 <20261025001105.1824178-5-jarkko@kernel.org>
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
In-Reply-To: <20261025001105.1824178-5-jarkko@kernel.org>

On Sun, Oct 25, 2026 at 03:10:12AM +0300, Jarkko Sakkinen wrote:
> +/**
> + * keyring_is_empty - Check whether a keyring contains any links
> + * @keyring: The keyring to check.
> + */

"contains any links" => "contains no links"?  Or even just "is empty".
Otherwise it sounds backwards.

Note that another "is the keyring empty" check just showed up in
mainline in kernel/bpf/keys.c.  So a new version of this patch will be
needed to update that one too.

Otherwise this patch looks good.

- Eric
