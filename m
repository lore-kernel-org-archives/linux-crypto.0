Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65046C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31DB120C01
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X0Uu/sVL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfHIGpe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 02:45:34 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:50872 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfHIGpe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 02:45:34 -0400
Received: by mail-wm1-f48.google.com with SMTP id v15so4565388wml.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2019 23:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xWrqNOfYZno97GmIwxnWHgVlCFr0X1VJsoxi85baUTo=;
        b=X0Uu/sVLM7AiBoeSAQz06Q+O1BcakPsg/XX2ifKUaVBGO3WoDMNR00AgsQFNFTYbbu
         nUxj3MjfgJKTy5Zzd2UIaWhRY9+NirLAZa7FxvFTuR5DLypQHU8NFH9dDa1zuxlmafoK
         cr2Eic+jxIWFmolugf272FJXTW+qIS1o13v2ScrKLXhGniy6g5RYRsUcF5SyDh9/2RAo
         LbYkQ16jBCU7Rtpj+kV9nIscE4/vxAc9+zaCoX5a2HzHjIpMbGKtPxY8URU2lHsNHXYI
         n9G8/A+kRJmvJE2FlUPMjaRM4RenTEZPVoUsl9T76RNRraIqlVdlfxULY7z9JRvePnxu
         Bsiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xWrqNOfYZno97GmIwxnWHgVlCFr0X1VJsoxi85baUTo=;
        b=G7f3S1uDsxj9J0uWhk5eZ+iCy2yfSbN6eqvectdPBwjEmzxwOHDT8mPSUcrW4QyTMD
         vYAX37kQGwdvC9/1BRg/qR4+OJdviGKuSfzPH6Us8NqBszbQaGQptEPPx7+D449voFyg
         kRHnC+2H+jDB0j8jiSbxR7Xjk3aIEDzf5QoBCi+miiLWau2wB7/emR7tozcJUvD+jE4F
         671tdZQtQv//0MbWHBqA+ZBo937MqpqQn6qR9fW8NjNwrV3fuA4Y5cswfOmJlOF/8dl+
         D/YP1E7DMmy3IkiVvZJhRK9KoEzlSbXj7zOeUu08SbtSzQitFqLVE0JnBNn5An6WLXuQ
         +D0w==
X-Gm-Message-State: APjAAAWg59+tD9roq/yX90Ea2loQQmnup612TP221uAY99VItLQww5Iq
        KTqJIstgyFdXwBm9fmEJKghFl+2X9e7RYkfAa4cD7g==
X-Google-Smtp-Source: APXvYqwhVO8fbnBnY0DLUc3HNgpvV+kPSb8nQdK5soptUT7qkD6/zTG9rnfkBGfT2Eu46Z6ioGLlZc2f2EH3sKFf9w4=
X-Received: by 2002:a05:600c:20c1:: with SMTP id y1mr9047480wmm.10.1565333131720;
 Thu, 08 Aug 2019 23:45:31 -0700 (PDT)
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
 <20190809024821.GA7186@gondor.apana.org.au>
In-Reply-To: <20190809024821.GA7186@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 9 Aug 2019 09:45:20 +0300
Message-ID: <CAKv+Gu9hk=PGpsAWWOU61VrA3mVQd10LudA1qg0LbiX7DG9RjA@mail.gmail.com>
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Milan Broz <gmazyland@gmail.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 9 Aug 2019 at 05:48, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 08, 2019 at 06:01:49PM +0000, Horia Geanta wrote:
> >
> > -- >8 --
> >
> > Subject: [PATCH] crypto: testmgr - Add additional AES-XTS vectors for covering
> >  CTS (part II)
>
> Patchwork doesn't like it when you do this and it'll discard
> your patch.  To make it into patchwork you need to put the new
> Subject in the email headers.
>

IMO, pretending that your XTS implementation is compliant by only
providing test vectors with the last 8 bytes of IV cleared is not the
right fix for this issue. If you want to be compliant, you will need
to provide a s/w fallback for these cases.
