Return-Path: <SRS0=E9jf=D4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BEBC388F9
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Oct 2020 15:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A49AF2177B
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Oct 2020 15:16:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AiMDdQAi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501929AbgJUPQH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Oct 2020 11:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502113AbgJUPQH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Oct 2020 11:16:07 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A79BC0613CE;
        Wed, 21 Oct 2020 08:16:07 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id s14so2764821qkg.11;
        Wed, 21 Oct 2020 08:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9MM2vEZBw6tjXUDyjGU6HmX8YCJo6rvFJY1GE/amDAw=;
        b=AiMDdQAiKYq+RAmX5cSS6Cn/89NjZLdcc9W3Vo9eFLejakE/Iu8RDxTcaYOgQM53iw
         dSl0L9KJMzvkoMY3V+veK9yAJRKMs9ZPfvzd2hljEutjRsVhL5lWWlaGAFqCIGdtyp4H
         vUQ2Zdjor3oywHO1+4Nw7FJC1Zt5Xj8c0p7ecDXtKya5IObozbbkOSaG9aHz4oH1T3RC
         dpIsojEilh3a4VfVoe35w0g2AbHlyrpzFpyiqXetUGM7kd79K1qGdWBMzcY4ikdXR41v
         yVkE1Bd7qGwzS3L70aFhRZCuB0XPpL3nLHklmAj9ciceE8W2A9Xdn3jGGzYfZsJ5KWmq
         CkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9MM2vEZBw6tjXUDyjGU6HmX8YCJo6rvFJY1GE/amDAw=;
        b=F1MN+QX1WarzBFJ8FBwKu6JDgBUJxHn8N0wTivLblvmUl3cDHk9lLVhWKcMKhBcMcN
         2bbhJHLTZRoex9YM731SvOc8X7kLHnjB83ZeevbbChpmtswsrLJ9CohP9l3VqFH4dNWx
         Thkd/Mduv7tNOStEmRcFcBnLeegfuhnZ9QA+mh6VDAxHopkzNm8UBnhGIKpP49gwydQh
         oFJg6zPq2T3HH7jDWqNgSi4w5x+Ipb7n5FInaLCTe/MA/CAYSKMOaNpYw5ZY504XkJUc
         974MVnD8Z0BwfR0MhcYLfLP47K0IdKpjPRfWwClBIbVnSLf51B8S+B/vuO3pzhd9jytR
         PyIQ==
X-Gm-Message-State: AOAM531DxpatJd5v0OiVvE/AL2kBb1I3QChsPfKt46lHoeIVvJoioNqz
        BSlafAWaQaA30k6aWL/JFEQ=
X-Google-Smtp-Source: ABdhPJx85NH8Q8Qnh3+FEQses7EhMqZQ1HiCXdrHQOBc0QBn+Wu6ZfGIFkGCdL7ZFZOFFM+co2Lycw==
X-Received: by 2002:a37:9f0a:: with SMTP id i10mr3484421qke.61.1603293366700;
        Wed, 21 Oct 2020 08:16:06 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id 67sm1472106qkd.14.2020.10.21.08.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 08:16:05 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Wed, 21 Oct 2020 11:16:04 -0400
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Arvind Sankar' <nivedita@alum.mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/6] crypto: lib/sha - Combine round constants and
 message schedule
Message-ID: <20201021151604.GA3750362@rani.riverdale.lan>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
 <20201020203957.3512851-7-nivedita@alum.mit.edu>
 <d8c1750ffcef4236904919321b872cd2@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d8c1750ffcef4236904919321b872cd2@AcuMS.aculab.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 20, 2020 at 09:36:00PM +0000, David Laight wrote:
> From: Arvind Sankar
> > Sent: 20 October 2020 21:40
> > 
> > Putting the round constants and the message schedule arrays together in
> > one structure saves one register, which can be a significant benefit on
> > register-constrained architectures. On x86-32 (tested on Broadwell
> > Xeon), this gives a 10% performance benefit.
> 
> I'm actually stunned it makes that much difference.
> The object code must be truly horrid (before and after).
> 
> There are probably other strange tweaks that give a similar
> improvement.
> 
> 	David
> 

Hm yes, I took a closer look at the generated code, and gcc seems to be
doing something completely braindead. Before this change, it actually
copies 8 words at a time from SHA256_K onto the stack, and uses those
stack temporaries for the calculation. So this patch is giving a benefit
just because it only does the copy once instead of every time around the
loop.

It doesn't even really need a register to hold SHA256_K since this isn't
PIC code, it could just access it directly as SHA256_K(%ecx) if it just
multiplied the loop counter i by 4.
