Return-Path: <SRS0=EIvj=EK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F21C2D0A3
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Nov 2020 17:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6CA82083B
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Nov 2020 17:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604512666;
	bh=xW2DCv1bVj8xZGAEExQ8YdJt58u6JujrKWAdykKMBT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=X7dqTuSuPA9/Pj1+G0OtLy+YXt6YbK8U/nTSfBQhtcnkOa/oIuYvSX19b2/BHH88s
	 Hlufeox4AmdC3S4W30XbQK9WxkrUoxHkNHJmAd4cg26lMN/2eG4rr8wQvUhpjqDCBu
	 wcNQ+m4EEg/t4e8Z7M/ow8WJsQ02UFw/MXY/yDnY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731043AbgKDR5q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Nov 2020 12:57:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgKDR5p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Nov 2020 12:57:45 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 604B920639;
        Wed,  4 Nov 2020 17:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604512664;
        bh=xW2DCv1bVj8xZGAEExQ8YdJt58u6JujrKWAdykKMBT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GUw/u0M0wg3yZno9YljUV9hR5ZAxyDxdNF2C6Ss9DHqGp7RMQWyA+lCUSGL9/sewd
         bjHoLOQawHNfYTX6Dkm1T4VDytSDbbZFTcs4ao69FBZq6BIdQJ52+jshAfL4IfyLf/
         TfTdHPpqxkd3yvrJF8AcJcj5DDIPfMr7YbegNZIc=
Date:   Wed, 4 Nov 2020 09:57:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     l00374334 <liqiang64@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, will@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
Message-ID: <20201104175742.GA846@sol.localdomain>
References: <20201103121506.1533-1-liqiang64@huawei.com>
 <20201103121506.1533-2-liqiang64@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103121506.1533-2-liqiang64@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 03, 2020 at 08:15:06PM +0800, l00374334 wrote:
> From: liqiang <liqiang64@huawei.com>
> 
> 	In the libz library, the checksum algorithm adler32 usually occupies
> 	a relatively high hot spot, and the SVE instruction set can easily
> 	accelerate it, so that the performance of libz library will be
> 	significantly improved.
> 
> 	We can divides buf into blocks according to the bit width of SVE,
> 	and then uses vector registers to perform operations in units of blocks
> 	to achieve the purpose of acceleration.
> 
> 	On machines that support ARM64 sve instructions, this algorithm is
> 	about 3~4 times faster than the algorithm implemented in C language
> 	in libz. The wider the SVE instruction, the better the acceleration effect.
> 
> 	Measured on a Taishan 1951 machine that supports 256bit width SVE,
> 	below are the results of my measured random data of 1M and 10M:
> 
> 		[root@xxx adler32]# ./benchmark 1000000
> 		Libz alg: Time used:    608 us, 1644.7 Mb/s.
> 		SVE  alg: Time used:    166 us, 6024.1 Mb/s.
> 
> 		[root@xxx adler32]# ./benchmark 10000000
> 		Libz alg: Time used:   6484 us, 1542.3 Mb/s.
> 		SVE  alg: Time used:   2034 us, 4916.4 Mb/s.
> 
> 	The blocks can be of any size, so the algorithm can automatically adapt
> 	to SVE hardware with different bit widths without modifying the code.
> 
> 
> Signed-off-by: liqiang <liqiang64@huawei.com>

Note that this patch does nothing to actually wire up the kernel's copy of libz
(lib/zlib_{deflate,inflate}/) to use this implementation of Adler32.  To do so,
libz would either need to be changed to use the shash API, or you'd need to
implement an adler32() function in lib/crypto/ that automatically uses an
accelerated implementation if available, and make libz call it.

Also, in either case a C implementation would be required too.  There can't be
just an architecture-specific implementation.

Also as others have pointed out, there's probably not much point in having a SVE
implementation of Adler32 when there isn't even a NEON implementation yet.  It's
not too hard to implement Adler32 using NEON, and there are already several
permissively-licensed NEON implementations out there that could be used as a
reference, e.g. my implementation using NEON instrinsics here:
https://github.com/ebiggers/libdeflate/blob/v1.6/lib/arm/adler32_impl.h

- Eric
