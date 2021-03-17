Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F7EC4332E
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 08:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED4DE64F92
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 08:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCQIQo convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:16:44 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:55734 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhCQIQc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Mar 2021 04:16:32 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2021 04:16:31 EDT
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 5F4FA606BA2E;
        Wed, 17 Mar 2021 09:07:40 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id T_Cb4WtbWj7S; Wed, 17 Mar 2021 09:07:40 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 011536083276;
        Wed, 17 Mar 2021 09:07:40 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TzdXatnevOaW; Wed, 17 Mar 2021 09:07:39 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id C14006083275;
        Wed, 17 Mar 2021 09:07:39 +0100 (CET)
Date:   Wed, 17 Mar 2021 09:07:39 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        kernel <kernel@pengutronix.de>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        horia geanta <horia.geanta@nxp.com>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, Udit Agarwal <udit.agarwal@nxp.com>,
        david <david@sigma-star.at>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>, jlu@pengutronix.de
Message-ID: <146776265.87663.1615968459694.JavaMail.zimbra@nod.at>
In-Reply-To: <CAFA6WYNyMzQJNhGds2Ff9waF6mAr_0E-izXA2GBooTJgVDp-3A@mail.gmail.com>
References: <cover.56fff82362af6228372ea82e6bd7e586e23f0966.1615914058.git-series.a.fatoum@pengutronix.de> <319e558e1bd19b80ad6447c167a2c3942bdafea2.1615914058.git-series.a.fatoum@pengutronix.de> <CAFLxGvxmRcvkweGSRSLGEm5MJDM4M7nzkp9FwOwmhZ+h2RE0vA@mail.gmail.com> <CAFA6WYNyMzQJNhGds2Ff9waF6mAr_0E-izXA2GBooTJgVDp-3A@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] KEYS: trusted: Introduce support for NXP
 CAAM-based trusted keys
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF78 (Linux)/8.8.12_GA_3809)
Thread-Topic: KEYS: trusted: Introduce support for NXP CAAM-based trusted keys
Thread-Index: +kVXho70mMifuE7sQWVE/TJ8Awdc7A==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Sumit,

----- Ursprüngliche Mail -----
>> >  module_param_named(source, trusted_key_source, charp, 0);
>> > -MODULE_PARM_DESC(source, "Select trusted keys source (tpm or tee)");
>> > +MODULE_PARM_DESC(source, "Select trusted keys source (tpm, tee or caam)");
>>
>> I didn't closely follow the previous discussions, but is a module
>> parameter really the right approach?
>> Is there also a way to set it via something like device tree?
>>
> 
> It's there to support a platform which possesses multiple trusted keys
> backends. So that a user is able to select during boot which one to
> use as a backend.

I understand the use case, my question was whether it makes actually sense to
have a module parameter for it, or additionally another way to define the
preferred backend.

Thanks,
//richard
