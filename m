Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6ACEDE989
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 03:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjIODVj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 23:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbjIODVi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 23:21:38 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562B92711
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 20:21:34 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-68fdd6011f2so1365776b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 20:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1694748094; x=1695352894; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:reply-to:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PTDOQBJsYSyw8b1H54D8BUhY8rLLu4LSSYhPNnbLvfE=;
        b=PFnpFcY0wrEoXHkYC8yKgsuXZjuJJfr6F7aJFTj2pAHEUilg9m7Xllo/sYNrpxYmVJ
         JiQBYCQH3GEvZgm3XoWO8m83BGIlx3anRva3VdG2tLDhIdpuy9WL9Ag4bSobu3GJzHL4
         zRNCNW9HrNlBfLz/zaacNS/tBP7rvb6f4F+1ahGzjfkZK1NAa3XoDNLgq2Ad/AW5sKqv
         Jhjty4wTQAbPQ+nqWqHPW3G2o5i0GRO+hbmO3uUHxSkTIlsHCYwUH/yhaV06QRtsvbX8
         TfhoEfTPPBC/pR/TMAAffiraWrt4UxODb4kggdqng8dM5zNFp5+3GYhKDDvHxhy8CBpU
         qXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694748094; x=1695352894;
        h=to:references:message-id:content-transfer-encoding:reply-to:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PTDOQBJsYSyw8b1H54D8BUhY8rLLu4LSSYhPNnbLvfE=;
        b=mGvxR8m2ue0euRzAHpXelQ0Dtxlx770RX9zeQpQ55UgQr4tn+tbC36MOZbRkvNlr1g
         70CeRpfZN9uH/q3mK0CqTC4Xk4S9gxfE+HsGuzw24CM4KW56FRRryAIn0vO352+eXA2r
         q8ffZgzOJu1SeBk/Icx4gj2kvkuFr5tHm+cqm4wqoe0+r62HCUanwxJGopmRAyU51KH+
         kIwni4uz5RygSif+tvACJftC8C0xnwbAkdmPAu3NJ/l+VQQ/FIIvihMNGPlO2EhwPzwE
         K2z5OKyhw1CGBNnWO2ojCaZURzSxIFgjzpFhY1VlL/nslWYq8ovYP4x4A5jUGc8IZpgc
         UqbA==
X-Gm-Message-State: AOJu0YxNOrbeEaUwYKa1ckatZsVd/G24WW4JQli5J+V+aSL64qDLXah5
        czVSZmBchH8vmJHP+ZDriP4MPA==
X-Google-Smtp-Source: AGHT+IEuvHA6qyozCTrAZcaIDeut+4ZIhEGVI11IyUpSTAA3tAcSzOB2bHYHNQ0B0UVKXCDJxrKPYw==
X-Received: by 2002:a05:6a00:17a3:b0:68b:ff3b:e140 with SMTP id s35-20020a056a0017a300b0068bff3be140mr563288pfg.8.1694748093778;
        Thu, 14 Sep 2023 20:21:33 -0700 (PDT)
Received: from ?IPv6:2402:7500:5ce:c546:b4c4:4f04:b63a:c241? ([2402:7500:5ce:c546:b4c4:4f04:b63a:c241])
        by smtp.gmail.com with ESMTPSA id m1-20020a056a00164100b00690397fdd9bsm1350856pfc.190.2023.09.14.20.21.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Sep 2023 20:21:33 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH v4 00/12] RISC-V: support some cryptography accelerations
From:   Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <3A0F6A71-C521-44A5-A56C-076AF3E13897@gmail.com>
Date:   Fri, 15 Sep 2023 11:21:28 +0800
Cc:     Charlie Jenkins <charlie@rivosinc.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, palmer@dabbelt.com,
        paul.walmsley@sifive.com, aou@eecs.berkeley.edu,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        conor.dooley@microchip.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        christoph.muellner@vrull.eu,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Reply-To: 3A0F6A71-C521-44A5-A56C-076AF3E13897@gmail.com
Content-Transfer-Encoding: 7bit
Message-Id: <DD3113B1-AB9F-4D6D-BD6E-8F75A83DA45D@sifive.com>
References: <20230711153743.1970625-1-heiko@sntech.de>
 <20230914001144.GA924@sol.localdomain> <ZQJdnCwf99Glggin@ghost>
 <3A0F6A71-C521-44A5-A56C-076AF3E13897@gmail.com>
To:     He-Jie Shih <bignose1007@gmail.com>
X-Mailer: Apple Mail (2.3445.9.7)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sep 15, 2023, at 09:48, He-Jie Shih <bignose1007@gmail.com> wrote:

> On Sep 14, 2023, at 09:10, Charlie Jenkins <charlie@rivosinc.com> wrote:
> 
>> On Wed, Sep 13, 2023 at 05:11:44PM -0700, Eric Biggers wrote:
>>> On Tue, Jul 11, 2023 at 05:37:31PM +0200, Heiko Stuebner wrote:
>>> 
>>> Hi Heiko!  Are you still working on this patchset?  And which of its
>>> prerequisites still haven't been merged upstream?
>>> 
>>> - Eric
>> It is my understanding that Heiko is taking a break from development, I
>> don't think he will be working on this soon.
> 
> We would like to take over these RISC-V vector crypto implementations.
> Our proposed implementations is under reviewing in OpenSSL pr.
> And I will check the gluing parts between Linux kernel and OpenSSL.

The OpenSSL PR is at [1].
And we are from SiFive.

-Jerry

[1]
https://github.com/openssl/openssl/pull/21923
