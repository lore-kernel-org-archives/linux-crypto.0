Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820A738399B;
	Sat, 22 Aug 2026 21:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787434079; cv=none; b=JN3Y4P/E8FzGoLBFnKIaNHyVkyZhJMuQJEXAiq1SLpeEXklfWfzl+KVf6pawyhr3inf3HO5sO7Xr/Kqnm7litZc93KL37NHxtD8yIZYrjrg7891u6zbsFMFOStoy1kZWmEl9vPghosyTHEP+r/LjLFDBV30iWh7n1NKtMRukFmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787434079; c=relaxed/simple;
	bh=RnvMjwr8PrhWW9LFmWiMs3Dz9ie40MXJYLQTRQlMpes=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J8qrImY2tAoQWELyA/VxrRuSEzv9IJVdlqNRRxnHsJTwaulPqlRq0yiXpF9AyTvMtlxsrtdf7Co0Rnp3xqHqiu2KuM5Pcaw3i+K8cqm5bCgS4d6bETF9J5dWQgJQh5VzFCN94Vd+opyJK8yG7i91haa3ITR5W8pgYo+hLaZGUpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=BS21dDip; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="BS21dDip"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=O2YyWvFNr3UAThA2597Fy+8bbmZ6au5P3Q7Z73hQufU=; b=BS21dDipKKnv/pLHJZTLcD9oFT
	zPCLXIDWIs9asXvqpNunk+5yTQSEGDC2nvGdmCw9IG2BzxrdSSm17zy3tXh3vWDsGnXYLW8e4wMvU
	tQsf0pZWPX6q5pAMPpb7lh4bpJih/YDS0KFH7bfW7fgX1XINpMc5yjj7k/MNv7twWW/Uhcyrnr/VM
	LXtDScw+W+r/jONi1EuBMhLcHTX6UrsJOy1rVG9xlGHY8jiiV26ZgWuBGrPCUZMz1ZTI9IhAkWI7c
	ERlkLUuzWEUFscnp1dXLoNIIvYlefTjgE1C7uSU9O/+miftPqWLce7L2Gjy+jTx1knqKZJsQgCtlp
	YRAK44jw==;
Received: from [151.115.150.205] (port=40898 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wxtFu-00000002bTA-0eVE;
	Sat, 22 Aug 2026 23:27:56 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: dhowells@redhat.com,
	lukas@wunner.de,
	ignat@linux.win,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] pkcs7: Check all signers before waiving authattrs rejection
Date: Sat, 22 Aug 2026 21:27:04 +0000
Message-ID: <20260822212703.1019792-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

pkcs7_check_authattrs() only looks at the first SignerInfo when deciding
whether rejection of authenticated attributes may be waived.  For the
remaining signers it checks only that authenticated attributes are either
present on all signers or absent from all of them.

This means an unmatched ML-DSA signer can be placed first, followed by a
trusted RSA, ECDSA, or ECRDSA signer.  Verification skips the unmatched
signature and accepts the later trusted signer.  The first signer still
leaves the waiver enabled for the whole message, so the non-ML-DSA signer
can use an exception intended only for ML-DSA.

Check each SignerInfo's public-key algorithm before leaving the waiver
enabled.

Fixes: 91db696adea4 ("pkcs7: Allow authenticatedAttributes for ML-DSA")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 crypto/asymmetric_keys/pkcs7_parser.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 6e3ffda..7f00e45 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -111,6 +111,12 @@ static int pkcs7_check_authattrs(struct pkcs7_message *msg)
 		if (!!sinfo->authattrs != want)
 			goto inconsistent;
 
+#ifdef CONFIG_PKCS7_WAIVE_AUTHATTRS_REJECTION_FOR_MLDSA
+		if (sinfo->authattrs &&
+		    strncmp(sinfo->sig->pkey_algo, "mldsa", 5) != 0)
+			msg->authattrs_rej_waivable = false;
+#endif
+
 		if (!sinfo->authattrs &&
 		    sinfo->sig->algo_takes_data)
 			sinfo->sig->hash_algo = "none";
-- 
2.47.3

