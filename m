Return-Path: <SRS0=7d9E=VY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0A8C433FF
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Jul 2019 16:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 838322085A
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Jul 2019 16:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MAUv3HvW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbfG0QEh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Jul 2019 12:04:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34356 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbfG0QEh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Jul 2019 12:04:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so57436371wrm.1
        for <linux-crypto@vger.kernel.org>; Sat, 27 Jul 2019 09:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xufq+sg1OgKMJHpTfBvbAhf96A/Qb3kdIla9BjnF7lo=;
        b=MAUv3HvWDBa/gJgDMh1Cekd4E84H+0GJwlFWAoF4txJjzx26Izn02GszjBBVdqG1L5
         vKafDSFZTC1LbEetrs7a/xOz6654mTyu9WRiuxOQWD99c4usL5mzN9XvTJc6pe9MlKQA
         eBM1XoEDZv/bq4SNhqf6utFlLk/mSMudpzOeuz8I29A4OzyW96X0yg+JQAL9Cb4/m7ho
         RvjdqdaS1rRhsSr68Qtd95X/OywR6ZqOEZG3f7N8ihxlnidp1d3kiqgEfR+54S6zUz3i
         LdEWLRNYlpNZqPF3JxgTa9x4QUFHW2Akfl4WZEduBq7lXHJQbgKDt2zOPrdBrP8A1Cuh
         Md/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xufq+sg1OgKMJHpTfBvbAhf96A/Qb3kdIla9BjnF7lo=;
        b=j3JtOpx1jFHCEpwFG9tW53w6Vwal/rIerYE752IS1xdJjsOlMw8YX9Y6G6i3filCR6
         Md4Y60dtwncNqGWE6ELzHZxVOAo/SF4D8462JWhY1pkMfwhqJMA5PcnXAq3lQF0DtHY4
         Inpk7mz7vVarCnZe7SqQPRUZHvpnZbHQJCsS/IxpydZjTrNovzUDNP6ASuYfjt1ZKd2k
         E+X1E9/gjP3wyAHDe8rMS7J8WAc0v+PxtakGdIPfZvhjPhsrZN0ifNJKDusr7I5woUA1
         GdzDt+8Ic9qiE4HfKEfqaYwuLhr/9Nc6VyG1EVBNTYr0pWCd3GAAPUJBV36LPlA2i6Hk
         AbPg==
X-Gm-Message-State: APjAAAXG4b+eWui3t29qtPnTkQxMw6cYk96S87OpGIHHBcwLxhmfEIEE
        qm1Xr1izlL6Wx5gmeHwqlpAjpYR+
X-Google-Smtp-Source: APXvYqxtYOttgKh7W5PzJ4p93lj2koGRlynUU4ePppek/JtWBvLtnoKhqq0W0YacuQgDN0UtRBa8Kw==
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr106841807wrq.333.1564243475231;
        Sat, 27 Jul 2019 09:04:35 -0700 (PDT)
Received: from [192.168.8.100] (78-80-26-9.nat.epc.tmcz.cz. [78.80.26.9])
        by smtp.gmail.com with ESMTPSA id j33sm115307879wre.42.2019.07.27.09.04.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Jul 2019 09:04:34 -0700 (PDT)
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <20190716221639.GA44406@gmail.com>
 <20190720065807.GA711@sol.localdomain>
 <0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com>
 <CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
 <MN2PR20MB2973B9C2DDC508A81AF4A207CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
 <MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
 <MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
 <MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <VI1PR0402MB34850A016F3228124C0D360698C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <MN2PR20MB29732C3B360EB809EDFBFAC5CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu9krpqWYuD2mQFBTspo3y_TwrN6Arbvkcs=e4MpTeitHA@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <97532fae-4c17-bb8f-d245-04bf97cef4d1@gmail.com>
Date:   Sat, 27 Jul 2019 18:04:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9krpqWYuD2mQFBTspo3y_TwrN6Arbvkcs=e4MpTeitHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 27/07/2019 07:39, Ard Biesheuvel wrote:
> Thanks for the additional test vectors. They work fine with my SIMD
> implementations for ARM [0], so this looks like it might be a CAAM
> problem, not a problem with the test vectors.
> 
> I will try to find some time today to run them through OpenSSL to double check.

I shamelessly copied your test vectors to my vector test for cryptsetup backend.

Both OpenSSL and gcrypt XTS implementation passed all tests here!

If interested - this is copy of backend we have in cryptsetup, vectors added in crypto-vectors.c
(there are some hard defines in Makefile, cryptsetup uses autoconf instead).
  OpenSSL: https://github.com/mbroz/cryptsetup_backend_test
  gcrypt branch: https://github.com/mbroz/cryptsetup_backend_test/tree/gcrypt

Once kernel AF_ALG supports it, I can easily test it the same way.

Thanks,
Milan
