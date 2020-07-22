Return-Path: <SRS0=N13L=BB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528AFC433E3
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 06:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C358207DD
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 06:21:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="qBWKXhuB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgGVGVg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jul 2020 02:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgGVGVf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jul 2020 02:21:35 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC305C061794
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 23:21:34 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id 88so700587wrh.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 23:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BAzrsApk4VDHwo72IBIJNtqOrqLOrpegciq43liSn5w=;
        b=qBWKXhuBxi4P7/ALiJhnN0/3BOb4QCSz/f3nOTO8A+Fr9K/geRWYwDfMVEIdPcLPrr
         G+qKk0mI9DXgdJ5XsxVrHslDFH9Kptsc+1985V9JQR33yZHRD+Sh4g/uE/kAyDVfsuPk
         kffk+OsBK+RYUlneEpTzwJXSUYMqIs1TYVymaY5gcljFptTSy5Y1/FFMKZtUJ0krvk1m
         1+eeQ+dUz+a0Gz74wHcA0Rv3rx9sK0npYfrqUIq/IwRhcQDt1FBnW2VsoMRe+aH2gVLd
         zPP6D4Mrt6Op/g6d1jvLt+LzkCexsrSVwrUDJUDo2zSWt9bxv2gOblwlOoKqRiCLXxrh
         uH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BAzrsApk4VDHwo72IBIJNtqOrqLOrpegciq43liSn5w=;
        b=anZys42v0eklwy0R3pipvVgyGh4GqJNHB4tQjrw/D5L1UyoNN157a5u2alZ5WWIAPj
         qggrOeRzxuArRdbg4iltOeEXoF4x54wps7rERQzNIJCsq/2yZWUH+02zkXdAlEyzAb1E
         QjCEAZ6c4j2cVIm+hWfKgtnwEapMMGCf524w8bParKjwGMpUIvTGhgcPArXEVjvgeqMz
         MKQyNaxPlqPMUrRd8R+qEE6u10mVhqJB3SgozaSPI/CvtXxP7HayqM7Y7wKzlqvxdbgU
         xtA4vfffV+TUGPzQcQBCgN0uHzRfltdEt7N3gcqOhzsuRjVXMP3OIdrM3EVQvkALj2iC
         L4gg==
X-Gm-Message-State: AOAM533fTO2WQRTwLNBmXs+YKLnIs23aKoTUni0menjeGeroYgfO9gnE
        MAgMDvZagMiLtON+hB9wDKgTEw==
X-Google-Smtp-Source: ABdhPJwuEjzYobRCatFsIux9YRMMuoKkRkV6U/KMc5KHMCsjUCPkOux1K3X1tnegkZe15mFE/NVfFA==
X-Received: by 2002:a5d:634e:: with SMTP id b14mr31237364wrw.423.1595398893567;
        Tue, 21 Jul 2020 23:21:33 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id y11sm24709367wrs.80.2020.07.21.23.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 23:21:32 -0700 (PDT)
Date:   Wed, 22 Jul 2020 08:21:31 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Joe Perches <joe@perches.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 16/17] crypto: sun8i-ce: fix comparison of integer
 expressions of different signedness
Message-ID: <20200722062131.GA24080@Red>
References: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
 <1595358391-34525-17-git-send-email-clabbe@baylibre.com>
 <11ac49bc33546ef9ebc4120878206bd882667d8a.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11ac49bc33546ef9ebc4120878206bd882667d8a.camel@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 21, 2020 at 02:32:15PM -0700, Joe Perches wrote:
> On Tue, 2020-07-21 at 19:06 +0000, Corentin Labbe wrote:
> > This patch fixes the warning:
> > warning: comparison of integer expressions of different signedness: 'int' and 'long unsigned int' [-Wsign-compare]
> 
> I think these do not really need conversion.
> Are these useful compiler warnings ?
> 

Since ARRAY_SIZE(ce_algs) will never greater than MAX(int), the conversion does not fix a bug.
But at least the code is more proper.
So I think the patch is still usefull.

