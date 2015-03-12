From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 0/6] Introduce devm_hwrng_register and convert a few dirvers
Date: Thu, 12 Mar 2015 14:00:01 -0700
Message-ID: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33581 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbbCLVAc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Mar 2015 17:00:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A few drivers can benefit from devm-style interface for hwrng since it
is quite often the last thing that isn't automatically managed. Using
devm_hwrng_register() in such drivers allows get rid of manual error
unwinding and drivers' remove() methods.

I tested changes to iproc-rng200, the rest are compiled only.

Thanks.

-- 
Dmitry
