Return-Path: <SRS0=kcel=DP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2A3C433E7
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Oct 2020 06:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13F732184D
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Oct 2020 06:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vZCCwXT8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgJHGg2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Oct 2020 02:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgJHGg2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Oct 2020 02:36:28 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59B1C061755;
        Wed,  7 Oct 2020 23:36:27 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l11so5190513wmh.2;
        Wed, 07 Oct 2020 23:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IBRbeWKDJRldULV0/PLeknMFH5O6Eh3yednDqQnM9vY=;
        b=vZCCwXT8Xqm41H5jMNICGm61BoycUAX2GktRhlUz/TFG+4wOSgBL+I0v3u77rTM4WL
         bYSmzmY9VRP5L30+EYIp40qpmngbiNsAOmqm4ojBBcvG428zxGsFkPdxNELhwWqEZlgn
         54iimffXyU0Z2OWqAxKjOPvNwQ+bZDd+ItQTaCuq7PUflw4nqYqoiSii/ifXodaQ4EJK
         J9Xn3HYGeZUlD6MOjS+awbtr4RwUYf2Mv4zdGeMP8sNRplIQg9kQEPRWA0MAuCEblFg6
         THJcJ1AEA0EwUn0MNM+TjobkgqOT2a/fv0p6xqgLFB6CvbAniQdWZtOR4MfnksQwfhrR
         +xMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IBRbeWKDJRldULV0/PLeknMFH5O6Eh3yednDqQnM9vY=;
        b=POAHdb5PAKSf5jPMmO/MKeyNV/qsEjPzNKchD//nyOa1vh2ZTwRAipGO3KoUwnjvDZ
         s4ccBMkaiDKdbQdvb/Pauwt7HnKpI7vfAmAnqQA+2Eq9VlVle0d+xUWpX5VVPMfmbkNV
         tdS7iXWD4SKksY6Ws3grjGmt8fG81EIOm4GeJxlU7nUvNmAzuhKUIZuBk9zYmoDGMci3
         lhtAd6XpbVwg2ihhlW/NRP3y9Q1Qwd21KAek3fMjYivVFcJWImbWjupEZRBE7TH/ayjv
         ydMlr70CCjzmJWFD/+cIRkZFbqX9AvDKC6bSHR6noBYGxDMXMvfUIAkGACFfs9aOXsO3
         doIA==
X-Gm-Message-State: AOAM531bvsK8iBleR61Ju+NQOC8RPXu9BUln1Bu6sdF8C2xQ33K5ypni
        lRnFdwYRU7S977rZ5t6MA8UPemGED6c=
X-Google-Smtp-Source: ABdhPJzMoxWNIMLAYr5QmRECiDBuQKbrhPzLftRz1wDgk05hMA1m4Nf/YXHp+oxVZ8lAc/jETOpw9g==
X-Received: by 2002:a7b:c3d0:: with SMTP id t16mr6910479wmj.169.1602138986586;
        Wed, 07 Oct 2020 23:36:26 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id d23sm5397303wmb.6.2020.10.07.23.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 23:36:25 -0700 (PDT)
Date:   Thu, 8 Oct 2020 08:36:23 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [v2 PATCH] crypto: sun4i-ss - Fix sparse endianness markers
Message-ID: <20201008063623.GA17802@Red>
References: <202009061621.J89kO43Q%lkp@intel.com>
 <20200907062400.GA15841@gondor.apana.org.au>
 <20200907160029.GC11894@Red>
 <20200908050036.GA19817@gondor.apana.org.au>
 <20200910122248.GA22506@Red>
 <20200911041354.GA5275@gondor.apana.org.au>
 <20200914104058.GA14265@Red>
 <20200924030859.GA8223@gondor.apana.org.au>
 <20200924132738.GA24386@Red>
 <20201008055238.GA9813@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008055238.GA9813@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 08, 2020 at 04:52:38PM +1100, Herbert Xu wrote:
> On Thu, Sep 24, 2020 at 03:27:38PM +0200, Corentin Labbe wrote:
> >
> > This is an example on next-20200923+BigEndian
> > alg: ahash: sha1 test failed (wrong result) on test vector \"random: psize=194 ksize=0\", cfg=\"random: inplace may_sleep use_finup src_divs=[98.25%@+1124, <flush>1.75%@+5] iv_offset=18\"
> 
> Hmm, the only way I can see this happening is if it was triggered
> by tcrypt.  Were you using tcrypt by any chance?
> 
> Ccing Eric in case he has any insight.
> 
> > === DUMP /proc/crypto ===
> > name         : sha1
> > driver       : sha1-sun4i-ss
> > module       : kernel
> > priority     : 300
> > refcnt       : 1
> > selftest     : passed
> > internal     : no
> > type         : ahash
> > async        : no
> > blocksize    : 64
> > digestsize   : 20
> 
> ...
> 
> > name         : sha1
> > driver       : sha1-generic
> > module       : kernel
> > priority     : 100
> > refcnt       : 1
> > selftest     : passed
> > internal     : no
> > type         : shash
> > blocksize    : 64
> > digestsize   : 20
> 
> Thanks,

Yes I use tcrypt to force all algos to be tested.
