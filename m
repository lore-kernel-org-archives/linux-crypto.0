Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12AE4078EE;
	Fri, 21 Aug 2026 19:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787340337; cv=none; b=iC5esqJgDSSspFmbTwLNnN4NUP+gnb+6a2bfIcKnR/bqklMeEtGsl+szQC83TCkMXGK9Nt3CDn9l3XNBkwOd26QXiiST0ycg6MODhwXCUqrJR9w+M1rhj4DbvtIkTJ1LFxEjynowBtrLmxeB+AokwZOViJfeXOo7ICojrxEL/tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787340337; c=relaxed/simple;
	bh=coC1wJYIa/Bk7cJ+Ao+mMXF5jUAofNGH5WfceLQBpBc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AVmt5b4ShT8cJrGB9UiCPuiiyjC1IZf+SzDmi/ALkozTyx5Y/4NL0HPqLODPEPa87AHZEGgRhivMkPGNuY3dtTktAW5yCb0k3DHd9ebK67H24pnNqXaGcx52aCfvaTfCgQZV6g8+Ssob55vByECYxMAvyn9xREIIBi/QhkbWyxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=RWnMcxyM; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="RWnMcxyM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SrtsCDy6dLoKwXxO7io5lmiObGVJLfwxHYxffavVPKQ=; b=RWnMcxyMvabDzvJgmfKS0rPTpm
	UHVE+6yY/9sUH9R1pnYtNhlQULNxdIghDRv6gEHggVr46ZJo2opNIsdUdQQULdcY0lSOUc5PLmK0N
	3hibkW6VjQ41hXhXWdkHhiwmXZr5UBo1eojhWLtWNchgWUoBHRIyYRg2apIkuarHCQWNlS1PmxfYQ
	LYN+zgyZOdGuAGPqMeh4xw2UP15md2kJZx2BOWhxUuOorTv7ZZcZZ6Q6mqXKVGTVliJGE+A86FDeq
	7o+nV/yNnoshbaxDkOPossvWlBtiuuzX4Hu55r31XHLgjAxnPZEM6gG3ChNt7V28wD3KAEFcHPqu/
	pa4xFVhQ==;
Received: from [151.115.150.205] (port=42692 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wxUrs-0000000DdqK-49Dd;
	Fri, 21 Aug 2026 21:25:32 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] crypto: asymmetric_keys: copy X.509 TBS for data signature algorithms
Date: Fri, 21 Aug 2026 19:25:03 +0000
Message-ID: <20260821192502.3942767-2-Jeremy.Jean@oss.cyber.gouv.fr>
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

For signature algorithms operating on a message rather than a digest,
x509_get_sig_params() points sig->m directly into cert->tbs.
cert->tbs is the preparsed add_key() payload.  The syscall wipes and frees
it on return, while the instantiated key retains public_key_signature.

A later KEYCTL_LINK into an asymmetric restricted keyring therefore passes
a dangling message pointer to ML-DSA.  KASAN reports a slab-use-after-free
in mldsa_verify(), with allocation and free provenance both leading to
__do_sys_add_key().  Reuse is also an integrity issue: bytes occupying the
freed object become the authenticated message instead of the certificate's
own TBSCertificate.

Give the signature object its own copy of the TBS, as is already done for
a precomputed digest, and release it through the existing m_free contract.

Fixes: f3eccecd782d ("pkcs7: Allow the signing algo to do whatever digestion it wants itself")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Assisted-by: Codex:gpt-5
---
 crypto/asymmetric_keys/x509_public_key.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 25cf8ac..5c9165a 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -53,9 +53,11 @@ int x509_get_sig_params(struct x509_certificate *cert)
 
 	if (sig->algo_takes_data) {
 		/* The signature algorithm does whatever passes for hashing. */
-		sig->m = (u8 *)cert->tbs;
+		sig->m = kmemdup(cert->tbs, cert->tbs_size, GFP_KERNEL);
+		if (!sig->m)
+			return -ENOMEM;
 		sig->m_size = cert->tbs_size;
-		sig->m_free = false;
+		sig->m_free = true;
 		goto out;
 	}
 
-- 
2.47.3

