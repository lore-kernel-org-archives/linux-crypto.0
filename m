Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CD5C04AA7
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 06:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F26D2084F
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 06:36:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="QIWLQFjn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfEOGgS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 02:36:18 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39018 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfEOGgS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 02:36:18 -0400
Received: by mail-pl1-f195.google.com with SMTP id g9so827898plm.6
        for <linux-crypto@vger.kernel.org>; Tue, 14 May 2019 23:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=UdH4Z2FP6ofwR9nmZmA2PbVfNSkzCa/ZtLAUNHYg2n4=;
        b=QIWLQFjnqpk4Xnic82J0fYlLmGbzPw9uVrqn9kAErbtMoOpXurlqK4YloMHjH8JXp3
         WMyVGXK5HaiO527nawczPIryeTdVC4p6Ndtr9A7zsdqnxTVgZrua2kwGcoLaNQRrAUU2
         A2TSpgl1jEHoiRJTum0DB89TBg/GFR9SZEBlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=UdH4Z2FP6ofwR9nmZmA2PbVfNSkzCa/ZtLAUNHYg2n4=;
        b=oFCqrUw9w1Kw1k6qOjUjyuMEMoBb5f2NBTY8lNcABJmp1HL2YCO6FIbLR5w91AB5Jq
         9F6MRpxDBXNTSqHGPgldlNMnOBmc5RZfNqsOFmQ4+71J4ao34deBAlBVR1BWfgZLqi8O
         VZeUCDGjkk0BVzbpiOPB/dEOiX88ZoWp58Ym6qyiZKJieov3ku3W9S0agx0VjmYUJUeF
         DtBVPe67PNsOxPl56CfhSywrn7xbO7xfusDSR7Ks/KBX6kLx02J+m7m9lKDeNsK9tIrf
         oUsHRHNY6y7iYEcyL3LNFJuFK3kRgUNBZmz98DPMqtjtbgLgQ8Y9w/w4siPgk9aIhKQx
         ze7w==
X-Gm-Message-State: APjAAAWgeYwBZsihzga2UspifXVUddcL5z0QlU/6r2zEvmsYfVVWG/at
        fYXjYF8wklXaJG7vBw8KFYXHyA==
X-Google-Smtp-Source: APXvYqyFBD8u2dpQZB+7bh4IaAaLADdl8Bqt38YwjGPvbGw/4MmYLbTs6g1LhmNcBAfyzJe0xzzy2Q==
X-Received: by 2002:a17:902:7e4f:: with SMTP id a15mr42572574pln.205.1557902177541;
        Tue, 14 May 2019 23:36:17 -0700 (PDT)
Received: from localhost (dip-220-235-49-186.wa.westnet.com.au. [220.235.49.186])
        by smtp.gmail.com with ESMTPSA id r9sm2222306pfc.173.2019.05.14.23.36.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 23:36:16 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Nayna <nayna@linux.vnet.ibm.com>, leo.barbosa@canonical.com,
        Stephan Mueller <smueller@chronox.de>, nayna@linux.ibm.com,
        omosnacek@gmail.com, leitao@debian.org, pfsmorigo@gmail.com,
        linux-crypto@vger.kernel.org, marcelo.cerri@canonical.com,
        George Wilson <gcwilson@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
In-Reply-To: <20190515035336.y42wzhs3wzqdpwzn@gondor.apana.org.au>
References: <20190315043433.GC1671@sol.localdomain> <8736nou2x5.fsf@dja-thinkpad.axtens.net> <20190410070234.GA12406@sol.localdomain> <87imvkwqdh.fsf@dja-thinkpad.axtens.net> <2c8b042f-c7df-cb8b-3fcd-15d6bb274d08@linux.vnet.ibm.com> <8736mmvafj.fsf@concordia.ellerman.id.au> <20190506155315.GA661@sol.localdomain> <20190513005901.tsop4lz26vusr6o4@gondor.apana.org.au> <87pnomtwgh.fsf@concordia.ellerman.id.au> <877eat0wi0.fsf@dja-thinkpad.axtens.net> <20190515035336.y42wzhs3wzqdpwzn@gondor.apana.org.au>
Date:   Wed, 15 May 2019 16:36:12 +1000
Message-ID: <874l5w1axv.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Wed, May 15, 2019 at 03:35:51AM +1000, Daniel Axtens wrote:
>>
>> By all means disable vmx ctr if I don't get an answer to you in a
>> timeframe you are comfortable with, but I am going to at least try to
>> have a look.
>
> I'm happy to give you guys more time.  How much time do you think
> you will need?
>
Give me till the end of the week: if I haven't solved it by then I will
probably have to give up and go on to other things anyway.

(FWIW, it seems to happen when encoding greater than 4 but less than 8
AES blocks - in particular with both 7 and 5 blocks encoded I can see it
go wrong from block 4 onwards. No idea why yet, and the asm is pretty
dense, but that's where I'm at at the moment.)

Regards,
Daniel

> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
