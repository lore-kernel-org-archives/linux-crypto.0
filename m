Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792898327;
	b=vdi1mCa+xu1r6w5QqODpN5qEBor5M+/IcsVqERJftj2Ij0Q+ZOHKbcYOkRPKZu7JeRN1
	 TpRKzST74YRj6tO1xjhpsK173e+ondd8vyhrALCGacwcTzfSfHYAK+Wb3XEVYQWuQNMtI
	 57UMKthvmCdVyf5TC6sqGLrKWL7kw1gK0VhB4Jevf77GocIjsYi8fQbQR1T/Pr92D2nA/
	 R4BWeGj6rBlJNczOWxK/RLT+52mOsDeiGsnB8WBF+Bn8mqfALNh+5n+lPPfV4hCaBntQu
	 a1cK1lSzJmM7dF3HtHFYF1wW0ow2Wo6UUmhaqoSPRj/RtaO6kS4buZhwjX33un2CvjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792898327;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=l8Stb9RPR7z+2klxLqRm21sbLpzxLDanY4W6rXhqE6g=;
	b=Omc66qycOFQCT2gItukn3teQMycO86taSLJ2ku9KLZVfS+2R7PJ3FHsM3CM424AiwBbN
	 t3AlFOHFSpZEU+DCHa6mD7yirx/O0wv3OUqScUQ14iuKXs69BH0h5unmpPKPTcj3AcZed
	 k8lR/L8Awy78op/lH/5/PNlRNVe4qX4M2Ecq04Y5FwKjvbfuCkh+eTlfWLMuv07HZMSpB
	 2WCaCj1OqvMfW2WvlfgebcL3zZySGziY410gB8SdzfkwgDnVnFXZ1u5tEFlY57DT+0YJb
	 n4ynpdUPMfMgUPWBfZDSmxK8oREgmwui99neLw0PTVSEXfiw8NT5MP4DrWgXAe+i+HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=lDAXSbpa;
	arc=none smtp.remote-ip=111.22.67.135
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E8E606A31B;
	Sun, 25 Oct 2026 03:18:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76E8E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=lDAXSbpa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=lDAXSbpaLYFZI5KwTL8VGrQQIPDwO61CpmcEKT7jaOOzQgB+Ogy9zpoPXVLBu3jrshQj5I89bC8ZU
	 KD1IQcMoLib0TbxDQwjBBUxxEf5J/a83uR/gZ4gglWmqKk2XEbfi6CWfsH6MStbEyxnajMBGLaJTiW
	 1blChLNhqfguuCVw=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee76add750b151-43d63;
	Sun, 25 Oct 2026 11:18:38 +0800 (CST)
X-RM-TRANSID:2ee76add750b151-43d63
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHA-W6400298 (unknown[36.137.216.17])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee16add750b151-7bf6b;
	Sun, 25 Oct 2026 11:18:37 +0800 (CST)
X-RM-TRANSID:2ee16add750b151-7bf6b
From: Tang Bin <tangbin@cmss.chinamobile.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tangbin@cmss.chinamobile.com
Subject: [PATCH] crypto: jitterentropy: Fix debugfs leak on register failure
Date: Sun, 25 Oct 2026 11:18:35 +0800
Message-ID: <20261025031835.2354-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.52.0.windows.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

jent_mod_init() calls jent_testing_init() to create debugfs entries, but on
success of jent_entropy_init() it returns crypto_register_rng() directly.
If registration fails the module does not load so jent_mod_exit() never
runs, leaking the debugfs entries. Capture the return, call
jent_testing_exit() on failure before returning.

Fixes: dfc9fa91938b ("crypto: jitterentropy - avoid compiler warnings")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 crypto/jitterentropy-kcapi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 652852649..43a0694e6 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -296,7 +296,10 @@ static int __init jent_mod_init(void)
 		pr_info("jitterentropy: Initialization failed with host not compliant with requirements: %d\n", ret);
 		return -EFAULT;
 	}
-	return crypto_register_rng(&jent_alg);
+	ret = crypto_register_rng(&jent_alg);
+	if (ret)
+		jent_testing_exit();
+	return ret;
 }
 
 static void __exit jent_mod_exit(void)
-- 
2.52.0.windows.1



