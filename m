Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D2AC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 02:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C901208A9
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 02:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t9zjijNX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbgGaCjd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jul 2020 22:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgGaCjd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jul 2020 22:39:33 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9ACC061574;
        Thu, 30 Jul 2020 19:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=pNQiSCD0PQklO78jJZr5s3Sixv/QTL1qnk/Re7leWNM=; b=t9zjijNXhlIM2+m1RE/lvh5qbK
        R4qdreG6JpbpjKbQxycfuI0d4aZO9OX4Yd9tfvOixGDmicFtClAAmoqZrnl8t+pjtkuHmtijoNwLI
        9c0jy6CO4sKOfjlwrji+UO+qYgUUolfFVe39zoxfW5U4VokIX8BZ11CqlyAJi5M+ZBUYhTUJnB3A2
        0q+6uHYLJFQUyqja1VdYtOHENhgOgQgsdG8TsTOs4ygs1i8RUZx+CuIP8eFmB607AvTZMhBnEaXV7
        1YoozqcyOrFDUwvWZAIKhxM19mYJRfV2t3yS5OYJHW/j0MDzsdLWB86qZt45mAUfELTW5gG0NQ1RN
        odaxquVA==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k1KxE-0001o3-HQ; Fri, 31 Jul 2020 02:39:29 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 0/6] crypto: delete or fix duplicated words
Date:   Thu, 30 Jul 2020 19:39:18 -0700
Message-Id: <20200731023924.8829-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop doubled words or fix them to what they should be.


Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org

 crypto/algif_aead.c                   |    2 +-
 crypto/asymmetric_keys/pkcs7_parser.h |    2 +-
 crypto/crc32c_generic.c               |    4 ++--
 crypto/crct10dif_generic.c            |    2 +-
 crypto/crypto_engine.c                |    2 +-
 crypto/tcrypt.c                       |    4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)
