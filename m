Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B270C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 16:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5D8765006
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 16:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhCLQQ4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbhCLQQw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 11:16:52 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6945C061574;
        Fri, 12 Mar 2021 08:16:51 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id b23so2168497pfo.8;
        Fri, 12 Mar 2021 08:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RWX7IO2Oo8TmYRuvuDdsRAk9vA6pUn2t00R0cd7mmNY=;
        b=X4jSZfe3lHmcE9DCz66oF+AtqRfB9k4nokKIZLlTYP0fUTdg4jUnEBbV8+B4X9gXKr
         v41BQlIVv63M6r/7EnNVCLgRgPetx1PR7p4CFwA2UJnLZBwAk9ZulMBuPMmoEsi6m29W
         OmOLY6ys2ZYaMv/XuQS7OUhHDEaymlyczm5M/t9s3npWtw0wl2l0qKFuUzo2FH+MZ1qE
         lOJMBbNZJYOCCm/YN/G6MbnoGE8nnhhHuXQrMAWenAZndJ4+ruQuQcg3mn6CF8upb316
         8pCR+hEoKHH1XTJY7ofscv+TFMtAMYTi/p/Ye69ZqF+RI79GEIxD6HoHiz/L6ljdMSRB
         lVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RWX7IO2Oo8TmYRuvuDdsRAk9vA6pUn2t00R0cd7mmNY=;
        b=YauMUALDdKdRZ2daBIpqBySadVzjZySsO/ZbuHMVMlMfAujRy7Xfmwhxwv/NjF7mVZ
         3ChVaxzUB7egvLw5sFiUQGcjS1cA4DbpvROA0LupI74P9tHFLv5O+bLPT3n7l/qI0FYC
         4oTiAoohm+PIIFHCDTr2MCCOxEQ58Mh/faTZxseTAxHsbI66CBU+VxVG4ziHSitY6m6n
         FCb0cG2q4kg1TaGt6YMQ4jsTuCWSOO9XWysjbSShQEhMuT3w/IpCDA7ktmfD/UmEMs0W
         eK+UdJSP2bJiBpEryEVROWz89aJwxqdXqMti7wUJhd0gcD0zflefpTPWo6sYTRkEnoM5
         Rf1w==
X-Gm-Message-State: AOAM532/A31DeWo7nBc1+vgyxRsbUQYUB/LGlrK/DObmuNG0YNhvwIGx
        yzlq33lqAUpuGHLHzGz/Ocic9I4oEjKqKUrlmsE=
X-Google-Smtp-Source: ABdhPJz6vyzpTP4o67vc3LofqtGMMBjfIhyVHOQ7lRF8qzxyZJzPG6wfXLunT91X9sV5ghtOs7hM9AfLFkXGo8BrcwI=
X-Received: by 2002:a62:528e:0:b029:1f5:c5ee:a487 with SMTP id
 g136-20020a62528e0000b02901f5c5eea487mr12965348pfb.7.1615565811282; Fri, 12
 Mar 2021 08:16:51 -0800 (PST)
MIME-Version: 1.0
References: <20210312141908.2388121-1-ztong0001@gmail.com> <20210312141908.2388121-3-ztong0001@gmail.com>
 <CAHp75VduTXkNgpmuQj_feQbHMAfWi7iGLtYxEJ6ugojmL1Da9Q@mail.gmail.com>
 <CAA5qM4CM4noDtaedPpd0yh8R2f+jDV2DnCERKi_ycD5Lq-vKDw@mail.gmail.com>
 <CAHp75VcFDXTXcaFqOyRCdArx1bGED_jsEeK1yRQhxUvHp0goTg@mail.gmail.com> <CAA5qM4DPqtPWMydx41Ovx6DCQoEESewkZbQrbhdwfVhkcy0nCA@mail.gmail.com>
In-Reply-To: <CAA5qM4DPqtPWMydx41Ovx6DCQoEESewkZbQrbhdwfVhkcy0nCA@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 12 Mar 2021 18:16:35 +0200
Message-ID: <CAHp75Ven=Sfmy0YE_Q60fiF-pyXg2tO8iq7_vN+aUzaxYTtZmA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: qat: ADF_STATUS_PF_RUNNING should be set
 after adf_dev_init
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        qat-linux@intel.com, linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 12, 2021 at 6:10 PM Tong Zhang <ztong0001@gmail.com> wrote:

> I am not really sure this reviewed by line should be added by me --
> IMHO from my past experience this line is added by the actual person
> who reviewed it on a per-patch and version basis

> I can send out another revision adding this Reviewed-by line if you
> think this is something should be done by me,
> but I don't feel I have such power to do this since I am not that guy
> and I am not a maintainer.

If you are sending a new version, it's your responsibility to collect
all tags, except the cases when the code in question drastically
changed between versions of the series.
So, please add a tag (and feel free to add the same tag to the patch
1) and resend as v3.
Thanks!

-- 
With Best Regards,
Andy Shevchenko
