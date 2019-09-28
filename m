Return-Path: <SRS0=xkmj=XX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4830BC47404
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Sep 2019 18:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24CE820880
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Sep 2019 18:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbfI1SGI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Sep 2019 14:06:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55874 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728458AbfI1SGI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Sep 2019 14:06:08 -0400
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2EB93859FE
        for <linux-crypto@vger.kernel.org>; Sat, 28 Sep 2019 18:06:08 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id d24so8329527qtn.17
        for <linux-crypto@vger.kernel.org>; Sat, 28 Sep 2019 11:06:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=d0byJOIsz1lqJ5hnq+jj0W7I6Ibu7N/QFdfVSTVCzMo=;
        b=FLGJfWf2J/e0Ox3xWYzvE9nDPppCEEY1j4PST1SXYPfnUa4z3Cl/OyMi/47qjKZuqg
         hIUKTvuOxhHBJl1bgyNbXAx90Q4tWFdLejFUIZQyrakXAaSbs7NCCysKAKVs6VpvrbSB
         uvTDFur9l3GVo2oXKPKKxgG6gwNlgjJXoPH/zfTt1k8HP0Q7LsYWSNb8Hw5TUuzlUYGV
         SKIHC4uBV4OneQMUC+mZ/js+5DtCA+j0WVG5hZrHOzggEvb+WEUQGCTUKapTljMh5uhN
         83Ngao9cYkiHJiAjYdgnz2lHrXk6l3YXqI0JAJUBVGrjgi5LTHWRfgfregXJ4WkDYEzx
         5okg==
X-Gm-Message-State: APjAAAULwTUc+qcWAuTQ7sMoxIPKOn19UiEVxQAWn31jKwWqjHCx56mK
        ezUmG1pAxI08I/PUiZ4Jgw2+2/IDeIgHWZjrfyeD79BIqu14vPkq3q7wrlwfzYjsC166/u7UxzV
        3gUS+jHo8xH0KZXDhOzQ/GcOg
X-Received: by 2002:a37:aa58:: with SMTP id t85mr11009831qke.381.1569693967477;
        Sat, 28 Sep 2019 11:06:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqztxQPbojuWzD2tjs1KlNLYklUTuFbRfAwL7mz2CmOFv1UcY4AcvsgovDjiYI9wdsF0ybTlZg==
X-Received: by 2002:a37:aa58:: with SMTP id t85mr11009800qke.381.1569693967176;
        Sat, 28 Sep 2019 11:06:07 -0700 (PDT)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id d40sm5647462qtk.6.2019.09.28.11.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 11:06:06 -0700 (PDT)
Date:   Sat, 28 Sep 2019 11:05:59 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20190928180559.jivt5zlisr43fnva@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu Sep 26 19, Jarkko Sakkinen wrote:
>Only the kernel random pool should be used for generating random numbers.
>TPM contributes to that pool among the other sources of entropy. In here it
>is not, agreed, absolutely critical because TPM is what is trusted anyway
>but in order to remove tpm_get_random() we need to first remove all the
>call sites.
>
>Cc: stable@vger.kernel.org
>Fixes: 0c36264aa1d5 ("KEYS: asym_tpm: Add loadkey2 and flushspecific [ver #2]")
>Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>---
> crypto/asymmetric_keys/asym_tpm.c | 7 ++-----
> 1 file changed, 2 insertions(+), 5 deletions(-)
>
>diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
>index 76d2ce3a1b5b..c14b8d186e93 100644
>--- a/crypto/asymmetric_keys/asym_tpm.c
>+++ b/crypto/asymmetric_keys/asym_tpm.c
>@@ -6,6 +6,7 @@
> #include <linux/kernel.h>
> #include <linux/seq_file.h>
> #include <linux/scatterlist.h>
>+#include <linux/random.h>
> #include <linux/tpm.h>
> #include <linux/tpm_command.h>
> #include <crypto/akcipher.h>
>@@ -54,11 +55,7 @@ static int tpm_loadkey2(struct tpm_buf *tb,
> 	}
>
> 	/* generate odd nonce */
>-	ret = tpm_get_random(NULL, nonceodd, TPM_NONCE_SIZE);
>-	if (ret < 0) {
>-		pr_info("tpm_get_random failed (%d)\n", ret);
>-		return ret;
>-	}
>+	get_random_bytes(nonceodd, TPM_NONCE_SIZE);
>
> 	/* calculate authorization HMAC value */
> 	ret = TSS_authhmac(authdata, keyauth, SHA1_DIGEST_SIZE, enonce,
>-- 
>2.20.1
>

Should tpm_unbind and tpm_sign in asym_tpm.c be switched as well then?
