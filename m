Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75517E7D0A7
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Sep 2023 19:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjIUThA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjIUTgz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2023 15:36:55 -0400
X-Greylist: delayed 1802 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Sep 2023 10:50:02 PDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2237F19E
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2023 10:50:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1695297001; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=HH2ruYx/F1XOu46RT8HDbmtZ9DLevbRu8TKU94VKhTVGhI7N1Th0keq/fjKtUSEfRL
    21DW7c6kXkfU6dvweuJ5jtLCueWaZn+mA+SdQe3qIL30h/0vJY+JP4n2rcpu5eUeo5DB
    AH3YnVwPcFI1l7p28N2IvUWVpP0BENIRnW7tc1IxHcCqInyJ3wD03Dq11DW8Biv09hdq
    RhKG5CefF5exT+8c5d93naZl5dVyJ17lGdg78kwEyYV4XuIZtUNupeFHVcf/yJ5OIUfh
    iZ/GJmyruH/qrteQJt1e9hFlae7baO1kNy35/PUlw7UdhgRi98bjfLixkp5IvIKPYREj
    JScQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1695297001;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Wb1IkiuunxnKdYRf5sz+mfS89nVHpibtJttOQxxeHqo=;
    b=oBT7lz8QTx57SyClU1hZNUgoC5+NafuWGZtHnyja9UsQhSKrTH3HfGqr2Lb7eCnJUv
    CwU+SAzNxWkPB0xoov25i0soY3muucZpvqIiEVLnfmESINcoUGS4CWuJYbk9WK7eZGsQ
    vED2DicHp0w7lzjsT/kx5hQDv8NFZYVXoy2JEoiJV8M1hg1rYMHTSbSX5Q8V12cds+5J
    BNNsBiHsT9WQVQqNOFPpYrZTu0MaHrepKOky/t1PZtaUkWX21eSu/iWd6HnaFLpReSOI
    CRvI5Ze/JEJOh3t93zD3LhWCFLva9QRg3XSDfgaoKFUBp2JUNxpME6BK7sR17n/L1dmw
    v/XQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1695297001;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Wb1IkiuunxnKdYRf5sz+mfS89nVHpibtJttOQxxeHqo=;
    b=D5L3C+q2kWtOHzngyOYEsqrrNRv/qqhg8/5TMGtRzSOAJPXYM/VSWmXq1RXb1C+8Ec
    4XOwRd1WxRU9K3/j7arF6R1cyiDlm+rc5/zxe5gmig0v4VoEIYqeE0DtnLni09/no1uL
    4EBCV1srTvvMrQel3eRxxDewjYIIWGT8D3D0nthNbc0y87bCzwM7LKCyKwMLXjXW/4nd
    2OLcEZvpKvqwgyN8Y/fJ9a4t99T+GrXbNKCyusTITwh7uGzT1Kf7BTK8rMhgrIisU+Ee
    7i+YJdIYUeM1jzbV2g2Oo/3UmdjwVPZRP2FlXKw8+C9RP0gd2AXcCYw9UZir+jldNrq9
    6kow==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1695297001;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Wb1IkiuunxnKdYRf5sz+mfS89nVHpibtJttOQxxeHqo=;
    b=MXhvPF49MGlJm3EGXArf7Tcp0HY6nLBEhy8O0KKdzOf1uK0WYW6FTqMtPol4fSUVwl
    jVUNNjrEHq68WCz3UhDg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9yGwdNoa/n6V4wJnv+Q=="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.8.2 AUTH)
    with ESMTPSA id u045efz8LBnv8tW
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 21 Sep 2023 13:49:57 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, "Ospan, Abylay" <aospan@amazon.com>
Subject: [PATCH 3/3] crypto: jitter - Allow configuration of oversampling rate
Date:   Thu, 21 Sep 2023 13:48:59 +0200
Message-ID: <4835498.GXAFRqVoOG@positron.chronox.de>
In-Reply-To: <2700818.mvXUDI8C0e@positron.chronox.de>
References: <2700818.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Autocrypt: addr=smueller@chronox.de;
 keydata=
 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
 kBFBHm+xdudNab2U0OpfqrWerOw3WcGd2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The oversampling rate used by the Jitter RNG allows the configuration of
the heuristically implied entropy in one timing measurement. This
entropy rate is (1 / OSR) bits of entropy per time stamp.

Considering that the Jitter RNG now support APT/RCT health tests for
different OSRs, allow this value to be configured at compile time to
support systems with limited amount of entropy in their timer.

The allowed range of OSR values complies with the APT/RCT cutoff health
test values which range from 1 through 15.

The default value of the OSR selection support is left at 1 which is the
current default. Thus, the addition of the configuration support does
not alter the default Jitter RNG behavior.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig               | 17 +++++++++++++++++
 crypto/jitterentropy-kcapi.c |  6 ++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 00c827d9f0d2..ed931ddea644 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1339,6 +1339,23 @@ config CRYPTO_JITTERENTROPY_MEMORY_BLOCKSIZE
 	default 1024 if CRYPTO_JITTERENTROPY_MEMSIZE_1024
 	default 2048 if CRYPTO_JITTERENTROPY_MEMSIZE_8192
 
+config CRYPTO_JITTERENTROPY_OSR
+	int "CPU Jitter RNG Oversampling Rate"
+	range 1 15
+	default 1
+	depends on CRYPTO_JITTERENTROPY
+	help
+	  The Jitter RNG allows the specification of an oversampling rate (OSR).
+	  The Jitter RNG operation requires a fixed amount of timing
+	  measurements to produce one output block of random numbers. The
+	  OSR value is multiplied with the amount of timing measurements to
+	  generate one output block. Thus, the timing measurement is oversampled
+	  by the OSR factor. The oversampling allows the Jitter RNG to operate
+	  on hardware whose timers deliver limited amount of entropy (e.g.
+	  the timer is coarse) by setting the OSR to a higher value. The
+	  trade-off, however, is that the Jitter RNG now requires more time
+	  to generate random numbers.
+
 config CRYPTO_JITTERENTROPY_TESTINTERFACE
 	bool "CPU Jitter RNG Test Interface"
 	depends on CRYPTO_JITTERENTROPY
diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index a8e7bbd28c6e..0c6752221451 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -256,7 +256,9 @@ static int jent_kcapi_init(struct crypto_tfm *tfm)
 	crypto_shash_init(sdesc);
 	rng->sdesc = sdesc;
 
-	rng->entropy_collector = jent_entropy_collector_alloc(0, 0, sdesc);
+	rng->entropy_collector =
+		jent_entropy_collector_alloc(CONFIG_CRYPTO_JITTERENTROPY_OSR, 0,
+					     sdesc);
 	if (!rng->entropy_collector) {
 		ret = -ENOMEM;
 		goto err;
@@ -345,7 +347,7 @@ static int __init jent_mod_init(void)
 
 	desc->tfm = tfm;
 	crypto_shash_init(desc);
-	ret = jent_entropy_init(0, 0, desc);
+	ret = jent_entropy_init(CONFIG_CRYPTO_JITTERENTROPY_OSR, 0, desc);
 	shash_desc_zero(desc);
 	crypto_free_shash(tfm);
 	if (ret) {
-- 
2.42.0




