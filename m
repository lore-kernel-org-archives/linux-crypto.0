Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE95C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Sep 2021 02:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AB166056C
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Sep 2021 02:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343914AbhICCeA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Sep 2021 22:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbhICCeA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Sep 2021 22:34:00 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36521C061575;
        Thu,  2 Sep 2021 19:33:01 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id u15-20020a05600c19cf00b002f6445b8f55so2634655wmq.0;
        Thu, 02 Sep 2021 19:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=65OzTBrhg+TqxEve/HIyWImqVZJdovDNaqVqqRqzPW0=;
        b=FfohmMubYobHHdA6Y5oPvYcQdeDMfOIcOLHy7H08puBAHNuIu5pqQNc+gVVNhQmNjc
         1681iaIu2263lFwD/KxdhRecMY3WAQGi/QIyNyTtApxVm42hi2rNRw17VroPkYUksZ2T
         Ep4wifvwQZt1bNwFTOftwAN5IcjqRWqZaW4eAYYg5rqWK10kt6ShLT43lRDEB3kL3aAw
         E2fo/V1KqidhgTGaZw2+qHR7US4pnwoD1zG9xa9ktw8H9kWIkdWlM5sGVzxPpwd1J5h9
         O7zIkAq4t+0x3LV58E86ZF3m8d6hrZTuqo7n4DFTh98GshpEihGoPPd+Ifc0UK0yrnTM
         0zXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=65OzTBrhg+TqxEve/HIyWImqVZJdovDNaqVqqRqzPW0=;
        b=a+aVeEnpe9oW2WeNA+gP61rieG7kP5cnumrx4v0xx2BGlxnyeHPQtrdK/ASkVjvy81
         IwlqcPGDlG5wFE0b/6mNDTf0KeYT/hQUsOIEKLBqoY078yWX6YcBiBqw1AHW/X2Wz/iF
         Es+ELHZA0pLOKm0+Ra3oRurRCxKYiC0IoLUJw/jZDvqbKw4KYan23qI5ux6N5t+xyXxL
         l0YL1QnaWCftASkLerYwW164uw4Drjtzr7q7g9g5xAUR+YNP1CnPchgfqvUSzHNi4/9Y
         FC/3HzEGQyGcnR+IvvOqK2tm7EL+QtdYfT7808r+BKgmnPWu5QpcR8pJYPIFrXiAoewK
         SFoQ==
X-Gm-Message-State: AOAM5304RoqSSWYrL+SCQaKgBSb4A2VWzVco6nUmAHDZVh/PxmRze/ek
        eONGxP9eh3KEZ3SW9zXWTDfyH0tnV0azxxnqby2pZoHMCiY=
X-Google-Smtp-Source: ABdhPJyMDSBJW81NT2zX+rRzepZoaAib170nGikW9ZkG6oMsB24Jo2a+rOPwA/fJas31xuJCYPtgTZjaKE9Yam989/g=
X-Received: by 2002:a7b:cb09:: with SMTP id u9mr5897529wmj.63.1630636379328;
 Thu, 02 Sep 2021 19:32:59 -0700 (PDT)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Fri, 3 Sep 2021 10:32:47 +0800
Message-ID: <CACXcFmkhSf9O6xyn+XerKd5AjLPv05aok+RB0owgxFpnhGjeCw@mail.gmail.com>
Subject: C vs crypto
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

An interesting academic paper on the difficulties of writing secure
crypto code in C.
https://www.cl.cam.ac.uk/~rja14/Papers/whatyouc.pdf
