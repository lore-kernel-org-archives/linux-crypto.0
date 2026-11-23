Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795405057;
	b=Z02DuBgC3QO5w34mFJElIAkjMa6s0hXjgDnanlWNHx6/7mfkDPHspJoYZdHs/q+yG+DT
	 AqoNnWIB0WU1mHQwJS/ZJO6+38mKLaX9iLTm0yF8ydh+DiIImKGNUpCuAjRGFR5a4+lGX
	 eawzHQ+vgQKYe+00MnzdLrJMgKn3FoIgYnIITlUWcPBFh8W3iaJ3CCVZUryJ1BHa7WGtE
	 e/VPhDLpqIko6/ivd7HrtMShY7OspXagJvETn1JY4HUYoUB0qfdM+IFdhe8RWGcI/6mGf
	 Ey2sRTOukviveuvXay8icVwQv4l5TBbjsm9GUBYBsFXhzZfQslOoOKTvM3NsuSw8ETg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795405057;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=YeflyiqAAa+dbmSP64t4NAZeKHrV6kCA8GXwn01BQXI=;
	b=JlTz8sEmNZlrSTsfuJdDxXKFGYC8OIPbCjRKMwdGVTiOxL4e9NmK/P+wjyoeqcs7wsRa
	 wYN6BVqe0D8QuYnzXseW9nOsZZTwJmPIe/Ws4/97jfMaHoymqM8hZkqXDYavki9RICqAH
	 +Bk2krczAeYTUyF1oKK/zGmQGewxh6lEnxUwuTX++k3G1uCj8egifa1i7nwqnz/qAzbMS
	 hFDLfSY/qQ0zODVLeC4wPxTYgEsAroQz0C73xa4OTRFFVSnTl0pmQQ4poox9Hm3j8EbFf
	 agDbLTUclQYd54DrhpjQddtU3+QFzZZHPHthme+0Ac8zuZuVgNBZZrsB4kVLpLKfA4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=Ce8aOf+y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CC4606A31A;
	Mon, 23 Nov 2026 03:37:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64CC4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=Ce8aOf+y
ARC-Seal: i=1; a=rsa-sha256; t=1795405036; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Jl/SxhPJQc3TxzuUgmHm+J8qAqKjqClACZBX2LkmL/J5twKgO6GXVCRn6zRgzgOeJQ8lrJYsun0N6B4gHkOUh/4jekO3JR4lRmMrLiAufFgxap4Fr9lU1f9AKvzQblZQKSjmlridbYJcUz80CALdhzHMHIKpAPEIOZRFtQgRrQQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1795405036; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=YeflyiqAAa+dbmSP64t4NAZeKHrV6kCA8GXwn01BQXI=; 
	b=aem8MZWy+B/GejWyx5bczsSnJao2U9qeVLbR4HNQut/BEX2+roXSLB3iXO5ZcxXGPApSa29VhE4P/8S58BE6NDzMoieQESdrcwMeIx3Du6hLhf52TIx2DI6V1REp3N+69NT7aSHZ061njv3zIp2TB5j1V7hEA86MLOBKCNk//fo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: a=rsa-sha256; b=Ce8aOf+ygimuwhJqPe0d1P1DAoYZzZTnuvHMZ6MvLbi1h6YgrQrazm+tv0ILuwloD3MUmcR5fGZDe8BKcyna1KJB1TJejj4GiJOiH8kCpiHD1ndj0pT9izOQZ8AqSraTAKwhFYNj9Xf4nYLlItbKGDwJC4OMoMZl/qodfR8jQ6g=; c=relaxed/relaxed; s=zoho; d=laveeshbansal.com; v=1; bh=YeflyiqAAa+dbmSP64t4NAZeKHrV6kCA8GXwn01BQXI=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1795405031593545.8022919128772;
	Sun, 22 Nov 2026 19:37:11 -0800 (PST)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: Arun Iyengar <aiyengar1990@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Erwin Pawliczek <pawliczekerwin@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: ecc - Fix P-521 scalar multiplication for small scalars
Date: Sun, 22 Nov 2026 19:37:05 -0800
Message-ID: <20261123033705.91056-1-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261114-ecc-p521-small-scalars-v1-2-7b114f076b33@gmail.com>
References: <20261114-ecc-p521-small-scalars-v1-2-7b114f076b33@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

On Sat, 14 Nov 2026, Arun Iyengar wrote:
> No caller is affected today: the only P-521 caller,
> ecc_is_pubkey_valid_full(), passes k = n.

Hi Arun,

"No caller is affected" holds for the results, but for k = n
ecc_is_pubkey_valid_full() now runs the ladder on 2n instead of 3n, as
P-192, P-256 and P-384 already do. The ecdsa-nist-p521 self-test covers
that path and still passes. It might be worth a line in the commit
message.

I tested the series on an arm64 QEMU guest (7.4.0-rc1, Herbert's tree at
8ba9044ff0bf, KASAN, lockdep and DEBUG_LIST), calling
ecc_make_pub_key() on P-521 for 76 keys, three times each, and comparing
with OpenSSL. With patch 1 alone every key below 2^522 - 2n (42 of 76)
gives the wrong point. With both patches all 76 match. There are no
KASAN or lockdep reports.

Please consider adding a KUnit test for P-521 key generation. Nothing
covers that path today, and a test would have caught both of these bugs.

Tested-by: Laveesh Bansal <laveeshb@laveeshbansal.com>

Thanks,
Laveesh
