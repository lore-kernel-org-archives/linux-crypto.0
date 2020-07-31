Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212D2C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 02:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5B302083E
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 02:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MqrBpIlo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbgGaCjh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jul 2020 22:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730904AbgGaCjg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jul 2020 22:39:36 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3949C061574;
        Thu, 30 Jul 2020 19:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=o7QUoER83xD6p0fZNpUapCM4TWj0xvsfJPvwt6jf7J8=; b=MqrBpIlo1BCpyDba2e4kDavou0
        J/LzoVXUXNKwLroe4/b7yxBgjHjiH42bmbZra+EX/iwbUE8g9Ox22ASYEHVyBjfp/Ds+cTDeLMOvP
        ay5Sgxo5S5+IZD16D6dlGa60qIGO4Uz6TbSoErVOF0hOcjB7BhzIph90StZX0Sx67SNDn5RJmoR9H
        eFTn3KN17t6wLZh37KJhXrZp7J5GnnoLj55vYarvlWStdtTlOca76OE6lGy8zYoA1Y/12F3XstUa0
        4C0x3yeoFzO3Y2UnXOE7qyLU0AxCC1Vj78aDHERNsGtVTV+QtnCrQSwv69ndgGdma5PGWuFWRKApV
        0sUBAubA==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k1KxJ-0001o3-9J; Fri, 31 Jul 2020 02:39:33 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 2/6] crypto: asymmetric_keys: pkcs7_parser: delete duplicated word
Date:   Thu, 30 Jul 2020 19:39:20 -0700
Message-Id: <20200731023924.8829-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200731023924.8829-1-rdunlap@infradead.org>
References: <20200731023924.8829-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop the doubled word "the".


Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
 crypto/asymmetric_keys/pkcs7_parser.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200730.orig/crypto/asymmetric_keys/pkcs7_parser.h
+++ linux-next-20200730/crypto/asymmetric_keys/pkcs7_parser.h
@@ -41,7 +41,7 @@ struct pkcs7_signed_info {
 	 *
 	 * This contains the generated digest of _either_ the Content Data or
 	 * the Authenticated Attributes [RFC2315 9.3].  If the latter, one of
-	 * the attributes contains the digest of the the Content Data within
+	 * the attributes contains the digest of the Content Data within
 	 * it.
 	 *
 	 * THis also contains the issuing cert serial number and issuer's name
