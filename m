Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5279B1AC8AE;
	Thu, 15 Aug 2024 14:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731757; cv=none; b=h6FixZ6zV2d5ce5q2KlFXhEoEv47XhhwG8oHqyRDBRxKpStnljFo66barlT+NKTrkTC+8vZZuWtVc8S2BEjNRJ2Yip1Q0FKrCK4IF8aGywwkCeq22iDlx5CTUc/Vc2ngO3inWiIGy8wOwvFW7eAjqPxX1g6qLKsOVOg2uWqaCF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731757; c=relaxed/simple;
	bh=kXQEvw1P1MKqMsSdJ6dqo+d9zkctvR+HinrDBuq8UDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oqAEeoSbSkkrwNQM5cZM/FOp8CWChJJAo+fLFiGq/AHOmwZjxATLmTXF+OrJ6JuhzcIAHB6PLWZhG9Be0w3iIHKnW+jaRqW7usGvyzJ93gW40Kix8SaRTI1d/kTyWkeb0M9ho+UADa6dVYfoqXymhdcPX5YRfeyZb2WAHKBqYQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=PWecjjlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PWecjjlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C2CC32786;
	Thu, 15 Aug 2024 14:22:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PWecjjlQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1723731754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y785oujOneXuK0txADs+5MXwl/4M9FZlOl0nIrQHO7I=;
	b=PWecjjlQr+9IoQK/d6OA3SE59zLN74E4d5wZJ4SV0yidKF6UEB8t6P9c3qpDRcUJlrqu9G
	JYA1o+10U+uEPrEt+e2bZO6p4aPPRQnPLxk8PMep3uhWPpXTx5i1yyTNkbbQvihi5p7rQf
	T7KUV8XB8s9h8IeQGZHGsYZiV6Tl1xM=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3b0e4627 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 15 Aug 2024 14:22:34 +0000 (UTC)
Date: Thu, 15 Aug 2024 14:22:29 +0000
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Diederik de Haas <didi.debian@cknow.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Non working HWRNG on AMD Ryzen 5 5500GT
Message-ID: <Zr4PJYISc_h7cQdW@zx2c4.com>
References: <D3GJCRNY4KDK.3SPJB5WP8Z7DK@cknow.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D3GJCRNY4KDK.3SPJB5WP8Z7DK@cknow.org>

On Thu, Aug 15, 2024 at 03:56:26PM +0200, Diederik de Haas wrote:
> Found an article [1] which could be relevant and downloaded and ran the
> accompanying test program (written by Jason Donenfeld):
> # ./amd-rdrand-bug
> Your RDRAND() does not have the AMD bug.
> # ./test-rdrand
> RDRAND() = 0x47c993c0
> RDRAND() = 0xec7c697d
> ... (more seemingly random numbers)
> RDRAND() = 0xba858101

RDRAND isn't the same as CCP.

> # dmesg | grep ccp
> [    5.399853] ccp 0000:07:00.2: ccp: unable to access the device: you might
> be running a broken BIOS.
> [    5.401031] ccp 0000:07:00.2: tee enabled
> [    5.401113] ccp 0000:07:00.2: psp enabled

Looks like the kernel reports CCP as broken. As the above RDRAND test
doesn't indicate anything about CCP, I don't see rationale for that
determination to be wrong.

Actual test code is in drivers/crypto/ccp/ccp-dev-v5.c:

        /* Find available queues */
        qmr = ioread32(ccp->io_regs + Q_MASK_REG);
        /*
         * Check for a access to the registers.  If this read returns
         * 0xffffffff, it's likely that the system is running a broken
         * BIOS which disallows access to the device. Stop here and fail
         * the initialization (but not the load, as the PSP could get                       * properly initialized).                                                           */
        if (qmr == 0xffffffff) {                                                                   dev_notice(dev, "ccp: unable to access the device: you might be running a broken BIOS.\n");                                                                           return 1;                                                                  }
