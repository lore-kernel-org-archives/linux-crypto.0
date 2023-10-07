Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7998E92FFD
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Oct 2023 07:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343635AbjJGHKy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Oct 2023 03:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343572AbjJGHKx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Oct 2023 03:10:53 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EA8BF
        for <linux-crypto@vger.kernel.org>; Sat,  7 Oct 2023 00:10:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1696662645; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=hVwS4POw3U2MdC/1YmWbBvp44sIdKQFMrSYxE2bUtPnHLqNHVKGjXPjC0O/dapzRPO
    7ePdPtXBIqlb59W2m++xahrCWsYk300tH53Ggl6qEZjRNeau9fDOMGUhp36wDnIwKHfF
    khfMgTAyzfG4fHjeVj3DyqkpPEvBGwt/o8XZ7lH1PCUNYLoPburelaiCPzVTHFBsZtVA
    0b2PVJM2I3Db2olhC0OanH65u3eogIHkQWfvfy61SRcw4go4bXCDzD+9HVAf+gQfPZ6i
    TNZhJGsNx9C6yXA+Zr6GELoUREa7irh9l1k0Tby7XFkvGGJrLTNRQh+e79YoL7/P3ZXI
    V0hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1696662645;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=nrsMyEP+XcGESJrgp1bdpydZ9zpzvdAecqVpNJ17h6Q=;
    b=Pakal1pu61Fnuz0q8GaJg3b71JptlfVe3ILg584YpA/slG4XD3sO239U4qeCANqn+2
    pBgIx76/ZvbS1Ri89JpKIDUHPbkB8z+j2WByzKCeu+Q0uX8e+5ndILCLk2qb1nhNiXgi
    KrpklmTYxyPqsSvFPYVQnFO6tW5kadhNyiQLkrUpyqpq/qHXXFR0h4kwbkx0KYJ/HRqb
    RNbn1BVEfDVi9FYCWJ5rJ/Hs7OBOskz9/+cREZL9hBPOltTAosi081zkCWHW5r58t0kT
    AP8C9y5XnK+at6DyiIuA0bHQ3DrT8tGi9SyPTwFrlCDwJOsfIrAPfkfEBczgMSimucle
    Kqyw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1696662645;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=nrsMyEP+XcGESJrgp1bdpydZ9zpzvdAecqVpNJ17h6Q=;
    b=pC4KonsqFsexLX5wx1fZ0B2CnsKALmoqjf30loduf4Su2dtqCBDNSrFrFfhRylRz6C
    2ev7UQSas11I/p+mqLbOld75QOTrow4sJENhAfCAF/X7ryzzkk6Sm9uuoN3xvSIsBVvT
    YNXOxA2K6YDSLj114FUJkuv3i5/C6wgDzabITJKXse6S5I077nkszbg02kQ0UI1VVziV
    3qouqSiBzhV6GfCmJv89266Raijb+EPSvfAoJREx1aJUdLG32NJxIag7xG0mNY2jlYOr
    9MQq4S6I8FuUI5MjCYykX4LXD6OV3Atv+7zB4VrQDSmphJAsJIME4etXA3BAOYLp4oTr
    Tp2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1696662645;
    s=strato-dkim-0003; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=nrsMyEP+XcGESJrgp1bdpydZ9zpzvdAecqVpNJ17h6Q=;
    b=LxnhS9JQqxwSjU44wVHV1hHv1Wi4ZFnwnw9QFBtdCkCi52nHG+TPRhC0zP7ieRISAM
    vzO+4envmLCUAjklPBCg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNkCSvDj2bFe3KpE="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.8.2 AUTH)
    with ESMTPSA id u045efz977AhMQ4
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 7 Oct 2023 09:10:43 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>,
        "Ospan, Abylay" <aospan@amazon.com>
Subject: [PATCH] crypto: jitter - reuse allocated entropy collector
Date:   Sat, 07 Oct 2023 09:10:43 +0200
Message-ID: <2701954.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Autocrypt: addr=smueller@chronox.de;
 keydata=
 mQENBFqo+vgBCACp9hezmvJ4eeZv4PkyoMxGpXHN4Ox2+aofXxMv/yQ6oyZ69xu0U0yFcEcSWbe
 4qhxB+nlOvSBRJ8ohEU3hlGLrAKJwltHVzeO6nCby/T57b6SITCbcnZGIgKwX4CrJYmfQ4svvMG
 NDOORPk6SFkK7hhe1cWJb+Gc5czw3wy7By5c1OtlnbmGB4k5+p7Mbi+rui/vLTKv7FKY5t2CpQo
 OxptxFc/yq9sMdBnsjvhcCHcl1kpnQPTMppztWMj4Nkkd+Trvpym0WZ1px6+3kxhMn6LNYytHTC
 mf/qyf1+1/PIpyEXvx66hxeN+fN/7R+0iYCisv3JTtfNkCV3QjGdKqT3ABEBAAG0HVN0ZXBoYW4
 gTXVlbGxlciA8c21AZXBlcm0uZGU+iQFOBBMBCAA4FiEEO8xD1NLIfReEtp7kQh7pNjJqwVsFAl
 qo/M8CGwMFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQQh7pNjJqwVsV8gf+OcAaiSqhn0mYk
 fC7Fe48n9InAkHiSQ/T7eN+wWYLYMWGG0N2z5gBnNfdc4oFVL+ngye4C3bm98Iu7WnSl0CTOe1p
 KGFJg3Y7YzSa5/FzS9nKsg6iXpNWL5nSYyz8T9Q0KGKNlAiyQEGkt8y05m8hNsvqkgDb923/RFf
 UYX4mTUXJ1vk/6SFCA/72JQN7PpwMgGir7FNybuuDUuDLDgQ+BZHhJlW91XE2nwxUo9IrJ2FeT8
 GgFKzX8A//peRZTSSeatJBr0HRKfTrKYw3lf897sddUjyQU1nDYv9EMLBvkzuE+gwUakt2rOcpR
 +4Fn5jkQbN4vpfGPnybMAMMxW6GIrQfU3RlcGhhbiBNdWVsbGVyIDxzbUBjaHJvbm94LmRlPokB
 TgQTAQgAOBYhBDvMQ9TSyH0XhLae5EIe6TYyasFbBQJaqPzEAhsDBQsJCAcCBhUKCQgLAgQWAgM
 BAh4BAheAAAoJEEIe6TYyasFbsqUH/2euuyRj8b1xuapmrNUuU4atn9FN6XE1cGzXYPHNEUGBiM
 kInPwZ/PFurrni7S22cMN+IuqmQzLo40izSjXhRJAa165GoJSrtf7S6iwry/k1S9nY2Vc/dxW6q
 nFq7mJLAs0JWHOfhRe1caMb7P95B+O5B35023zYr9ApdQ4+Lyk+xx1+i++EOxbTJVqLZEF1EGmO
 Wh3ERcGyT05+1LQ84yDSCUxZVZFrbA2Mtg8cdyvu68urvKiOCHzDH/xRRhFxUz0+dCOGBFSgSfK
 I9cgS009BdH3Zyg795QV6wfhNas4PaNPN5ArMAvgPH1BxtkgyMjUSyLQQDrmuqHnLzExEQfG0JV
 N0ZXBoYW4gTXVlbGxlciA8c211ZWxsZXJAY2hyb25veC5kZT6JAU4EEwEIADgWIQQ7zEPU0sh9F
 4S2nuRCHuk2MmrBWwUCWqj6+AIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRBCHuk2MmrB
 WxVrB/wKYSuURgwKs2pJ2kmLIp34StoreNqe6cdIF7f7e8o7NaT528hFAVuDSTUyjXO+idbC0P+
 zu9y2SZfQhc4xbD+Zf0QngX7/sqIWVeiXJa6uR/qrtJF7OBEvlGkxcAwkC0d/Ts68ps4QbZ7s5q
 WBJJY4LmnytqvXGb63/fOTwImYiY3tKCOSCM2YQRFt6BO71t8tu/4NLk0KSW9OHa9nfcDqI18aV
 ylGMu5zNjYqjJpT/be1UpyZo6I/7p0yAQfGJ5YBiN4S264mdFN7jOvxZE3NKXhL4QMt34hOSWPO
 pW8ZGEo1hKjEdHFvYowPpcoOFicP+zvxdpMtUTEkppREN2a+uQENBFqo+vgBCACiLHsDAX7C0l0
 sB8DhVvTDpC2CyaeuNW9GZ1Qqkenh3Y5KnYnh5Gg5b0jubSkauJ75YEOsOeClWuebL3i76kARC8
 Gfo727wSLvfIAcWhO1ws6j1Utc8s1HNO0+vcGC9EEkn7LzO5piEUPkentjrSF7clPsXziW4IJq/
 z3DYZQkVPk7PSw6r0jXWR/p6sj4aXxslIiDgFJZyopki7Sl2805JYcvKKC6OWTyPHJMlnu9dNxJ
 viAentAUwzHxNqmvYjlkqBr/sFnjC9kydElecVm4YQh3TC6yt5h49AslAVlFYfwQwcio1LNWySc
 lWHbDZhcVZJZZi4++gpFmmg1AjyfLABEBAAGJATYEGAEIACAWIQQ7zEPU0sh9F4S2nuRCHuk2Mm
 rBWwUCWqj6+AIbIAAKCRBCHuk2MmrBWxPCCACQGQu5eOcH9qsqSOO64n+xUX7PG96S8s2JolN3F
 t2YWKUzjVHLu5jxznmDwx+GJ3P7thrzW+V5XdDcXgSAXW793TaJ/XMM0jEG+jgvuhE65JfWCK+8
 sumrO24M1KnVQigxrMpG5FT7ndpBRGbs059QSqoMVN4x2dvaP81/+u0sQQ2EGrhPFB2aOA3s7bb
 Wy8xGVIPLcCqByPLbxbHzaU/dkiutSaYqmzdgrTdcuESSbK4qEv3g1i2Bw5kdqeY9mM96SUL8cG
 UokqFtVP7b2mSfm51iNqlO3nsfwpRnl/IlRPThWLhM7/qr49GdWYfQsK4hbw0fo09QFCXN53MPL
 hLwuQENBFqo+vgBCAClaPqyK/PUbf7wxTfu3ZBAgaszL98Uf1UHTekRNdYO7FP1dWWT4SebIgL8
 wwtWZEqI1pydyvk6DoNF6CfRFq1lCo9QA4Rms7Qx3cdXu1G47ZtQvOqxvO4SPvi7lg3PgnuiHDU
 STwo5a8+ojxbLzs5xExbx4RDGtykBoaOoLYeenn92AQ//gN6wCDjEjwP2u39xkWXlokZGrwn3yt
 FE20rUTNCSLxdmoCr1faHzKmvql95wmA7ahg5s2vM9/95W4G71lJhy2crkZIAH0fx3iOUbDmlZ3
 T3UvoLuyMToUyaQv5lo0lV2KJOBGhjnAfmykHsxQu0RygiNwvO3TGjpaeB5ABEBAAGJATYEGAEI
 ACAWIQQ7zEPU0sh9F4S2nuRCHuk2MmrBWwUCWqj6+AIbDAAKCRBCHuk2MmrBW5Y4B/oCLcRZyN0
 ETep2JK5CplZHHRN27DhL4KfnahZv872vq3c83hXDDIkCm/0/uDElso+cavceg5pIsoP2bvEeSJ
 jGMJ5PVdCYOx6r/Fv/tkr46muOvaLdgnphv/CIA+IRykwyzXe3bsucHC4a1fnSoTMnV1XhsIh8z
 WTINVVO8+qdNEv3ix2nP5yArexUGzmJV0HIkKm59wCLz4FpWR+QZru0i8kJNuFrdnDIP0wxDjiV
 BifPhiegBv+/z2DOj8D9EI48KagdQP7MY7q/u1n3+pGTwa+F1hoGo5IOU5MnwVv7UHiW1MSNQ2/
 kBFBHm+xdudNab2U0OpfqrWerOw3WcGd2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In case a health test error occurs during runtime, the power-up health
tests are rerun to verify that the noise source is still good and
that the reported health test error was an outlier. For performing this
power-up health test, the already existing entropy collector instance
is used instead of allocating a new one. This change has the following
implications:

* The noise that is collected as part of the newly run health tests is
  inserted into the entropy collector and thus stirs the existing
  data present in there further. Thus, the entropy collected during
  the health test is not wasted. This is also allowed by SP800-90B.

* The power-on health test is not affected by the state of the entropy
  collector, because it resets the APT / RCT state. The remainder of
  the state is unrelated to the health test as it is only applied to
  newly obtained time stamps.

This change also fixes a bug report about an allocation while in an
atomic lock (the lock is taken in jent_kcapi_random, jent_read_entropy
is called and this can call jent_entropy_init).

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/jitterentropy-kcapi.c |  2 +-
 crypto/jitterentropy.c       | 36 ++++++++++++++++++++++++++----------
 crypto/jitterentropy.h       |  2 +-
 3 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 0c6752221451..76edbf8af0ac 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -347,7 +347,7 @@ static int __init jent_mod_init(void)
 
 	desc->tfm = tfm;
 	crypto_shash_init(desc);
-	ret = jent_entropy_init(CONFIG_CRYPTO_JITTERENTROPY_OSR, 0, desc);
+	ret = jent_entropy_init(CONFIG_CRYPTO_JITTERENTROPY_OSR, 0, desc, NULL);
 	shash_desc_zero(desc);
 	crypto_free_shash(tfm);
 	if (ret) {
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 18bbe2b89a94..86ffdd6735cc 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -611,8 +611,7 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 			 * Perform startup health tests and return permanent
 			 * error if it fails.
 			 */
-			if (jent_entropy_init(ec->osr, ec->flags,
-					      ec->hash_state))
+			if (jent_entropy_init(0, 0, NULL, ec))
 				return -3;
 
 			return -2;
@@ -686,14 +685,30 @@ void jent_entropy_collector_free(struct rand_data *entropy_collector)
 	jent_zfree(entropy_collector);
 }
 
-int jent_entropy_init(unsigned int osr, unsigned int flags, void *hash_state)
+int jent_entropy_init(unsigned int osr, unsigned int flags, void *hash_state,
+		      struct rand_data *p_ec)
 {
-	struct rand_data *ec;
-	int i, time_backwards = 0, ret = 0;
-
-	ec = jent_entropy_collector_alloc(osr, flags, hash_state);
-	if (!ec)
-		return JENT_EMEM;
+	/*
+	 * If caller provides an allocated ec, reuse it which implies that the
+	 * health test entropy data is used to further still the available
+	 * entropy pool.
+	 */
+	struct rand_data *ec = p_ec;
+	int i, time_backwards = 0, ret = 0, ec_free = 0;
+
+	if (!ec) {
+		ec = jent_entropy_collector_alloc(osr, flags, hash_state);
+		if (!ec)
+			return JENT_EMEM;
+		ec_free = 1;
+	} else {
+		/* Reset the APT */
+		jent_apt_reset(ec, 0);
+		/* Ensure that a new APT base is obtained */
+		ec->apt_base_set = 0;
+		/* Reset the RCT */
+		ec->rct_count = 0;
+	}
 
 	/* We could perform statistical tests here, but the problem is
 	 * that we only have a few loop counts to do testing. These
@@ -783,7 +798,8 @@ int jent_entropy_init(unsigned int osr, unsigned int flags, void *hash_state)
 	}
 
 out:
-	jent_entropy_collector_free(ec);
+	if (ec_free)
+		jent_entropy_collector_free(ec);
 
 	return ret;
 }
diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
index e31661ee00d3..aa4728675ae2 100644
--- a/crypto/jitterentropy.h
+++ b/crypto/jitterentropy.h
@@ -12,7 +12,7 @@ int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_len);
 
 struct rand_data;
 extern int jent_entropy_init(unsigned int osr, unsigned int flags,
-			     void *hash_state);
+			     void *hash_state, struct rand_data *p_ec);
 extern int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 			     unsigned int len);
 
-- 
2.42.0




