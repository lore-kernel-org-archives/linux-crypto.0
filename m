Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F3D44CF4F;
	Wed, 15 Jul 2026 12:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116878; cv=none; b=mzZIpapJn+bdcIjX3A5mtACCBNBcvo4FgyEpRu6ne0jw3vnXNHtjX2wWX9ndarn7ttol7GITittzJJ8XLPRgqNCZK4yJ+rcUxITZU3DnpekhWDGrjJnd58/mTOl0zbXq4ELnlWsJP3kd9xn4MJ1blgRGOKXX42CEOgdUlkRjdMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116878; c=relaxed/simple;
	bh=snKEYRguqD5VR4XqudKYgg++c8lGDC3R8iymuV8aQ38=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mAwmR4l7vhqAV3RV2XO0BGP0QXZINluEXalI4RTJDSSA4xnYDC88XmbcJLn3iKpWh+bv7l4z/xEHz/A57N+aETbiNRA6OkvoqJ512z7ukRxYGrKoFLXI74iY5vXZz88N/CLBubtcJpS2nssp3HVeYsUdnarMTHMRebJEuLtEVNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=UF1jJNYz; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="UF1jJNYz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784116876; x=1815652876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jW12a7gMz+PxQStmkNYCvL4Zb6H83SZzrOZFyQ4Rc4k=;
  b=UF1jJNYzQvA1MI6SI4wgoHKEzsTDAlJuvHwVL9r7c3GJ5W8NdoIH4bFu
   FVoTcw1uyzikeaqPtbh9Sq+xGzpfr/tWS2TiIQvTHxc3qH2TsnIyLd6T7
   mCRDfRPCKDkHp4vU/I4biiQZo0RbsYypcdBwOPln3N+Fi5pRVpRC2kIS0
   1NfbnwJoh35kufQNy9QM18MQ+xw87p8WjUJCbOf+Px0pLHe2l5QxFlRpo
   hCS9o/FvWk57KqeoMPCcCV8q1WBgMBVLuB3ATXoLZh40QUAfwNz8/mwwr
   nMPwKrozy6w1L75Y2naRE4JbLF9JKeZ4E8hgab6zYkoS58u9Oo1ON8aMK
   w==;
X-CSE-ConnectionGUID: IjX3y7uJSuSX5U/9yg+d5Q==
X-CSE-MsgGUID: cuILeauFRhWBVEgn5g1XcQ==
X-IronPort-AV: E=Sophos;i="6.25,165,1779148800"; 
   d="scan'208";a="23727927"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:01:13 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:23601]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.199:2525] with esmtp (Farcaster)
 id f061b287-cd6f-4f30-941c-36b95fe3dae9; Wed, 15 Jul 2026 12:01:13 +0000 (UTC)
X-Farcaster-Flow-ID: f061b287-cd6f-4f30-941c-36b95fe3dae9
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 15 Jul 2026 12:01:13 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 15 Jul 2026 12:01:11 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<davem@davemloft.net>, <ebiggers@kernel.org>, <snitzer@kernel.org>,
	<mpatocka@redhat.com>, <axboe@kernel.dk>
Subject: Re: [PATCH v5 2/5] crypto: dun - data-unit-number dispatch template
Date: Wed, 15 Jul 2026 12:01:02 +0000
Message-ID: <20260715120102.6687-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <alRMn--pY1ELYmBJ@gondor.apana.org.au>
References: <20260630083431.2772-3-lravich@amazon.com>
 <alRMn--pY1ELYmBJ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Jul 13, 2026 at 12:25:35PM +1000, Herbert Xu wrote:=0D
> This shouldn't be a template.  The default data-unit handling=0D
> should go into the mid-API layer (so skcipher.c).  It should=0D
> transparently split things up *if* the underlying algorithm does=0D
> not support multiple units.=0D
=0D
Done for v6 (mid-API split in skcipher.c, cherry-picking  acomp=0D
CRYPTO_ALG_REQ_SEG / segmentation-wrapper patch as you suggested).  One=0D
design fork I'd like your call on before I resend.=0D
=0D
I benchmarked the mid-API split vs the legacy per-sector loop on=0D
r7i.metal (VAES-AVX512): dm-crypt shows no measurable throughput or=0D
latency regression, but a microbench isolates a fixed ~50 ns per 512B=0D
unit.  It's a fixed per-call cost: the split=0D
copies the counter IV to a per-unit scratch and re-walks the sglist per=0D
unit and is paid only by callers setting unit_size !=3D 0.=0D
That gives two directions:=0D
=0D
  1. SW batching layer (current v6): mid-API transparently splits when=0D
     the alg lacks CRYPTO_ALG_REQ_SEG and unit_size !=3D 0.  =0D
     Works today on every existing skcipher at the ~50 ns/unit cost, =0D
     and goes quiet as algs gain native support.=0D
=0D
  2. HW-offload-hint model (as in Inel acomp series): callers set=0D
     unit_size only for CRYPTO_ALG_REQ_SEG algs and the mid-API never=0D
     emulates non-native ones.  Zero overhead, but the path is dead=0D
     until an in-tree skcipher advertises native support, unlike=0D
     acomp, where IAA already does.=0D
=0D
(1) is usable now with a small permanent SW cost; (2) mirrors the acomp=0D
mid-layer dispatch but, absent a native skcipher, ships an interface=0D
with no in-tree user.  Which would you prefer?=0D
=0D
Thanks,=0D
Leonid=0D
