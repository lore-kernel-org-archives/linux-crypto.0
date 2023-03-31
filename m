Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3772BC76196
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 19:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbjCaTeh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 15:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbjCaTeg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 15:34:36 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F65B3C1F
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 12:34:31 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id h27so20111911vsa.1
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 12:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680291270; x=1682883270;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j5aI4zIcRoRLxHWt+SS9DifZOEmMBwiP2WMG4ZM+Us0=;
        b=GBvj2VVzqcz8cM1eZWgTv9CGJbCh3zsVEDpjDHXkTESlN0fjtf99vxFgjC7OHKg3xK
         H4JCfx5akPv1CZRSefFIb7I885BGidHlru/Ddntd6dfR7S1DLZVhd5wIHsq4TSG446sp
         RhyGidbX74IyLJo3hc79hGmAzBWGNfFt6e4do=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680291270; x=1682883270;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j5aI4zIcRoRLxHWt+SS9DifZOEmMBwiP2WMG4ZM+Us0=;
        b=krpZxpaK8EsJYB5NYpDjzvEOFT9NFxTOJ4QhmiO3BGaSopV5euUKC09UYGa42JQ8hk
         44R04VL2VNWjqGSRS+2ofMWVFOUF/OtdCl/qd5V8i5Lvcb/sga7yC2s3IcbdcfrXWcXk
         H4SdSPgeII2ne4GiJIsTdxZZJ/BRjeD6MTDZUuw9lV6N2FE0vkiK9r4HKSDG857DHxow
         0iQMm1fQHfhcFbftKdelFtWumw7NL9b4VMxYzxNFNXtG7WOhaSU3bn9NiXLKv8sSiFF/
         nKde27qOySrGRf94G5FKhq3A4FoBSpwh8ngRPwU0tLQVp4E9tIsV0XVpCndgxqrwK3m4
         TC4g==
X-Gm-Message-State: AAQBX9fef/z5+kfvO/MON2C3ydxkutPYzmH/YPv3mxtA5UwgcEEbd8D/
        /NBHLWwGapwcajzMaR7hX6Kx4UvdS4zI2DcSfUe+JA==
X-Google-Smtp-Source: AKy350avAB5zM9H9xCzxvaea8vrZmf27YUrlGiTRyv7e4+dWXsw3Sz6xg7dkenWal9cIF2zXy/xEIE/sEnOmr8Fg7YY=
X-Received: by 2002:a67:e1c4:0:b0:427:2159:370f with SMTP id
 p4-20020a67e1c4000000b004272159370fmr2538299vsl.3.1680291270429; Fri, 31 Mar
 2023 12:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230329220753.7741-1-mario.limonciello@amd.com>
In-Reply-To: <20230329220753.7741-1-mario.limonciello@amd.com>
From:   Mark Hasemeyer <markhas@chromium.org>
Date:   Fri, 31 Mar 2023 13:34:19 -0600
Message-ID: <CANg-bXDsYffoYz+VL9hWkhOAyXKXDDLmB1rAvyahf7GCGibfVg@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] Use CCP driver to handle PSP I2C arbitration
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     =?UTF-8?B?SmFuIETEhWJyb8Wb?= <jsd@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-crypto@vger.kernel.org, linux-i2c@vger.kernel.org,
        Felix Held <Felix.Held@amd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tested-by: Mark Hasemeyer <markhas@chromium.org>
