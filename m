Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A8BC433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Sep 2021 01:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D484260FDA
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Sep 2021 01:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344741AbhICBPG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Sep 2021 21:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbhICBPF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Sep 2021 21:15:05 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE42C061575;
        Thu,  2 Sep 2021 18:14:04 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id q11so5762225wrr.9;
        Thu, 02 Sep 2021 18:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=wDGw9jS/MTv37T06LNdhRlV9dv+DZoHzz+VFlgPfmO8=;
        b=omFlQfltboSk1QU/I0UiBWwcvPsZOoW+42kTHvGhx/AFgUPSLtO5ZJmmeeqBcPZKZ9
         DA2F/dMxcNNBa4XYzLn+/CKdSmvxWP2UWgvm9OdFdbpVBpjGB7V16QyzD7Lzv1dLbIQM
         AaaIR9PY4QXgDEvH+BCzOfJIzeiZ85Q0vrT3Vk/vUvAwUdbm2n1VK721x1l/heAGZiBz
         GHHqDrJUgQXi6oIu98oGC1gFP3cKaDotjOcvpkLJj6bGXk1uJoDqlxOIcuvecdoUX3xG
         WFpOy9ZWYxRoRNv6tnpYUrQOOcv/xRsHkYsAAAykY7Nz6p2+KdVTOjOBjVb0oYIWGJvS
         w/AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wDGw9jS/MTv37T06LNdhRlV9dv+DZoHzz+VFlgPfmO8=;
        b=GVhJgxpXtP9CiF4Z3HlMrphr7PhDQVq7PdclFKiaQfPsqE4L4MuC+JcMUgtZVTacXt
         /LUN2X+pCvsePTLWcEF9wkeeXI9gLYWITqrVOQmjHqyTKJX2UfZBpemB0+zEO3rFSW0v
         VvsMe69MRHXYMC40qrtmn1KNqeLJS3TwJh0rNyT2jIlI5rCMJyqgEYiUBRtcgRSTWOT+
         QBV3s1QlLLWY5ft3a4PQeIxuVqHBSA9WkR94W2gleYg30ISfcX5q+/JiuAt7GAP9jdNL
         R9+5dWlLW3sBVsN9vFsYLDoBrBhK6O1xbtOOfOEvoQF5nPpipjYJLZZ8mYWKdEJ5H7n+
         JKUw==
X-Gm-Message-State: AOAM532B9jVgcKXQh3Sk3Za8Iktmbcsfyf02zLnzLrMmIfLsHgrW74AM
        LqyQ1L9V5ZMfuYJZp1Uy5wmU+svKbv27w1/9TrHLpYA2xcc=
X-Google-Smtp-Source: ABdhPJxsdNBRQRqeKMAg85mDKJB2zPyzsjLqiEipnHLFlztuFtEPuLMksuaQWhYeXXmqkgEuTSEDuABGVyYS5s/c9DE=
X-Received: by 2002:adf:b7c2:: with SMTP id t2mr943448wre.375.1630631642523;
 Thu, 02 Sep 2021 18:14:02 -0700 (PDT)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Fri, 3 Sep 2021 09:13:43 +0800
Message-ID: <CACXcFmnOeHwuu4N=WiGrMB+NNgGer9oCLoG0JAORN03gv1y+HQ@mail.gmail.com>
Subject: memset() in crypto code
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Doing this the crypto directory:
grep memset *.c | wc -l
I get 137 results.

The compiler may optimise memset() away, subverting the intent of
these operations. We have memzero_explicit() to avoid that problem.

Should most or all those memset() calls be replaced?
