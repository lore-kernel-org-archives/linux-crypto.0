Return-Path: <SRS0=ef2Z=W3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32F3C3A59B
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Aug 2019 02:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A35C42343B
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Aug 2019 02:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567216922;
	bh=EH7UF4hE0hUphJlOsvXuyX+GyJDs8CBq8W6IzESMZnc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=xRBF6a96nlPNKZsOKpVbprbaeXw8/3YlBMOlbycTSke/BUDncsP2xno1XAGGn03NK
	 8gmn5DytHkHK8Fe5wadYfYZA3Z3qWDgUoxcyEGg16BglQ8T4KnGs7d+qJoC8CNDKee
	 3J7se+mbAo/GW0ZBGK6Eiaq7BQjA/fUcnNh+aKRw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfHaCCB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 22:02:01 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45508 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbfHaCCB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 22:02:01 -0400
Received: by mail-lf1-f65.google.com with SMTP id r134so5773376lff.12
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 19:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5gMwt6isAwVm7YJJXL3zlJvn3zNlFGgyGxV9A3cBnEc=;
        b=SOrA9k8fOzCUHmFRfMqLCAdkYLAH+8RewUOAcE/to+bTCzJNInpxUKc/kug/GXXr8X
         G14cx+KeOC32/pE2vKyqsTdpnJSc9rarN6X5cBfbPL7gHg5aUaNJuFwgEoOce2XeonMJ
         6pUCmoV8rMRso0oYOnKp4D52/MEeR2IeeC97M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5gMwt6isAwVm7YJJXL3zlJvn3zNlFGgyGxV9A3cBnEc=;
        b=oDOtFECMcJE3oxuiugPjBT5gFwPju/8IH1OIdKj9IgNaOHeWAnctJ8KjUXBEEhFQOQ
         N4CR+Vthkhr7BvmL3OazuJ6ivvui4VsQ7fLxapb0hmMGavfbxbrpewuiWUF6+mJt1ShX
         3H5hvNVYixH16TiLl7SqQX9KBOI0a8jdgLqGzw9rzLFYaoLGgfE504C4F4TojgohPVde
         M8EFRF/qsM7mxRKR8FrJ9asy1DAtbnJQLuTabUyMin2d8LtchhNj8RdYDFkWK3f6eDaC
         lbqmCRWcWof1hVr9wIyyAenIC5BUmWVDUjuar+fdO3IrHaGzgGnCoJ7CAso9xPhQLZtT
         g2jw==
X-Gm-Message-State: APjAAAWy6LtjHePqoHxQ3tG3Nlf53+ST2Pkl65JWeWkInyDEtQhvMxr2
        yl2PAJPMeMzNH86DMT0c604JukFbIq0=
X-Google-Smtp-Source: APXvYqwPmNd2Djux5LDBWo1pUingknlg1OhUU7/U/JqSWqJOBC7xiBkJSKmBmAiBwLV6YESRHTPPtQ==
X-Received: by 2002:ac2:530e:: with SMTP id c14mr1461405lfh.165.1567216919047;
        Fri, 30 Aug 2019 19:01:59 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id q24sm1226941lfa.94.2019.08.30.19.01.57
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2019 19:01:58 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id e27so8056014ljb.7
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 19:01:57 -0700 (PDT)
X-Received: by 2002:a2e:8507:: with SMTP id j7mr2974829lji.156.1567216917739;
 Fri, 30 Aug 2019 19:01:57 -0700 (PDT)
MIME-Version: 1.0
References: <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au> <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au> <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au> <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
 <20190515060552.ecfwhazt2fnthepg@gondor.apana.org.au> <20190719031206.nxyxk4vj6dg7hwxg@gondor.apana.org.au>
 <20190809061548.GA10530@gondor.apana.org.au> <20190830073906.GA4579@gondor.apana.org.au>
In-Reply-To: <20190830073906.GA4579@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 30 Aug 2019 19:01:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=whnH09S73Nfo-HMH+V-Ew39+tZdEzaLUQo41PJEo=PZZw@mail.gmail.com>
Message-ID: <CAHk-=whnH09S73Nfo-HMH+V-Ew39+tZdEzaLUQo41PJEo=PZZw@mail.gmail.com>
Subject: Re: [GIT] Crypto Fixes for 5.3
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 30, 2019 at 12:39 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This push fixes a potential crash in the ccp driver.

Btw, Herbert, can you add "pull" somewhere in your pull request email?

It could be in the subject line (ie change the "[GIT]" to "[GIT
PULL]") but it could also be anywhere in the email body (ie a "please
pull" or something like that).

As it is, your pull requests don't actually trigger my search terms. I
eventually get to them anyway (I do try to look at _all_ my emails),
but it does mean that they don't get the priority action that other
peoples pull requests do...

               Linus
