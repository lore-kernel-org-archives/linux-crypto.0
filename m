Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FA844A417;
	Fri,  2 Oct 2026 08:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790929592; cv=none; b=cOjyCjNUW6biukqOwEEUQ9++hHqTQrhPGnHtEuW+E8klgBdG8S8yF4IDoqtXpuWHCiJdVNx2tRZbQzlV2A4WKzq3aP/3xZtlqfj448zNRnIrWiPuyrLYaA/MqC01/91+ORV2yyE6TIhX28Nv5LtnTeQS7znYWFVKpbygqRy3dEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790929592; c=relaxed/simple;
	bh=E+pHqQpI6i3Vihb8D8zLnusxaYh1XlPsSeBNtV4dqfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B8qMdTLod/Oo6Vfv//I+YCaTItk5xwVg5A2Ckh2seP7Ew90lBvjMmqs9VpGPAS3StQOdYNIhmQfDpMuVZykaa1PVE6js3gnSLG1/v1MY1bxzaaeYQ/QUlX/jqDwaonyDkTTMEyWOGXZGfMpkfp8/5smOiyMKw7ixp3nf4pbClXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ILBAGpMt; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ILBAGpMt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Id6HJiKvUSBEp3UrNv9fXkakPqolui9DiZmkFRhGHLY=; 
	b=ILBAGpMtl75PTtt48oKGT0+aHlR5Q5HPyZJdLbtcy7SE7zUtkNleILgw80wgbydo0xUr5pSOoft
	vTvRnSrA7JIGgli3iZQY11g1EeTkk30QBKhsixZHLc0PIR1T2R4tbz7udVL1aiHEHy2ZPX/OdkA+f
	PmgQa3TOBoaeZDcFL7uDv+cYA9Yl1CD8k2Qvqx1WgBusSSWDND0Fewr3iqR21qKHmye6sem1BpPvp
	PiMCTXav8DuQ8q3LWVp69wCx+ICHAX8f9ElwtxWcSaG0b+Xl/PikfxZnIK31J+/ENEBqyROAk1tSa
	5lQRQY5KCIKeAtQHidEv5otTADHttKnTPMEw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCYat-00000002mkH-1mAV;
	Fri, 02 Oct 2026 16:26:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 18:26:15 +1000
Date: Fri, 2 Oct 2026 18:26:15 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bill Wendling <morbo@google.com>
Cc: Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	codemender-patching+linux@google.com
Subject: Re: [PATCH] crypto: hisilicon/qm - annotate cap_tables with
 __counted_by_ptr
Message-ID: <ar9qpzRS9E8UOWcB@gondor.apana.org.au>
References: <20260923060114.2605310-1-morbo@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923060114.2605310-1-morbo@google.com>

On Wed, Sep 23, 2026 at 06:01:14AM +0000, Bill Wendling wrote:
> Annotate the 'qm_cap_table' and 'dev_cap_table' pointer fields in
> 'struct hisi_qm_cap_tables' with the '__counted_by_ptr' attribute.
> This improves bounds checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE, allowing KASAN and compiler diagnostics to
> detect out-of-bounds accesses.
> 
> The 'qm_cap_table' pointer is associated with 'qm_cap_size' which
> specifies its element count. Similarly, 'dev_cap_table' is associated
> with 'dev_cap_size'.
> 
> To ensure safety under compiler instrumentation, the assignments in the
> initialization paths have been updated to set the 'size'/'count' fields
> prior to setting the pointer fields. This prevents any transient state
> where the pointer is valid but the count is 0 (or uninitialized),
> ensuring that subsequent accesses to these tables do not trigger
> false-positive bounds check panics.
> 
> Cc: codemender-patching+linux@google.com
> Assisted-by: LLM
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 2 +-
>  drivers/crypto/hisilicon/qm.c             | 2 +-
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 2 +-
>  drivers/crypto/hisilicon/zip/zip_main.c   | 2 +-
>  include/linux/hisi_acc_qm.h               | 4 ++--
>  5 files changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
