From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: testmgr - don't print info about missing test for gcm-aes-aesni
Date: Wed, 24 Jun 2015 16:44:13 +0200
Message-ID: <1441660.1IFzzoL80j@tauon.atsec.com>
References: <20150624141422.30488.59869.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47856 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbbFXOoR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jun 2015 10:44:17 -0400
In-Reply-To: <20150624141422.30488.59869.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 24. Juni 2015, 07:14:22 schrieb Tadeusz Struk:

Hi Tadeusz,

>Don't print info about missing test for the internal
>helper __driver-gcm-aes-aesni
>
>Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
>---
> crypto/testmgr.c |    3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>index 975e1ea..ad4c3e3 100644
>--- a/crypto/testmgr.c
>+++ b/crypto/testmgr.c
>@@ -2056,6 +2056,9 @@ static const struct alg_test_desc alg_test_descs[] = {
> 		.alg = "__driver-ecb-twofish-avx",
> 		.test = alg_test_null,
> 	}, {
>+		.alg = "__driver-gcm-aes-aesni",
>+		.test = alg_test_null,

Wouldn't fips_allowed = 1 be needed here?
>+	}, {
> 		.alg = "__ghash-pclmulqdqni",
> 		.test = alg_test_null,
> 		.fips_allowed = 1,
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
