Received: from sonic315-20.consmr.mail.ne1.yahoo.com (sonic315-20.consmr.mail.ne1.yahoo.com [66.163.190.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F07F267B05
	for <linux-crypto@vger.kernel.org>; Sun, 15 Mar 2026 11:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.190.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773573923; cv=none; b=gKgQVcBnRnKxzXLg0d2V8Lo8fsJwTmQ7XEJiUtGxndc+GdnyU59nOnxTFkVPKDZ9Oxb1dI6gTqd2iOfRxy6UxfGh8ZXACmDHh0YJseGWtXaohm11hohTutAcOJNc4n7pQu+I+dyMiOjj7teQjbHOQ4jKmLO0EiB6TqqLOdwE/5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773573923; c=relaxed/simple;
	bh=gduYucxqjBqP1TTNLTHUwfPheFvJi4MdSJt5Me7waws=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type:
	 References; b=EPRicv9hszZVP1gdtBTX7zwcaqLIQegjNOGPoj27yZQYAchqIKnZJ5qUBMTFNw+XOFB09N7QbS9Bu3KZY2Z49i/Sql2ESAKFfTYF9y64OWh9aPoesuSG90C+yuOkXH8ZnnJxXPBq7juwV79hsnqGTKKZaJXwlJLjyV1HemWh4gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=kTC7E3Tr; arc=none smtp.client-ip=66.163.190.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="kTC7E3Tr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1773573921; bh=yNpoaDhO5vLhq04P1glUl4rxzl5iJBWKKO4rkVZh9Ek=; h=Date:From:To:Subject:References:From:Subject:Reply-To; b=kTC7E3TrG2Q9VrH+0LrVfu33/OQAxFzQwY6ZFTlAIAuFneKXQweR2H5AIaqCLrHfmaoYQGYSnS+7SSs2BgnURvJ0wlGA4ivZzIlzMCvcRA0kKYera3eZ9okJnBsVdQLHZvDCM7Tgs/xrM+i+/T7EcQ2OeWi94KBZVPRG55Pc8nLMZ/axkTJr0NjoknmVeIBbHMm+EKkTzYWt0sgOxUdnZIAmhOMu0GJK3z8Q3vSSDvGwB/NtSfqB6DtJ38iQuAEdjXXmtXVF/kPZbL05laM+SJL9oBNyyJ6SLNtb8gWI7mWV7eLyFa0nyYY5GzbVZF7BGrRt12HXwKyiMSw0Criivg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1773573921; bh=uqWtBdstOYudK1cde5cCtKCBWgVo46yCa2sxkiUJ9JS=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=e9At2xIJK6kLox5jYIWJx/pzR+TyDNmykyteDpAqjQGqmP10d5akX1TttkhVuiIhnyeTmslu1UvIiqPu7fqol2BJcmeSTN9kMOQ0ZdF9Cd6D3zduZ+iu+CwCIs9RK4+vgNN3MrgGbIHLeMIqqghFxDmo9v/JtrFA13B+qv0rinHsLpME9ebMNR5QXauwy0hN6qyFbg7jkwBkvJd/WdrXEo6He8CcCrwx2vjtgEBZU8PXSKPIo1bU6hkNQwLOtVkeg6KvaO1ToHh53diDSHE+OcDAby6BteVOrDXeXz7br6gVA+6CUdRrqYMP3xoRC9+adLEsfIoYS4bV/QRrdQvNwQ==
X-YMail-OSG: 1jic.LgVM1n1QXilnu6neFG.fcmlabRszLK7_c2Y2h1IJevASJlhUoY1Uy6c9WD
 6fUNBAjL_O4RBdQUlQnMbmWZs5Dfx83nHNZHq1onlGRYlJSrgV7xZBsQ80QR8GwbzqTTpm6JEYZn
 MLg1YSxcxo3f4TXXNqaw_Jy_WjN.mJLb0qQbFyhr5lY.nPaBC5sxzUjhylBJD7F7lrFyUwof7Lkw
 b9X0WzF869L3b4UkiIgitLfP76SM9YRHYLtsimR2FZO.BnSkL1xz9Blb4oST2JzMHcHuzhxqAGi0
 40a0ZWOVBLjyZlYc5NKP.m0vtxbluNdnaRcJaAgsK4a485QlBWuUTzd1kpz3Y1d8r1BGvPtF1R4i
 3g2RgxXIOKMVOT68ntZdraL96aY9yQ8NNdEhyqWDymCEaVJ1pUIczZFnV.T1l7Pwuxk67I43_t75
 WGaCAYzUOu_i3vzogHh3LnCV7yfM3yQQFOD._ltMRven0W_VGHrn2NN9su6kU3fl75Eq8vBReeZE
 Xr1.nQohuWHjz42Cjh36kNOzHXfqGgW_ewVQHCYGB_oAd2OKTI1yZvs9f3Oqf5lcFZb9JogyypWy
 PQuPzoKveYwMd_QEZca.LBqTZCtSEGGGDCWJVYqRxSMEYjRE9Y9eyTjXper7J.K7w5IOTZl2XUL7
 b5eKb4d00I4lyyFGdRVa._RPirUBPLruRYUxpu6JUjUxZJq51v4GOkAl2vQeLhu7k8nUZuQw4PGx
 U4OkdN0qhxBb8lAHKnur3vI1BGF4GT7ddQEV5cfnyHUGZnm4KuHbYKz6e4TyrCwnWHElUKMsvdNd
 yX1wayt8seQeiKSrVz4J_2MMFxprwY893jeHEi8uUPi9HHaCLjlsrM7LHZpgwMVKzxOed7YQ4YF5
 Z1Ow6N9uQxWrAq5SVddBHMIc0CL9Cl2G3BBRDhAroR_LSZL2bRYMIQ6vQG94cs4Ak38jWNs5QrZQ
 A7JMgpuRZ0TUdPonMoVHX8J33_SZXP3.KxolU1e2A_yLLHovtnqu3hsJswrk_xDxeyZ.J7tJSfH3
 vkKQ1X9WCEuUyat_3kbQ74qs_mV3UXRecf7gCnNxESKI8fsft8K0VhWuu6WIlCZzU.M1xN9XUGsI
 _1G.BYh7HwRe9tZptM4Ou27Ghhla9DSLPfKAqxz1j15QnzMaTc7yIxqRHQaSYgZbSPOqUyt.ydcz
 lm8cNCy3DW723wlsv3IKp3ht0p98F0r1fiGBbE1SLB5QrYWrm8cePZ3vknAl2QaWAH.1ExNnAvYD
 bV9cDSNBBZlhopWv72xraAkVJpjjj3Ae_3dwKReqM7ZW1uKuafJdzUZBbLjaEC5M0Kw3IHALFtco
 KDAdvZpfnpU4S98xAG3pZ7Kh1ckXr.CnilvSsnxyaxArCxPlBV0v9xytx2HATxNLNpUPrOTewPhm
 SvhBGhjOyxU9oMIQGngcCOB0_gzgcq5NTE_timSCMqJo1ybICM5J.e2QsIf9vU1vac.qNWl640uV
 0xl587SWItcwsrX5y8mQf5vvpB5PmsknvuMTLMInqENo3jzBJIIc1yHOPJhcS4RMoiRJZO5ACOo0
 Iu1gM880f0uU5qDu5iT60iEAcMOAf7iBKJZYxMesTaR9UmgicVpmxjX4TaLmnsuKM52QDD8LJZU1
 8VvnkIAPjRi9uaBKOEo1G_d1qAw8rEJNmnnrnE5cuXMOCo6rzdROyxW0k9m3qVw5wdsTWBRdjo8L
 T2Akoz3qTyPQnpkLcdw63J91gt75012R5vOiFMf.oymcOjj10PSYsnhaqezZiDpdF2z8LZzh287a
 aCgDjhHSB86hU2ZJovzs7GgAVyseM9hGmAU772vfK8Dgq0bQSWhGGcMuk0gqFNCXM.eIqdS6HTy.
 htsCMd3h2vBnJHRdwEI4cyqmtKmxmegbnI.0bpCscSGlrP3_PgTJhnaAbivJrhRdihwH7bR8ENve
 sg4hnf5zJqu8TlP4Fg1ycJY5gQbzZipGYqr7zjaY.S2VaEkulzYQpsizvNJpZlMgaxS0K957V_3p
 PiNBTI__Gcp2_SOMjUnvdwOSW_F.w7f1gv5hh_FXsXYnLM.D_mZM2AoDDgT_pxp64AFD7O6MCekH
 n50AQBvWCRohXhXzCSckLfXrWzteq_uTB.eTk3Xb7BdJgIkQcsDmg8T2KmYys459gq3D1QoO_hld
 wyq0O7VNcn8e3zMbu6QoZ.gVZhVqWifpX2_RmsEz0K9Axn1TDIdfTBQ8sGH0iX6f_W9b6IKaQ4wV
 L7SZV3FK9xEVnR4Sz4aeDwPVorFKUj7lp5zFpO94-
X-Sonic-MF: <namiltd@yahoo.com>
X-Sonic-ID: 83b4b31f-08d5-457b-8fd8-c724d411738a
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Sun, 15 Mar 2026 11:25:21 +0000
Date: Sun, 15 Mar 2026 11:05:03 +0000 (UTC)
From: Mieczyslaw Nalewaj <namiltd@yahoo.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Message-ID: <1003432575.1235274.1773572703895@mail.yahoo.com>
Subject: [PATCH] crypto: inside-secure/eip93 - correct ecb(des-eip93) typo
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1003432575.1235274.1773572703895.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.25297 YMailNovation

Correct the typo in the name "ecb(des-eip93)".

Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
---
drivers/crypto/inside-secure/eip93/eip93-cipher.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-cipher.c b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
index 7893c15..4dd7ab7 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-cipher.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
@@ -320,7 +320,7 @@ struct eip93_alg_template eip93_alg_ecb_des = {
.ivsize = 0,
.base = {
.cra_name = "ecb(des)",
- .cra_driver_name = "ebc(des-eip93)",
+ .cra_driver_name = "ecb(des-eip93)",
.cra_priority = EIP93_CRA_PRIORITY,
.cra_flags = CRYPTO_ALG_ASYNC |
CRYPTO_ALG_KERN_DRIVER_ONLY,
-- 
2.47.3
