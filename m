Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 580AAC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 02:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 299722083E
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 02:39:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HVbBFRLB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731235AbgGaCjq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jul 2020 22:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731229AbgGaCjp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jul 2020 22:39:45 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1ADEC061574;
        Thu, 30 Jul 2020 19:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=wAw0MJ1X4tOEhdrjFhUXv4X8d8xnWtmux1JkPQoh9qo=; b=HVbBFRLBQJg74jfxzistx4SGuJ
        klH/YMvYhpaJvPBtlUgtwv/soO0s7CRfd4GvFg+2Apq8MRBSIweEP7cyYvMnZqRZbtQDCo3vhrImb
        GO8lWZ/Uk5SbdJfjyeasZj7WyyLnOzm29VuaGSpSO6GsvQNwE2k/r/gBN09zfkE/37nF1131b87If
        Ers4KVO4X5EjVWlcZ59uOoiRwoNAUr+4KIwPScy/DeTB/TGQ9vtse20KFbDbLqY7vYTfr2Iulxrfc
        0C7klEZjPREoxD+BzCyOVgM5MRN/ItMFFaGvyuX3C7h+fekPi3LcC6huYjCE8N4YX1bVRiPVNlo7z
        FiIAKl2Q==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k1KxS-0001o3-KC; Fri, 31 Jul 2020 02:39:43 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 6/6] crypto: tcrypt: delete duplicated words in messages
Date:   Thu, 30 Jul 2020 19:39:24 -0700
Message-Id: <20200731023924.8829-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200731023924.8829-1-rdunlap@infradead.org>
References: <20200731023924.8829-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop the doubled word "failed" in pr_err() messages.


Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
 crypto/tcrypt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200730.orig/crypto/tcrypt.c
+++ linux-next-20200730/crypto/tcrypt.c
@@ -398,7 +398,7 @@ static void test_mb_aead_speed(const cha
 					ret = do_one_aead_op(cur->req, ret);
 
 					if (ret) {
-						pr_err("calculating auth failed failed (%d)\n",
+						pr_err("calculating auth failed (%d)\n",
 						       ret);
 						break;
 					}
@@ -648,7 +648,7 @@ static void test_aead_speed(const char *
 						     crypto_aead_encrypt(req));
 
 				if (ret) {
-					pr_err("calculating auth failed failed (%d)\n",
+					pr_err("calculating auth failed (%d)\n",
 					       ret);
 					break;
 				}
