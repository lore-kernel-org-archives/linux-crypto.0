Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84483C433B4
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 18:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61B7F60241
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 18:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbhDASNu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:13:50 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:41070 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbhDASGq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Apr 2021 14:06:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 4FD18606BA25;
        Thu,  1 Apr 2021 15:17:46 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id bJBE-i7eTNS0; Thu,  1 Apr 2021 15:17:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id D512A606BA2C;
        Thu,  1 Apr 2021 15:17:45 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tRm9oOfPG5bU; Thu,  1 Apr 2021 15:17:45 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 99E80606BA25;
        Thu,  1 Apr 2021 15:17:45 +0200 (CEST)
Date:   Thu, 1 Apr 2021 15:17:45 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        horia geanta <horia.geanta@nxp.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>,
        James Bottomley <jejb@linux.ibm.com>,
        kernel <kernel@pengutronix.de>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Udit Agarwal <udit.agarwal@nxp.com>,
        Jan Luebbe <j.luebbe@pengutronix.de>,
        david <david@sigma-star.at>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        "open list, ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Message-ID: <1666035815.140054.1617283065549.JavaMail.zimbra@nod.at>
In-Reply-To: <CAFA6WYO29o73nSg4ikU9cyaOr0kpaXFJpcGLGmFLgjKQWchcEg@mail.gmail.com>
References: <cover.56fff82362af6228372ea82e6bd7e586e23f0966.1615914058.git-series.a.fatoum@pengutronix.de> <CAFLxGvzWLje+_HFeb+hKNch4U1f5uypVUOuP=QrEPn_JNM+scg@mail.gmail.com> <ca2a7c17-3ed0-e52f-2e2f-c0f8bbe10323@pengutronix.de> <CAFLxGvwNomKOo3mQLMxYGDA8T8zN=Szpo2q5jrp4D1CaMHydWA@mail.gmail.com> <CAFA6WYO29o73nSg4ikU9cyaOr0kpaXFJpcGLGmFLgjKQWchcEg@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] KEYS: trusted: Introduce support for NXP
 CAAM-based trusted keys
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF78 (Linux)/8.8.12_GA_3809)
Thread-Topic: KEYS: trusted: Introduce support for NXP CAAM-based trusted keys
Thread-Index: b36oPlTcuCXRSzXZSqikRqY0W9mM2w==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Sumit,

----- Ursprüngliche Mail -----
> Von: "Sumit Garg" <sumit.garg@linaro.org>
> IIUC, this would require support for multiple trusted keys backends at
> runtime but currently the trusted keys subsystem only supports a
> single backend which is selected via kernel module parameter during
> boot.
> 
> So the trusted keys framework needs to evolve to support multiple
> trust sources at runtime but I would like to understand the use-cases
> first. IMO, selecting the best trust source available on a platform
> for trusted keys should be a one time operation, so why do we need to
> have other backends available at runtime as well?

I thought about devices with a TPM-Chip and CAAM.
IMHO allowing only one backend at the same time is a little over simplified. 

Thanks,
//richard
