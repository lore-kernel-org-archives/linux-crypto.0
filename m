Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3951C4361B
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 10:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A651E20684
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 10:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407332AbgLLJyb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Dec 2020 04:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:58838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407229AbgLLJy2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Dec 2020 04:54:28 -0500
X-Gm-Message-State: AOAM531XCqonceRNB/Rx9BFvM75SPj7eexNEcF3GKDZPXepzXuvOLaww
        NSR5sVMYO+8oiNz5z9ilGFckB0L+7Ta7gug7f1Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607765800;
        bh=nFGtZ/HFEHYfdCjnllpqPiKX/TmzW3TQgjTrncJ6pZQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=baf2PcFhvxCvZxtGrLwrC1ENdEdlbJEQdN/O/ORkF5uxhuXxsSgdSWBiwiSYYWc0B
         +WoGFHmw4W1eLQsfIs9dX4Cdts/iMIsnXEMgW9Gwby/VqRx+Fy/W6+RsLVnZzADy5q
         pHm4PzWAiagcz6l+XSxVZL6K/9+chAX1CRSsTfzlERK2YlY3ONuozS8uKKSOy7iN47
         qX2hQdYYKdfm5u3FD/ZXdYxIgy74pS4x2u3q75HPNSWR19q1BSqEzYrFt2T9llMynM
         MQC8IjWKoV8kwqgoL6WsX0fbKMRDzXSZ+lX8VP1HJ0LR+rymFCH+EF4O7lMNnrjwu6
         sNuHHyIwd7leA==
X-Google-Smtp-Source: ABdhPJyKp2IMSGtwQ8agGmA1yEbsCVDrgQU7NO2o4B7q4Q/kokew7wD2ltF2196c5GcLnIFERGdFU7WlhtQdY1o5Gyc=
X-Received: by 2002:a05:6830:10d2:: with SMTP id z18mr12824788oto.90.1607765799289;
 Sat, 12 Dec 2020 01:36:39 -0800 (PST)
MIME-Version: 1.0
References: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com> <X9Ov3RWDpUik7gXo@sol.localdomain>
In-Reply-To: <X9Ov3RWDpUik7gXo@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 12 Dec 2020 10:36:28 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEDjQG_my5FWVY+b7Q43-_waW74sZyBAPCkd7EEdku+Rw@mail.gmail.com>
Message-ID: <CAMj1kXEDjQG_my5FWVY+b7Q43-_waW74sZyBAPCkd7EEdku+Rw@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        TimGuo-oc@zhaoxin.com, CooperYan@zhaoxin.com,
        QiyuanWang@zhaoxin.com, HerryYang@zhaoxin.com,
        CobeChen@zhaoxin.com, SilviaZhao@zhaoxin.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 11 Dec 2020 at 20:07, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Dec 11, 2020 at 07:29:04PM +0800, Tony W Wang-oc wrote:
> > The driver crc32c-intel match CPUs supporting X86_FEATURE_XMM4_2.
> > On platforms with Zhaoxin CPUs supporting this X86 feature, When
> > crc32c-intel and crc32c-generic are both registered, system will
> > use crc32c-intel because its .cra_priority is greater than
> > crc32c-generic. This case expect to use crc32c-generic driver for
> > some Zhaoxin CPUs to get performance gain, So remove these Zhaoxin
> > CPUs support from crc32c-intel.
> >
> > Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
>
> Does this mean that the performance of the crc32c instruction on those CPUs is
> actually slower than a regular C implementation?  That's very weird.
>

This driver does not use CRC instructions, but carryless
multiplication and aggregation. So I suppose the pclmulqdq instruction
triggers some pathological performance limitation here.

That means the crct10dif driver probably needs the same treatment.
