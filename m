Received: from sonic312-50.consmr.mail.gq1.yahoo.com (sonic312-50.consmr.mail.gq1.yahoo.com [98.137.69.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DBC2E36E3
	for <linux-crypto@vger.kernel.org>; Sun, 13 Jul 2025 13:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=98.137.69.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752414531; cv=none; b=aPG/cpO+1we5L+CJ8fAHs3Hul0etg577hekVzLsadIRk2Ki0LcX/J1ZJKlXwSfnjHf7b7G19/6W7ydNRuWUAiWey5qY+OtAbZLlJrNZUPsUOpWRXllecrtvtCptU/NSkE4I/Ayk9PG6mcdqgD6jeZfxTzNlel/oe/bfe7eEaXZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752414531; c=relaxed/simple;
	bh=b5+k4CcPiOfmdikq/ISS0LQzkpAhBg8sAYUKHOoombc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:References; b=KpCQWUHTrovE5G2zuOYVWrCxIGLFbNwH9zPkUMj0NXv5mqQouVTWla9hmwLKqN9wx7WqbwGwAJWvJv8GqXtZeIwfM6Cd4mVB5opndxREWLyOigZm3+Ul1eXITLn7PnL/zOE0XlSSzpwf1O2Oei7yicrI3M7cIMoYTbcFAllep/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aol.com; spf=pass smtp.mailfrom=aol.com; dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b=VTvQAe+a; arc=none smtp.client-ip=98.137.69.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aol.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="VTvQAe+a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1752414523; bh=YVxrRfY0ZcMh2YBMkFdorjPbvq5RL7xja7NFFKKz8A0=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=VTvQAe+aKJXRnFJnrEignIoqAp96I3eR2bfRQ9cTeTFTHtHAEhBhwJ7hLhpVpsVt68uAF7XGcoG4V1TFTMKqdUKKC9phzhWRKVgX3W1oZSRhQaC1Nw2E+5VO2oRZGcmuR/liyJLVsKEco+FQD8/xcpKJrUaJPxrFZ0Gx0aXdJN58mJM+PXinWMAo4CzrdkRoYzI+QBHJCwvCZhETQ0Oa/2Seey0sRc+/JJVdDs7UUEEjg0x7lSNU72VrOjIYgAY0DKy63FvkXvdCQ3+9B7ZkPuFtFIdG+kV303cBCZN5j1TAc5HggmOYTzZWvSCq2q5pr1n36k/8DkcWE1WC9BHTLw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1752414523; bh=b1ptXn1+o2Bcugzl7xhHaPlTz092qJCCp09wIlk3eMi=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=N9NSiAqC87upZapQTUCvHfrHTlDKDQd0MFx/IMCi+r2zHww3oKS1haOpYiM48lCUCtzQJuxGv9rXEiB7/rFm9NoxbcpIq/M8m0/Y9VtJUftaFlKZ6JEb2RRQGsDnq2ZyJ/WqEBfdqI33eywmC6bPltACmev4qHDXSv6dWKeQFL6UPuOiy7URlvQAqnlwY/bVZF34qe5xBJ/fwzZt8Zje+t3VX032Ax2yTJuE5yV1A8rYZYtnf1N8+/mRuXx5OEXte14rqyn2PLBb4kENCKnm7TkePwpwh5fzHkHiuy9WeHwLiUzYxQyanYnKe3HaHf24SC05D0mdCoyg9leWFcZKwA==
X-YMail-OSG: nyDZomUVM1mhYgvJgAu31pmGwIQB4AKw5VEtaWWeekSlOH.GoKI.fYR1bd6I.DE
 eNdB9BK5pljR5zfJ35FAWlaRbHhiUba2kTvyEz1.b_hLrXzf6an3sC4RmEbX1eqOxjx.NI1A3aDC
 BS85gISm.Hd06HYcpRVXhT19BOVLak3SAgQkKeK.nYcnVSGhImN8Hrej9vmps8Rk1B3Ad6hXjc6E
 f4uNfRETOh20.4QD1SERPNX.o86ePJlvbgkd7fFkVQhqnkBxzNMUMaSCbvtFb9oZVm9stBmMl2zT
 03MymC6iHIPUMTfKCT7EWImyH7hbaa7Sggg5HAg1FBzJlEi2d3VWUA4cJKYtUDcXHEk0A2ihZi7g
 vo4iDEd7s4G7AmDl2NAUxKyKxt1i0JHoyl13ZtNDZw2ePEq9CdhTFTelRGAQVOJDjGV5WxQx_RDB
 QoHf.dmOgzAkCtzZoENNKodIh1t_8yOlt4HVzOOvB0MjzF_RUYXHoA2D5NAppfuRho_ln0Lqr3on
 liu_rvyQCSir6nZu1MDNywfbsIpf1VHjySoMKhKHmVE_4UXp5oaZRG6zR82aEwB2pDCKGfhIrWeo
 ObFa7DLSbzX9Ab_oSvrKz3T2KO413I6yJ5to5XLwkuzBoouQl6bcLTX0j2kolygHS84yTl6dH6fU
 gn5O32o2M4gzvFWJWU6GBHno1L7EyCj3fSmv4nmkO98XGn2Z_0kBFWBDNeA_CNJV18KpNamEiutQ
 79GKIiYx125EnOp3BOwXwGxXuhBEn8j2nuOurPTt6ZVoErEGzjZAwyaqQpHDyoTOgZoXPhFLUCsC
 OpI3ROcFOT19BAvRS400ZP0xbOBpDQsmIYKhwrcrG_ag5KD4lnHKcpdq6ZstYZwAo3jNnTV8Bb93
 ACydUYNfWMXos4qEJs2rs3cGO88XhCaJOzRtrwrdTNRUsMqmTGI9A886tmlRX3Bt08sDZWMnIBb7
 M_HvvOjpKOA7QMaMF7OF5t83ZzWEBrzXJOBqLEnvE9pN_HxKw73EN3lwFDCL7YXQ7Y.VIcId_qPd
 NP4qjm5Zx98Eb4zv.01Fo_9hPxMyMj2HQxeJfn6Jl9GTn9s4d7Hy2B5mDM28clsrFpwDwtD2VNgX
 1aAzfpyEcafaEMQqTdyWoFCQ_ZyF8hZHTitFbwDlM95ZsePBng87EJQvSZFPAufCq9NViJqlLt7R
 2tlJD2YaR3YIcb.EmOAygnwmHfpKKuEuaWFOeHx.ofkByDWvWmVJcwEZAqLKav0HoaBcskjpMEEQ
 TeM5k9bpalOB2KOl6cfbsRIRl18uQBJmjU82NpxPLP6jq72WaSD3CA0dSe2RoNJlW6tqxwiz6.Ox
 v6yGyM5MBtYMlVLXjt2Ik3PiME5V4blnr9XpqvijdX0Zu46e307gIPvUNZy1Ezm06z002LcE.uf9
 by_2GAad_1qYnfde0PzwsJgaeYWKZwXe2FNGCB0e3erCogSIVASh36oDHkw7GvZnyjQ8mOOS90_k
 IkgLxn0HeHVen20FcFXTRW0Ljpk3XlLY4LneWrp0kmpRJi6Jl0EU8lRHqERmRXd_mq020Cn0TUiX
 TFWlOgYUrHRLInbCs0QQxo3JWx8w4aPM_FY5lqzHgxsptn5TLhBTvN6Xu2ae6XDZhNjLVGih7bTY
 tK9sGC8ilEIeC32rSfIiGMAWKHIfAkP1J.5KocNI4ObUXikNFMg.ibzujKQYY3FoArVw.9OFtH0Z
 MUjdlp_.jatdw2toMWqhX0sgN9lj30o7G4K.9bwswPzorNwyh9GUYOJWwE9qvgu_cwlKoF_0.UHR
 e771v0A8ujzcVzavba14Z.nagRdeZDm47BLHrckwubW8DCtoO0N1rigRlhJgZkTfpLQnQvDmDNny
 37StcL9OGK4oebR3LJBv5wxEXJ3L429JiDkCjqulOz5AgjHe44qj0ncDCAbPL9tFChBkBZqsL_aA
 Kn7LL7yYK9zSfWH_ViOAb36YevrYMRHAQHLLdk4mDJGRyN.6adR8moCEGRqb5_boqBhAeT2bln4y
 treTHHJ3wBI807CkUE0RPGSKTCsF8EE9.Qyt4A5NC5Nu8pl5hgYj8p7VzSfBOgo_vxidagyHwGyF
 YQI7FLurhnvbz.AbrCYUfwEMgtN0gehIfAdqtjJbLNI6Nini0bfZa.lSWLUCWS1Xpu2zW0yJUr1u
 LZAMaA4e4Au2QES70jY6lRhekMKqK.8x1lbA.YSJs1NPwQMsZV3DqSvaQqLb008p77zSvOKcrfoy
 ZDQ6SmyP33EeX6.xFSMbBa0XjeD5UDkRLnPlFy8.kDdmK97Xl6JK8i7bHoBcYp55_TQ005Maz.B8
 SngIulXQ6Z9ZRwXWYMLzwvHyK8mcdN01ulbZHC.07
X-Sonic-MF: <rubenru09@aol.com>
X-Sonic-ID: bb0f07d6-f911-40bf-b427-426bd7a2e1bb
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Sun, 13 Jul 2025 13:48:43 +0000
Received: by hermes--production-ir2-858bd4ff7b-mfhj2 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 2cb29ace9bc0ca72342193b636377030;
          Sun, 13 Jul 2025 13:16:20 +0000 (UTC)
From: Ruben Wauters <rubenru09@aol.com>
To: Herbet Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Ruben Wauters <rubenru09@aol.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: jitter - replace ARRAY_SIZE definition with header include
Date: Sun, 13 Jul 2025 14:13:50 +0100
Message-ID: <20250713131608.38859-1-rubenru09@aol.com>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20250713131608.38859-1-rubenru09.ref@aol.com>

The ARRAY_SIZE macro is already defined in linux/array_size.h

This patch replaces the ARRAY_SIZE definition in jitterentropy.c with
an include, to make the code cleaner, and help reduce the number of
duplicate ARRAY_SIZE definitions in the codebase.

Signed-off-by: Ruben Wauters <rubenru09@aol.com>
---
 crypto/jitterentropy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 3b390bd6c119..2920ecbf3f13 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -147,6 +147,7 @@ struct rand_data {
 
 #include <linux/fips.h>
 #include <linux/minmax.h>
+#include <linux/array_size.h>
 #include "jitterentropy.h"
 
 /***************************************************************************
@@ -178,7 +179,6 @@ static const unsigned int jent_apt_cutoff_lookup[15] = {
 static const unsigned int jent_apt_cutoff_permanent_lookup[15] = {
 	355, 447, 479, 494, 502, 507, 510, 512,
 	512, 512, 512, 512, 512, 512, 512 };
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
 static void jent_apt_init(struct rand_data *ec, unsigned int osr)
 {
-- 
2.49.1

