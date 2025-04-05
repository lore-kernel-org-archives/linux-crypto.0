Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A3222615;
	Sat,  5 Apr 2025 01:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743816700; cv=none; b=TQL/hr/ZLMi7mNNSoHBrZZb1vZooTTL6EuYZbttddviUVehwl4Hsr2kKzss5VQczCqSQ8bn03xfBpJMqPHWEM1Ju1kIOA8Th8R4fHfnCnJhzGS5I+oEq/a2O/59l6lU0xQ/ObBF15bmcs7H+sWfZrKlmhba9Bos9jDj/86mWu3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743816700; c=relaxed/simple;
	bh=EEdUgnUojoRXpiTbpkEarFeVfjlVtp7QnFJ0ZqhbxKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Clcmb3XW8rZlELEN25RnHfi3r2y65lPiKHYhIqnetv7wQEhDbpmZst+aSKhQQjdIEaNhBCm/M4XUVN65gsjDvsGRSohWGtIg6i0+dkpOLQ0DHK40/MeP6b+NsYaU1JxgB2SQC72QlPkhp6bc6Px+KGpkza63jEkToc/9/wfchtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZpK6BsFn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZpK6BsFn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+n/TUQrYZeqTM9M0hCWSCER7aL7XLQiMb5zOS4sSbB8=; b=ZpK6BsFn8fJTsVdbG5+wsa7mCm
	lwlUq0TI6t1B/fN/URaf1387HgqqbX9l8t2hwb+DN14ZSOB1m1aeAc52dawLLW9peYc2WnYpttgJn
	S2B/USeL1FCVsQUu4f8uO8SXuDjmNzqzZjDi45a6E2qW2Qi4fQLcIU5hG1r9riaav11uDlRYFK1KQ
	MlkXy3FYFp+U+bedbvtommWwMnr7lrGfSrg2tWc0v1ffHBhUl+Nvu+3jzaCr69bjL1cBt+zwEgu+V
	2RJXdEdzZZpCwYeSriFgUDZQshty8WUxt6PT2LnNrgfIluXWDtERkvcCgz9bmQ4ikybhP971nC4W7
	gsaYaojg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u0sNd-00CxRq-2r;
	Sat, 05 Apr 2025 09:31:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Apr 2025 09:31:29 +0800
Date: Sat, 5 Apr 2025 09:31:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Uros Bizjak <ubizjak@gmail.com>, linux-crypto@vger.kernel.org,
	kernel test robot <lkp@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/3] crypto: x86 - Remove CONFIG_AS_AVX512
Message-ID: <Z_CH8RAVeqTlPrDO@gondor.apana.org.au>
References: <20250403094527.349526-3-ubizjak@gmail.com>
 <202504040855.mr885Pz1-lkp@intel.com>
 <20250404015112.GA96368@sol.localdomain>
 <CAFULd4YrG-7DCXabke+uuLwLw2azciogG1nPGeAkMxLACw+0og@mail.gmail.com>
 <20250404190923.GB1622@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404190923.GB1622@sol.localdomain>

On Fri, Apr 04, 2025 at 12:09:23PM -0700, Eric Biggers wrote:
>
> $ ./scripts/get_maintainer.pl lib/raid6/avx512.c
> linux-kernel@vger.kernel.org (open list)
> 
> Whee, more unmaintained code...

I think it's maintained as a part of the software RAID code:

SOFTWARE RAID (Multiple Disks) SUPPORT
M:      Song Liu <song@kernel.org>
M:      Yu Kuai <yukuai3@huawei.com>
L:      linux-raid@vger.kernel.org
S:      Supported
Q:      https://patchwork.kernel.org/project/linux-raid/list/
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git
F:      drivers/md/Kconfig
F:      drivers/md/Makefile
F:      drivers/md/md*
F:      drivers/md/raid*
F:      include/linux/raid/
F:      include/uapi/linux/raid/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
