Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F27CC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 13:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D7A561242
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 13:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbhIPOBK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Sep 2021 10:01:10 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:50562
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231425AbhIPOBK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Sep 2021 10:01:10 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7832440264
        for <linux-crypto@vger.kernel.org>; Thu, 16 Sep 2021 13:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631800788;
        bh=LEounu6pVpMY/+ETig5QlpJIX0QAhRnRClgXx8ZL36o=;
        h=To:Cc:References:From:Subject:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=wAosNxHq1/S576khK6LCDoWdk4o8ext7ZYwV6tbx6pytAnKlHyTlPJ6xmgQB1eqPJ
         pE3az0jzDqVIozlOEOfreU+UUoswlYRktIeVu64pQhMXrAgq+Gc+e1rxXZuptpFAox
         u8sJCXKzZ6OcFzjWn3FqzCuc01sYh1xOmW5SwJ3tgoHVsCG1tFdD6cUj/C5rAkQque
         zUrZsCIZOa5KQOv62uc1q46stddrEBrHWs+vaThvQ3hoOt+iNwcwVhPQNzLj0Ubey2
         m2U0yKODU2qhgMTXhDovn3Jc5kEGwOOuXhibusK2JmV6RcNF0GmIJwwISneWpAXoZM
         4sHRDUMYPNU4g==
Received: by mail-wm1-f71.google.com with SMTP id 5-20020a1c00050000b02902e67111d9f0so3177164wma.4
        for <linux-crypto@vger.kernel.org>; Thu, 16 Sep 2021 06:59:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LEounu6pVpMY/+ETig5QlpJIX0QAhRnRClgXx8ZL36o=;
        b=M99uAMdXoz9+tX3txTTKxFvLzMp2xV88Ou8vASchJA4fY84r7xAJyP7P0wlXKihCyg
         295MQBwQFvsVA8OLSZHtOCcoZSFbtvuzDgiMLq04wdoHi+afAEErsSitwm3PianFR0gT
         O8nZx96SBcTkb6O0QJY3izBiQ3ZWCFS1Baqi0dZjBQhCiKbwUPj/CdnNy8T9e0lfb0zi
         NdxU0eGoFaOiit3rbjHZl7T3X8GVgXndVgc3qBCcoB2o3GeGFyGV90q+HWKL6Furl4wR
         ta4jfEAQVrQrKOoI18y0zbGVI+r5g8HFmOJzWJ2S5CDzUpvD8Gsgd+iILeIAP5th8MVI
         GLtg==
X-Gm-Message-State: AOAM5329oU4XE/dPTF9mJlXd0/xGFscno0+Tk34/XXdNlPpII6d9395X
        MlXgIAQ/FJ2ufH7HtF4Ugw+WR/Z5mvZNwkBEsli4oObbBJnlrFGh/CoVI/pYe1MT2NtSLs/mo4S
        ugmpnoi/foqhjVZdA+xOANgvRjE6nedS+fBNg1YOrlg==
X-Received: by 2002:adf:f98b:: with SMTP id f11mr6315928wrr.333.1631800787826;
        Thu, 16 Sep 2021 06:59:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz57pk+Ezv1dNymSc+pH/GxkAI24iTKa42bFu+mfFypmXGv8izqXwHTasFVM49zH4OMsOqrKA==
X-Received: by 2002:adf:f98b:: with SMTP id f11mr6315914wrr.333.1631800787694;
        Thu, 16 Sep 2021 06:59:47 -0700 (PDT)
Received: from [192.168.2.211] (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id q11sm3466001wrn.65.2021.09.16.06.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 06:59:46 -0700 (PDT)
To:     Marek Vasut <marex@denx.de>, linux-crypto@vger.kernel.org
Cc:     ch@denx.de, Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
References: <20210916134154.8764-1-marex@denx.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: Re: [RFC][PATCH] crypto: caam - Add missing MODULE_ALIAS
Message-ID: <441a7e2e-7ac8-5000-72e0-3793ae7e58d5@canonical.com>
Date:   Thu, 16 Sep 2021 15:59:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916134154.8764-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 16/09/2021 15:41, Marek Vasut wrote:
> Add MODULE_ALIAS for caam and caam_jr modules, so they can be auto-loaded.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Horia Geantă <horia.geanta@nxp.com>
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  drivers/crypto/caam/ctrl.c | 1 +
>  drivers/crypto/caam/jr.c   | 1 +
>  2 files changed, 2 insertions(+)
> 

Since you marked it as RFC, let me share a comment - would be nice to
see here explanation why do you need module alias.

Drivers usually do not need module alias to be auto-loaded, unless the
subsystem/bus reports different alias than one used for binding. Since
the CAAM can bind only via OF, I wonder what is really missing here. Is
it a MFD child (it's one of cases this can happen)?


Best regards,
Krzysztof
