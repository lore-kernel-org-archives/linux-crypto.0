Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42113C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 06:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0824721873
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 06:48:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Sth9rGRd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfCVGs2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 02:48:28 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:37961 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfCVGs2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 02:48:28 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2019 02:48:28 EDT
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id fdece72c;
        Fri, 22 Mar 2019 06:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=azs2OUP40jtKNVU9vC1hvkHXt6A=; b=Sth9rG
        RdsrXINSsQl6qaXe/kzn9F+HDQYW1TIQfNnnQGSuzwcCykSUpYbm2ki3ssXTOtWc
        X1fgrf8N11mIw0mzwLgEWG6iN+0LhH+pBfu7PGfbdxZF7E6IXTAfPw0I4HLMoKvX
        5BVq88rEI7i0dbI9SPu9KuRnZGf/L0IGox3dg+i4SKRf2I5vxE5u6iuF2GI11SiW
        TcrQze+H50a5hBm2qVTPs925nrdiJ5xYXYV5HH4NKXsoQ0Vu73LmQPtMDLe8AYzB
        SzfM2Pjr3jaUOM7+z8XQO1k9qPDB6jTXteuFFHeCSiS2DKF3TyiXPsstXTAzzQKF
        liCtzpJo79Buw3yQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5de66ee3 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 22 Mar 2019 06:20:03 +0000 (UTC)
Received: by mail-ot1-f47.google.com with SMTP id c18so987819otl.13;
        Thu, 21 Mar 2019 23:41:46 -0700 (PDT)
X-Gm-Message-State: APjAAAXe2/tVZyvwsOcHTF8PGo651X5eeLMtn7VXY7lvyS5s60tHd/0M
        a8e/OMAtJG8KNTZOeXTu2DnVO1rp5iMICP4NFZY=
X-Google-Smtp-Source: APXvYqxnzhpysOmmG3+N9H6q6guC/JMj4SI/UKjCvMhjYykkR/+H1ziKA1NcHiTiEN4FEpXRYhVwCUUJbBIOrF5iJhs=
X-Received: by 2002:a9d:5501:: with SMTP id l1mr5528653oth.143.1553236905497;
 Thu, 21 Mar 2019 23:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190322062740.nrwfx2rvmt7lzotj@gondor.apana.org.au>
In-Reply-To: <20190322062740.nrwfx2rvmt7lzotj@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 22 Mar 2019 00:41:34 -0600
X-Gmail-Original-Message-ID: <CAHmME9qSNp+T3NcL0a7xCZGn9pronRquyu=MYDN4cjd2ELFB7w@mail.gmail.com>
Message-ID: <CAHmME9qSNp+T3NcL0a7xCZGn9pronRquyu=MYDN4cjd2ELFB7w@mail.gmail.com>
Subject: Re: [PATCH 0/17] Add zinc using existing algorithm implementations
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
        Martin Willi <martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Herbert,

On Fri, Mar 22, 2019 at 12:34 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> This should allow the wireguard code itself to proceed.  At the
> same time we can also move forward with replacing the existing
> implementations of chacha20 and/or poly1305 where appropriate.

I'll have a long flight tomorrow to review this, but also, I should
have v9 of the patchset submitted soon, which will address a lot of
the good issues people brought up several months ago for v8. So please
sit tight while I prepare that.

Jason
