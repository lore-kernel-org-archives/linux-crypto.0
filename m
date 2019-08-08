Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4502C433FF
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 12:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7029B21883
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 12:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i1KjPVL7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732610AbfHHMwh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 08:52:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35318 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728980AbfHHMwh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 08:52:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id k2so8964495wrq.2
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2019 05:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YWHYbWqY351NKxb89r4Xk4spZ3MRrynqi74kHBEauB4=;
        b=i1KjPVL7wuLeDIrZtcsn++lCvUh8QZ1KjRwNMn1TdhsFIfY4/fMa1AINrFpJ/9xTbB
         2M23mbb3hV81tjHLQ43l4vzcIKxkguqHM//x56/q7KHVa2s7wsuTHXoGYZD3QNa/pdML
         UlpdHY2kPVLO8Chzw3Uu+lRLPbCviV0EK+DUdmXCn1PiZ71EYsTyfvyGx5+5GAuxKnzo
         s0I/yGL+IlUaZfMbjfLmdSI5p4TR0DEs4fwnNfHik7S+G+IOHEFcfMvea3+awkwVHf3r
         vTUn9ugtP7qxSww3O91a+0yntuGu/MLElK/QgskXcLrxruB8gaTAqKV5ZmAwTC4RTnzu
         IQhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YWHYbWqY351NKxb89r4Xk4spZ3MRrynqi74kHBEauB4=;
        b=qOf/4iGWRFTxeGvbWR/snSdiVPJifDQ0ExzC5ABy7681KxnM8w2fbUqomgXfK4XGOe
         siiUxKnVKFyUvWud8zr56vq+GAqf3K60XoipD9Dlpj9feIYbhqPn68my7UyS65yyVEtb
         eoJotTOB2VLEXXWKPgElMml9ID4xi1N60QR7cvA33xOWzKUMVRsABzDWXbfXjYkX0Ft/
         cU7EpJsO8FHnVHAdFsE3APIyuE+VMLw7fLsyBKfZZd0Hvw9H3tZq2Y1ncuUxVRx1kCzk
         ggswAX2VedxL1djk7WwJr9S0TsimrgQLJ7cduY1gILMcOGTNGgliiePv11Ah+lI7KY+e
         rX2w==
X-Gm-Message-State: APjAAAWBv/jnEgnjQRJswedeGXFFYbRd6p+AivfSBkj+aXpaRGIFx1lD
        x9nT6esIy3oF82SkKy5wIVU=
X-Google-Smtp-Source: APXvYqwqFr4h3LasP+XLgrOCuHThAVepCGECBX6Wbxnwn5oAu/fVhwaE63/A28aEDyOvT3GAzQnuTQ==
X-Received: by 2002:adf:cf02:: with SMTP id o2mr16943806wrj.352.1565268754588;
        Thu, 08 Aug 2019 05:52:34 -0700 (PDT)
Received: from [10.43.17.10] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g25sm2386442wmk.18.2019.08.08.05.52.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 05:52:33 -0700 (PDT)
Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
 <MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
 <MN2PR20MB2973A02FC4D6F1D11BA80792CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8fgg=gt4LSnCfShnf0-PZ=B1TNwM3zdQr+V6hkozgDOA@mail.gmail.com>
 <MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190808083059.GB5319@sol.localdomain>
 <MN2PR20MB297328E243D74E03C1EF54ACCAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <67b4f0ee-b169-8af4-d7af-1c53a66ba587@gmail.com>
Date:   Thu, 8 Aug 2019 14:52:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <MN2PR20MB297328E243D74E03C1EF54ACCAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/08/2019 11:31, Pascal Van Leeuwen wrote:
>> -----Original Message-----
>> From: Eric Biggers <ebiggers@kernel.org>
>> Sent: Thursday, August 8, 2019 10:31 AM
>> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-crypto@vger.kernel.org;
>> herbert@gondor.apana.org.au; agk@redhat.com; snitzer@redhat.com; dm-devel@redhat.com;
>> gmazyland@gmail.com
>> Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
>>
>> On Wed, Aug 07, 2019 at 04:14:22PM +0000, Pascal Van Leeuwen wrote:
>>>>>> In your case, we are not dealing with known plaintext attacks,
>>>>>>
>>>>> Since this is XTS, which is used for disk encryption, I would argue
>>>>> we do! For the tweak encryption, the sector number is known plaintext,
>>>>> same as for EBOIV. Also, you may be able to control data being written
>>>>> to the disk encrypted, either directly or indirectly.
>>>>> OK, part of the data into the CTS encryption will be previous ciphertext,
>>>>> but that may be just 1 byte with the rest being the known plaintext.
>>>>>
>>>>
>>>> The tweak encryption uses a dedicated key, so leaking it does not have
>>>> the same impact as it does in the EBOIV case.
>>>>
>>> Well ... yes and no. The spec defines them as seperately controllable -
>>> deviating from the original XEX definition - but in most practicle use cases
>>> I've seen, the same key is used for both, as having 2 keys just increases
>>> key  storage requirements and does not actually improve effective security
>>> (of the algorithm itself, implementation peculiarities like this one aside
>>> :-), as  XEX has been proven secure using a single key. And the security
>>> proof for XTS actually builds on that while using 2 keys deviates from it.
>>>
>>
>> This is a common misconception.  Actually, XTS needs 2 distinct keys to be a
>> CCA-secure tweakable block cipher, due to another subtle difference from XEX:
>> XEX (by which I really mean "XEX[E,2]") builds the sequence of masks starting
>> with x^1, while XTS starts with x^0.  If only 1 key is used, the inclusion of
>> the 0th power in XTS allows the attack described in Section 6 of the XEX paper
>> (https://web.cs.ucdavis.edu/~rogaway/papers/offsets.pdf).
>>
> Interesting ... I'm not a cryptographer, just a humble HW engineer specialized
> in implementing crypto. I'm basing my views mostly on the Liskov/Minematsu
> "Comments on XTS", who assert that using 2 keys in XTS was misguided. 
> (and I never saw any follow-on comments asserting that this view was wrong ...)
> On not avoiding j=0 in the XTS spec they actually comment:
> "This difference is significant in security, but has no impact on effectiveness 
> for practical applications.", which I read as "not relevant for normal use".
> 
> In any case, it's frequently *used* with both keys being equal for performance
> and key storage reasons.

There is already check in kernel for XTS "weak" keys (tweak and encryption keys must not be the same).
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/crypto/xts.h#n27

For now it applies only in FIPS mode... (and if I see correctly it is duplicated in all drivers).

Milan
