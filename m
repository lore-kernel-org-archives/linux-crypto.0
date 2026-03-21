Received: from sonic303-21.consmr.mail.ne1.yahoo.com (sonic303-21.consmr.mail.ne1.yahoo.com [66.163.188.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE1E286D73
	for <linux-crypto@vger.kernel.org>; Sat, 21 Mar 2026 10:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.188.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774089006; cv=none; b=fcNOMN4eIHAvAxA7Xke/eNKQaMiHoJjQF91hKCstc/lM3sJeQuPSfK6eJZ6PeQSt6lyepFV4rdujRer0O7kTE+Imy39OpWQp6qhIrD/YgK0JyHqkcw7tldvmUU0wQ5skOcry8BU2wosPl8D+/5VQg2qLMnumKBBYw58mYmwNXs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774089006; c=relaxed/simple;
	bh=hiLW7GUrNZQD6ulC+/25pmQqyLT0p02LH6ZyzHSLEGA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:
	 References; b=GRNGLpKZ5SSsATkeOSjG2pnWrLhaRIRsWpRGDg/xjOEai6qPyuZHGcipyR69dAKiV5u8aYqm1X65ekosJjYA3n/tzxaVsTu9YXeKcNklTPO7mvb6zXPofc8SscYznjZdKDERJWnvmqWAqWkXwW4WDTcj6fypl4LkVCBo2H7DLUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=cugrTGMB; arc=none smtp.client-ip=66.163.188.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="cugrTGMB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1774089004; bh=+RM5D3BYPYaGZuq1WM5UhP2k4zjNkFNopxt1z6xM2+g=; h=Date:To:From:Subject:References:From:Subject:Reply-To; b=cugrTGMBltKzbns1B3vasfjv6rzm9N6L25BWjmpmDpr4JYqTDb8YdMXqI+x5W5x2TCBlxbs4PhwI0fwExu+KqV3gj95deJxfMn9c0Ynj9wPV/ByA4iCUyJL4pmASSp2Wuo5PpauRfPWlYpBXX3rrmv3/oGReaYMMsMgAsqEMUpSCV+PIhugxcvg8kWNriZI2LAmAMs1v9jAGucPe0B9fMtbqw3p5OzD+g4GmVpOuZkd4457HKhcgdKBsI3GAXJ2WDhC6dOrKyOXcNBq52ihWQtqgnhqmQ+UHshK/E960RG2e0w6Q1r/NvGQ02ruerllVrXIyJzIdgF2QPKMFkYH8Jg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1774089004; bh=6/Nw7VXzGQixoFlwdGkkthpgpOJqYmg0Xq4rq2J9FHF=; h=X-Sonic-MF:Date:To:From:Subject:From:Subject; b=Mygm3sQGHSvFC0VYI97q7yQZ75GGkqN0fS5TXA1ojNoTORPh5pCJsQ6GwVhPb08ikKPZ8xOVMZT+s0JS8pi2s5RUgybNI4E5gX2fJdD3HIXHnXBQL99xzN8ktHMMEcirpFOHK2/bW1TBR32ROiwV+hd3cAKRTogtzPxcLH1MYWCHwcc8+z+IHwaB8jy90la8IpISwaylHqT9aX0XlwRkxO4de0WGvxZs/cI65Y4gFkuJg1bfARRlQjCNz9b/lynhYXEVUzbKv8SCSzvlAJHSkJoL42ir7TweZJ8k5wBGjC08yy+UGJd2yVwF3R56yKX+nRwYLdD72ASo0qoxExdGRA==
X-YMail-OSG: SHFj0IYVM1l9OxS4gI58o52cR8zVXDC4i.1QTsJE2Hu_FUoTJTfk.cTfFCWSPK6
 XWhJKn7JAKij8Kzlz7W6jQaS72VsLX.71vpMNUtk8x4ItNffp2rImaAK06p_2ift40ZNesXAqiGk
 fZDljk2jkieJip5yDnAK67_hwUuYWi9g_Adc3okbbURxMowxLNpY6Is3GL6wTUNeq6RNHZR.CMc6
 sNgfe.M9GbN1UPUE0QNsomDDIcgSDkAqEWKE8vssXcuYEOYZ4EZpHI1qJyuJ4dm4Fw8lRBtDlVmF
 RI9lP7ctZbH4nF8KsMdrg5bXYXiNyrHP8Yi2m_v.cc85EVDQTsVMibzVnCwhZxidv2wEMJYT1U2S
 qNYe6OKAqGtETPDWKMUa8kd.jXgNZEbflvCF8XuuEuoLZQJ9BuanFPv_K8jzaiwYtPQ0XIVAGqEN
 3D3dpMQejTbSQ9KUA5x9skghYAo57UGZXkzLj9TqIbeWiApNUbZAm_M0vdJDC.9WLtjfMw0ogWSs
 qWHNwTfPtgwlJY56RIGddrxFfhwylJxslJK_4onToyZErqzBC5ATUmfyj16EbN8HGPeXbMo8PK1q
 mJ0VkVCU9_ZrZ8AA.YE72G7T01QinOHyGHBjwn2H2PQk6gGLfq5OBYmmP_KGwyHTjd6C11pGsrfT
 x27CkYUhi7FGvBAcff6mIx0Q_YDH3uzxQU7zlFIkD95.K_J68Jds1DFNXGx5iiZ2djgVqHWJ.Yv8
 LywTM1sxPnT23uhtJ8AKOE40a3I2g4eGr.fL6ANbiIyJ.H4yGAA3bgf8qkFyrO.DTwoI3vNo5n9p
 GMRauLtEokZO1hwaDlHUzE.qkDIyGQkg3_f23bBCrBJgt5xkY7IVxLbY3BUlyNCSr8EInu4Ph_iG
 mvxCkFCmGCqJ5qUnBhUVcacCWuoLRNPQBIxEpT6E3AW4L6yuS_86TZnpUHzm9mwYUFNQWmyKcFXg
 whKavmV8af3Wo7KkqZmekL8NTTubjbIcr9r5Faii2Ou9gygzAhpK6yesbmvG1yjOq4xKU3uP5BdL
 fqHHzfuC7Iht_GCFG60vOFAW1.r3BWlWPcq7ZpV7mhpuS1os97XRfaAlqzSJzc752YbFhJHbYGy5
 JKRYEuwgROWTAMvcW7RewbSKGV6QmyPgvDql0nEkdFnFtG1JC5VojQeSBZORvtKcwMOKjOa4oj5U
 DoHdLhV257yMAf2k55D9tLlW2DkkvsQPl_adqdqHRlPDVw4Hs56jhlfCJH5xFVJkk8mSL1b1phD7
 01XsQDd21EAiSzguzuQGqne7fcEP3QUEZbbPMZn7LkCikBcfopXx07jGugJfkHjtbEB6hAueI1J3
 3U9JqOr.R5Xvc3N9gZxcuNx1qVnSLqiAeKeh9UTaqJED7NwjwtUUAviJTEMEATlEbKW7WMzt5JDf
 0WnltHVh.8gBOqYijccnuL9diiuX5tJqAPB.i9PqyLgqIXGV50dNFgcxQCiVQkL0XDgz5WooemGr
 wnC_Nn.pkU.mXxUEhTDLDmbbbWqimZ_IVf9GOeNxm4CKtgHE5fu3vkESzRixjTYVddkBS9Ng8G6T
 ozeclYFCKYYw7dJmXdcUvJM_DPh2Bi39tE3y_jIMuTONE7inc0_Xzygb2tPYND2ht.WB4u3mLnne
 0o2Y9StC3khY5EcSFtI3Y19CYJZTRZdDgaI.jFdx0kvylh1sL_Swqg6p4iACewFeLf8xFm4zD9RQ
 X.9LGWxZj6_OzE0i.sFNBDPylYHfCFjFNdSVcRUreEokVZGLL9.1R_BdiFl_qAqUI_pHfp0kNaVy
 PERe0Z2IGAwy8_IJ2Dyp2Pa89tVP1fWvKb.bePJuwXeoWwPjD9f4pRaJir13vqITxcEMFvckuGgN
 42BMMFFY508.vfwnk9y1JLitvh_fF.gbapNt5CV4Pd3okSPfStzXR4znniZTBGLw6ccGhG4MQZe3
 VHwj5drB_zvEAWwXFwZ4TPcWTsz3aKelrrJcknA6kDN4yCM8KM9wnyfH06vqI4oelrhtqLTUeRk7
 HCG5DSBJwdi6Kg9qLpPohSeA5l6l7Bl_eqj51xjTHS8DXWqeFMVy5v8A4H1fT.OiIWnbS1gk4sWk
 AR3XAtolDx6aYIp5zz2qzJU1VxyrQJNDJkMWPLGulH.vBwFeVjjlQxThcLL_peJlzSpF5.VmuFg9
 9d5.eZvEQx9DH3_3eA7LrtgqwwK6gEOAfWf_5lBzoWTD3BZ3xUqjPX90iAoSkZY9L38y0ARl7hqe
 IPW4HWR8SAswt5cwFFyGhAgjpjz33At0bjKKKLejfdJTEqmyXs1cbxPOcrPO0jcxQn1oYwavAVGQ
 3eZ4-
X-Sonic-MF: <namiltd@yahoo.com>
X-Sonic-ID: 50c47fe6-4d08-45cb-9518-5e71960e853e
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Sat, 21 Mar 2026 10:30:04 +0000
Received: by hermes--production-ir2-bbcfb4457-4sf65 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 452cfa1dfcb513a2aff084f616b95894;
          Sat, 21 Mar 2026 09:59:39 +0000 (UTC)
Message-ID: <e0090aea-45f9-48b6-99a7-7ad8666dce59@yahoo.com>
Date: Sat, 21 Mar 2026 10:59:37 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: pl
To: linux-crypto@vger.kernel.org
From: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Subject: [PATCH v2] crypto: inside-secure/eip93 - correct ecb(des-eip93) typo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <e0090aea-45f9-48b6-99a7-7ad8666dce59.ref@yahoo.com>
X-Mailer: WebService/1.1.25380 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Correct the typo in the name "ecb(des-eip93)".

Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
---
drivers/crypto/inside-secure/eip93/eip93-cipher.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-cipher.c b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
index 7893c15..4dd7ab7 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-cipher.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
@@ -362,7 +362,7 @@ struct eip93_alg_template eip93_alg_ecb_
 		.ivsize	= 0,
 		.base = {
 			.cra_name = "ecb(des)",
-			.cra_driver_name = "ebc(des-eip93)",
+			.cra_driver_name = "ecb(des-eip93)",
 			.cra_priority = EIP93_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
-- 
2.47.3
