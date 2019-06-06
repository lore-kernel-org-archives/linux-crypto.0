Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9BEC04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 17:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BDCB20872
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 17:51:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ozS0g1Kr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfFFRvn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 13:51:43 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45233 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbfFFRvm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 13:51:42 -0400
Received: by mail-lj1-f196.google.com with SMTP id m23so2854481lje.12
        for <linux-crypto@vger.kernel.org>; Thu, 06 Jun 2019 10:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LX7UPkKEbs2H7p/8IRQHhp005pCTt9Jaa99XCrcHGP0=;
        b=ozS0g1Kr7oJk2/vb/ilvwYaYr/ZZ3fDIrVZuwbK6cpte7dO+7JyNKkUwkhJ2f3fE00
         Xw6NbPnv74bJ5RDghJUrqnv7mgnFeqeXtAFj10WnSB0X1kKK/RXuVHC6l1bJZrFg64mk
         UpXFTONzvJfcU09L+ZfJ03cChB4xJOiurlxOxESytq39BuHym+nnTB6cWRcyU5rZrj8y
         mFSsRdIS6Wv1vFfHAvbdAKdj7FiBej49dDL22ojGMLcb5fadmkIQ378pxUQS1wlFBxbV
         qBPKd9EN62lYlN9BxBQWgdPHcNE9f07DLQbm/ewDvkmd6ZRnP2omf4dDYasM+ZKfUgOH
         QQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LX7UPkKEbs2H7p/8IRQHhp005pCTt9Jaa99XCrcHGP0=;
        b=Uet5VcmiLOpOhXmoF6Pxeg7lO+aqMG71hugr8TvsqYw1Q/c3CgXGmqXkZKyc8Yq+rO
         ifeOUHkkSYow9h5clCmwB/MRPQjjHiSoE1BoHpeMoNfjkrg6YQcvUfXiIy8nDH5iBmGg
         QJ0fE1p5qEr4nVUUiOhmEG4f5AJIUjbqhT1lkZrzjzKz6NceaUL8hmVnfC9hBTjHiyne
         u0wclE0djWVguVWNR+b2HvMEeNsPJEqQ99jD0CIs//9gCWplJZTmyuHfrOpTMwt3nJmB
         1KEE9BTO7ePwsYtyJ69gYa+GaeGXgJlJPc2Z2Nf58KRlAs6qqWaD+4jj4/cVwO0SJ6pK
         QrXw==
X-Gm-Message-State: APjAAAXczpXOx+vSNakxb5KbF2LkUfYLLqpi06XK/rBL0gzf3m8cwMoq
        Qt0a7pmV1ZOumW9lohGplaqjcuh/8Do4xsNVnMg=
X-Google-Smtp-Source: APXvYqxZQpkW1LPjRf8QgpOvkJgIlHXGtAeFPRMXjQ7t+vON2A6stsDHaGRPHd+iqNo4DAjQQ3YOji8Keg/VaZ+ON8A=
X-Received: by 2002:a2e:91c3:: with SMTP id u3mr25315439ljg.130.1559843500647;
 Thu, 06 Jun 2019 10:51:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190606172845.16864-1-festevam@gmail.com> <f166aeb5-bde2-1721-d7d8-bc19245a324a@c-s.fr>
In-Reply-To: <f166aeb5-bde2-1721-d7d8-bc19245a324a@c-s.fr>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 6 Jun 2019 14:51:32 -0300
Message-ID: <CAOMZO5D7nWw-+mwuNny3nJe-buz0dhGY2M=e6nSQgjOJDKkBaw@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: talitos - Use devm_platform_ioremap_resource()
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Horia Geanta Neag <horia.geanta@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Christophe,

On Thu, Jun 6, 2019 at 2:45 PM Christophe Leroy <christophe.leroy@c-s.fr> wrote:

> Have you checked that it has no impact ?
>
> On SOCs, areas of memory are often shared between several drivers.
> devm_ioremap_ressource() can only be used if we are 100% sure that this
> area of memory is not shared with any other driver.

Thanks for the clarification. I think we should stay on the safe side
and discard this patch then.
