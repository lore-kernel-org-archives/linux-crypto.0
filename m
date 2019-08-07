Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E2DC32751
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 11:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39146218FE
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 11:41:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AWLZIy4q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfHGLly (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 07:41:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35365 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfHGLlx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 07:41:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id k2so5177167wrq.2
        for <linux-crypto@vger.kernel.org>; Wed, 07 Aug 2019 04:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lZEjv/tSJ4XQ75HSv1v6c/RWLiy7l88goEGobpWk0+Q=;
        b=AWLZIy4qEkkWVPEL85DyMlL76SBf/KU1OpzlaYRoUWfmLg+/4UYWXOm0TN2sEbcxWW
         cbQWfJhnJZQS8rYj9RKxA4WzO0eD7p/x5izXq1JnuA3vdM4twm/aST0+o6PFqYTUOoDb
         RlarSLZJ6mdpvpI7WiD09KPUZ6mVyhU5kWiztjfsXD3Qc85KNpRSlkCco3cGUmiEUYbS
         GGgujqMn2DaNfvTCS8UeUnz/v5K3w9fdATljx8OPB9q+UDrbO8PQiQgSYanzRsnA4nLF
         tsf2OTQSYeC1WksdPqr2pe2hAL4LFY9e/ra8/6cnJlk/5t0IZdi81PwazmLbDxkT2oAx
         Qilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lZEjv/tSJ4XQ75HSv1v6c/RWLiy7l88goEGobpWk0+Q=;
        b=TojIemT4Wf91ZrpVq8PZ8PaA+1AKGGkYw97CrvHGrGV/utXdqjx1rWD+0ihyNgtAHT
         z5dMAZpT0sg5FOtmWaF2rM7VJMuVEtE+NnpqDUprnDSLptvfLauvuf3t8LBe1JXZle1S
         E49rbcMrjT1JgNOSL7LpgyHe2AJ7Ue2Z/tiq9TsX11VdOHC2Fs3EStJO9N+GsTL/uIrc
         NumGaRdRvvo0XXzJqg4+Y0s1P21GM8QJkRdG3K+XzNSu7KMjDbMbb7U9ZIpJ0N/d8eSl
         NXlr2IfJCtm+cxaEK+QZX747spxCc4ufweI45VTiDWEQlI4KizvDlmmvSVbzJgrq95Ud
         lhTQ==
X-Gm-Message-State: APjAAAWFp7pZLHJv3ZcDRBQXeqIuWMpczV9G0FxgHz6jvDLcozh5vzWJ
        tF4ikvdiscaQYMF5CgU2UCs=
X-Google-Smtp-Source: APXvYqzOagnfvoFJ1u0lR7qcuv6CiR+kqOaiEEE6uxPbSzr6/Ay2frx7k/XcbFXu0yEyFEZJkgWvGg==
X-Received: by 2002:a5d:4ecc:: with SMTP id s12mr10728818wrv.157.1565178111703;
        Wed, 07 Aug 2019 04:41:51 -0700 (PDT)
Received: from [10.43.17.10] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id n12sm99897545wmc.24.2019.08.07.04.41.50
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 04:41:51 -0700 (PDT)
Subject: Re: [PATCH] crypto: xts - Add support for Cipher Text Stealing
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     "rsnel@cube.dyndns.org" <rsnel@cube.dyndns.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <1565074510-8480-1-git-send-email-pvanleeuwen@verimatrix.com>
 <5bf9d0be-3ba4-8903-f1b9-93aa32106274@gmail.com>
 <MN2PR20MB29734CFE2795639436C3CC91CAD50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973A38A300804281CA6A109CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <a0e3ce44-3e47-b8d9-2152-3fd8ba99f09a@gmail.com>
 <MN2PR20MB297333F0024F94C647D71AA2CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <52a11506-0047-a7e7-4fa0-ba8d465b843c@gmail.com>
Date:   Wed, 7 Aug 2019 13:41:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <MN2PR20MB297333F0024F94C647D71AA2CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07/08/2019 13:27, Pascal Van Leeuwen wrote:
>> On 07/08/2019 10:15, Pascal Van Leeuwen wrote:
>>> I went through the code a couple of times, but I cannot spot any mistakes in
>>> the lengths I'm using. Is it possible that your application is supplying a
>>> buffer that is just not large enough?
>>
>> Seems there is no mistake in your code, it is some bug in aesni_intel implementation.
>> If I disable this module, it works as expected (with aes generic and aes_i586).
>>
> That's odd though, considering there is a dedicated xts-aes-ni implementation,
> i.e. I would not expect that to end up at the generic xts wrapper at all?

Note it is 32bit system, AESNI XTS is under #ifdef CONFIG_X86_64 so it is not used.

I guess it only ECB part ...

>> Seems something is rewritten in call
>>   crypto_skcipher_encrypt(subreq);
>>
>> (after that call, I see rctx->rem_bytes set to 32, that does not make sense...)
>>
> Eh ... no, it should never become > 15 ... if it gets set to 32 somehow,
> then I can at least explain why that would result in a buffer overflow :-)

Yes, that explains it.

(And rewriting this value back does not help, I got different test vector output, but no crash.)

Milan
