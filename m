Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8522DC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jun 2022 06:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiFWGPg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jun 2022 02:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiFWGPb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jun 2022 02:15:31 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7294C3206B
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2022 23:15:28 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id t21so11883983pfq.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2022 23:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tKM3xvFOU9BbHzW/2uuQbOBzRGB1RdsYKFUv60RJdxg=;
        b=zkfVRqeerd8u8NEwmgYPq9hmMYJ7IGtcSvmIgVgVfznPL6Dw3ggguq6/sRYKXu3/VO
         SLGrTrMQhjkyI53ylxtUIkwMVCDgh+BBnsUqeWIO8NvMjzYS/TVVeZPJl7BTNlAeFvJA
         lq28dsXrOrAx9WSOmOGJlKf4145Dsoxd18SR9SsiIenWpQu/FwlAx8PCJl+U/gfT1CkX
         8ILTiCKhZMTBHNuEaqTPQlUU9OHAG/QiSYdQYD6wOwfpDd15Wl1x33cO+kdjgENV+WJo
         W2jCYA0ZxaMfLF8Z7sdtQxJDlqKtSgmnUgyEdDch+805R564jAqkSlbz/fhVGYIe3Qul
         x8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tKM3xvFOU9BbHzW/2uuQbOBzRGB1RdsYKFUv60RJdxg=;
        b=JKT6JKzcJV6OAR1i1lbynIJB3VR4PeQLC8ytMyFqgHwY7GB47iuQVIs54eLMi5H3cC
         nw7omoYLwOReYNlJrfuoCB4zyxi4mRPFQBrVC00L9xE1tza1ORNdCWTWoRtHbx/S3scL
         ifQI3kp432N2OxvPYRjBOo/G+Ftbw3mR0GyuWIbRIwualXHUNAxz94qWW84xl4FuZQbI
         nF5NuAX1rnW2Q66SOOmKTDxuXs+GGTRhK5B5E2xcOh7uB82giEFM8srfPTCHkHS8p9bI
         JasNwOZ+bhR6Ra6nJw+bStIUmAPWqs9N5BbixugExXx+jglJ0h2q1X3wHoB/QGXopy0u
         d6yQ==
X-Gm-Message-State: AJIora+I2yOlMuwgXMhZJHRuxPkKiqgUcy6UIIN9TLhYPng428Cj/nLv
        V28thMIJXzidmNkpXbGC10kLedwb7b6NFg==
X-Google-Smtp-Source: AGRyM1uRBf9yGlBHsxFSSoM2oyrF8FT/8ncsKSMtOLqQiehNwhyGl1j5HLzeQVVMwzFf9fMlQgy7Rw==
X-Received: by 2002:aa7:83d4:0:b0:51c:3949:9c93 with SMTP id j20-20020aa783d4000000b0051c39499c93mr38554541pfn.10.1655964927845;
        Wed, 22 Jun 2022 23:15:27 -0700 (PDT)
Received: from FVFDK26JP3YV.bytedance.net ([139.177.225.234])
        by smtp.gmail.com with ESMTPSA id y22-20020a17090264d600b0015e8d4eb1b6sm350992pli.0.2022.06.22.23.15.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jun 2022 23:15:27 -0700 (PDT)
From:   Lei He <helei.sig11@bytedance.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        dhowells@redhat.com
Cc:     mst@redhat.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, berrange@redhat.com,
        pizhenwei@bytedance.com, lei he <helei.sig11@bytedance.com>
Subject: [PATCH v2 3/4] crypto: remove unused field in pkcs8_parse_context
Date:   Thu, 23 Jun 2022 14:14:59 +0800
Message-Id: <20220623061500.78331-3-helei.sig11@bytedance.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220623061500.78331-1-helei.sig11@bytedance.com>
References: <20220623061500.78331-1-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: lei he <helei.sig11@bytedance.com>

remove unused field 'algo_oid' in pkcs8_parse_context

Signed-off-by: lei he <helei.sig11@bytedance.com>
---
 crypto/asymmetric_keys/pkcs8_parser.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pkcs8_parser.c b/crypto/asymmetric_keys/pkcs8_parser.c
index e507c635ead5..f81317234331 100644
--- a/crypto/asymmetric_keys/pkcs8_parser.c
+++ b/crypto/asymmetric_keys/pkcs8_parser.c
@@ -21,7 +21,6 @@ struct pkcs8_parse_context {
 	struct public_key *pub;
 	unsigned long	data;			/* Start of data */
 	enum OID	last_oid;		/* Last OID encountered */
-	enum OID	algo_oid;		/* Algorithm OID */
 	u32		key_size;
 	const void	*key;
 	const void	*algo_param;
-- 
2.20.1

