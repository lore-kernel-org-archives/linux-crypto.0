Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C097C35280
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 21:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 300FF21D71
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 21:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569879488;
	bh=BH/iBL1ZbFK0qZcjnUOmWd7KDaMQ+O4qAsRp9NWpdV4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=hV5aSnnQq2jfbRny9s5VoSqji3QWgwxm76QDmA7E1x843EJ10XBsPD1jtaDfkOJYF
	 WRjhqOc4GO8dsy6WXbCwyG3+W8CWzqzc5WZ0qzn+VKy73tStcW6F5/9y1w857nVaoS
	 tIoyw++J0r42+IVETFYokT/Hqsb16DEfphuTcgyE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731233AbfI3ViG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 17:38:06 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:46334 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730639AbfI3ViG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 17:38:06 -0400
Received: by mail-lf1-f43.google.com with SMTP id t8so8152178lfc.13
        for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2019 14:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ixtEphxdbSY2nxhdSSuwlJ43CSGi6j7e5g55W0WR5ps=;
        b=XDHWgPO2tzxfiQyNRdnzo5hR74XX4mhCRJG+pVQURE69/fv86sRHLqbR3Xh3C1gd/u
         UU/z4/3Mjsdm3CYGi8S26KjwIQ0tmQDWgZwJVlNpomeMgLYjCG4+ZgeFj1YgtZhqyL/U
         HUKEOCcp3//Tp068MpezftV8CG+hOBPc8g8Jw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ixtEphxdbSY2nxhdSSuwlJ43CSGi6j7e5g55W0WR5ps=;
        b=t4E5s310g3hDaC4Nj9/izu1tDeopW2WkafA/hmlzTpZCWkdnNcqdqm6LI77ZavW9KG
         ZJiP1aFSri1CdBRt+VTw/UOI+CZHnxlMyhbJ9+yPgal9GZT7k4LEQk8AeKW+ACZExMxT
         FnBhI6VaDWd4pVpnMVS6beJh3UPKK+ADySrvcts1iyIXKAp51wkC8qp/nUrvGHZCrTVt
         F+oKmpx0Tq3rXiBqBIs/xwvGrWVb6XFZz/xsM6eELVzj14PTP8FgLdOu7qSa3GP/Ey4q
         UGjqa02aVheu5b5I05usy0ZcYYKJKlljMdcSMW9LRm+PkOC66gVNUKlqGka0JB5Z3dTk
         rzOQ==
X-Gm-Message-State: APjAAAXSOW9Bef80POT2yHkNLOxGu+eUctcLUJ95KPh6ENswYuAoybYS
        EdFWwXwt8ENlmQkSe9wzIO4p9PxgB9o=
X-Google-Smtp-Source: APXvYqytlz+x7EX1ThAlbnRdudsjsNSHg6Kros7u5Dxp4r06BjooLxFwUSSM1U19Yv/TbUeQg5h2Yg==
X-Received: by 2002:a19:98e:: with SMTP id 136mr13030060lfj.156.1569879482838;
        Mon, 30 Sep 2019 14:38:02 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id y3sm3396785lfh.97.2019.09.30.14.38.01
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2019 14:38:01 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id u28so8200101lfc.5
        for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2019 14:38:01 -0700 (PDT)
X-Received: by 2002:ac2:47f8:: with SMTP id b24mr12877392lfp.134.1569879480494;
 Mon, 30 Sep 2019 14:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org> <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
 <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com>
 <MN2PR20MB2973A696B92A8C5A74A738F1CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wj9BSMzoDD31R-ymjGpkpt0u-ndX6+p0ZWsrJFDTAN+zg@mail.gmail.com> <3e5347a2-9aa7-bffb-2343-42eda87a6c83@free.fr>
In-Reply-To: <3e5347a2-9aa7-bffb-2343-42eda87a6c83@free.fr>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 30 Sep 2019 14:37:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj=377rsWmvrK_MvL6yamTisj5SWFQZsQH+rjeic8_suA@mail.gmail.com>
Message-ID: <CAHk-=wj=377rsWmvrK_MvL6yamTisj5SWFQZsQH+rjeic8_suA@mail.gmail.com>
Subject: Re: France didn't want GSM encryption
To:     Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 30, 2019 at 4:14 AM Marc Gonzalez <marc.w.gonzalez@free.fr> wrote:
>
> Two statements above have raised at least one of my eyebrows.
>
> 1) France has laws that require backdoors.

No. But France has a long history on being bad on encryption policies.
They've gotten better, thankfully.

France was one of the countries that had laws against strong
encryption back in the 90s. It got better in the early 2000s, but
there's a long history - and still a push - for some very questionable
practices.

It was just a couple of years ago that the had discussions about
mandatory backdoors for encryption in France. Look it up.

Are there other countries that have worse track records? Yes. And in
the west, the US (and Australia) have had similar issues.

But when it comes to Western Europe, France has been a particular
problem spot. And I wanted to point out that it's not always the
obvious problem countries (ie Middle East, China) that everybody
points to.

> 2) France did not want GSM encryption.

I'm pretty sure that France had the encryption bit off at least during the 90's.

GSM A5/1 isn't great, but as part of the spec there is also A5/0. No,
it's not used in the West any more.

France was also at least at one time considered a hotbed of industrial
espionage by other European countries. And the US.

You can try to google for it, but you won't find all that much from
the bad old days. You can find _some_ stuff still..

  https://apnews.com/4206823c63d58fd956f26fd5efc9a777

but basically French intelligence agencies have been accused of
extensive industrial espionage for French companies over the years.

Anyway, I'm not trying to point to France as some kind of "worst of
the worst". I literally picked it as an example because people
generally _don't_ think of Western European countries as having
encryption issues, and don't generally associate them with industrial
espionage. But there really is a history even there.

            Linus
