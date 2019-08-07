Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1445C32751
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 17:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94777222FC
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 17:24:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NeuZX4IL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbfHGRYd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 13:24:33 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:44858 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729804AbfHGRYd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 13:24:33 -0400
Received: by mail-wr1-f44.google.com with SMTP id p17so92149949wrf.11
        for <linux-crypto@vger.kernel.org>; Wed, 07 Aug 2019 10:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wo3nEGAkLOpA+UYnrX7HewWZPxXPoldMl2fw5CMEKQY=;
        b=NeuZX4ILVKJaqD+Mub9t4ESBnhqQDy/d2+pKZJqMje+BOjXlR1sEYkyiZngEe1OrNp
         EKBA7XgOw8bttAAc2Snkoo65J3FP3x+BnpzeWpQuPbGjPCYfXdDcggFiu/1kv9cHHP0c
         Csct/zoPff7MrA439MSypSH8MEN9udGp2Ppw6MCGesWojxdSE0Z2+JrbORvPhoEaQqT/
         l6xV+FBO1TPms3VnyFWuzpc6GGfLEKTzy/INlVOrdrg1M5IFz7i+ib44n/CylD7qfbxx
         nFPiUF+XEJIhjRDSp7uh+My1WWzGeuH3yIxxN5LS2vjNPITpTICqumndxIGFHucxmyia
         SDew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wo3nEGAkLOpA+UYnrX7HewWZPxXPoldMl2fw5CMEKQY=;
        b=ecMI75AvQ/57dY5kbNuZWhpKRG93BRduiaVaCnADR/GDgOrAd0jzP4/Wnx4rheysBd
         7969HuhkVLmRJuZZPG65tQuSCoUEn02Z50+rXsPAykAyNjDFcJIO9D8vxrsxf5k/Hiar
         MLEKeNsGcR7ypYfCHrTlpcCmYrTN4HLlkWLVg+aNCb7w+kGypvgKfo/vMtDiESC41QdM
         FT+pxIVHU5vU1r3ZYZPTg81UNX5HdaBQTPgZPW/8XD2g3M4UD/VOKBijj2i231InIfoN
         Kd0BWZy2cpc5m2BVVrDIQeH/jKZdR2MdgfFEqc3EYFi9lXQYP/GgucNHU6JKsMJRL67v
         dGCw==
X-Gm-Message-State: APjAAAUybmobzkiLZJZHfsygmzxA3KY0HRLWFEqRsvAEvKmf23BNgWSE
        f2CF8+HG1W8wcXjULx1aFYQAqFRJRyI=
X-Google-Smtp-Source: APXvYqyNLi/svvuoG+3fKLV4B57pReEluEzAmpg0iN9cwpHEa1Jca2dcnZ+QxoDp1rt+GPZxiiHSJw==
X-Received: by 2002:a5d:618d:: with SMTP id j13mr11826320wru.195.1565198671385;
        Wed, 07 Aug 2019 10:24:31 -0700 (PDT)
Received: from [192.168.2.28] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id s2sm344971wmj.33.2019.08.07.10.24.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 10:24:30 -0700 (PDT)
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
 <52a11506-0047-a7e7-4fa0-ba8d465b843c@gmail.com>
 <MN2PR20MB2973C4EAF89D158B779CDBDACAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <46f76b06-004e-c08a-3ef3-4ba9fdc61d91@gmail.com>
Date:   Wed, 7 Aug 2019 19:24:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <MN2PR20MB2973C4EAF89D158B779CDBDACAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07/08/2019 17:13, Pascal Van Leeuwen wrote:
>>>> Seems there is no mistake in your code, it is some bug in aesni_intel implementation.
>>>> If I disable this module, it works as expected (with aes generic and aes_i586).
>>>>
>>> That's odd though, considering there is a dedicated xts-aes-ni implementation,
>>> i.e. I would not expect that to end up at the generic xts wrapper at all?
>>
>> Note it is 32bit system, AESNI XTS is under #ifdef CONFIG_X86_64 so it is not used.
>>
> Ok, so I guess no one bothered to make an optimized XTS version for i386.
> I quickly browsed through the code - took me a while to realise the assembly is
> "backwards" compared to the original Intel definition :-) - but I did not spot
> anything obvious :-(
> 
>> I guess it only ECB part ...

Mystery solved, the skcipher subreq must be te last member in the struct.
(Some comments in Adiantum code mentions it too, so I do not think it
just hides the corruption after the struct. Seems like another magic requirement
in crypto API :-)

This chunk is enough to fix it for me:

--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -33,8 +33,8 @@ struct xts_instance_ctx {
 
 struct rctx {
        le128 t, tcur;
-       struct skcipher_request subreq;
        int rem_bytes, is_encrypt;
+       struct skcipher_request subreq;
 };

While at it, shouldn't be is_encrypt bool?

Thanks,
Milan
