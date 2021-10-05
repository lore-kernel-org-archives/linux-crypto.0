Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273D2C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Oct 2021 19:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D916113E
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Oct 2021 19:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235654AbhJETxe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Oct 2021 15:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbhJETxc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Oct 2021 15:53:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCEBC061755
        for <linux-crypto@vger.kernel.org>; Tue,  5 Oct 2021 12:51:41 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j193-20020a2523ca000000b005b789d71d9aso86952ybj.21
        for <linux-crypto@vger.kernel.org>; Tue, 05 Oct 2021 12:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ruleJux/5LJ89GBnHLLZrulEoEZQntK4/1Ov9wfpo+4=;
        b=P1FicB+D7N40MyGLhIwZ/HaGNpUlZfZIcgpM3fJyqJUBIZtpNE7GUZOHqGtLeFRuUK
         k/TY4xjrZADxoa0nsPAs682fJrrZCeK5qktH5Br+VghVRSTld5y29oifxAkdm8N4wmn8
         PXzHNn1Zp5+TidAthHOYvcYjX/SND+u3TePP7DYwDiTJK5G949OkIzKSlJjoTqJJAIzO
         SnPaArK+kTTISGDcqg+vvWhvXTTml2h4/hGBEHm8EYw/05h5N+d5Filz2NhSTt+Eu9+I
         tTjpedR3ZvJOU2/6cYsVmkGyHVlUmFJd4ohDPIh0K41/aODexlarcRxRGFqzNEOg4F3V
         hANQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ruleJux/5LJ89GBnHLLZrulEoEZQntK4/1Ov9wfpo+4=;
        b=YzIIKgdzHXWsnImHKMVvUQjSDZdj+7QMKPdxYSAMoQaq6CPK8vTCHbQSoacPXu/m0Z
         qqq4Q5byC4GZqawaTIh+6p469eIQhTec240soLKi41/jLEEbHoKMOuZm/pBj4UPc1VoR
         1sZSSgdALDdtd0/5ZTgKwvJSudOleMP0pkCnyv291QRhgWwWxcxNMCvIqWMloaN2E/pw
         hp+lpuec4TEiidSkMQ30mmlv9uxWebwid8EOLtq1aZWu9jcjC+DEZS92zpElFLzPoavd
         dKGQFOWftvZDrAj4veQcm58gApo0sWIOJhvDDvh0iJCu5nrMiFl6awCrHOF5etb0NqHh
         U5GA==
X-Gm-Message-State: AOAM530yPAJCHl2NrdpQfCCXCROUR3SZU+6Aitsew7NdAowwzijzroiV
        5MzM/fLURLUlKtuwYq+PRy0dHg2i8o0=
X-Google-Smtp-Source: ABdhPJzPEmHJWlRyTuNPyeYZh6L/nXbs5BX6Lcne2eMYq4+WjxiKZNPQ+V+rswlP5O89vaL5+iT5Rltg7bo=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:b603:db5:e90f:74aa])
 (user=pgonda job=sendgmr) by 2002:a25:b9cf:: with SMTP id y15mr22754044ybj.110.1633463501163;
 Tue, 05 Oct 2021 12:51:41 -0700 (PDT)
Date:   Tue,  5 Oct 2021 12:51:31 -0700
Message-Id: <20211005195131.2904331-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH] crypto: ccp - Fix whitespace in sev_cmd_buffer_len()
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extra tab in sev_cmd_buffer_len().

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2ecb0e1f65d8..e09925d86bf3 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -134,7 +134,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_DOWNLOAD_FIRMWARE:		return sizeof(struct sev_data_download_firmware);
 	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
 	case SEV_CMD_ATTESTATION_REPORT:	return sizeof(struct sev_data_attestation_report);
-	case SEV_CMD_SEND_CANCEL:			return sizeof(struct sev_data_send_cancel);
+	case SEV_CMD_SEND_CANCEL:		return sizeof(struct sev_data_send_cancel);
 	default:				return 0;
 	}
 
-- 
2.33.0.800.g4c38ced690-goog

