Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E208F47
	for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2024 06:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723444137; cv=pass; b=nj8YQcGiQ4SeCzsIPbeuuklRZO8+csq3UIbVLKn9giNpeKQ/ASC1I6m/4hTiblBSZ/JigluQRcq56CFA8QT5SjSaKBBLT4yj2mgqV6wtlFreB08cOOzZ12Ap4ovUCdqUGh+HOwJAVdHpvLOfJRNQRLeU0nifnwgNCjv42r9cJSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723444137; c=relaxed/simple;
	bh=d6RyXn1n9L/oPVAZa2LHfVjYrPAhV211CPtko/UD8Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pFmrGOMDMxsGbQTI4l60hY2TKotVdLXnz6j/rP4z4quvqRdUdXgAcgYIvuKUIO9ndiBanGRe7bz+6lEwnnRZ17q7YLUwkToQ45m6AsL+1iYBra8ygKjwQfeXIcOyjonMHT4UF5IayNWqn2eaEy/cgNVGCVbkvlE1IbGGT3CSN9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=iagJlMTE; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=4pmzwrZJ; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="iagJlMTE";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="4pmzwrZJ"
ARC-Seal: i=1; a=rsa-sha256; t=1723443943; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=pdzZa2LyB7z+YNdfqbSmZahYWgrih+w1tep7e+MWqWnwD84TMJXAU+rv8slH5/P3qh
    oi+NVM8ZGiF+AkAOvDSskJrFLc15yLLBd2oZq8N8KEWCkJVWS30ChDUigBNQ5J0eBZh/
    BSW6oHKdsU8Ee1u2Q7aGJoWHYo83XGnft7klJAczp+ZYiXWl0VAY3UnjYIoNaXH8c1us
    N4zmR7SMnVQYvIeBEHi8OeDOnQBnk9nffVlgh2AOhi/woswap0m7oVRj7Krrd81D03Nk
    oHf/Bz8dib5NyPpWmLnDYetxQMPJcwmJha7LQl1ZAy++dcwErFeY8qRPqhfflrUxZi10
    wSWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1723443943;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=P3Y0xA88hIhckfa9IvHCax/lx0AwW8oQxka6ZYfWl+4=;
    b=o+dtyhNSdZCxQPXvR83cXxDewyljVnonB5H+p2grWQV5sOu0AvIRnTd4pkXoTX0UPe
    Ks6eogyCK9wi/nLqzMbZCiiQQifWk2Kcn+4UGPiZirqhS1eMsMc0b7YM4F9zkOH8iNXG
    cn5MDzNxhAJWqIvFQt7TCcSlEDXhxikSahGmlMR6RfvKOlFUQjrdw5xTuxRwpq9MW+Ny
    G99rzng1B1SsCZL6e/KdMs7vT7hdMKMJ9l4nvg3zVB9ayk7L9pDXgybga+Z5VX7oMM6r
    CkWTwC/AeS6seYqoQNF53ckwKK8TGmYO7H8VMmc0/jzxOLAeLaeUOCdQkHOi1v6CAchH
    qZtg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1723443943;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=P3Y0xA88hIhckfa9IvHCax/lx0AwW8oQxka6ZYfWl+4=;
    b=iagJlMTEleIisyi/q7rui+Bg3snt5G6K/+vkx6hjz/6z9LnoEOsRNvOnJ8LTWM02tx
    IWxgMWjAvyU8LmnWBg/3o2k+75vydZUJIO2zqGnKGwjnFtog34Zo38RmK2GTIkQmz4TI
    cJqhSZl9c2HK8nko7Aard06/RCXY+xuaRVT4k6SzG6s+Mof5CATftvqLr3/TYnxux01z
    0L0NWgSRLGpMT8+eDPwRmuhpIw75KsTKPKYQuQ/QhOObYEVFTj9sLmN933hFqNA6cL2f
    /lMMBoDnanjuiDBS/wPlYkvscsuypm/Tgq3gW0H8vaXw77CbeCmibHpZPGW/dmy/c5b/
    F3Fw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1723443943;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=P3Y0xA88hIhckfa9IvHCax/lx0AwW8oQxka6ZYfWl+4=;
    b=4pmzwrZJxcFIK999YlXRtwBwDDoquC2TFGuqkaSpS3Oq4e9c1eQlFamLjiIJuApxCs
    utTR9NAgOUj/NGdALiDw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDYI/SfDjXa"
Received: from tauon.atsec.com
    by smtp.strato.de (RZmta 51.1.0 DYNA|AUTH)
    with ESMTPSA id f5d0fe07C6PgC0U
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 12 Aug 2024 08:25:42 +0200 (CEST)
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Jeff Barnes <jeffbarnes@microsoft.com>, Vladis Dronov <vdronov@redhat.com>,
 "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>,
 Tyler Hicks <Tyler.Hicks@microsoft.com>,
 Shyam Saini <shyamsaini@microsoft.com>
Subject: [PATCH] crypto: JENT - set default OSR to 3
Date: Mon, 12 Aug 2024 08:25:42 +0200
Message-ID: <2185508.xKdoZgZVDs@tauon.atsec.com>
In-Reply-To: <ZrRUzaPVqoDAcRLk@gondor.apana.org.au>
References:
 <DM4PR21MB360932816FA7B848D7D8F7B0C7B82@DM4PR21MB3609.namprd21.prod.outlook.com>
 <2143341.7H5Lhh2ooS@tauon.atsec.com> <ZrRUzaPVqoDAcRLk@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

The user space Jitter RNG library uses the oversampling rate of 3 which
implies that each time stamp is credited with 1/3 bit of entropy. To
obtain 256 bits of entropy, 768 time stamps need to be sampled. The
increase in OSR is applied based on a report where the Jitter RNG is
used on a system exhibiting a challenging environment to collect
entropy.

This OSR default value is now applied to the Linux kernel version of
the Jitter RNG as well.

The increase in the OSR from 1 to 3 also implies that the Jitter RNG is
now slower by default.

Reported-by: Jeff Barnes <jeffbarnes@microsoft.com>
Signed-off-by: Stephan Mueller <smueller@chronox.com>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 72e2decb8c6a..a779cab668c2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1305,7 +1305,7 @@ config CRYPTO_JITTERENTROPY_MEMORY_BLOCKSIZE
 config CRYPTO_JITTERENTROPY_OSR
 	int "CPU Jitter RNG Oversampling Rate"
 	range 1 15
-	default 1
+	default 3
 	help
 	  The Jitter RNG allows the specification of an oversampling rate (OSR).
 	  The Jitter RNG operation requires a fixed amount of timing
-- 
2.46.0




