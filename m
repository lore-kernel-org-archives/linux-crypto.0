Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1A1C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 09:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B3E3613AD
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 09:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhETJg1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 05:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbhETJe0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 05:34:26 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC75C061345
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 02:27:39 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i17so16878477wrq.11
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 02:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rS7P8Ei6Lo3i+RlQq5zKImv/cfX/br3YBCEeZlUR+Wo=;
        b=fyvFyYwTHmysyDvUCxIUqz4GHhibyDSHfz1LJ24o5pcPss1gmV+GmcTdA5C0BZmnpL
         84K5AkNzJxeWBcNhA0BdAQ2aWQyMOvyATMjlqxbOYFrk2U60M/QKYKruXetGnSetmeqS
         I7vCvJk//2EyTCHUsbSTwa5pOdo2r36ZtpEf3PLHCJ715UCvCEebEyTGAyrS5h1S60c5
         jzZT/wq1PNaaUZU57Ej2EQJIoqvk5N0zdxPirMmP52uCWsi5tZQVG6V7rX+UPSUOZc7L
         3VMa81rJpjZE43EN/OUnJGzrn2EwfMw4tDEmXSAW27hnLioaQaGRK+da4dwWVTRlt7JE
         lY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rS7P8Ei6Lo3i+RlQq5zKImv/cfX/br3YBCEeZlUR+Wo=;
        b=oqbXRN6Qq0jekE4HD7xvXAhaKVPZL4LhwzH7r+wMZCNXcJ58M3zlwJGEbQHaEzKxqe
         XTq2BdrRSsIo1OusMozVgghdo/ABJopdtoNGkxawW5HXUkTk8ap6GDUxD7k3oJrTKoJJ
         9iC/4KvqnRcccXJ6AXP0zyAzTtwtOsi9z6X5b7yrppdcPW2iCb4Wj3WWIgQadbH0yc7F
         qsd9aUf9nFOBLF53xiwRCAMWSi626T+Ubw8T9GeI+KS7mrGYFBjnV4Cc2+ADzrHRZxt0
         0XNmWtArLFQdnO3EpCFqzRWtTg0X8CpYjVOykknRiBGLOThROaJR90rZfN9AJ///7GES
         cNHQ==
X-Gm-Message-State: AOAM5317dQqwGqZZ/4hGJ25K7ZYTPtnkuhTdZb4IHxjIq1LPi/jsC+ki
        cRyYhOh4qt6JM/daYqC7iItErw==
X-Google-Smtp-Source: ABdhPJwhzqzv8ZBlSOOdzJVfnyeZCdwIgAf8NIgxGoUr4jQPPkKtw2EeCYoF6aW4L0gQERY0JDP8Tw==
X-Received: by 2002:a5d:5249:: with SMTP id k9mr3291616wrc.301.1621502858330;
        Thu, 20 May 2021 02:27:38 -0700 (PDT)
Received: from dell.default ([91.110.221.215])
        by smtp.gmail.com with ESMTPSA id u11sm722971wrw.14.2021.05.20.02.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 02:27:37 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Haren Myneni <haren@us.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/3] crypto: nx: nx-aes-gcm: Kernel-doc formatting should not be used for headers
Date:   Thu, 20 May 2021 10:27:32 +0100
Message-Id: <20210520092733.3434378-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092733.3434378-1-lee.jones@linaro.org>
References: <20210520092733.3434378-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/nx/nx-aes-gcm.c:26: warning: Function parameter or member 'tfm' not described in 'gcm_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-gcm.c:26: warning: Function parameter or member 'in_key' not described in 'gcm_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-gcm.c:26: warning: Function parameter or member 'key_len' not described in 'gcm_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-gcm.c:26: warning: expecting prototype for Nest Accelerators driver(). Prototype was for gcm_aes_nx_set_key() instead
 drivers/crypto/nx/nx-aes-ecb.c:24: warning: Function parameter or member 'tfm' not described in 'ecb_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-ecb.c:24: warning: Function parameter or member 'in_key' not described in 'ecb_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-ecb.c:24: warning: Function parameter or member 'key_len' not described in 'ecb_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-ecb.c:24: warning: expecting prototype for Nest Accelerators driver(). Prototype was for ecb_aes_nx_set_key() instead
 drivers/crypto/nx/nx-aes-ccm.c:26: warning: Function parameter or member 'tfm' not described in 'ccm_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-ccm.c:26: warning: Function parameter or member 'in_key' not described in 'ccm_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-ccm.c:26: warning: Function parameter or member 'key_len' not described in 'ccm_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-ccm.c:26: warning: expecting prototype for Nest Accelerators driver(). Prototype was for ccm_aes_nx_set_key() instead
 drivers/crypto/nx/nx-aes-ctr.c:25: warning: Function parameter or member 'tfm' not described in 'ctr_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-ctr.c:25: warning: Function parameter or member 'in_key' not described in 'ctr_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-ctr.c:25: warning: Function parameter or member 'key_len' not described in 'ctr_aes_nx_set_key'
 drivers/crypto/nx/nx-aes-ctr.c:25: warning: expecting prototype for Nest Accelerators driver(). Prototype was for ctr_aes_nx_set_key() instead
 drivers/crypto/nx/nx-aes-xcbc.c:22: warning: cannot understand function prototype: 'struct xcbc_state '
 drivers/crypto/nx/nx-sha256.c:21: warning: Function parameter or member 'tfm' not described in 'nx_crypto_ctx_sha256_init'
 drivers/crypto/nx/nx-sha256.c:21: warning: expecting prototype for SHA(). Prototype was for nx_crypto_ctx_sha256_init() instead
 drivers/crypto/nx/nx-sha512.c:20: warning: Function parameter or member 'tfm' not described in 'nx_crypto_ctx_sha512_init'
 drivers/crypto/nx/nx-sha512.c:20: warning: expecting prototype for SHA(). Prototype was for nx_crypto_ctx_sha512_init() instead
 drivers/crypto/nx/nx-842-pseries.c:280: warning: Function parameter or member 'wmem' not described in 'nx842_pseries_compress'
 drivers/crypto/nx/nx-842-pseries.c:280: warning: Excess function parameter 'wrkmem' description in 'nx842_pseries_compress'
 drivers/crypto/nx/nx-842-pseries.c:410: warning: Function parameter or member 'wmem' not described in 'nx842_pseries_decompress'
 drivers/crypto/nx/nx-842-pseries.c:410: warning: Excess function parameter 'wrkmem' description in 'nx842_pseries_decompress'
 drivers/crypto/nx/nx-842-pseries.c:523: warning: Function parameter or member 'devdata' not described in 'nx842_OF_set_defaults'
 drivers/crypto/nx/nx-842-pseries.c:548: warning: Function parameter or member 'prop' not described in 'nx842_OF_upd_status'
 drivers/crypto/nx/nx-842-pseries.c:582: warning: Function parameter or member 'devdata' not described in 'nx842_OF_upd_maxsglen'
 drivers/crypto/nx/nx-842-pseries.c:582: warning: Function parameter or member 'prop' not described in 'nx842_OF_upd_maxsglen'
 drivers/crypto/nx/nx-842-pseries.c:630: warning: Function parameter or member 'devdata' not described in 'nx842_OF_upd_maxsyncop'
 drivers/crypto/nx/nx-842-pseries.c:630: warning: Function parameter or member 'prop' not described in 'nx842_OF_upd_maxsyncop'
 drivers/crypto/nx/nx-842-pseries.c:692: warning: Cannot understand  *
 drivers/crypto/nx/nx-842-pseries.c:825: warning: Function parameter or member 'data' not described in 'nx842_OF_notifier'
 drivers/crypto/nx/nx-842-pseries.c:825: warning: Excess function parameter 'update' description in 'nx842_OF_notifier'

Cc: Haren Myneni <haren@us.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/nx/nx-842-pseries.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 8ee547ee378ec..67caff73f058f 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -264,8 +264,8 @@ static int nx842_validate_result(struct device *dev,
  * @inlen: Length of input buffer
  * @out: Pointer to output buffer
  * @outlen: Length of output buffer
- * @wrkmem: ptr to buffer for working memory, size determined by
- *          nx842_pseries_driver.workmem_size
+ * @wmem: ptr to buffer for working memory, size determined by
+ *        nx842_pseries_driver.workmem_size
  *
  * Returns:
  *   0		Success, output of length @outlen stored in the buffer at @out
@@ -393,8 +393,8 @@ static int nx842_pseries_compress(const unsigned char *in, unsigned int inlen,
  * @inlen: Length of input buffer
  * @out: Pointer to output buffer
  * @outlen: Length of output buffer
- * @wrkmem: ptr to buffer for working memory, size determined by
- *          nx842_pseries_driver.workmem_size
+ * @wmem: ptr to buffer for working memory, size determined by
+ *        nx842_pseries_driver.workmem_size
  *
  * Returns:
  *   0		Success, output of length @outlen stored in the buffer at @out
@@ -513,7 +513,7 @@ static int nx842_pseries_decompress(const unsigned char *in, unsigned int inlen,
 /**
  * nx842_OF_set_defaults -- Set default (disabled) values for devdata
  *
- * @devdata - struct nx842_devdata to update
+ * @devdata: struct nx842_devdata to update
  *
  * Returns:
  *  0 on success
@@ -538,7 +538,7 @@ static int nx842_OF_set_defaults(struct nx842_devdata *devdata)
  * The status field indicates if the device is enabled when the status
  * is 'okay'.  Otherwise the device driver will be disabled.
  *
- * @prop - struct property point containing the maxsyncop for the update
+ * @prop: struct property point containing the maxsyncop for the update
  *
  * Returns:
  *  0 - Device is available
@@ -571,8 +571,8 @@ static int nx842_OF_upd_status(struct property *prop)
  *  In this example, the maximum byte length of a scatter list is
  *  0x0ff0 (4,080).
  *
- * @devdata - struct nx842_devdata to update
- * @prop - struct property point containing the maxsyncop for the update
+ * @devdata: struct nx842_devdata to update
+ * @prop: struct property point containing the maxsyncop for the update
  *
  * Returns:
  *  0 on success
@@ -619,8 +619,8 @@ static int nx842_OF_upd_maxsglen(struct nx842_devdata *devdata,
  *  0x1000 (4,096) data byte length and 0x1f3 (510) total scatter list
  *  elements.
  *
- * @devdata - struct nx842_devdata to update
- * @prop - struct property point containing the maxsyncop for the update
+ * @devdata: struct nx842_devdata to update
+ * @prop: struct property point containing the maxsyncop for the update
  *
  * Returns:
  *  0 on success
@@ -689,7 +689,6 @@ static int nx842_OF_upd_maxsyncop(struct nx842_devdata *devdata,
 }
 
 /**
- *
  * nx842_OF_upd -- Handle OF properties updates for the device.
  *
  * Set all properties from the OF tree.  Optionally, a new property
@@ -812,8 +811,7 @@ static int nx842_OF_upd(struct property *new_prop)
  *
  * @np: notifier block
  * @action: notifier action
- * @update: struct pSeries_reconfig_prop_update pointer if action is
- *	PSERIES_UPDATE_PROPERTY
+ * @data: struct of_reconfig_data pointer
  *
  * Returns:
  *	NOTIFY_OK on success
-- 
2.31.1

