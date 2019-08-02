Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C963C32750
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 05:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CFD5206A2
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 05:21:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ueV7Spbz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfHBFSf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 01:18:35 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:39969 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbfHBFSf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 01:18:35 -0400
Received: by mail-wm1-f42.google.com with SMTP id v19so65103615wmj.5;
        Thu, 01 Aug 2019 22:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eYTBzEX7GMOtIqjborVnFKsDkL4kSXgG4qFbaiySFOY=;
        b=ueV7SpbzhRpnl8iQm2HfnxN2bO6BhCambLM5XdoTPJwI8TwdtCzlBzMVVEvtxsK+ck
         aW/308wwjayjrlp1M2VqfdxUMCck2x5+fcuKwKRzVGgoM//S9RajWxDHbh3JMAZUK7kM
         gQv71iMpx+2ry+vhYoxKW6qvtD6BJCN3U/GlhOiTPKN7h1xJo1336VAFskhJyik1mBU/
         PaI7FWD3NPBHL65YaU6cLuK7NKAbJiJNmYcFX/YiNvqE7pSKve+12f+rNaGKhDNhLUyN
         KPImUEcaoo5jP4wST9mBqm0uYC1l8jUr5GcFTIQLE5MeZscAPQiN5feUxJ+TDxAw7qSq
         C1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eYTBzEX7GMOtIqjborVnFKsDkL4kSXgG4qFbaiySFOY=;
        b=ujrSr6d6LOd0yI+Q46G3HaP8x/iR+HdIsqXPViw+kGBG6kFoodA1jmRd+C3AEeUPao
         oyDfGI9yrM3zMEGyN/rusucHNUEHZpHzfoZbG7b7uFCq81oMm+tAwmhLoEvrzcP234+5
         VMyGJAEM+jp+7z9WgvVY5k9vJVZ9tO5mVMoE6aZVi4CGmaNZMimrLrScgppKkM4kaLuZ
         OPM5SxX7ZkuGwYOYaM+M83+SYZ5t7ZU6DQZuXlwZvex9tSMh8RbDDfU/XnEr3Im8dv0U
         E3sggGJcEEMblRv5s0pO6XTVfKT2vL5VZOCIWhb/wq5ZJAmFvL7f5AZVaZMZMwqpyy+f
         wq6g==
X-Gm-Message-State: APjAAAX2pbTzHyOL8mUZhvyq36AHpHKSqhhN2ZmT7MNJQpSelwHld6hm
        Jv3x49Xj+1JNLRtRdguLr47mYtxT
X-Google-Smtp-Source: APXvYqy5l5dC5ORyhEdYkw2aFAApDY3VJbNLp6XFp0/GmBZPXoekpUdgnDsxUUALy1Iwjmyux44qRQ==
X-Received: by 2002:a1c:107:: with SMTP id 7mr2210361wmb.84.1564723112827;
        Thu, 01 Aug 2019 22:18:32 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id c78sm102330630wmd.16.2019.08.01.22.18.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 22:18:32 -0700 (PDT)
Date:   Fri, 2 Aug 2019 07:18:30 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Need help with failling gcm_base(ctr,ghash-generic) selftest
Message-ID: <20190802051830.GA13677@Red>
References: <20190801194249.GA18705@Red>
 <MN2PR20MB297372F8FB158C59BF4F6F2FCAD90@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB297372F8FB158C59BF4F6F2FCAD90@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 02, 2019 at 12:24:04AM +0000, Pascal Van Leeuwen wrote:
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of
> > Corentin Labbe
> > Sent: Thursday, August 1, 2019 9:43 PM
> > To: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Need help with failling gcm_base(ctr,ghash-generic) selftest
> > 
> > Hello
> > 
> > I am writing the Allwinner sun8i-ce driver and when running tcrypt I got
> > [   30.201739] alg: aead: gcm_base(ctr-aes-sun8i-ce,ghash-generic) decryption failed on test
> > vector 3; expected_error=0, actual_error=-74, cfg=\"random: may_sleep use_digest
> > src_divs=[100.0%@+2614] dst_divs=[5.90%@alignmask+3015, 60.56%@+3996, 17.92%@+865,
> > 15.62%@+10]\"
> > or
> >
> The decryption reports only an -EBADMSG here, which means the decryption itself went
> fine, but the authentication tag mismatched.
> 
> 
> > [  148.613537] alg: aead: gcm_base(ctr-aes-sun8i-ce,ghash-generic) encryption test failed
> > (wrong result) on test vector 2, cfg=\"random: may_sleep use_final src_divs=[100.0%@+0]
> > iv_offset=20\"
> > 
> Can't say for sure, but considering the decrypt error, this is most likely just a
> mismatch on the appended authentication tag.
> 
> > Since ctr-aes-sun8i-ce is passing the ctr(aes) selftest, I dont understand what could be
> > wrong.
> > 
> That is possible, as this appears to be a problem with the authentication part,
> not the encryption part. So possibly a problem with the way you setup the 
> authentication key (which is actually derived from the encryption key, but I don't
> know if your hardware does this autonomously, mine doesn't) and/or operation?
> 

But since my driver is just a skcipher, I dont understand why I should care about any aead part, right ?
