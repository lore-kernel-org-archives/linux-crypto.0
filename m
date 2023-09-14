Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCD7EDE99C
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 09:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbjINJcJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbjINJcI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 05:32:08 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E841BEF
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:32:04 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c1e780aa95so5249995ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694683924; x=1695288724; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DX+szOONGw3oPdGurZDyUJB73s9XYVYsx0LcmlQVVlc=;
        b=k6mcKWi5QbxQzKsdtSrI5eiOztjs3/g9MJfwtPhrP2QiwjdI3+WM+jrPfgY2YHdlNh
         7ysyC0ev9tCcf0f84I78fw7HL3AX6h7u1seo+EiKzhHHZgP2PtBVNHMPydMo3s418BDF
         SEq43s5vn9sUZGIh3rvNWUOssv7rvgrCwhT11NzI4uRK920JoAGN5XVeWSzB4TUC8x1m
         IXmXVVRKAcTLJZzPLUBcrMNXxnZBM4vC/ANtJoFEcWXcaNPephwniQFg69jFyl30/Ji6
         VpK02oAHb4PoR7Hi05FMKjTUUNrBl141cpfBKb5JzIVgMXjP9j8w0KhhyNmwzP1/3ot2
         CCuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694683924; x=1695288724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DX+szOONGw3oPdGurZDyUJB73s9XYVYsx0LcmlQVVlc=;
        b=D4GY9kewpxvLsQEpISSN3thwxfKW3rF+QPD7DlM7U0YmCEuutSbjetVlAQ9R1aQbaM
         ws2R2XR8mYTabkkRdFV2NUS8wBXFyDbizN+tsz3nNw26bBE4C9SdrEq4RDk1hPLUtKfJ
         qQjEi2vfPHKuSr3jtEw0w5/TT3FGew/CKQiTG77eYxKy/EJCpBc/QNX3GSYpEExJx5ry
         3+MpFQ9YIo7w8CBCIe4NfcXxkermMvAo9MPp2W2aUlF8Y0ifpkaQFmomVgwypFiiwTMJ
         Dt52U1KFHWJY4q5udg4LbeGRgP2XtuRbAkcBwHh5cM11UVWliJPxyRqwn+5akPPnnMGE
         DHMA==
X-Gm-Message-State: AOJu0Yx3HmRI3hbVHS0KXjbQ2iYCcCzwcL2vGcMRYYBIwFfPhCL893Q/
        m2241+loxZrQ3BuT2a0igVw=
X-Google-Smtp-Source: AGHT+IG5p/KerWeXpVljnyoNSI0eyQIg6u5RFSrwbdN4K607nrDLzTzG4fcRz2DCESzJuMq9oIwVIw==
X-Received: by 2002:a17:902:efca:b0:1b6:649b:92cc with SMTP id ja10-20020a170902efca00b001b6649b92ccmr3914919plb.69.1694683924034;
        Thu, 14 Sep 2023 02:32:04 -0700 (PDT)
Received: from gondor.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902694600b001b801044466sm1111088plt.114.2023.09.14.02.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 02:32:03 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
Date:   Thu, 14 Sep 2023 17:32:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 0/8] crypto: Add lskcipher API type
Message-ID: <ZQLTE2INDx0blFek@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <CAMj1kXHLZ8kZWL3npQRavdzjRtv_uiRKmKDeXaQhhy3m4LvK+w@mail.gmail.com>
 <ZQLK0injXi7K3X1b@gondor.apana.org.au>
 <CAMj1kXHvhrUyShdSNCJeOh8WVXFqPPu+KLh16V6fJJdQKhPv1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHvhrUyShdSNCJeOh8WVXFqPPu+KLh16V6fJJdQKhPv1A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 14, 2023 at 11:18:00AM +0200, Ard Biesheuvel wrote:
>
> > +static struct lskcipher_alg aes_alg = {
> > +       .co = {
> > +               .base.cra_name          =       "aes",
> 
> So this means that the base name will be aes, not ecb(aes), right?

Yes this will be called "aes".  If someone asks for "ecb(aes)"
that will instantiate the ecb template which will construct
a new algorithm with the same function pointers as the original.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
