Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794469504;
	b=2j/kGTdqiSXL5pefCwhlfh6sfmaKXRGtFVQqzPTKcxLUu2+6zAunWU0kDPZQaKjt361F
	 fJeRPF6QwG5qCtE1Ql6etWHAtit70MKrsv6yde7WCuVqiE6e0hR0329qTYJQYphVMg2Ai
	 PUfW4wmpo5C1O7sm1eQUsuAjQ1phQ2uI+NNyyNNVJbZ9raGfftOplv7paWp42fWihhjXs
	 pgVyytcEYHFnELBLwvjm0poo7h6DBnr2mGc1pM2tekr8IbFjiiclWDPGmnJv7V1/EhSUY
	 irF1SkcTFCwsYVQ/TEbsylOsOyEkAunOlwUE1vikON8b3DoTQ/FwJTR+H15aQ591wlw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469504;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=2n7R8ofHZX8I0vZDA0F5DVHy4PjWf19a1pO4yE828SU=;
	b=y5z9KTMrFOaIKWHkQV5foQHquGc14J62YY7ZaS1ahd4XWIA7HI/ALZkGdlp+hXnmM4pe
	 fvfbdb5C3efpEbLmzKWf2e6F5WEa2HJeR3dUhoGHc1L6XmIOMmUxKTD9io089m+yHa34X
	 jI79xRj+Ngq6/fQOpnqCrWGStsuXY7za7RkHj7oERSXsZZUt3op114SApSzWA45B/9qwz
	 yEDk1iJ10Y1wu2Lewkv0hu1KMa8xZ3+ENhwPfLfLeoVsvy/hgO+4L8TEdhw4i22r1tX+o
	 V6EeduNOoCqqO7vhO8QLVSXWKvjz/uMAWASAF4KgUKUJX2+SOKoZddPszsVkeGXn4QA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=MwgC9ddv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A601606A321;
	Thu, 12 Nov 2026 07:45:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A601606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=MwgC9ddv
ARC-Seal: i=1; a=rsa-sha256; t=1794469424; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=SA+zLV8YNJsP3kF0RU3EljGWeDok4tHkWkJbxlSQrkObI1pJp0FVxzxWmahowtX87bao//VveeeMae3cLmoFczfTk+jExdrB1q2GeF8LARkLjtAIG4X5TMC3z/OfNmA6T1qAqO+muuyWGaV6pjj9EAYh6xlHL8zWNYuImxBwUQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1794469424; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=2n7R8ofHZX8I0vZDA0F5DVHy4PjWf19a1pO4yE828SU=; 
	b=XOs0WhFXq7yB5ZAPe6zmLBO0RvR7FnwAFpFrjozR3RgjbBwGEwIYTVvtmzQ/Ail9JNNk1dNcYBcTTCvI2fHoY3zylv5QowipZ6aGP0cGI8VigZcaIRzaU5TZ4P4OshpSpAWLcYJUZs9bUTgmxlqjVi0gjPbmkXh/9VY10xahXMs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: a=rsa-sha256; b=MwgC9ddvb57QvTEO5WgJ35hqPmY3P3R72SiDdtc0ijCpnAW8+yfbFdYStU6ZRZnAhu/naHWpkUwKW/aJVNLLfR/mJXwWfGquDHaP7Z779nWGvsor41W3O1BPdr3Eke63VmK/5R7/iJ/3z5ZcV9p7eoUm/O1f+beU9WReLUqoglM=; c=relaxed/relaxed; s=zoho; d=laveeshbansal.com; v=1; bh=2n7R8ofHZX8I0vZDA0F5DVHy4PjWf19a1pO4yE828SU=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1794469424309448.41107899587405;
	Wed, 11 Nov 2026 23:43:44 -0800 (PST)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Denis Kenzior <denkenz@gmail.com>,
	Maximilian Stahlberg <maximilian.stahlberg@uni-bremen.de>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] X.509: Accept a certificate with an empty subject
Date: Wed, 11 Nov 2026 23:42:45 -0800
Message-ID: <20261112074246.99421-2-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261112074246.99421-1-laveeshb@laveeshbansal.com>
References: <20261112074246.99421-1-laveeshb@laveeshbansal.com>
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
X-ZohoMailClient: External

A certificate with an empty Subject, which RFC 5280 allows, fails to
load: add_key() returns -EBADMSG. iwd hits this with an eduroam server
certificate.

The subject is parsed with the Name rule. The ASN.1 compiler turns a
SEQUENCE OF into a loop that runs at least once, so the first RDN is
mandatory and an empty SEQUENCE runs out of data in the decoder.

Give the subject its own rule, a SEQUENCE OF a one-member CHOICE, so the
first RDN can be absent. Anything that is not a SET is still rejected.
The issuer keeps the Name rule, as RFC 5280 requires it to be non-empty.

Fixes: c26fd69fa009 ("X.509: Add a crypto key parser for binary (DER) X.509 certificates")
Cc: stable@vger.kernel.org # v3.7+
Reported-by: Maximilian Stahlberg <maximilian.stahlberg@uni-bremen.de>
Closes: https://lore.kernel.org/r/9b05b89cf296b8a6392bbe6327228c1bc2f05c49.camel@uni-bremen.de
Signed-off-by: Laveesh Bansal <laveeshb@laveeshbansal.com>
---
Tested in QEMU/KVM guests on arm64 and x86_64 (cbbddb6b08cc, 7.3.0) with
KASAN, lockdep and debug lists on. Each cell is the add_key() result
before / after the patch, the same on both.

  case                                        before / after
  empty Subject                               EBADMSG / ok
  the reporter's certificate                  EBADMSG / ok
  Subject with 1 or 4 RDNs                    ok / ok
  empty Issuer, truncated, garbage            EBADMSG / EBADMSG
  malformed Subject (a member that is
        not a SET, or an empty SET)           EBADMSG / EBADMSG
  chain: empty Subject, CA-restricted ring    EBADMSG / ok
  chain: empty Subject, signed by another CA  EBADMSG / ENOKEY

The built-in keyring and PKCS#7 messages share this parser and now accept
such certificates too (tested on arm64). I didn't find any lookup that can
hit an empty Subject. The only one that compares Subjects is the dn:
fallback, and it would need an empty Issuer, which is still rejected.

Letting the compiler accept an empty SEQUENCE OF would need an opt-in,
since Extensions must stay non-empty. The CHOICE is that opt-in for the
subject alone; x509_akid.asn1 already uses the same shape for
GeneralNames.
 crypto/asymmetric_keys/x509.asn1 | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/x509.asn1 b/crypto/asymmetric_keys/x509.asn1
index feb9573cacce..d22f7bad9721 100644
--- a/crypto/asymmetric_keys/x509.asn1
+++ b/crypto/asymmetric_keys/x509.asn1
@@ -17,7 +17,7 @@ TBSCertificate ::= SEQUENCE {
 	signature		AlgorithmIdentifier ({ x509_note_sig_algo }),
 	issuer			Name ({ x509_note_issuer }),
 	validity		Validity,
-	subject			Name ({ x509_note_subject }),
+	subject			SubjectName ({ x509_note_subject }),
 	subjectPublicKeyInfo	SubjectPublicKeyInfo,
 	issuerUniqueID    [ 1 ]	IMPLICIT UniqueIdentifier OPTIONAL,
 	subjectUniqueID   [ 2 ]	IMPLICIT UniqueIdentifier OPTIONAL,
@@ -34,6 +34,12 @@ AlgorithmIdentifier ::= SEQUENCE {
 
 Name ::= SEQUENCE OF RelativeDistinguishedName
 
+-- RFC 5280 4.1.2.6 allows an empty subject.  The CHOICE lets the first RDN be
+-- absent, and its COND_FAIL still rejects a member that is not a SET.
+SubjectName ::= SEQUENCE OF CHOICE {
+	rdn	RelativeDistinguishedName
+}
+
 RelativeDistinguishedName ::= SET OF AttributeValueAssertion
 
 AttributeValueAssertion ::= SEQUENCE {
-- 
2.54.0

