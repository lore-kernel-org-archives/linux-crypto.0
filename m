Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE5C7405A;
	Sat, 28 Dec 2024 11:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735386767; cv=none; b=ZR5jGUXw6p8d2tmdiX4FBNiuOSp/YItOhOT8sZY8ZU/Ivx0NAwxICh3k0v1ew0w/BMYsgmMILvAmohp4G3A50sPW/kVRwYheaX3S5PCoOQPS7mE3+NFk4Q9lq98OhuE/H6NiOpHCo7ryaUu4a19qPO3h6cKP4gA6ID2UGSAu3+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735386767; c=relaxed/simple;
	bh=+QQ1axTlwUvcu3nSyIqnbTK2eIjNAS9Suurp8jAs4pA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=AUJcO8Fwo6jdT01fp8kfP92k8Anf9e1Zr5caAU70uarqfA9invTmhbRHRqVtX0V7C7FEtD30NzKThH265SK2ZtoLIDz+hnBWwqD4l5TYkbg+P6CdDJXaKBemaI74Oth4xOgdClaiTEbHrsmWcebQyzqdILUryO3/z+Jv2++QUTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CAt5V2NT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CAt5V2NT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=u1/oC8BCLPT6yMZPY3Inwd3Vjvgb95l3JqkPW1qz50w=; b=CAt5V2NTTc0kb0kGRdkIX/GZQQ
	bTTgHPH/NKLbxDLA1MWIRbDtr1+h1JQ3XTYWhrKwwElWtk9P9hcq4K3641+Y3JYO9EQk3QgAZyzVU
	0PTMD9vVeb5gNmpADBEVs8wmeUO/fh2YOdh/v32sAb29LJYimtK7hz42n3OZAvGVJZqiCWjxkZCQp
	Cy0RlSprSqCndAlanQhh8J5a4oRrv46//YRY5TnrbR9SmMlbxXAo7jv4zmQn1b5ZMB4ad7oM9jvo8
	qcbr5WJHkqH+rTXOqfGmDbIxTeDcl/ii9iAR09JP8nZY3HXepGGVAsVFC9nz/UmrgUW8zepJW0jQv
	sJsPL07Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tRV9r-003ZHr-0b;
	Sat, 28 Dec 2024 19:52:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Dec 2024 19:52:23 +0800
Date: Sat, 28 Dec 2024 19:52:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosryahmed@google.com, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: Re: [PATCH v1] crypto: iaa - Fix IAA disabling that occurs when
 sync_mode is set to 'async'.
Message-ID: <Z2_md-qdzb4b77gy@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241221220707.7050-1-kanchana.p.sridhar@intel.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Kanchana P Sridhar <kanchana.p.sridhar@intel.com> wrote:
> With the latest mm-unstable, setting the iaa_crypto sync_mode to 'async'
> causes crypto testmgr.c test_acomp() failure and dmesg call traces, and
> zswap being unable to use 'deflate-iaa' as a compressor:
> 
> echo async > /sys/bus/dsa/drivers/crypto/sync_mode
> 
> [  255.271030] zswap: compressor deflate-iaa not available
> [  369.960673] INFO: task cryptomgr_test:4889 blocked for more than 122 seconds.
> [  369.970127]       Not tainted 6.13.0-rc1-mm-unstable-12-16-2024+ #324
> [  369.977411] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  369.986246] task:cryptomgr_test  state:D stack:0     pid:4889  tgid:4889  ppid:2      flags:0x00004000
> [  369.986253] Call Trace:
> [  369.986256]  <TASK>
> [  369.986260]  __schedule+0x45c/0xfa0
> [  369.986273]  schedule+0x2e/0xb0
> [  369.986277]  schedule_timeout+0xe7/0x100
> [  369.986284]  ? __prepare_to_swait+0x4e/0x70
> [  369.986290]  wait_for_completion+0x8d/0x120
> [  369.986293]  test_acomp+0x284/0x670
> [  369.986305]  ? __pfx_cryptomgr_test+0x10/0x10
> [  369.986312]  alg_test_comp+0x263/0x440
> [  369.986315]  ? sched_balance_newidle+0x259/0x430
> [  369.986320]  ? __pfx_cryptomgr_test+0x10/0x10
> [  369.986323]  alg_test.part.27+0x103/0x410
> [  369.986326]  ? __schedule+0x464/0xfa0
> [  369.986330]  ? __pfx_cryptomgr_test+0x10/0x10
> [  369.986333]  cryptomgr_test+0x20/0x40
> [  369.986336]  kthread+0xda/0x110
> [  369.986344]  ? __pfx_kthread+0x10/0x10
> [  369.986346]  ret_from_fork+0x2d/0x40
> [  369.986355]  ? __pfx_kthread+0x10/0x10
> [  369.986358]  ret_from_fork_asm+0x1a/0x30
> [  369.986365]  </TASK>
> 
> This happens because the only async polling without interrupts that
> iaa_crypto currently implements is with the 'sync' mode. With 'async',
> iaa_crypto calls to compress/decompress submit the descriptor and return
> -EINPROGRESS, without any mechanism in the driver to poll for
> completions. Hence callers such as test_acomp() in crypto/testmgr.c or
> zswap, that wrap the calls to crypto_acomp_compress() and
> crypto_acomp_decompress() in synchronous wrappers, will block
> indefinitely. Even before zswap can notice this problem, the crypto
> testmgr.c's test_acomp() will fail and prevent registration of
> "deflate-iaa" as a valid crypto acomp algorithm, thereby disallowing the
> use of "deflate-iaa" as a zswap compress (zswap will fall-back to the
> default compressor in this case).
> 
> To fix this issue, this patch modifies the iaa_crypto sync_mode set
> function to treat 'async' equivalent to 'sync', so that the correct and
> only supported driver async polling without interrupts implementation is
> enabled, and zswap can use 'deflate-iaa' as the compressor.
> 
> Hence, with this patch, this is what will happen:
> 
> echo async > /sys/bus/dsa/drivers/crypto/sync_mode
> cat /sys/bus/dsa/drivers/crypto/sync_mode
> sync
> 
> There are no crypto/testmgr.c test_acomp() errors, no call traces and zswap
> can use 'deflate-iaa' without any errors. The iaa_crypto documentation has
> also been updated to mention this caveat with 'async' and what to expect
> with this fix.
> 
> True iaa_crypto async polling without interrupts is enabled in patch
> "crypto: iaa - Implement batch_compress(), batch_decompress() API in
> iaa_crypto." [1] which is under review as part of the "zswap IAA compress
> batching" patch-series [2]. Until this is merged, we would appreciate it if
> this current patch can be considered for a hotfix.
> 
> [1]: https://patchwork.kernel.org/project/linux-mm/patch/20241221063119.29140-5-kanchana.p.sridhar@intel.com/
> [2]: https://patchwork.kernel.org/project/linux-mm/list/?series=920084
> 
> Fixes: 09646c98d ("crypto: iaa - Add irq support for the crypto async interface")
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
> Documentation/driver-api/crypto/iaa/iaa-crypto.rst | 9 ++++++++-
> drivers/crypto/intel/iaa/iaa_crypto_main.c         | 2 +-
> 2 files changed, 9 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
