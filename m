Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF4FC43600
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 17:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 345E860FE7
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 17:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhDARw6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236560AbhDARpc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Apr 2021 13:45:32 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0D6C08EC89
        for <linux-crypto@vger.kernel.org>; Thu,  1 Apr 2021 06:53:07 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id n138so2981763lfa.3
        for <linux-crypto@vger.kernel.org>; Thu, 01 Apr 2021 06:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c893QbRRmjQkEtB2posydTcKTgGrQP7cS/Yzjgewk74=;
        b=cU1/w+Ev6H6Wdyc50mYASof9MSjhUc9dkCpvuENGmyhJsVhMz+Ufq+lmVSgNIeVBeK
         PbFUfLm4E1xcJ9HZ5XaHZORsL4dXolTon/o7fchVX7AzcKhccS4cnyNCP9eYDwkh/tjY
         ObFY120/dvcpAvkUtDNcIeaJwwzWacVE1zgEio1J/pBBIaVkeDFrBTHmbkLbGmh8e/vy
         7Jw5fVPkwDcKBziVeobEki4jh0HUVxqz4PODne1uZb1s1d+Z+c1J8ELr++rl+vf5b6KS
         zS1VLh347XyLyD4Q/E6wnYQBFCViiNhC29iHIGiFl4tcSv9WSK5SmIy9d9L57/H4xDfk
         b0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c893QbRRmjQkEtB2posydTcKTgGrQP7cS/Yzjgewk74=;
        b=Vx0ZmejOcY2OBxCIWApBVQyBY3/79snb6dAgQLKGtGk3IZKoc7MBNXN4kstoHXsmXA
         P81dsto4muHY0werGQxtQdMxns4IOLGpXGUcO+7L6j4VudH8AobnmTA41hRJQjrbgPaJ
         2QoLLmOYR5xozw9fYHPZoBWD+Kkm4URmaeh8uKXMcyyn6EqouMj9NM67WeBmgriNQovJ
         aUPoZws3bfqH80NQyGLnqWA1ak6l1JcWzBX6evrz+QW6xaI3re9fh59WwfrEaR7vnsn0
         uB3phtNlRzTUllb336siHm08dpHJ62HzqW/xC69f5Q7EX3viCPV5nJwMhWwOLq+r6op3
         ouMw==
X-Gm-Message-State: AOAM533M+YzMgjKl7+G4qS2yxILSw1f80jAPypUaRxpvjoWPK+gn35MT
        3yjR2WwbQchUx4hfo8x+dFBFhDFjXMaSsYbKZOD80A==
X-Google-Smtp-Source: ABdhPJzf2Vf+J0kHLdivX0dvXkq4BlUU//tUmf8HMN2XU1LxE89EyoNOm2SAuZ5vFZYQrOuPdm9P3QNcmVEHVOzMvJw=
X-Received: by 2002:a05:6512:1084:: with SMTP id j4mr5525797lfg.194.1617285186182;
 Thu, 01 Apr 2021 06:53:06 -0700 (PDT)
MIME-Version: 1.0
References: <cover.56fff82362af6228372ea82e6bd7e586e23f0966.1615914058.git-series.a.fatoum@pengutronix.de>
 <CAFLxGvzWLje+_HFeb+hKNch4U1f5uypVUOuP=QrEPn_JNM+scg@mail.gmail.com>
 <ca2a7c17-3ed0-e52f-2e2f-c0f8bbe10323@pengutronix.de> <CAFLxGvwNomKOo3mQLMxYGDA8T8zN=Szpo2q5jrp4D1CaMHydWA@mail.gmail.com>
 <CAFA6WYO29o73nSg4ikU9cyaOr0kpaXFJpcGLGmFLgjKQWchcEg@mail.gmail.com>
 <1666035815.140054.1617283065549.JavaMail.zimbra@nod.at> <ea261e53-8f5d-ac52-f3b9-7f2db4532244@pengutronix.de>
In-Reply-To: <ea261e53-8f5d-ac52-f3b9-7f2db4532244@pengutronix.de>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 1 Apr 2021 19:22:54 +0530
Message-ID: <CAFA6WYODfsMTiCEyFA2aRGm+UQE0OTe-ui7mMSK-cqUR_YJFTA@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] KEYS: trusted: Introduce support for NXP
 CAAM-based trusted keys
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Richard Weinberger <richard@nod.at>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 1 Apr 2021 at 19:00, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>
> Hello Richard, Sumit,
>
> On 01.04.21 15:17, Richard Weinberger wrote:
> > Sumit,
> >
> > ----- Urspr=C3=BCngliche Mail -----
> >> Von: "Sumit Garg" <sumit.garg@linaro.org>
> >> IIUC, this would require support for multiple trusted keys backends at
> >> runtime but currently the trusted keys subsystem only supports a
> >> single backend which is selected via kernel module parameter during
> >> boot.
> >>
> >> So the trusted keys framework needs to evolve to support multiple
> >> trust sources at runtime but I would like to understand the use-cases
> >> first. IMO, selecting the best trust source available on a platform
> >> for trusted keys should be a one time operation, so why do we need to
> >> have other backends available at runtime as well?
> >
> > I thought about devices with a TPM-Chip and CAAM.

In this case why would one prefer to use CAAM when you have standards
compliant TPM-Chip which additionally offers sealing to specific PCR
(integrity measurement) values.

> > IMHO allowing only one backend at the same time is a little over simpli=
fied.
>
> It is, but I'd rather leave this until it's actually needed.
> What can be done now is adopting a format for the exported keys that woul=
d
> make this extension seamless in future.
>

+1

-Sumit

> Cheers,
> Ahmad
>
> --
> Pengutronix e.K.                           |                             =
|
> Steuerwalder Str. 21                       | http://www.pengutronix.de/  =
|
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    =
|
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 =
|
