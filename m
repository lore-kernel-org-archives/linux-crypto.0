Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E809C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 18:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FD7B61A26
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 18:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhCZSOQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Mar 2021 14:14:16 -0400
Received: from sender4-pp-o95.zoho.com ([136.143.188.95]:25504 "EHLO
        sender4-pp-o95.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhCZSOA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Mar 2021 14:14:00 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1616782431; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=iW2ase+BPwg2ZhFmmLE4pD8WhOYYh6aizZ4rqQGuEruqVPpn0xIA0hEHMm5MH1Jiaz/ksCjBS15cFyrSN3XczaUrArfJdd3R+iWZ2Ga39psuyNjrhxciQj8LbgWy9qUucF3UEi2ctP45JGC19kapPgYemckvn2T0TeRgGJCkZbU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1616782431; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=hR0yMEotDjWNnzZELo+7Iv5vovRWVVOWJgIiZbDR8yI=; 
        b=iOvm4Sx/RpnhIYae1JCxfolD3cVijbb0BbSGjjLLRhSREX/570/CnqyamD850l6PT+okhr81jBvQM91X744dr1MQhwqj1lkXaVfvpgTyODrCrIZhk/DqYivkoTv7fI+GntDVVyFNJSjnXo35oo7fHMQa37u3AMl58NBMAomYJ7w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=zohomail.com;
        spf=pass  smtp.mailfrom=mdjurovic@zohomail.com;
        dmarc=pass header.from=<mdjurovic@zohomail.com> header.from=<mdjurovic@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1616782431;
        s=zm2020; d=zohomail.com; i=mdjurovic@zohomail.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=hR0yMEotDjWNnzZELo+7Iv5vovRWVVOWJgIiZbDR8yI=;
        b=izsPTe1cmG5jUxcZUMpKB7xvCSk4LXEg8SrtOWYbOWyE/+r7PZPTfeks6v1pTr4c
        n3bV3fNNlVGxW6BEV+66iX8Vdh+Z11wfVSIr4tHQH5Zg5TlvYtL1SFqJGhlhg1jMYIh
        KWXRnodM0d9cgPIRzowcKnT3RndTpdK3VfoKwVvM=
Received: from milan-pc.attlocal.net (107-220-151-69.lightspeed.sntcca.sbcglobal.net [107.220.151.69]) by mx.zohomail.com
        with SMTPS id 1616782427247674.3410469146485; Fri, 26 Mar 2021 11:13:47 -0700 (PDT)
From:   Milan Djurovic <mdjurovic@zohomail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org,
        Milan Djurovic <mdjurovic@zohomail.com>
Subject: [PATCH] crypto: keywrap: Remove else after break statement
Date:   Fri, 26 Mar 2021 11:13:59 -0700
Message-Id: <20210326181359.97406-1-mdjurovic@zohomail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the else because the if statement has a break statement. Fix the
checkpatch.pl warning.

Signed-off-by: Milan Djurovic <mdjurovic@zohomail.com>
---
 crypto/keywrap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/keywrap.c b/crypto/keywrap.c
index 3517773bc7f7..054d9a216fc9 100644
--- a/crypto/keywrap.c
+++ b/crypto/keywrap.c
@@ -114,9 +114,9 @@ static void crypto_kw_scatterlist_ff(struct scatter_walk *walk,
 			scatterwalk_start(walk, sg);
 			scatterwalk_advance(walk, skip);
 			break;
-		} else
-			skip -= sg->length;
+		}
 
+		skip -= sg->length;
 		sg = sg_next(sg);
 	}
 }
-- 
2.31.0

