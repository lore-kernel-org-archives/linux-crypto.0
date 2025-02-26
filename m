Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F748224B1E;
	Wed, 26 Feb 2025 03:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740539318; cv=none; b=TUzEdXydezwMvFxA9v7p3UX3DJDhfa4SDNsHeUa+l1WNkYQGc4l9q3vkwuwWTLF1rNJZCeDzCFx0X0ZCveAk2e7fK81Zi8k0TlESGdNoK3sH/f+CiW8OuKqY33hpkvvsahF6FPoStwSPSP7SErxcwpaoqZAytHba4AL21BYCCOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740539318; c=relaxed/simple;
	bh=3b5TsZZvS3/lwiA5SwS5rXu+T9HCFeqIBigOYrUnQTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdpjZKNmOu3xSlPbbytIry6AsEDVnsRfbn2Ejjt1hf1NB6TCFYbtoYuaf3E5xUnUdoJg9SYTI+PHpPv4LaBX33kdr4+yCWehsScuczxwWWjcj2w8kqBwp4X+gwu3DHutOATAPl7j7Yn4CdUbUAO03WJwHa3UdVmX7ZE7RrKdxPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PxVS32XF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PxVS32XF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Dws9BOk5y6tixhfVzZcU9yZM1Tg/ShQfBBQAMIde0P4=; b=PxVS32XFffHn1HAeRYgxkj3qFH
	o3LQTpS+8KrMfytOvFAEMcDeTvtSUIdWdKVd+fPRo6BUUSuOtY+hf9nPv9R0Za6MSJFxrbAhukcUa
	OzIlaPKDQ4t01/xDHPyWc3/9xXBuyBvfMeAOHVDHb1VKl98V/AroYHXzttOqstr8rfn72VvauCLE8
	B6U9YhpLkC7UFM4Pik5EK5mG1Up5utGrHMu65ESQPjdGk5ghStWu9u+15n1HBe7A6BPjTBXJTvRtP
	B4jk4OqZRpsUL88+eE31r0PugDrBMFYavFiiIs8nCUag7tFdFJbAk4dp0lfGiKHUd4IJTmvZ555D5
	OTLlaUGQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tn7ma-001ojv-0Y;
	Wed, 26 Feb 2025 11:08:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Feb 2025 11:08:24 +0800
Date: Wed, 26 Feb 2025 11:08:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: syzbot <syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com>,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: mm: zswap: fix crypto_free_acomp deadlock in zswap_cpu_comp_dead
Message-ID: <Z76FqBdP9EZJ8MWQ@gondor.apana.org.au>
References: <67bcea51.050a0220.bbfd1.0096.GAE@google.com>
 <Z72FJnbA39zWh4zS@gondor.apana.org.au>
 <3482501981b13aedda3c1c6b54d83d496bd05922@linux.dev>
 <Z75tg3wXoDnGtLis@gondor.apana.org.au>
 <Z753jsValuBdcvnv@google.com>
 <Z754DloF4TpoRr7P@gondor.apana.org.au>
 <Z76AnbQVZybcAi3g@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z76AnbQVZybcAi3g@google.com>

On Wed, Feb 26, 2025 at 02:46:53AM +0000, Yosry Ahmed wrote:
>
> Can do :) May I add your Co-developed-by and Signed-off-by since this
> would be based off your patch?

Sure you can also add my ack:

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
