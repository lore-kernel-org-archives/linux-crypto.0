Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC60C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 05:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75B0D613EE
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 05:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhEJFiv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 01:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhEJFiu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 01:38:50 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F88C061573
        for <linux-crypto@vger.kernel.org>; Sun,  9 May 2021 22:37:44 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m37so12487902pgb.8
        for <linux-crypto@vger.kernel.org>; Sun, 09 May 2021 22:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=pGYundZh3DMkJO/27D5JZK0KI0HXvrAdOMOppV9+t9g=;
        b=XQ+XbY+eazUK4qe8iY755dRv9YEe8GiiJ5wPzdyI96Ciwesg8GtfETlGk3gEnXP7kF
         ucGMcC5yxabMLfPPEKLA5Cw8LXJWiNOJ73EqIxMW9wLFgJyMatF1NgJeWaYDvVgV8ddw
         qI0dtd1LnUN11azGl9Q2DNozWxRP8yNnZ5TOuqZE9H1G8VAx+zd6XXYIQ7V1cMgqsFWf
         Zhv4GcwyWc+ofocW8E8AsmK9UkL+JKonJWL/szf207uFjlzIISF94pgKduvNnMLYLm8N
         eqXqbLYZ0F2mG6EGpkcJLmES/lVQnKWFU/B/qx+JgXd6jY3efQiow2hP02K76QRI7obB
         jIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=pGYundZh3DMkJO/27D5JZK0KI0HXvrAdOMOppV9+t9g=;
        b=uTdOwt/T52M3R70UCkh9ixKjX5f6kpL1V5kJWfKluTvFpg57v1bpWn2dcl2tHHZbx1
         DiX7c6GEBjfvPRvIp/IdlW08mBOxAebT1MbrgHEHRGji0UB9BjgE/7YoUWTxe5YYcH3z
         Yr+rJJvN53O3L7hPukJrOK7+02q+2vE4WJouQnCmVnCu5ZyQweHWS5Mcw86yPPlYO1iY
         lcSuGKNErLCO2+XYDScEsMfJrq9HfEeQa7w22IeDXA+OeUtX2gP1gsiCx7HK8x1f8mTB
         YMKQenq89RrqZYypy0r2VbzBvyjahQl9rjrq8WH+B2tv3JMuTcpRIF+gmU2Tvpb82xtq
         /75Q==
X-Gm-Message-State: AOAM531UTfBWZtbM+pbCUj54FOCjI3/Ev9GdsAWhQUcltYpwujVQvgZJ
        JW8L5P3jHcVcXKI1lZsve3Q=
X-Google-Smtp-Source: ABdhPJxF0/bbM2o8V0Qg7RAgNBJ7jcdJM6pJxcim7Dfi8jAEWTN6O5/hlt0JwcmSnKKIeshmiuMtRg==
X-Received: by 2002:a62:1481:0:b029:2c1:1e90:c54 with SMTP id 123-20020a6214810000b02902c11e900c54mr2559336pfu.55.1620625063877;
        Sun, 09 May 2021 22:37:43 -0700 (PDT)
Received: from localhost (60-241-47-46.tpgi.com.au. [60.241.47.46])
        by smtp.gmail.com with ESMTPSA id l21sm9949324pfc.114.2021.05.09.22.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 22:37:43 -0700 (PDT)
Date:   Mon, 10 May 2021 15:37:38 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [V3 PATCH 05/16] powerpc/vas:  Define and use common vas_window
 struct
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
        <293d2b3ba726c8e2a61ccca52165c4fb1e9e593e.camel@linux.ibm.com>
In-Reply-To: <293d2b3ba726c8e2a61ccca52165c4fb1e9e593e.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1620625034.ib9vm2fvp0.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of April 18, 2021 7:04 am:
>=20
>=20

Empty email?

Thanks,
Nick
