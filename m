Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB23367B61;
	Sat, 22 Aug 2026 08:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.230.196.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787387984; cv=none; b=W/cx7bKcib22HHO2AmUKvUa/8hNvAWSrOJFs+ArDqc7cK/NW0D0yk5WlOwI2DEGWIofIeLcZyBNxlA4UALCAjpSs/hrhRiGj78msRdwvpwHFlINCbcmpOQuebfvYfJyAvJ+QZrO2lrMetVJI9J0h/ILWbosk6XmnGePyBmzPi/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787387984; c=relaxed/simple;
	bh=4sI1NdIiMLwYD5o6jZ+qjz/USjnVVq4k2iEiiwLTJD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQZH8tGUYAv/X0VAX0HeW0RxjlyKUS5F77eow2J3nUXs17mHP93TQbpAT8PYxnjDt6p2nn6R542hHK1tMkRwHMeK/2Wsh9Z4rEJcqrIr2YICqcRhiQt0k3s1VTFVqM/E/dhuxX1t7W5uhCqjmujxqsrEBJSTWqELlg6uAONZV+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=XqPiA8nZ; arc=none smtp.client-ip=37.230.196.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="XqPiA8nZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1787387461;
	bh=4sI1NdIiMLwYD5o6jZ+qjz/USjnVVq4k2iEiiwLTJD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqPiA8nZXyraSDmgMlyLHDO3URAH44KAA1y7khdR1ZZ11qbIBI6SlCN2YdliarklE
	 ZJBBMDqxwPbRGNZAf8xGGGmxye/z5A3wUlrlHynY39UiHy9o0kqqucMe2RzuAVlGHK
	 ESdHD5+O8yiS2q+F9OVCICgnaXLswJGBJRbJJ83nfCnubzBoj8YOACF1/gx1lme/dc
	 bvqLJL/dRABY1Y/MI4Oh1JImh+FFT0JayohfVG5ESClDnPNzD94hKu+NTZwZD2G5sj
	 0nuOcOI5sor4ar7RJFgPdWl7HWYHxNfx4OTGSGa4y2WumdZoG2ZKLfqNc64QPaP7lr
	 7JmEu3Spvzm7A==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id DC3A1250B0;
	Sat, 22 Aug 2026 11:31:01 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Sat, 22 Aug 2026 11:31:01 +0300 (MSK)
Received: from astra.astra.ru (unknown [10.198.17.65])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4hRr3n32DqzrB6;
	Sat, 22 Aug 2026 11:31:01 +0300 (MSK)
From: Timofei Novikov <tnovikov@astralinux.ru>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Timofei Novikov <tnovikov@astralinux.ru>
Subject: [PATCH 1/3] ASN.1: fix OPTIONAL for SEQUENCE OF and TYPE_REF
Date: Sat, 22 Aug 2026 11:26:40 +0300
Message-ID: <20260822082642.48936-2-tnovikov@astralinux.ru>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260822082642.48936-1-tnovikov@astralinux.ru>
References: <20260822082642.48936-1-tnovikov@astralinux.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: tnovikov@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 116 0.3.116 e16f906af7c720a8bd440e8c76eb19faffaac9ce, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;new-mail.astralinux.ru:7.1.1;127.0.0.199:7.1.2;astralinux.ru:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 205480 [Aug 21 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/08/22 08:00:00 #28528350
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

Fix two issues with OPTIONAL fields:

1. For TYPE_REF fields that are OPTIONAL, propagate the ELEMENT_SKIPPABLE
   flag to the target type via a temporary tag element.  This ensures the
   target composite type generates MATCH_JUMP_OR_SKIP instead of MATCH.

2. OPTIONAL SEQUENCE/SET OF: set ELEMENT_SKIPPABLE on sequence wrapper,
   not just on parent field. This allows the entire sequence to be
   absent from the data.

Signed-off-by: Timofei Novikov <tnovikov@astralinux.ru>
---
 scripts/asn1_compiler.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/asn1_compiler.c b/scripts/asn1_compiler.c
index 4c3f645065a4..5b118acbdbeb 100644
--- a/scripts/asn1_compiler.c
+++ b/scripts/asn1_compiler.c
@@ -1039,6 +1039,8 @@ static struct element *parse_type(struct token **_cursor, struct token *end,
 			if (cursor >= end)
 				goto overrun_error;
 			element->children = parse_type(&cursor, end, NULL);
+			element->flags |= element->children->flags & ELEMENT_SKIPPABLE;
+			element->children->flags &= ~ELEMENT_SKIPPABLE;
 		} else {
 			element->children = parse_compound(&cursor, end, 0);
 		}
@@ -1056,6 +1058,8 @@ static struct element *parse_type(struct token **_cursor, struct token *end,
 			if (cursor >= end)
 				goto parse_error;
 			element->children = parse_type(&cursor, end, NULL);
+			element->flags |= element->children->flags & ELEMENT_SKIPPABLE;
+			element->children->flags &= ~ELEMENT_SKIPPABLE;
 		} else {
 			element->children = parse_compound(&cursor, end, 1);
 		}
@@ -1522,7 +1526,13 @@ static void render_element(FILE *out, struct element *e, struct element *tag)
 	/* Deal with compound types */
 	switch (e->compound) {
 	case TYPE_REF:
-		render_element(out, e->type->type->element, tag);
+		if (skippable && !tag) {
+			struct element tmp = { .flags = ELEMENT_SKIPPABLE };
+
+			render_element(out, e->type->type->element, &tmp);
+		} else {
+			render_element(out, e->type->type->element, tag);
+		}
 		if (e->action)
 			render_opcode(out, "ASN1_OP_%sACT,\n",
 				      skippable ? "MAYBE_" : "");
-- 
2.43.0

