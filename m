Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BA8C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF488214C6
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VxyADs6U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfHIRt1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 13:49:27 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:43687 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfHIRt1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 13:49:27 -0400
Received: by mail-wr1-f54.google.com with SMTP id p13so24409722wru.10
        for <linux-crypto@vger.kernel.org>; Fri, 09 Aug 2019 10:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gPwm+r5WNS1IOxztbTU9nvDsGGWOUrwXuVfZcxKOapU=;
        b=VxyADs6UriQsKq84MWP+Ibx/F2XohR2o48Y/suR3NH22kPQFipGErhfNjeUPpqKBDl
         3h7qsCODSm/GvLEzUh/EdeRNgarW0ykAUFFV5glrPE5RU5KEEaXpgqXaiR3uxDMwbG1M
         C6ETbS0GnGRX872FElZmhRMVyvCcqpi3ZcsbV945anvS9tSxyjDNi1B7T6egbCRNFgHj
         SWaxE7xYgJZ3RLe5ieseNfxONleZ4jBtvv9DLARkT1gcsY53BGsGZiaXQC0Gc7goiNh4
         +Rcsm8ldF2PG9JrG6ckqCfxyZGm/PH3A6r9sP1/FlUKbAuJLhp+htWMZ71ZqRXhXdfxp
         CWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gPwm+r5WNS1IOxztbTU9nvDsGGWOUrwXuVfZcxKOapU=;
        b=uZab4jfvj7BwWcJcXMtCRJof0WXu7DV6kVVcY+UWzPGpm+NGv0OKP9nRekleTBETfd
         Zo5J7If93J9B5LgbIhlpHaQIv29MS42f7QnnPjkEtl7jIvif55TOWPstrMdpnsq+hB07
         RxRbGJAX9AFng3BMPL6KRHEqo1MfE1xwTZoCoK5dXoA9Dktirq6y3UceAOUXffx6p9sf
         Zyd3IuLgjDOeASze2jNSGSAWAEhjf6rgj5eQwTFu4/K7MDYnPwkDw4z8WMFl4d5HAX+Q
         TaIP7u3ZHyFoPH6TE43/MwZt0oj/M1wGLho2U8lFMbQdw80iwPvsOT+gtVhTeGfOD0VL
         xvVQ==
X-Gm-Message-State: APjAAAUJqhVL9BpaDyoXAVQN2zSK/6r4BT/LG1WVAcbIqwxVTbPOiyNB
        jTdVRnJy9HL+H7FpyfmxKKk4kJ70f7IzrHjNptoEyA==
X-Google-Smtp-Source: APXvYqyNsVff7t9wfsKx2DAt8Eagy8q0d67Jxnxp10Y0gV7LpZSL0gAy1sE0FDJziKN0JepQCO3sLlk1oza6NgzvGSc=
X-Received: by 2002:adf:aa09:: with SMTP id p9mr3597878wrd.174.1565372965031;
 Fri, 09 Aug 2019 10:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
 <MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
 <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
 <MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20f4832e-e3af-e3c2-d946-13bf8c367a60@nxp.com> <VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <MN2PR20MB2973127E4C159A8F5CFDD0C9CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB3485689B4B65C879BC1D137398D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190809024821.GA7186@gondor.apana.org.au> <CAKv+Gu9hk=PGpsAWWOU61VrA3mVQd10LudA1qg0LbiX7DG9RjA@mail.gmail.com>
 <VI1PR0402MB3485F94AECC495F133F6B3D798D60@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485F94AECC495F133F6B3D798D60@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 9 Aug 2019 20:49:13 +0300
Message-ID: <CAKv+Gu-_WObNm+ySXDWjhqe2YPzajX83MofuF-WKPSdLg5t4Ew@mail.gmail.com>
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Milan Broz <gmazyland@gmail.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 9 Aug 2019 at 10:44, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 8/9/2019 9:45 AM, Ard Biesheuvel wrote:
> > On Fri, 9 Aug 2019 at 05:48, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >>
> >> On Thu, Aug 08, 2019 at 06:01:49PM +0000, Horia Geanta wrote:
> >>>
> >>> -- >8 --
> >>>
> >>> Subject: [PATCH] crypto: testmgr - Add additional AES-XTS vectors for covering
> >>>  CTS (part II)
> >>
> >> Patchwork doesn't like it when you do this and it'll discard
> >> your patch.  To make it into patchwork you need to put the new
> >> Subject in the email headers.
> >>
> >
> > IMO, pretending that your XTS implementation is compliant by only
> I've never said that.
> Some parts are compliant, some are not.
>
> > providing test vectors with the last 8 bytes of IV cleared is not the
> > right fix for this issue. If you want to be compliant, you will need
> It's not a fix.
> It's adding test vectors which are not provided in the P1619 standard,
> where "data unit sequence number" is at most 5B.
>

Indeed. But I would prefer not to limit ourselves to 5 bytes of sector
numbers in the test vectors. However, we should obviously not add test
vectors that are known to cause breakages on hardware that works fine
in practice.

> > to provide a s/w fallback for these cases.
> >
> Yes, the plan is to:
>
> -add 16B IV support for caam versions supporting it - caam Era 9+,
> currently deployed in lx2160a and ls108a
>
> -remove current 8B IV support and add s/w fallback for affected caam versions
> I'd assume this could be done dynamically, i.e. depending on IV provided
> in the crypto request to use either the caam engine or s/w fallback.
>

Yes. If the IV received from the caller has bytes 8..15 cleared, you
use the limited XTS h/w implementation, otherwise you fall back to
xts(ecb-aes-caam..).
