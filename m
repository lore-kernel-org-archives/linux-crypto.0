Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CF8C61DA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Feb 2023 19:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjBKTCS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Feb 2023 14:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBKTCR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2023 14:02:17 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAFD14EAB
        for <linux-crypto@vger.kernel.org>; Sat, 11 Feb 2023 11:02:16 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id w14-20020a17090a5e0e00b00233d3b9650eso897312pjf.4
        for <linux-crypto@vger.kernel.org>; Sat, 11 Feb 2023 11:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AhV+kuejfFEIUH1LugvRrz53KcmgwC816Evw/+TiOaw=;
        b=cv//KYN7SRluavxo5IZzZt3FMUfoTb2Dt9JgWMY+4BiHJdtCJQ0HXniIsE6DIr+Qoi
         SjKTaS3jCXgLNtXJBkjCMHRHV0r11nAZ+uoA6lOYDb+Ibnfn2o0bCpoLV37t5C4JkwYL
         kJxjcZypOAL4/Uy99Jfex4HIfytB31xAiYPLxRd+bsD21E2xSMrUO7JpPJlHPbiHaBYh
         5QAd063u6eHKd5+UM7gutLf0XG2lVBYIS/nsrvTLDG34atgk9sQbMOwL6mgj/c1It+jq
         qU7W+ZFt3tVEOFMfv/AMAT1tzTvfTVhZ5V7f3Y+HbeNcZi4JPkJ8nFyyaHxXFOtNZfuB
         KTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AhV+kuejfFEIUH1LugvRrz53KcmgwC816Evw/+TiOaw=;
        b=HgFss/xuvTdm9BuUNR3Qxju8gW5KA1QLEm7Cl8xhXe6U/xYksmp2/5DosXU7o+9O16
         CduMdsXsDKZJjpjJEvEcPqOMzLtGPInFrxv7C0Ijnrm73hbEPct0h7I8KfNOX1Wj/8wo
         2LzRZQvjX3ALc2Y1VNAQNfVyN1xjLC2EQnRys3Sk0PgoYIQdunTaVaDf6wPAZYoslUDp
         Dgka+GcskZr3LYVYxedX/1xrkW7gZV8DblEEL9ecU5hVD6vhIIfYtcvd2zmXs9yyj4s9
         KU/5Xpw0RY9AsxXd0i2RSu5j9Wn/Y5DYgbHKJg9mzzopHUFOxh0vB+IUfamh0pyx2uiW
         l4ZA==
X-Gm-Message-State: AO0yUKUj5WQT8Yc96tnr3BtBCL39jlNaoHLsSya/WyPKuLBvcZiZiN3Q
        GnhJaUUn3c4U60EWHgrJJHk=
X-Google-Smtp-Source: AK7set+tI5Dfb/ksC/sLAjP2YXuvz7RkxDJDo2D90+/P+OK2miO6oWkKn5/E9TUwf1rmuEl13Tcs4Q==
X-Received: by 2002:a05:6a21:3a97:b0:be:ce7a:8728 with SMTP id zv23-20020a056a213a9700b000bece7a8728mr19170342pzb.53.1676142136082;
        Sat, 11 Feb 2023 11:02:16 -0800 (PST)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id b9-20020a639309000000b004fb5f4bf585sm2959080pge.78.2023.02.11.11.02.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 11:02:15 -0800 (PST)
Message-ID: <1d5c317b-81a2-6ddf-7641-cbe325688c51@gmail.com>
Date:   Sun, 12 Feb 2023 04:02:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] crypto: x86/aria-avx - fix using avx2 instructions
Content-Language: en-US
To:     Samuel Neves <sneves@dei.uc.pt>
Cc:     linux-crypto@vger.kernel.org, x86@kernel.org
References: <20230210181541.2895144-1-ap420073@gmail.com>
 <CAEX_ruFsUzDheaa0GMSeoauFMnymU9kcN1r0MZR3Mai1vrRS9g@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <CAEX_ruFsUzDheaa0GMSeoauFMnymU9kcN1r0MZR3Mai1vrRS9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/11/23 06:18, Samuel Neves wrote:

Hi Samuel,
Thank you so much for the review!

 > On Fri, Feb 10, 2023 at 6:18 PM Taehee Yoo <ap420073@gmail.com> wrote:
 >>
 >> Also, vpbroadcastd is simply replaced by vmovdqa in it.
 >>
 >>   #ifdef CONFIG_AS_GFNI
 >>   #define aria_sbox_8way_gfni(x0, x1, x2, x3,            \
 >>                              x4, x5, x6, x7,             \
 >>                              t0, t1, t2, t3,             \
 >>                              t4, t5, t6, t7)             \
 >> -       vpbroadcastq .Ltf_s2_bitmatrix, t0;             \
 >> -       vpbroadcastq .Ltf_inv_bitmatrix, t1;            \
 >> -       vpbroadcastq .Ltf_id_bitmatrix, t2;             \
 >> -       vpbroadcastq .Ltf_aff_bitmatrix, t3;            \
 >> -       vpbroadcastq .Ltf_x2_bitmatrix, t4;             \
 >> +       vmovdqa .Ltf_s2_bitmatrix, t0;                  \
 >> +       vmovdqa .Ltf_inv_bitmatrix, t1;                 \
 >> +       vmovdqa .Ltf_id_bitmatrix, t2;                  \
 >> +       vmovdqa .Ltf_aff_bitmatrix, t3;                 \
 >> +       vmovdqa .Ltf_x2_bitmatrix, t4;                  \
 >
 > You can use vmovddup to replicate the behavior of vpbroadcastq for xmm
 > registers. It's as fast as a movdqa and does not require increasing
 > the data fields to be 16 bytes.

Thanks for this suggestion!
I tested this driver using vmovddup instead of using vpbroadcastq, it 
works well.
As you mentioned, vmovddup doesn't require 16byte data.
So, I will use vmovddup instruction instead of vpbroadcastq instruction.

I will send the v2 patch for it.

Thank you so much,
Taehee Yoo
