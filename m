Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB2EC2D0E4
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 20:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D116920872
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 20:27:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WbYjKxRw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgKLU1H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Nov 2020 15:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgKLU1H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Nov 2020 15:27:07 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390EBC0613D4
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2020 12:27:07 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l5so7944996edq.11
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2020 12:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sYKFElnM8PV2uRdPgYx6ckV/PR7vDr51MnCadtA6HrM=;
        b=WbYjKxRwe6k1XomVjke+a8XLPngRSXXh+E0ez7T5MyvUjPvsOtSLma46jI1JETfWou
         ugjxNYP64QLsbr79oOcfJeadKmMZv8tKESv1Q0X42rhTtbqVrDoKc2c8Nqn+vPPK896a
         z0i09LTXhEkTxX96myCxXgDgFAeGVkyZqB78mOi9DmccOhzn5c3Vc1J8yKpqKngZOjhn
         QkLXZ4Uh/7u61ayhh2BzU23VOKsAi8OJEuuSDg1GVHBZVMoNkHtlWdhcyULGZ8oogng+
         ROyWXplg64L9Ii/Llouj3UdkFOE5sj5DkTmaMsD4VgA8m4/Wzeh5OsyaJLLcAtP+D7GL
         2yBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sYKFElnM8PV2uRdPgYx6ckV/PR7vDr51MnCadtA6HrM=;
        b=Z8cbv6zKusR0fmzUHOJWrHCSbYoBny++/WMfmObVSrdTlVcu2CseavDHcrWvNLH1Qp
         64IAntn4q0rREg+9nuZLvM05ZxCrVN2x4RPLq1zDUCJppicCh54Ff1VC114P0ayKf7VZ
         7AlFlHnv0jpqXBRKuC4SnTHpW5ZEzaRgSEx0tHAW+XDHfdxqVQt5AwFg6diR54WBchWI
         CFMPDPDYK8+tnw6rkHCA9e0na3SKT8yRw/3eMBG7T8lu7UcREfnEHO1JJspNqoFR4JWx
         +sbaG913wF5OW0vmmJxG+6dzEQuX3KNvihOrAearQcQHLs4cyFJm1+gCdiRVnogD0RJF
         T88Q==
X-Gm-Message-State: AOAM531w3lA+7ldb3q3igt3ZA/GVsypdePjN8wx4adtPScN4tA2Z/gW1
        ilTACt2y9LjYF3H3aQskwp/RajgGwERLI9zRSzU=
X-Google-Smtp-Source: ABdhPJzaYvU+WQH2K9+/ofNxSA19ddQ1rg1F7IIV7ixh66WC9QwCbAIs6wLnwzXBfdZS6FW1Brn2oGFlFwrT6SgUXyk=
X-Received: by 2002:a50:a689:: with SMTP id e9mr1729956edc.233.1605212825948;
 Thu, 12 Nov 2020 12:27:05 -0800 (PST)
MIME-Version: 1.0
References: <CAMS8qEVZFBFv4VpFtijxnR8Z5-wWFkpZx8nKOmbm6U-vah7eLg@mail.gmail.com>
 <20201023170003.GC3908702@gmail.com>
In-Reply-To: <20201023170003.GC3908702@gmail.com>
From:   Konrad Dybcio <konradybcio@gmail.com>
Date:   Thu, 12 Nov 2020 21:26:30 +0100
Message-ID: <CAMS8qEX766tggsR0DpJm8TVRwctwwvnRofiiDWhqsNDDK6exYA@mail.gmail.com>
Subject: Re: Qualcomm Crypto Engine driver
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

First of all, I am EXTREMELY sorry for my long overdue response..

I just wanted to bring up that piece of HW so as to offload crypto
tasks from the CPU, but it ended up being slower (which I suspect is
due to bw scaling not being implemented, but I might be wrong, maybe
A53+crypto is just superior..)

The goal is to have the phone run Mainline Linux *at least* at
functional parity with the BSP kernel. Both ICE and CE support are
welcome.

Thanks for your interest and the patches you sent. There is more
sdm630 (and not only, keep watching :D) work coming. I suppose you
managed to boot your Xperia by now, but if you had issues, you should
try out my v5.10-rc3 branch from the repo you linked with the supplied
ninges_defconfig. Then you append the DTB to Image.gz and create an
Android boot image (or put Image.gz+dtb into an existing one with
abootimg -u boot.img -k Image.gz+dtb) and the phone should boot.

Thanks once again for your interest and apologies for the time it took..

Konrad
