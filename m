Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E9224B2F;
	Wed, 27 Dec 2023 09:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rIQFK-00ErIR-Mw; Wed, 27 Dec 2023 17:30:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 27 Dec 2023 17:30:49 +0800
Date: Wed, 27 Dec 2023 17:30:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chengming Zhou <chengming.zhou@linux.dev>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	nphamcs@gmail.com, syzkaller-bugs@googlegroups.com,
	yosryahmed@google.com, 21cnbao@gmail.com,
	zhouchengming@bytedance.com,
	syzbot+3eff5e51bf1db122a16e@syzkaller.appspotmail.com
Subject: Re: [PATCH] crypto: scompress - fix req->dst buffer overflow
Message-ID: <ZYvuyY5RQpfuwedI@gondor.apana.org.au>
References: <0000000000000b05cd060d6b5511@google.com>
 <20231227065043.2730440-1-chengming.zhou@linux.dev>
 <ZYvtqW7TAm6mCelt@gondor.apana.org.au>
 <4b2f3c71-738b-4b6f-9c38-b10f0c6c7ff0@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b2f3c71-738b-4b6f-9c38-b10f0c6c7ff0@linux.dev>

On Wed, Dec 27, 2023 at 05:28:35PM +0800, Chengming Zhou wrote:
>
> Right, ENOSPC is better. Should I send a v2?

Yes please.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
