Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310A3C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 10:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDDCC206DA
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 10:27:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="P9OmgoA9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbfLLK1L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:27:11 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:44431 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728410AbfLLK1L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 05:27:11 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ad3b6fba
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 09:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=ywUq5zC84iId6wUJrJ2e1YBkmfg=; b=P9Omgo
        A9/xoDMi7cGgRmaBzSDz4EqxADhQeUXvhdhSbuOdU4eZPl1lh+JygpA2qs3DvUvw
        Pzd7Z/8YOM31uW5eifRhy5+X9nb0iNfA6NukVolNzFvA9HVk2jLAeKLf8c3v1h0j
        eOBPpSZsHzds4TiKZ/eOpjo34mbOH/TAyorEj2nnBHq85bmWUFc71rXba9mjtdgu
        73rXbhpem/noKGp8x4L604+S6nzeZeD2ZdTHLDIEd/132BdbEEimghtStaOJ5QH+
        XoXUa1lduUZ4Dw8SSuHMaGdHM50NY8j3EkJGgxh/iBjVv0jDtg8CGVW73scVhtbL
        dW/apjf0RUnL208Q==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5caceccb (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 09:31:23 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id k14so1377336otn.4
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2019 02:27:09 -0800 (PST)
X-Gm-Message-State: APjAAAVUGU31Rc/7ZsmXpxQgb6m+2tdQ+llsvYdG2/BMSvwTECBxaXLz
        s/8oI7TjJAjgJj131HwWSTIO9TCbttuPdXn2vZs=
X-Google-Smtp-Source: APXvYqx5uvQiM+dZJi8jc0GivFClaVJ6OTK12TZbZ+UrTPHhVDhHlc5HAyCm0/AQf+rXwVjw3H62fJYPEG0CspjoMHM=
X-Received: by 2002:a9d:1e88:: with SMTP id n8mr7564156otn.369.1576146429060;
 Thu, 12 Dec 2019 02:27:09 -0800 (PST)
MIME-Version: 1.0
References: <20191211170936.385572-1-Jason@zx2c4.com> <20191212093008.217086-1-Jason@zx2c4.com>
 <20191212093008.217086-2-Jason@zx2c4.com>
In-Reply-To: <20191212093008.217086-2-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 12 Dec 2019 11:26:58 +0100
X-Gmail-Original-Message-ID: <CAHmME9rYe7c_rJP+Lh_1YaL3LU3XYJpXRqPsE3c3kBK7h4vCVg@mail.gmail.com>
Message-ID: <CAHmME9rYe7c_rJP+Lh_1YaL3LU3XYJpXRqPsE3c3kBK7h4vCVg@mail.gmail.com>
Subject: Re: [PATCH crypto-next v2 2/3] crypto: x86_64/poly1305 - add faster implementations
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Samuel Neves <sneves@dei.uc.pt>, Andy Polyakov <appro@openssl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Looks like I accidentally removed sha1-ssse3-y from the Makefile in
this one. I'll have this fixed for a v3, but please let me know if
there are any other nits before I submit that.
