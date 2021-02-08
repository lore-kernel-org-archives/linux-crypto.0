Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4F1C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 06:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3601864E6D
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 06:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBHGsr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 01:48:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229993AbhBHGsh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 01:48:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 978EC64E6D;
        Mon,  8 Feb 2021 06:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612766876;
        bh=kQATBibazqnNCmN8dcGfS5T7v+WBIVLbjyFvnpYwQdw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gw3TI3PNLQk1cQ1dyOFGagIq18ghucI70xiSo1HbNnnErndBFGRhpvtMk5F9Ly706
         BBZEwwpa2Mjp9IHfa3DZ/sERUtmK0/AnxleiecIvx5RTvVdQ/5buOkvCpYWtl9wwd4
         0M03oJ/rnDMZeLoqZKF0TQOGHdyMdYjjDaFUocMGY0y1MSltRF/7gowQ58rHI1I1vB
         kowLUUZVziqA6UH4D8nUHCb7JOqeK1T3BnIxWsbobj6h+RnTxzx0cgredyFfzVRtcj
         YwkEAJs/C9XI7q6fObvL64+cpchOXXfY1GyXIPRLU7sXI1Z1o+g6t/whepXKtGslEr
         nOikoYmfawLIA==
Received: by mail-oi1-f174.google.com with SMTP id l3so4626587oii.2;
        Sun, 07 Feb 2021 22:47:56 -0800 (PST)
X-Gm-Message-State: AOAM531mVo5NQ8Un6W5db3AMEuJWlgk6ZnfM1jjKGiYLEMqvHMMdYZp+
        3/JMs0fUQqAm02ndt+x1l6K5AD/SQT4vfb8e9ts=
X-Google-Smtp-Source: ABdhPJwwWUwurEJrYiXDO0EfWR7tpo3sJbLcMU1kqQtlGqZShcPpn3vAYzW1vE2iX8YDEg8UTyOBTiY+rg9WRtP1Vcg=
X-Received: by 2002:aca:b6c1:: with SMTP id g184mr10460313oif.47.1612766875935;
 Sun, 07 Feb 2021 22:47:55 -0800 (PST)
MIME-Version: 1.0
References: <1611299395-675-1-git-send-email-yumeng18@huawei.com>
 <1611299395-675-5-git-send-email-yumeng18@huawei.com> <20210128050354.GA30874@gondor.apana.org.au>
 <CAMj1kXHvY9JveFyhtETALCH=AFGMGVbGGFMNDGc6ZVngEKbyDQ@mail.gmail.com>
 <ff63fffd-2d65-337f-d802-adcf4352fdc3@linux.ibm.com> <20210129030004.GA3463@gondor.apana.org.au>
 <20210208063541.ribifj3445djxfy5@altlinux.org>
In-Reply-To: <20210208063541.ribifj3445djxfy5@altlinux.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 8 Feb 2021 07:47:44 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF18T11WQm6coYOO8yD7g=AxSBDP1QjWghWRVAp6dCJ8w@mail.gmail.com>
Message-ID: <CAMj1kXF18T11WQm6coYOO8yD7g=AxSBDP1QjWghWRVAp6dCJ8w@mail.gmail.com>
Subject: Re: [PATCH v7 4/7] crypto: add ecc curve and expose them
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Meng Yu <yumeng18@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Zaibo Xu <xuzaibo@huawei.com>, wangzhou1@hisilicon.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        Patrick Uiterwijk <patrick@puiterwijk.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 8 Feb 2021 at 07:37, Vitaly Chikunov <vt@altlinux.org> wrote:
>
> Herbert,
>
> On Fri, Jan 29, 2021 at 02:00:04PM +1100, Herbert Xu wrote:
> > On Thu, Jan 28, 2021 at 09:49:41PM -0500, Stefan Berger wrote:
> > >
> > > In my patch series I initially had registered the akciphers under the names
> > > ecc-nist-p192 and ecc-nist-p256 but now, in V4, joined them together as
> > > 'ecdsa'. This may be too generic for a name. Maybe it should be called
> > > ecsda-nist for the NIST family.
> >
> > What I'm proposing is specifying the curve in the name as well, i.e.,
> > ecdsa-nist-p192 instead of just ecdsa or ecdsa-nist.
> >
> > This simplifies the task of handling hardware that only supports a
> > subset of curves.
>
> So, if some implementation supports multiple curves (like EC-RDSA
> currently supports 5 curves), it should add 5 ecrdsa-{a,b,c,..}
> algorithms with actually the same top level implementation?
> Right?
>

Yes. The only difference will be the init() function, which can be
used to set the TFM properties that define which curve is being used.
The other routines can be generic, and refer to those properties if
the behavior is curve-specific.


>
> > There is a parallel discussion of exactly what curves we should
> > support in the kernel.  Personally if there is a user in the kernel
> > for it then I'm happy to see it added.  In your specific case, as
> > long as your use of the algorithm in x509 is accepted then I don't
> > have any problems with adding support in the Crypto API.
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
