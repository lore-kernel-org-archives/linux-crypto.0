Return-Path: <SRS0=HgoS=YM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F97CA9EAC
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Oct 2019 08:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C5E420679
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Oct 2019 08:59:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SLFAWYRR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfJSI7F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Oct 2019 04:59:05 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36819 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbfJSI7F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Oct 2019 04:59:05 -0400
Received: by mail-pg1-f193.google.com with SMTP id 23so4696405pgk.3
        for <linux-crypto@vger.kernel.org>; Sat, 19 Oct 2019 01:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=9P1Hc5zx6KpRJ1G0QDp0Is0b1Emh/h9sENDo50qYI+0=;
        b=SLFAWYRRuzx0BVXm1R600VMfhtaXBl6PtH7su/FogBYhDtCIjomJmM39OqKr6+Wbwe
         gTusfVa5GpPt+Qj7S24AfwOjwWhMvz/nBeioFA4uAerjvZsdmP2o58lmAFSE/Xke42Vx
         aQZ6ELf9LeXI0LTYqr0+TuJkrmbOwZPxD1l5WhUn5ejUJepWWv29MATcr/I2WV4OzCU5
         DZv1G5Ns7MYGsI0isGkelC4SlvkeCNAiOA2khWCUQ620NEKAAxSgRmcm+YsSaGUi1mJf
         0cjlEryBk6hVzBw6ZjdmeTTsf5Xap7lI3a/D2f3vwvUdheBqOwEOApbEIb80dsJSjiZA
         c9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=9P1Hc5zx6KpRJ1G0QDp0Is0b1Emh/h9sENDo50qYI+0=;
        b=Qe23CkDgW1k7CobdghPm5z7zvU0ITwT8S8t+lRty4s4fnYn5D1HhndT59WN6tkDJbb
         e4SA9paPgl1rgXAC5KAIq2ynwc6v5M9YrdywEw1sazlq5IJ0XZwpRdBHMADK8i6nXX/Y
         gD9UFFwYRWfEyYjvlTxeAu0co8mKNMZY6N4hs10wsldcih0jNMIKFN2ooJZNQAekCZMT
         AwiB3zM1wKx4ftvd/kGp3B7LtqjaPflFzRmFKFCWM5fxa27YKWxE3grx3NIoY8T0riIt
         W9IeG3igS2wkckaZUr/lkWQ6PUt+4KzMMzK4QE2/jl6aKjQHsqs3+ayXCRgRxnpra1vM
         8OHA==
X-Gm-Message-State: APjAAAX8fyV2WKxIUTZr3BjGwTWj4zCJnS8Rt6H2zjjpyfGfEIMd7pmW
        TCtJ1bT0B9jbZoIx4UysztzZJA==
X-Google-Smtp-Source: APXvYqx01bELy8Vsdb65I8HmRPcBNWlKJoUuWytBKnuVV3b6pEgQDNnpTSe5QSXLIHzXuDLGD24tpg==
X-Received: by 2002:aa7:9156:: with SMTP id 22mr11523471pfi.246.1571475543864;
        Sat, 19 Oct 2019 01:59:03 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id y20sm4045137pge.48.2019.10.19.01.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 01:59:02 -0700 (PDT)
Date:   Sat, 19 Oct 2019 01:59:02 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
cc:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "info@metux.net" <info@metux.net>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp - Retry SEV INIT command in case of integrity
 check failure.
In-Reply-To: <20191017223459.64281-1-Ashish.Kalra@amd.com>
Message-ID: <alpine.DEB.2.21.1910190156210.140416@chino.kir.corp.google.com>
References: <20191017223459.64281-1-Ashish.Kalra@amd.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 17 Oct 2019, Kalra, Ashish wrote:

> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> SEV INIT command loads the SEV related persistent data from NVS
> and initializes the platform context. The firmware validates the
> persistent state. If validation fails, the firmware will reset
> the persisent state and return an integrity check failure status.
> 
> At this point, a subsequent INIT command should succeed, so retry
> the command. The INIT command retry is only done during driver
> initialization.
> 
> Additional enums along with SEV_RET_SECURE_DATA_INVALID are added
> to sev_ret_code to maintain continuity and relevance of enum values.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/psp-dev.c | 12 ++++++++++++
>  include/uapi/linux/psp-sev.h |  3 +++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 6b17d179ef8a..f9318d4482f2 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -1064,6 +1064,18 @@ void psp_pci_init(void)
>  
>  	/* Initialize the platform */
>  	rc = sev_platform_init(&error);
> +	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
> +		/*
> +		 * INIT command returned an integrity check failure
> +		 * status code, meaning that firmware load and
> +		 * validation of SEV related persistent data has
> +		 * failed and persistent state has been erased.
> +		 * Retrying INIT command here should succeed.
> +		 */
> +		dev_dbg(sp->dev, "SEV: retrying INIT command");
> +		rc = sev_platform_init(&error);
> +	}
> +
>  	if (rc) {
>  		dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
>  		return;

Curious why this isn't done in __sev_platform_init_locked() since 
sev_platform_init() can be called when loading the kvm module and the same 
init failure can happen that way.

> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 8654b2442f6a..a8537f4e5e08 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -58,6 +58,9 @@ typedef enum {
>  	SEV_RET_HWSEV_RET_PLATFORM,
>  	SEV_RET_HWSEV_RET_UNSAFE,
>  	SEV_RET_UNSUPPORTED,
> +	SEV_RET_INVALID_PARAM,
> +	SEV_RET_RESOURCE_LIMIT,
> +	SEV_RET_SECURE_DATA_INVALID,
>  	SEV_RET_MAX,
>  } sev_ret_code;
>  
