Return-Path: <SRS0=me0G=UN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACF5C31E4B
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 15:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC902168B
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 15:51:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iDPmhW5R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfFNPvq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jun 2019 11:51:46 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:43398 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfFNPvq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jun 2019 11:51:46 -0400
Received: by mail-yw1-f65.google.com with SMTP id t2so1275985ywe.10
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jun 2019 08:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rmSFmNkxkdutblBF4nfv/FPx6xLmobVG8p088ta4ck0=;
        b=iDPmhW5RgAGCEpcKLC3ltY+btEId/3FHt4RKDKod0xODrdjP/0RT109iLSVA56rgDq
         K6hK8Ngf7Y6R3I97clhiD7v+qg6XLSY0y0I3h5+hY+lvaPFVNyEozJXyehokPzib9Jti
         82LSMs8egVajPZvAS6YKDvhyN/W0NgYQyK4JIoQQFyY6o1YxbdkvL8/WRr8WzD6Be1CM
         qzHm7Tl+IKByNuCDKLWqAkNqCj1ff01GWm2FQUOQylhxP1Om9V/AAR3MPNMADjFSEBhx
         Lg6S5m+/YAAe0XBIO3oLlW0pKp3DgbIupu+U3qXcNCJLUE+5GvGn8n3upQjqEa1Wt4BD
         tMOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rmSFmNkxkdutblBF4nfv/FPx6xLmobVG8p088ta4ck0=;
        b=PYj6gvJKHiIndIYLUrVHAexOM0+0TfW6vg3QdHR1SExWd5C9ko3WU390z1yiLYTfNW
         5p/TCucrSJ7qkiqPcIR00b1HK/9/PcrWFaGJ7LVZQWacgtAo1bLABYoOv/SLJa1ndy9S
         uBa7A13p7jSvkTRFaHU+9xUoghtyos1gMpwbKL5nvIgIC+eaAJP+8ciA6jMApL7S46gV
         dB1H9fc2nyHioI2yTDG51xVJAxiA5HHOGJKF4dhTLdGcl/jQGo4xN1MfL/qQNlJvTXf4
         uYJasQbSXH5BE8gEoDJg51S05BRU/VMT7WQTmDPbDFiSm4GS3kCL8nSlcsFIOeocYbdL
         faSA==
X-Gm-Message-State: APjAAAU8OPG+aSDQp9MZy3PGbC1GnQl+cgqGiWDvlAjbd2nSkD0tyPT2
        3eorLcoev28GXuR1/qGe3p39cYiC7tbM0MOJ5h9CmA==
X-Google-Smtp-Source: APXvYqwWTd58Je8czU4JBtOH9SKl1U0nCrCgT6B26s4+OBGhGae+5cjR9z9bABLNUOUjCRdeStZI8eDUCIEY2PRMOCk=
X-Received: by 2002:a81:2e93:: with SMTP id u141mr40026081ywu.21.1560527504985;
 Fri, 14 Jun 2019 08:51:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190614140122.20934-1-ard.biesheuvel@linaro.org>
 <CANn89iKP2fQ6Tc0jBW_WdLq3kYQx7NsdVDB5S3y453T+6yp86g@mail.gmail.com> <dcae85a5-9782-ab4c-c079-1d06675ea4b7@akamai.com>
In-Reply-To: <dcae85a5-9782-ab4c-c079-1d06675ea4b7@akamai.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 14 Jun 2019 08:51:33 -0700
Message-ID: <CANn89iKUtN3gO1rndW-2yNsOZian4OngnLUxLWqfo4VRb73-kA@mail.gmail.com>
Subject: Re: [PATCH v2] net: ipv4: move tcp_fastopen server side code to
 SipHash library
To:     Jason Baron <jbaron@akamai.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        netdev <netdev@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, ebiggers@kernel.org,
        David Miller <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 14, 2019 at 8:44 AM Jason Baron <jbaron@akamai.com> wrote:
>
>
>
>
> The inconsistencies coming from kernel version skew with some servers
> being on the old hash and some on the newer one? Or is there another
> source for the inconsistency you are referring to?
>

The servers still using the old crypto hash, and the new servers using
the new siphash,
will generate different fastopen cookies, even if fed with the same
key (shared secret
among all the server farm)
