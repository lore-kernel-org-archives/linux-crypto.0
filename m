Return-Path: <SRS0=xeh7=RU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85006C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Mar 2019 06:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DE082148D
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Mar 2019 06:06:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="CfuMZL96"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfCQGG6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Mar 2019 02:06:58 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:40727 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfCQGG6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Mar 2019 02:06:58 -0400
Received: by mail-vs1-f67.google.com with SMTP id z18so7674927vso.7
        for <linux-crypto@vger.kernel.org>; Sat, 16 Mar 2019 23:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HfE+rjyzdDhxR0cAYbGu1CqFpdkP6z604SA1D/opXnY=;
        b=CfuMZL96GHOtg+wbLz3K6Be5Zm+2FSvuJpbkbn3lZjQWOwfxT3xatqRBP9BcxZr10w
         m0DpZuCf2mTCcZzpUxOYhFMjErDkRWRNlHRShjwadkbRsTeMY3uw4+A9TiWUpzRxl2Jx
         Uzr5j2kXdKLPmNAS9u+YXEdCaph8xyPkkUkmNSMvg4TX09kfgwR1DZUUCTNeMChBaOlw
         0nlBHTS+rtcycpbgQOEdJqMITjUWMIva1Qnj0ma2fmw9R7OvUEohku4O3tLACDUkKWpd
         JgV3VLUSB4Gj712xcQcqLRtK2EKLMD41lNQkNxcNhQ4a3HNovdXfc+deo/D33Gi/DlVW
         tN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HfE+rjyzdDhxR0cAYbGu1CqFpdkP6z604SA1D/opXnY=;
        b=IdHodLrAFbMOWmLh7nekOtMdP+t5R1p2TruuyVKFgVEMhixs8fRofO4Vyksz/JZXxF
         FMvMiQ8lheYg6Vu23hJUxdCAoi3T/A8X60uHR4E9Gw386HHpqOJEarUctHia3tZ2dXh4
         /PuNPd9OphD/HYrZUionWJSEXiS7NUH/9cUz8V53vOOkJ7BjhlrG0ke195nPcPaG840i
         uFfiZ8O3W58bxmVFw5vh//rjGZEj2exg5FfzVOASHwcD1ZIICOrH1IS+2iEoKkQharVR
         Pbtd4bYBEAtk+Yue3jADIVwzPhByP88cv7aI3Mxfo1UZdyYJt2LtxadcNEFANXdyWqjq
         fxNw==
X-Gm-Message-State: APjAAAUpnwHUBnHr1EtmiQEIbK9ilN3uwy9QEsoXupMNb+LqVL7HAoxb
        3//m9LWizvRbSVxoRhy5sIA4S4ozN8V5p+cjjohEfQ==
X-Google-Smtp-Source: APXvYqxPvLTF/mJd1znrWaUmxv4Mlj3gAdNw+tDEQf2SSi+wJhpSbjZ7MshLDe2/0gqGX3GFCdZ5bvFuHh2B4kMaCWo=
X-Received: by 2002:a67:f8cc:: with SMTP id c12mr5983786vsp.136.1552802816812;
 Sat, 16 Mar 2019 23:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190314090951.840339-1-arnd@arndb.de>
In-Reply-To: <20190314090951.840339-1-arnd@arndb.de>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 17 Mar 2019 08:06:44 +0200
Message-ID: <CAOtvUMeGsk8zuX_0QP7G_JXP_iuWh=ytKPDmaPvdhUKQDqTLRw@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccree - reduce kernel stack usage with clang
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 14, 2019 at 11:10 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Building with clang for a 32-bit architecture runs over the stack
> frame limit in the setkey function:
>
> drivers/crypto/ccree/cc_cipher.c:318:12: error: stack frame size of 1152 =
bytes in function 'cc_cipher_setkey' [-Werror,-Wframe-larger-than=3D]
>
> The problem is that there are two large variables: the temporary
> 'tmp' array and the SHASH_DESC_ON_STACK() declaration. Moving
> the first into the block in which it is used reduces the
> total frame size to 768 bytes, which seems more reasonable
> and is under the warning limit.
>

Thank you , Ard.

I will also revisit splitting that function to further reduce stack
usage after I finish tackling the fallout of the new testmgr... :-)

Acked-By: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad
--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
