Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA02EC4167B
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Dec 2022 20:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiLNUcw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Dec 2022 15:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiLNUcd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2022 15:32:33 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA175436F
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2022 12:21:03 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3ceb4c331faso11179917b3.2
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2022 12:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L22LQH7KmOjrT8G6djNy9I40Y6DACrH51I/z1yt47rc=;
        b=UXt16BrghWlfjJ3XF28huqJShfounRuXVxB3uz3pPGPcotNdlL2dNrrOF5OwG3WvTt
         7fgw/t0HRdPYJAl48IqtiQ3QRWCzeJZozMRHvgzy97kLH8vWOkBNK6Hd+2UeQzPo/kLZ
         Xq+FAPFw8iWaFFifDrqEwYCRDMwY8Xsgd4b3FPUqP0MPS9FsW/vVNeeZ9IyLQ63P8XRM
         Jw7Pwrx7WNqbEbmY2mO0Nm4MdgutDRFg/T4crCr2s/m8G1BP3+0ISXdsrYdlxo69VWy8
         e174P5Io5tr8AuA8LO/U9kGHNroBuh0mvPHmAbW/eJtHybSPiucqDw0huwjzo60NqAm9
         0o7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L22LQH7KmOjrT8G6djNy9I40Y6DACrH51I/z1yt47rc=;
        b=dNT4Ci1pFOtEsYMiff7B1ROXr4yjngknCtki6phh9531Q/IWJ/AlGuww3zLguD2sRt
         SLLsmUjCmsH5HjJ70hq5yi/vBuGLvUH8hMAVh/gKVRSEwu2PCWWQDfF3ASI2mzmTnzHG
         j0LEf2foDalo8YrHqwH17joCA7IVLkhEkW5qB/ACLWZQqmzdV4j25uS93BfnqWE0p6D4
         OYaFfbA+PZcgwGkrzSuHbp29QDpPUs2ZVsZhGWR/DsAWhPGw3DQQBnP3yM6xzCBTmYs+
         aJv2fUCQ8qQxp+283m+M4DueBZ+oRDOovFMDOOpHn8/m09lpNG5A0Ocs5rdiG3cXhh0x
         AZoA==
X-Gm-Message-State: ANoB5plU0ufHM/dTd6F7Z1XIBEIo9PPkKCLut5iH4FuSmmxBuJ5ngz6z
        tEgKvu9vKZI8j+AWHQfQnDusYrMJey4=
X-Google-Smtp-Source: AA0mqf5er0t0Z6NzSbBwHoupkBE/aAiAby9eU++DWgEG66GmPY5p0RGLfP+wTFkJgGI5Yje4G0waeky+4Wo=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:19c4:743c:e0e0:b558])
 (user=pgonda job=sendgmr) by 2002:a25:8743:0:b0:6f0:c9e7:68bf with SMTP id
 e3-20020a258743000000b006f0c9e768bfmr68411640ybn.78.1671049262522; Wed, 14
 Dec 2022 12:21:02 -0800 (PST)
Date:   Wed, 14 Dec 2022 12:20:46 -0800
Message-Id: <20221214202046.719598-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Subject: [PATCH] crypto: ccp - Limit memory allocation in SEV_GET_ID2 ioctl
From:   Peter Gonda <pgonda@google.com>
To:     herbert@gondor.apana.org.au
Cc:     Peter Gonda <pgonda@google.com>, Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        John Allen <john.allen@amd.com>,
        "Thomas . Lendacky" <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently userspace can ask for any uint32 size allocation for the
SEV_GET_ID2. Limit this allocation size to the max physically
contiguously allocation: MAX_ORDER.

Reported-by: Andy Nguyen <theflow@google.com>
Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: John Allen <john.allen@amd.com>
Cc: Thomas.Lendacky <thomas.lendacky@amd.com>

---
 drivers/crypto/ccp/sev-dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 06fc7156c04f..5c16c4406764 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -878,6 +878,10 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
+	/* Max length that can be allocated physically contiguously */
+	if (get_order(input.length) >= MAX_ORDER)
+		return -ENOMEM;
+
 	input_address = (void __user *)input.address;
 
 	if (input.address && input.length) {
-- 
2.39.0.rc1.256.g54fd8350bd-goog

