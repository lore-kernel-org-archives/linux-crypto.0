Return-Path: <SRS0=9BFZ=XA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEC2C43140
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 16:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BF14214D9
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 16:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MWKovpwW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387467AbfIEQb4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 12:31:56 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42444 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732082AbfIEQb4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 12:31:56 -0400
Received: by mail-pg1-f194.google.com with SMTP id p3so1691064pgb.9
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2019 09:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:mime-version:content-transfer-encoding:in-reply-to
         :references:cc:subject:to:from:user-agent:date;
        bh=SZRwWiwkgh1GK9Bkb/9Pdeq8WDYShoyhFDPtRHfeWLM=;
        b=MWKovpwW8zTqMdmJ6SnU7bXm40Ky35yU73fI4bDwvGgxd2s8/Xi5imkfpb/SMKDLGD
         sQ/CqCU7EsSTI11Ky2b1tigH/UCjk3cUgZim0eRbgflNIQ12hnhmSCO9H6FNoFUe+PgG
         t3oQAlTtwlMWoTHLG7EFoVEpGTrLCyVTM+cAc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:in-reply-to:references:cc:subject:to:from
         :user-agent:date;
        bh=SZRwWiwkgh1GK9Bkb/9Pdeq8WDYShoyhFDPtRHfeWLM=;
        b=Y3eG1F1MxTg6Rcj5q2+/4Sdahze3bgzfsrxXQ6F8YvmxXSUS7/QPuPSy6aQQvUM9kO
         HyJis1wsaqlzJ816SJg43nTTZaxDxZW6G/HzWE5KcS5T8nzvPCldDXvi81ZgzviVZ/FJ
         7zW30hVAc7lUP6CZaRfzx3zSTCmQJczFknkTUbI6Piqye/LF6yRIDGq0GIdW9kv3ZWma
         7le3ezIbk3sBhITuXG275U8PganC+vd+UN4wDiXB82hg/Nh4PtFafyv0GAGc0dCqoCH3
         +tzRwWzEtOPtM2GFG/AHb5GabVuOJ43qzTguZ0FFunh59WGGxR6QrWhftdNcmDmMyOu6
         b5fg==
X-Gm-Message-State: APjAAAXVAhQ7Pbz/9QHOkeVd3olQZYViyxS5Mkm1cIzWSPiZSExwH0t9
        lkHTdFcZJIQBbALmlNwrPcAxnw==
X-Google-Smtp-Source: APXvYqyTceuhZnqbPWbDs3R8tZnE3eh1qj5gCXK7x6cT0077/9SMY7ws5QIdPLCSvBrgo6pYO+Lw5A==
X-Received: by 2002:a63:3006:: with SMTP id w6mr4043307pgw.440.1567701115407;
        Thu, 05 Sep 2019 09:31:55 -0700 (PDT)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id em21sm2302534pjb.31.2019.09.05.09.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:31:54 -0700 (PDT)
Message-ID: <5d71387a.1c69fb81.4fb28.5e25@mx.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190905074152.3oufn7yqr4flu3yc@linutronix.de>
References: <20190904110038.2bx25byitrejlteu@flow> <5d700756.1c69fb81.77c08.9c82@mx.google.com> <20190905074152.3oufn7yqr4flu3yc@linutronix.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Keerthy <j-keerthy@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] random: Support freezable kthreads in add_hwgenerator_randomness()
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.8.1
Date:   Thu, 05 Sep 2019 09:31:53 -0700
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Sebastian Andrzej Siewior (2019-09-05 00:41:52)
> On 2019-09-04 11:49:57 [-0700], Stephen Boyd wrote:
> > Can you try this?
>=20
> yes, works.
>=20

Cool thanks. I'll send a proper patch with your tested-by then?
Alternatively this can be squashed into this previous patch because it
was all wrong and is basically reverting the patch and changing the
wait_event call to be freezable.

