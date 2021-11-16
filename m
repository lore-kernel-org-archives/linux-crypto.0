Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBA7C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E24F61994
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbhKPLXe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 06:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbhKPLXN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 06:23:13 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2BFC061570;
        Tue, 16 Nov 2021 03:20:16 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id i8-20020a7bc948000000b0030db7b70b6bso1648454wml.1;
        Tue, 16 Nov 2021 03:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=9k0lq1roo1yU+sgwXvoU+dRrg4C2CqKLsD8JklMCe+w=;
        b=Chfn+tRTd96qWWqOSSFTiiFiEqbNeTMm721F3a+6JRK6oFCzu33qlEXqX4ASPuFBwe
         LqloIcWSG6viWNo/zq3BbHm/nCZ2nppWzbcpJoTz1ZAqD4OQo3O5xUP5BVWjFBIMkXh6
         SHawqYaulypV6uqN37DveXeDeuAOQPHIh1vgAaFgpUIBU5slgw7njCwoQcuZPdt4b/mu
         JMiLkaN7pXVjMKaMzuUwJW0oaY0sXKPgRh04gsY0WqsQ7VxUJc0UOkqflnIcChk/fkkj
         1G5tvqAW2/GzTWOL02DD85H/UT058vtQVOuwZodPfKp2rD6GzS9vej4Q5yHAM0hYXaOf
         smQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9k0lq1roo1yU+sgwXvoU+dRrg4C2CqKLsD8JklMCe+w=;
        b=f6yMdwypv9wG8Dv3R36FHQpneioHhu756+/hK9rgxPoO/eIAjVMQK/iddCXA3L1WrH
         cTDPmSyzR/yfp/twhu7kLm/c2RNP3+YjG+tiqEORrSTBLhdUy40vWRSGmcwHOQ6wpGFs
         335fshFFNJFqxgFgnHP/n40QaZ78vaHGd6li/snUt1HeeQie4R2+7UE0DCiNHdvT2X2S
         7jEIk0rJ3/QJGNtU8XlxSSxyw37cQUrmEtWL7Uovbx/R07PebyYqfG9hxsR2+IHTdoBL
         4YVlx10HTfbmRddi3vt7xgJFzpjoGGnKyrg69XykHlQ9W6mt0Ke6dwXJ+eqCqcIVFj/q
         LAkg==
X-Gm-Message-State: AOAM531I+vzTTrw4U+n/l7tpAFaoYFGKf+cfjC5NmQFBj3yy046A3xAb
        iPNyppLp5sT7Km6LC2HzIs4Fv0BEBXDlZCF+HvMaau+Cq2c=
X-Google-Smtp-Source: ABdhPJxE/j9R9J7pcBZyLKN9vxLkUjqLTSLV8QoJ5A0Cx9D4tQ9geZ9cUvnd1muA5YzO3ZLEJsgbufQOBDL7h9lh/Eo=
X-Received: by 2002:a05:600c:a42:: with SMTP id c2mr68402117wmq.154.1637061614438;
 Tue, 16 Nov 2021 03:20:14 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 16 Nov 2021 19:20:02 +0800
Message-ID: <CACXcFmkO0g2YRjvfknKXr_ZnJaMg2cpvOsLq=h1ZcB=hg9NK8w@mail.gmail.com>
Subject: [PATCH 0/8] memset() in crypto code
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fairly often we want to clear some memory in crypto code; it holds
things we are done using and do not want to leave lying around where
an enemy might discover them. Typical examples are crypto keys or
random numbers we have generated and used for output.

The obvious way to do this is with memset(address,0,bytes) but there
is a problem with that; because we are done using that memory, the
compiler may optimise away the "useless" memset() call. Using
memzero_explicit(address,bytes) instead solves the problem; that
function is designed to resist the optimisation.

There are well over 100 memset() calls in .c files in the crypto and
security directories. I looked at them all and found about a dozen in
eight files that I thought should be changed to memzero_explicit().
Here they are as patches 1 to 8 in this series.

I did read some code & think moderately carefully, but I do not know
the code deeply & it is possible I have made some errors. I think
false positives (making unnecessary changes) are more likely than
false negatives (not catching necessary changes).
