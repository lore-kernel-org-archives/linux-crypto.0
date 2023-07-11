Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCD6C001B0
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jul 2023 08:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjGKIkY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jul 2023 04:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjGKIkX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jul 2023 04:40:23 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96955C0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jul 2023 01:40:20 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-307d20548adso5470979f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jul 2023 01:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689064818; x=1691656818;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jO3p2R6PvDXWlq4WPv9Xl22zgwoTKhJNavHiIsEtFtA=;
        b=Ae20dguLWTcUcArQpBwy+8UhyKeU1IHItg1B/5XQWMwITlVy/68fHyrFMly/KqdLp3
         xTUbzyjr6im01vIGo0taf8ujfJfq1q8qHFhlbAXlUTWZ7l/NTnwo45FKLpaa0pudmDUp
         rh9hZNFCMhST68TuTm4JcScGSf2IbgLWj/HUgOJo+w3Jqm4+IwMrjyo1xcQS4pMEhJSd
         ndg6tFlmvM3I3nXWfgCLnvSyq8sp+j2J9MX1Baysgrvqfwd3U6C+cEA3tQlHWsXM3N1K
         DJaX2RZSVZS9nxKzsQ1kRzd9j1gpmCZ5PMEHrU7565JU9HtFmDgTr0KXruYjx0H+WUwl
         QKpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689064818; x=1691656818;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jO3p2R6PvDXWlq4WPv9Xl22zgwoTKhJNavHiIsEtFtA=;
        b=hJ6zJZ/HUMmuB1vPqdzUwEepTLMlPNC+fqtABaMCghBN8A4aw51ZWz3hiTj5MNtOXE
         wEv+hEfxYtKdKwk22KxqZ3Om0/ECRQiaTlI78RXoxjCCcM5t4zcP2LwO57iw8uCPNvhP
         vGRkgez8A06WckWlyQJGEIK5nxsXyyYlhU5aoKue1R702k5WBiEZ43ZkxJ8wK7qnVU5u
         2hT0aLZc9XjuxoCsVU3dF+5TYeO/jbMGyBe0WMmd818QX1TLSLi3646/lghcNiJZOhWm
         RT2LGz6/vRE+qj+peNoRejEWNo82JofszgEtsEh67EGBevmGmvMPF4EH5uFZpjJxjW6M
         Lepg==
X-Gm-Message-State: ABy/qLZY6W0DR5GcU2KTLhPfjRzKJvqtMUfI6LTB5t1E2ws2myxqOaPV
        FGXxMhLWeCYKjjpwkpIkE6WJqg==
X-Google-Smtp-Source: APBJJlHFGlltvFFqYky0ftaQRRy3ncLK1TPRpiIYcTCCuWWaBIxh3CsVAwMtRs+v+r5eDRDETT+ilQ==
X-Received: by 2002:a05:6000:104c:b0:313:e55f:b78c with SMTP id c12-20020a056000104c00b00313e55fb78cmr12965313wrx.21.1689064818638;
        Tue, 11 Jul 2023 01:40:18 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id q10-20020adfdfca000000b003144b95e1ecsm1589896wrn.93.2023.07.11.01.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 01:40:16 -0700 (PDT)
Date:   Tue, 11 Jul 2023 11:40:12 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] KEYS: asymmetric: Fix error codes
Message-ID: <15340a35-2400-43dd-9f50-fcbcb3c4986d@kadam.mountain>
References: <c5e34c6a-da1e-4585-98c4-14701b0e093e@moroto.mountain>
 <CTYVE0G0D53P.Y8A7V3C9BW9O@suppilovahvero>
 <CTYVFFFI0SE9.2QXXQPRJW3AA3@suppilovahvero>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CTYVFFFI0SE9.2QXXQPRJW3AA3@suppilovahvero>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 11, 2023 at 02:12:22AM +0300, Jarkko Sakkinen wrote:
> > > Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without scatterlists")

[ snip ]

> >
> > I'll pick this as I'm late with 6.5 PR.
> >
> > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Causes merge conflicts with my tree:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/

Your master branch doesn't include the "Use new crypto interface" commit
so it doesn't have the bug.

(I'm just testing against linux-next and I don't know how the crypto
trees work).

regards,
dan carpenter
