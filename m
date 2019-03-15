Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAB7C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D7FF2186A
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:24:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="oaHYdJGb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfCOEYl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 00:24:41 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42566 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfCOEYl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 00:24:41 -0400
Received: by mail-pf1-f195.google.com with SMTP id r15so2614530pfn.9
        for <linux-crypto@vger.kernel.org>; Thu, 14 Mar 2019 21:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Ns2BikTimGEvj26ADZRD9DW1O6qtk4kZmoPLUHoIyE8=;
        b=oaHYdJGbcL/e5pFQGi/YqJlyopqeZK7aSPQAPEMJM7FGBwodkFNIlkwbrJ7kIS70+H
         8Q8EmNLObLC3/UtRMMPH33vGtKLItzUntzBXhpzItUxouC6Lx0HqI7puROd7wctSktnT
         bGKOb/COx0Aq2mbBiLGwfl0NmrX7Jv3vWRjt8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Ns2BikTimGEvj26ADZRD9DW1O6qtk4kZmoPLUHoIyE8=;
        b=Vgp4yuWqfalqlnrhcHDYyXrrQyGkfOpfs8ubR+2Bi08uXYdhMt9snyq+rwh0xGBJ6C
         DHgfPoMcRF2IqhZdup1vyJ1gq/M9I+ct7SOUpr3g/cZgntnyhpfoZ063twgR1a1AOy8K
         qCp2szwwIW08oi3eKDOtX5VkViy4q96sPJ+N6Qmau0h5wn667ghBaoqiFPiWO1wGk+Y0
         vYxwdwZsFLIqiUAoYs9R/MkgrDQwoJr6+gavkY+JNnWsLueWaLmahFElb+Se/b9taEJt
         ZT0t/2dGxMzhIhosag6bjbKQm/BE7nct7nKt8whP+sNaznrcwPn8lFkT6cf8jnuVMuaP
         jU8w==
X-Gm-Message-State: APjAAAVFAt85LUILPLf7Ew1ojGX2v9PsOUD6JDwx15fqRF0z5PEmBkzE
        MFgOm/bJ3zEYiCyt2Nkc7uLSiw==
X-Google-Smtp-Source: APXvYqwWbnwSChy35tVzJGS+KlwlLNOVfU1P3UPtX/FUYAXf29sStZ4Wm0ZVcPhIMh4WqpnwXcQKBQ==
X-Received: by 2002:a17:902:2a89:: with SMTP id j9mr1385525plb.272.1552623880527;
        Thu, 14 Mar 2019 21:24:40 -0700 (PDT)
Received: from localhost (124-171-209-25.dyn.iinet.net.au. [124.171.209.25])
        by smtp.gmail.com with ESMTPSA id z6sm1323087pgo.31.2019.03.14.21.24.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 21:24:39 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     omosnacek@gmail.com, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
In-Reply-To: <20190315022414.GA1671@sol.localdomain>
References: <20190315020901.16509-1-dja@axtens.net> <20190315022414.GA1671@sol.localdomain>
Date:   Fri, 15 Mar 2019 15:24:35 +1100
Message-ID: <875zsku5mk.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

>> The original assembly imported from OpenSSL has two copy-paste
>> errors in handling CTR mode. When dealing with a 2 or 3 block tail,
>> the code branches to the CBC decryption exit path, rather than to
>> the CTR exit path.
>
> So does this need to be fixed in OpenSSL too?

Yes, I'm getting in touch with some people internally (at IBM) about
doing that.

>> This leads to corruption of the IV, which leads to subsequent blocks
>> being corrupted.
>>=20
>> This can be detected with libkcapi test suite, which is available at
>> https://github.com/smuellerDD/libkcapi
>>=20
>
> Is this also detected by the kernel's crypto self-tests, and if not why n=
ot?
> What about with the new option CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy?

It seems the self-tests do not catch it. To catch it, there has to be a
test where the blkcipher_walk creates a walk.nbytes such that
[(the number of AES blocks) mod 8] is either 2 or 3. This happens with
AF_ALG pretty frequently, but when I booted with self-tests it only hit
1, 4, 5, 6 and 7 - it missed 0, 2 and 3.

I don't have the EXTRA_TESTS option - I'm testing with 5.0-rc6. Is it in
-next?

Regards,
Daniel

>> Reported-by: Ondrej Mosn=C3=A1=C4=8Dek <omosnacek@gmail.com>
>> Fixes: 5c380d623ed3 ("crypto: vmx - Add support for VMS instructions by =
ASM")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Daniel Axtens <dja@axtens.net>
>> ---
>>  drivers/crypto/vmx/aesp8-ppc.pl | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-=
ppc.pl
>> index d6a9f63d65ba..de78282b8f44 100644
>> --- a/drivers/crypto/vmx/aesp8-ppc.pl
>> +++ b/drivers/crypto/vmx/aesp8-ppc.pl
>> @@ -1854,7 +1854,7 @@ Lctr32_enc8x_three:
>>  	stvx_u		$out1,$x10,$out
>>  	stvx_u		$out2,$x20,$out
>>  	addi		$out,$out,0x30
>> -	b		Lcbc_dec8x_done
>> +	b		Lctr32_enc8x_done
>>=20=20
>>  .align	5
>>  Lctr32_enc8x_two:
>> @@ -1866,7 +1866,7 @@ Lctr32_enc8x_two:
>>  	stvx_u		$out0,$x00,$out
>>  	stvx_u		$out1,$x10,$out
>>  	addi		$out,$out,0x20
>> -	b		Lcbc_dec8x_done
>> +	b		Lctr32_enc8x_done
>>=20=20
>>  .align	5
>>  Lctr32_enc8x_one:
>> --=20
>> 2.19.1
>>=20
