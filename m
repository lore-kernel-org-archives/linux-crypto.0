Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FB7C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Apr 2022 16:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354147AbiDOQXX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Apr 2022 12:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbiDOQXX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Apr 2022 12:23:23 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668DB9E9EA
        for <linux-crypto@vger.kernel.org>; Fri, 15 Apr 2022 09:20:54 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id y32so14708168lfa.6
        for <linux-crypto@vger.kernel.org>; Fri, 15 Apr 2022 09:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rBexj3eQsZ3wqG1HL5nZa5jhi+e1ylFf5sIYb7x7L1I=;
        b=lyJP4p0/jTYul0L7lAjkhp1x44jUqCwvtCr08WvTa6Wqh6aKOdBE87Mfec1WJaP2uE
         4Dq4pu8IkavHpAxUT6GKabeIGzkQqgVuAIlfyToWC7pWqLSXwj2hE888qZJJu1Q3DAjN
         drPpFeFdvPi+4WmjvdD1BhjcgY+QaPsGSWhbIY1E+55M10pBPjDuH3w/p6j4/4X5wbeo
         G2u3zFHxaL/HxCuWzoiatweF31uhkMLF0xo2JrwPEPmdMiyIC6iB8C9jmBwRyoXaRB1H
         yoQR8IpsNm7npG5MUVn0g/jn9UhMb2yhQF6shscDSV0nKbJF/GnJQbk4bUOFo234pkR0
         wcgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rBexj3eQsZ3wqG1HL5nZa5jhi+e1ylFf5sIYb7x7L1I=;
        b=5H9cX77QmmHJCqJI9b9Q2Eh1c2nite87vs1sQ8TWQZ38Hhw7qZ4+nyHdDKVwzfNVnF
         +VW/aN4WgU7+7esBFaG3v7X5XAnOL1h8IejeQ67glkIm4X90whs2Yg8eVqn1a2XLf9mE
         bFtogeETogO1qKp/KRIih2vJ9TH2comgoVoEZHheapHPtb8DEC/Vz0GLrc4sc2p4603r
         YcCFovi679C7EL5Z1Hpnf7MAD7qgbjiTUBop3kAXlpnOeT8ufZLTPtHb8YUoiuw7opjF
         jZJQABgxH3w90XmzVQLDCawD5Tjse9dOOE/ahwcFQmZUx/EmwitpvYJV5JK+aHzB7WBd
         nhdw==
X-Gm-Message-State: AOAM530l5OvW/AXOepOM7p3MNJd3sn31COq063X6a6KdlO3BKv2FmdvW
        NJD+5glaZ5uMxcI0Z/42ZAes9hw3rYo7A6JNK2T8xQ==
X-Google-Smtp-Source: ABdhPJyrpFklWSsc8st0wbc04Hdn0wEal7J3pt97tatylqke3ynq/jSAqqktjaRPn62ybtQahD24pOa4QhxwQAYgQw8=
X-Received: by 2002:a05:6512:687:b0:46b:8d08:36da with SMTP id
 t7-20020a056512068700b0046b8d0836damr5435405lfe.402.1650039652290; Fri, 15
 Apr 2022 09:20:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220414162325.1830014-1-jackyli@google.com> <fe209f25-6119-cc26-2608-8aaccf11ac36@amd.com>
In-Reply-To: <fe209f25-6119-cc26-2608-8aaccf11ac36@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 15 Apr 2022 10:20:40 -0600
Message-ID: <CAMkAt6pyDQaqLCRzJWow6hgtyMrAtarPri9yUWBgMPPuucm77A@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: ccp - Fix the INIT_EX data file open failure
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Jacky Li <jackyli@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Orr <marcorr@google.com>, Alper Gun <alpergun@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 15, 2022 at 7:49 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 4/14/22 11:23, Jacky Li wrote:
> > There are 2 common cases when INIT_EX data file might not be
> > opened successfully and fail the sev initialization:
> >
> > 1. In user namespaces, normal user tasks (e.g. VMM) can change their
> >     current->fs->root to point to arbitrary directories. While
> >     init_ex_path is provided as a module param related to root file
> >     system. Solution: use the root directory of init_task to avoid
> >     accessing the wrong file.
> >
> > 2. Normal user tasks (e.g. VMM) don't have the privilege to access
> >     the INIT_EX data file. Solution: open the file as root and
> >     restore permissions immediately.
> >
> > Fixes: 3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support")
> > Signed-off-by: Jacky Li <jackyli@google.com>
> > Reviewed-by: Peter Gonda <pgonda@google.com>
>
> Looks good, just a quick question. Should there be any type of access
> checks before switching credentials? Should we check access to /dev/sev or
> such? Or is the capability to load the module enough?

I thought this was fine because regardless of if an admin sets
psp_init_on_probe=true or false, their intention is that people who
have rw access to /dev/sev can use the commands which require the PSP
to be init. In the case of psp_init_on_probe=false only rw users can
cause the file to be created. The case of psp_init_on_probe=true seems
a little less clear to me but if a user can modprobe ccp that seems
like sufficient privilege to create the file. What do you think, Tom?
