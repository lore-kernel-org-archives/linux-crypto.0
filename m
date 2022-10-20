Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD2C7C43219
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Oct 2022 19:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJTTYB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Oct 2022 15:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJTTX7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2022 15:23:59 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0374D20FB0E
        for <linux-crypto@vger.kernel.org>; Thu, 20 Oct 2022 12:23:56 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id d13so614339qko.5
        for <linux-crypto@vger.kernel.org>; Thu, 20 Oct 2022 12:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UXYBorl1dI3AKqx3xQmawJPVUjsdLNNAJw91kOBPSIk=;
        b=SQ8OK63PFQry61FWFejRq6pCAtpPieg4TVk5hrGs9yrj+h+2wqx1laUos+OOt2inze
         DxH8KYz/cFMdCorv+jYplUO9OBUoad0QYHCrDukFBDYQPBbyRbh85/wjBDyceg5Qn/Mw
         AY6c47hC4FlDCeYqXpsjlx5xcFXM2e8jCwRYjVjGrgARsDTjAxsyuPtQr8llfQEKnJg1
         X17NSzzxO60lqAYhBWrsrzqfsyp3nIWpLFhXkfq1bXrVeNlc6rHwsCfM0+veR6Lf7Tii
         ahBQKsXfUlV5kuc64s1qLlK24/w3Yz0Hj9ecP3Ukekz9WUV+Sr3+7HWIPNNvVSg5WPWS
         H9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UXYBorl1dI3AKqx3xQmawJPVUjsdLNNAJw91kOBPSIk=;
        b=5uSq/jm5Y0L8DXRJCaP7z7054k+pjxQwMQptaYrh9AiiEiErA84mxLFdJBqtjo2Ha2
         qK3xq95kmM6AQ1ia1/x0aE5S0mPmP3eN+lSwGrtkps3s6/4oRLQ/jVJWKjaoTh5BTr67
         ZfXEzajIiBFOhiYMqoi/TaMh1M1Nr8jajKI+BQKCbFv1mdel/yPuRSnXRhihGgumAIRr
         atfmy/n2BOEdFkbuxABB9K3QeA51FtcIO17eapE+9SpWFWq/x7dMp5V33gZfeBukRrnq
         HQA0rS45tRMhGKFJOKhhyeeNJK9Vu6Z62CaIl5x4DMftYJpUYVz3wmQ/m5tyhul9cdcj
         n/6Q==
X-Gm-Message-State: ACrzQf0ZJ+Vvng2yKrUIY4yl1dGaMeMa1YWTg1kTlw2dwjzyWHjiyGUv
        7cHBbjuqARzu2OeLoIyeZlSfhA==
X-Google-Smtp-Source: AMsMyM6/PxGqTil/yztlMG8oGxbBRTidnNsSg45nwoJJ8KtNHLjmGAlx/eEJkbzdVhzCbBBaGVTwmg==
X-Received: by 2002:a05:620a:1512:b0:6ee:b258:51f1 with SMTP id i18-20020a05620a151200b006eeb25851f1mr10701716qkk.716.1666293835335;
        Thu, 20 Oct 2022 12:23:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id ew5-20020a05622a514500b0039cc9d24843sm6594369qtb.66.2022.10.20.12.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 12:23:54 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1olb8z-00Ay3E-DR;
        Thu, 20 Oct 2022 16:23:53 -0300
Date:   Thu, 20 Oct 2022 16:23:53 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "gilad@benyossef.com" <gilad@benyossef.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "sumit.garg@linaro.org" <sumit.garg@linaro.org>,
        "david@sigma-star.at" <david@sigma-star.at>,
        "michael@walle.cc" <michael@walle.cc>,
        "john.ernberg@actia.se" <john.ernberg@actia.se>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "j.luebbe@pengutronix.de" <j.luebbe@pengutronix.de>,
        "richard@nod.at" <richard@nod.at>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        Sahil Malhotra <sahil.malhotra@nxp.com>,
        Kshitiz Varshney <kshitiz.varshney@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>
Subject: Re: [EXT] Re: [PATCH v0 3/8] crypto: hbk flags & info added to the
 tfm
Message-ID: <Y1GgSX+ZmOsxhB2N@ziepe.ca>
References: <20221006130837.17587-1-pankaj.gupta@nxp.com>
 <20221006130837.17587-4-pankaj.gupta@nxp.com>
 <Yz/OEwDtyTm+VH0p@gondor.apana.org.au>
 <DU2PR04MB8630CBBB8ABDC3768320C18195209@DU2PR04MB8630.eurprd04.prod.outlook.com>
 <Y0Q3JKnWSNIC4Xlu@zx2c4.com>
 <Y0UxY51KQoKCq59o@gondor.apana.org.au>
 <Y0XLqd/+C1sxq2G0@zx2c4.com>
 <Y0aDiLp7BztzwNez@gondor.apana.org.au>
 <Y0m2TU5k78I1AR+p@ziepe.ca>
 <Y1DN3SqEyFZd9i37@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1DN3SqEyFZd9i37@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 19, 2022 at 09:26:05PM -0700, Eric Biggers wrote:

> Are you referring to the support for hardware-wrapped inline crypto keys?  It
> isn't upstream yet, but my latest patchset is at
> https://lore.kernel.org/linux-fscrypt/20220927014718.125308-2-ebiggers@kernel.org/T/#u.
> There's also a version of it used by some Android devices already.  Out of
> curiosity, are you using it in an Android device, or have you adopted it in some
> other downstream?

Unrelated to Android, similar functionality, but slightly different
ultimate purpose. We are going to be sending a fscrypt patch series
for mlx5 and nvme soonish.

> > Yes, it would be nice to see a comprehensive understand on how HW
> > resident keys can be modeled in the keyring.
> 
> Note that the keyrings subsystem is not as useful as it might seem.  It sounds
> like something you want (you have keys, and there is a subsystem called
> "keyrings", so it should be used, right?), but often it isn't.  fscrypt has
> mostly moved away from using it, as it caused lots of problems.  I would caution
> against assuming that it needs to be part of any solution.

That sounds disappointing that we are now having parallel ways for the
admin to manipulate kernel owned keys.

Jason
