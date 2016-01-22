From: Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH] crypto: chacha20_4block_xor_ssse3: Align stack pointer
 to 64 bytes
Date: Fri, 22 Jan 2016 08:55:24 +0100
Message-ID: <1453449324.36963.7.camel@strongswan.org>
References: <1453393448-13636-1-git-send-email-elicooper@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Eli Cooper <elicooper@gmx.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:48718 "EHLO
	mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbcAVIFI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jan 2016 03:05:08 -0500
In-Reply-To: <1453393448-13636-1-git-send-email-elicooper@gmx.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Eli,

> This aligns the stack pointer in chacha20_4block_xor_ssse3 to 64 bytes.
> Fixes general protection faults and potential kernel panics.

I assumed 16-byte alignment according to the System V AMD64 ABI, but
this is obviously not true with -mpreferred-stack-boundary=3. The AVX2
version seems to be ok, so is Poly1305.

Acked-by: Martin Willi <martin@strongswan.org>
