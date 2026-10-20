Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792533466;
	b=XYBNt/6+yPcSXRtk+QxVNHJoF2RrZWTvG8wKCJB6rVGt+GesbQpsIF0HIkLTtmzg9ze1
	 kWnjSZZZmS27oeKa5zdIGw6fjRyBJ6pD411d4gO5tViQp0v753GQ/JjYsF//Kgg409bXU
	 n1G5tfW+wUSUffIxDABvR2bxGlU4pF4xk0lV8ShJPxSuGxAtll/tJV8olJ1rb0HqT4ZVb
	 3zUTHp1fWJDTFWytP30Z5qdKvxheIBE0Ra5ISYLtfIGq84mNKsZmYLCRcMgscpKbzRYt+
	 8j1aQxX0i3QuUq8cSFzkd1EVn5yJyMvB70iJG0TRiCD6mPlVhmFQ2g+o226xwq94gdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792533466;
	h=Received:DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition;
	bh=TiQgQBDQQ33hSiC1mjJ6wj+GxePP+BY7SZlw3xfKiuY=;
	b=rRcPEAhWmjJRPUi4A+MJ79W9v+9J9p1CLJGoxtPtehpowNpkuQSlZ4m71mO+l5aRjEiu
	 I3S7ELqhoW2um/cLdtJb/+dfqmQf4rqFQWlz4R5/rc4GYYDvTlhWWjHD351+dMlZaFN3w
	 yf/ynZ2hUpyT0kpLQAmBFRSh/ZtUP9tkN5XN8+qqXp3pum/bwSwPENoUscCzSeLFa0uYj
	 TCgobTbjrcDvrpK1FoF349jhV1yy/3K2Cl8aUGn/DPO+RmaM6PG4gztU20XnwpZa50Sy7
	 64dSDCiyDkRNkU7TkBI0+GxVvEqaeconk1BJ+X9IenM3G+jHN/VvGbqE/OaRiQxBkhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gHQRlqXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1511D606A319
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 21:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gHQRlqXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2471F000CC;
	Tue, 20 Oct 2026 21:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792533465;
	bh=TiQgQBDQQ33hSiC1mjJ6wj+GxePP+BY7SZlw3xfKiuY=;
	h=Date:From:To:Subject;
	b=gHQRlqXgC4x0d64jB95VOrWcLpzImu4suW5N2NsJq1RpSPlsRbUt1zLUjQD9uuIvT
	 9dH4T5MW5ApB3NAWjYtkBNoMp+UbURJrzDJeo0MJFBgFTZHuBCmdSTwEurr71ntzmF
	 I0VRQ9uQdue/3ltdWT685JvSEKdQxJgrZwhKPSjG/rCB50e5bu9uygsLrbReUrxcBB
	 w970n66Duy/ia87V0Tvvcq+QM6LP8jimc07gH1wqbRJjDuBn/1eo8nUsqQwZsKRtQI
	 h76tVGykguNln0wnwaHzd0SnqBnKVphgB/2zxfKrmXgPZnykb0qUp5Hm4B5nPnVD/Q
	 2g36iS4eT0Qww==
Date: Tue, 20 Oct 2026 21:57:44 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Enabling Sashiko replies to linux-crypto?
Message-ID: <20261020215744.GF699485@google.com>
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

Currently, Sashiko is configured (in
https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml)
to monitor linux-crypto for patches, but not to send emails to it.

Would there be any objections to me opening a pull request that changes
it to the same setting that I set the fscrypt and fsverity lists to?

    ["linux-crypto@vger.kernel.org"]
    reply_to = ["author", "list", "recipients"]

That would enable emails for issues found, with reply-all.

(There's also a 'positive_review = "all"' setting that would enable
emails for positive reviews, i.e. "Sashiko has reviewed this patch and
found no issues. It looks great!"  But those are kind of noisy.)

- Eric
