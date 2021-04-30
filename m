Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D33AC433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Apr 2021 06:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D9D861185
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Apr 2021 06:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhD3GL5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:11:57 -0400
Received: from gw.atmark-techno.com ([13.115.124.170]:37524 "EHLO
        gw.atmark-techno.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhD3GL4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Apr 2021 02:11:56 -0400
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 84CAB801BA
        for <linux-crypto@vger.kernel.org>; Fri, 30 Apr 2021 15:11:06 +0900 (JST)
Received: by mail-pj1-f69.google.com with SMTP id oc5-20020a17090b1c05b029014c095a5149so34232506pjb.2
        for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2021 23:11:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DxynFfDpuwJtJkg8gx5czayPX9kb0rIzF28ZKYs4mnw=;
        b=pB7FpbKNlALMiHZffOge+sZNNfZepoWQXoGNS4+lnIsIHXeV8/WN/3qvz7YhVLKtSR
         jXd2jT9DUuM0cLX7R0KqkUcQdPJu9uugu9i+D3ZdrtvweOeBAvbP0aWlkj2+CjxyvCuT
         nG7Fv1S9tIuKKF/siw3J6VAYXc5YS+KAp8SanlJP/0YaWz3aun/M0jsWrrWpmWKhkp+Z
         UZdr3+sO4uzE40NlGGdxIO9C8QJP4HQzfoq0Tpzv3yYCTtZs46qQmBe50XZe8VtL8YqI
         zSnwIpSZP1ddpCwDlK6QNJgJca3uBq1qDxJReAiiOIH8kG5OHlc0FZ/qRg6PPeJybaev
         OmmQ==
X-Gm-Message-State: AOAM532euuseph8Z/xqbyxk2oMd6r3XJIBC0g/PkIs1CLx+mfZXQcThU
        ppHdZz7n4KFV8hqwLWHKvdpvPvQJAGbRX7ORNGdy68Nq9jLaQF+5MJk7IC/by5kput/K1IID6Es
        CIoiUU/7So0lYHAD9MHsmaV3sI/0S
X-Received: by 2002:aa7:8010:0:b029:254:f083:66fa with SMTP id j16-20020aa780100000b0290254f08366famr3417636pfi.17.1619763064949;
        Thu, 29 Apr 2021 23:11:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyk+KRT1yyHrzNLd+yCCRWYpTePsNEGgGV0icQ0W6YTILQrJhDCzLsrJS2dGoL4hGaZ2lG+KQ==
X-Received: by 2002:aa7:8010:0:b029:254:f083:66fa with SMTP id j16-20020aa780100000b0290254f08366famr3417613pfi.17.1619763064669;
        Thu, 29 Apr 2021 23:11:04 -0700 (PDT)
Received: from pc-0115 (70.211.187.35.bc.googleusercontent.com. [35.187.211.70])
        by smtp.gmail.com with ESMTPSA id 14sm930318pfl.1.2021.04.29.23.11.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Apr 2021 23:11:04 -0700 (PDT)
Received: from martinet by pc-0115 with local (Exim 4.94)
        (envelope-from <martinet@pc-0115>)
        id 1lcMMg-005CAI-AS; Fri, 30 Apr 2021 15:11:02 +0900
Date:   Fri, 30 Apr 2021 15:10:52 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-imx@nxp.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/2] caam: imx8m: fix the built-in caam driver cannot
 match soc_id
Message-ID: <YIufbNaWeLgYxQGZ@atmark-techno.com>
References: <20210429140250.2321-1-alice.guo@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210429140250.2321-1-alice.guo@oss.nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Alice Guo (OSS) wrote on Thu, Apr 29, 2021 at 10:02:49PM +0800:
> From: Alice Guo <alice.guo@nxp.com>
> 
> drivers/soc/imx/soc-imx8m.c is probed later than the caam driver so that
> return -EPROBE_DEFER is needed after calling soc_device_match() in
> drivers/crypto/caam/ctrl.c. For i.MX8M, soc_device_match returning NULL
> can be considered that the SoC device has not been probed yet, so it
> returns -EPROBE_DEFER directly.

So basically you're saying if the soc is imx8m then soc_device_match()
has to find a match -- if for some reason there is rightfully no match
the caam driver will forever loop on EPROBE_DEFER (not sure how that is
handled by the driver stack?); but in this particular case we don't
actually need soc_device_match() to work: it's just there to pick the
appropriate clock data from caam_imx_soc_table[], and we already know we
should use &caam_imx7_data if imx8m_machine_match got a hit.

If we're going this way (making the caam driver only handle soc init
being late as that was noticeable), then I'd tend to agree with arnd's
comment[1] and not rely on soc_device_match at all in this case -- just
keeping it as a fallback if direct of_match_node didn't work for
compabitility with other devices.

[1] https://lore.kernel.org/r/CAK8P3a1GjeHyMCworQYVtp5U0uu2B9VBHmf9y0hGn-o8aKSJZw@mail.gmail.com/



Note I haven't had time to play with device_link_add or other ways to
make the soc init successfully early, but it's probably better to not
wait for me on this so I'm quite happy with this for now.


> Fixes: 7d981405d0fd ("soc: imx8m: change to use platform driver")
> Signed-off-by: Alice Guo <alice.guo@nxp.com>

And philosophical questions aside, this works for me:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

-- 
Dominique
