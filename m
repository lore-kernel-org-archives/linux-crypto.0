Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D01CDC4338F
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Aug 2021 03:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ECE761250
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Aug 2021 03:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhHVDtY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Aug 2021 23:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbhHVDtW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Aug 2021 23:49:22 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A34C061575;
        Sat, 21 Aug 2021 20:48:36 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n12so8225754plf.4;
        Sat, 21 Aug 2021 20:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AM5YpUjTpEeHgm+rJvNpvLk076ooqk9uZkEnJohDtb4=;
        b=ZI6BLhg6OvoEyQf76+E49qzmwSdfLQO5faYQA8H1J5am8p1U3/Ir4stV3mFrO4fhng
         D5B0bbEpWLf9tpuai8sdLvv7QaCdpkugkwzm/enJiqT3tb5ethSjsJ1GW79kFJOkdLZd
         fLNwdKkBFxmIZBKfb2o5E9fI5/wDgFyQK4ukW32zHW+Zo/e4zzS3WyZSpwVqagn3IBv2
         5abHlw80X260aBcv0HnoN0peKR6bUOrYmabr1MSljorKnRLDV06Kl5ztrG4NXvuMSTL6
         jJ/pWp1ozXFT+1q6LkvgAWE+Hag2YktA7oDeqkoxhNGlH/75go+GqLVrVLv6Rs3U0bOY
         Mf8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AM5YpUjTpEeHgm+rJvNpvLk076ooqk9uZkEnJohDtb4=;
        b=Nc8xkA0ivLHUa95O1wYahV0svGva31j3mCqlRmcM13EpRGW/XnKYvbYrY8RUVaNFCl
         6GGHSc0ujF3BUebxBthQvbdzkyutes1E4TS/SXhm7rSoZmADObSZ9RaK0f+uAld99JrQ
         x6HGEFnsXtU0Lx/P8Ij3smPp3Pcy8xz3VgUxM4zgh222l29RSuzaa9J5VomO6wdeZU0j
         uB6zZiRJPTlxBUamFjXR2EFuLloPJMibKoy+uYzoi6IPwaNOReDLihosSMOkRio1Gm//
         zRd9Bsgg1NxaY7H80ryo7xleZjcDgGG3czSz8eLFLfRdTn6sZ1SD9bhBxxS5Rjp6D6z+
         X3JQ==
X-Gm-Message-State: AOAM533+02jrZN3dDurtfnq2AU3Y9nPK4+q1II//INeVptofXzp4PAtM
        BO6y08KJebcZPhJzmAClHPw=
X-Google-Smtp-Source: ABdhPJw06kvguYxYsSgkBtFCK7TZAge59CD1QHXq4Pvb9Y946Fq6fjdCxeD5Uer2AYRuq0VvB1A1Ow==
X-Received: by 2002:a17:902:9a03:b029:12d:72e2:f7a1 with SMTP id v3-20020a1709029a03b029012d72e2f7a1mr22588876plp.49.1629604116020;
        Sat, 21 Aug 2021 20:48:36 -0700 (PDT)
Received: from fedora ([2405:201:6008:6ce2:9fb0:9db:90a4:39e2])
        by smtp.gmail.com with ESMTPSA id y67sm11882425pfg.218.2021.08.21.20.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 20:48:35 -0700 (PDT)
Date:   Sun, 22 Aug 2021 09:18:29 +0530
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
Subject: Re: [PATCH] crypto: xts_crypt() return if walk.nbytes is 0
Message-ID: <YSHJDQRE7G+eOnum@fedora>
References: <YQ0Qm+Xs1g/7Eant@fedora>
 <20210809141027.860850-1-chouhan.shreyansh630@gmail.com>
 <20210820083111.GA28484@gondor.apana.org.au>
 <CAMj1kXGMPimX0_dR_kLuzZjuJK9rM=uCpRDtoJq0UjWq12M10A@mail.gmail.com>
 <20210820125315.GB28484@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820125315.GB28484@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Thank you Ard and Herebrt for your reviews. I have sent an updated
patch. Sorry for the delay.

Regards,
Shreyansh
