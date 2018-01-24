From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] sparc64: fix typo in CONFIG_CRYPTO_DES_SPARC64 =>
 CONFIG_CRYPTO_CAMELLIA_SPARC64
Date: Wed, 24 Jan 2018 16:50:01 -0500 (EST)
Message-ID: <20180124.165001.873099042670433590.davem@davemloft.net>
References: <1516717994-24407-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
To: clabbe@baylibre.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:50710 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932474AbeAXVuD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 16:50:03 -0500
In-Reply-To: <1516717994-24407-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Corentin Labbe <clabbe@baylibre.com>
Date: Tue, 23 Jan 2018 14:33:14 +0000

> This patch fixes the typo CONFIG_CRYPTO_DES_SPARC64 => CONFIG_CRYPTO_CAMELLIA_SPARC64
> 
> Fixes: 81658ad0d923 ("sparc64: Add CAMELLIA driver making use of the new camellia opcodes.")
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

Applied, thank you.
