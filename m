Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07296C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 03:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C964660232
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 03:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238891AbhEUDZs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 23:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238890AbhEUDZk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 23:25:40 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F99C061574
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 20:23:46 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d16so13890321pfn.12
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 20:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=5yJ93m6CegNlSMHAeMKjyxLyMafra/bBo5cvOo7vxug=;
        b=OHl4KuE0KdFyZ8dehKBcShzJE8s8GtJAKwXzgEzq/w4irCWtLKlO+abL6xE/fyIjsl
         mNXH9j/fo6MJQ103l1NxrAL0dFS/KbYNdVS6GvF6ntBfh4VSnIm8rjxw+Zl7BxYnCOPW
         JNkRi+WAnRagh0HaVyGzTVxGo+Lt6kVBhTAhDMjkuUzAXcp1Tfca/nbeJ3LQ6xs+OBSp
         5WkXsnl10z+0rTl3xVoci9j9kAdgBOXp8pnu/rdKvAsWAWK2geyIDSa4VXjgZ1Z0mhqC
         RNxOpbiCZ0tY74lWxf0H6Ri++d11SPJJd3Jko2YBl8Ujvwh4H7bN8+K8ZHMLdVAfAG8c
         xfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=5yJ93m6CegNlSMHAeMKjyxLyMafra/bBo5cvOo7vxug=;
        b=jfckIV3KOMHvEqrEmkIgqVxVD+G6fypqnXOMzlefKdNWUoFkzcsH+bQWKZUWkQDzNy
         ya4X+Si5R06/locU5gcOm8IrfyVc1HycRXQ5P4/deE0LuphVOxfJNqqVM4rHlPXMvXL8
         FlpKLcb0I7XJI7qUREUyXOFigJ1gswjtruzaFU83E/i3oxgoM0Upvoy/cQr7KrycCXzG
         +3kZYpOyWXHKUE5/K2VbdB3yjMigPPUBURK3CdfFBrHGLIKQrK0H6B+DgFmWEhgF8kgT
         7WhW2yGtSGwBF2ISzoti/VlCloIlglZtng7mPrdJVk6NlS+xFiuhEoQvQS1KaWIbb+8/
         YI4g==
X-Gm-Message-State: AOAM532OQG8NPNLSZAXFaZ1VoF7JdlgagM4IoMXfDVLQrwiQwk+9Od3C
        /GK/G0gbUIfk+RDO0CwTo1GGJOYw+oiJdiVrD7vobjZwZMSB4Q==
X-Google-Smtp-Source: ABdhPJzVeUBQKlTb7gMMh5rgmKoqOL3vrdhloMn7tOOKF2WUd4Xc/dVx0f04KsUsUy3D7ScLKFe/+zpKfaQ25JSy3eg=
X-Received: by 2002:a65:6a4f:: with SMTP id o15mr7574107pgu.399.1621567425529;
 Thu, 20 May 2021 20:23:45 -0700 (PDT)
MIME-Version: 1.0
From:   Yiyuan guo <yguoaz@gmail.com>
Date:   Fri, 21 May 2021 11:23:36 +0800
Message-ID: <CAM7=BFrCTTuBkYb-ceX5C=e8VhAuWBVb_pYQ+K0LB1gn3h=hqA@mail.gmail.com>
Subject: A possible divide by zero bug in drbg_ctr_df
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        Yiyuan guo <yguoaz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In crypto/drbg.c, the function drbg_ctr_df has the following code:

padlen = (inputlen + sizeof(L_N) + 1) % (drbg_blocklen(drbg));

However, the function drbg_blocklen may return zero:

static inline __u8 drbg_blocklen(struct drbg_state *drbg)
{
    if (drbg && drbg->core)
        return drbg->core->blocklen_bytes;
    return 0;
}

Is it possible to trigger a divide by zero problem here?
