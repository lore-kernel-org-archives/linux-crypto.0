Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5FCC43441
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Nov 2018 01:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF31120840
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Nov 2018 01:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF31120840
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.us
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbeKIKoM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Nov 2018 05:44:12 -0500
Received: from mout.gmx.net ([212.227.17.22]:42995 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727229AbeKIKoM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 05:44:12 -0500
Received: from [192.168.1.153] ([74.104.183.64]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MOjMY-1gOkjR3PWA-006A9i; Fri, 09
 Nov 2018 02:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Subject: Re: [PATCH] crypto/simd: correctly take reqsize of wrapped skcipher
 into account
From:   Qian Cai <cai@gmx.us>
In-Reply-To: <CAKv+Gu_7M+A5OiCOsOd7_e5+GH7VkrOZ33iSexd2oacyzUNKEA@mail.gmail.com>
Date:   Thu, 8 Nov 2018 20:05:48 -0500
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Transfer-Encoding: 8BIT
Message-Id: <873FB29E-8809-4B3E-AE62-F5076BBCBCEC@gmx.us>
References: <20181108225516.9967-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu_7M+A5OiCOsOd7_e5+GH7VkrOZ33iSexd2oacyzUNKEA@mail.gmail.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
X-Mailer: Apple Mail (2.3445.100.39)
X-Provags-ID: V03:K1:6vFgdSQHBMkHHInCO9Eg3tzF5dpimI9k5fv5NnSGcv8aWZ3/9Rz
 wI27F6tuv4R+9xEk7rhsKR42r2h5Jdk+CfXXHUSLTnAB0Imup/ojnPxSs7a1Gfi+HcxTHPX
 o1e+TjemlZxtGPbKAO1bmGivCjwYkZhZ7DvFRNgMa1JqbvFLBDkiPJ7Tf3OuP0kZMG5Yb1X
 n/3SMv+xpS6rFjtqLp32A==
X-UI-Out-Filterresults: notjunk:1;V01:K0:lm1pXTqK8x0=:yB/xCEw8XVvUctdPED1JyK
 4PScMiKiSSKkeoBCbG9viJU3YRfZLdGJtiDczs3QzboY+k+aUqFiOsaW2iULrxFE/3YCtoeAR
 Ny9NtDbrTnXJK9zLoURppC5ZC/pc6h/us/dkhVpG8/iNkWBzPl1qR8zff+afRtODk1QoiXDZn
 j0kDK04We08/fbR4aqFoF5hlM0TMZm33SCLbpJ9aiJzJkmLXgBAAJ4bh81VRz0CQgDsqQTbkC
 RJVX6b8rEjoReZQ1W6D2SZFuArnQLReg50WkDw+i+x/VciGvbX5lk8HupQyfbwmgMFnp6gzis
 6f3f1O4WmRXxMfMkKDC2LS7r7vXaMGQME8EdeGMKfLSBY3Ld74YcD/vSt4cFlrOhky1m/tGOc
 B7KvkKjah4szvYd848pnjpO2Hbohw4jL9siJ5uZTYoqiTiS79Sne0yIC2xX4ZVYvfe6SjiCmX
 oncknqCMJWQvpCg6JFR72SZQ1J9bDpwdNoAAS7Yp4cRDS+1EZMJPVo3hlZIzoJ0hTWxQExtR6
 wpRGyUfw25l/S2XGFBN/MMH0fOHcKS+j5Nn+72TFV5Q1y4C9vWl5zHkuegP4XkanaKr0+PVzs
 VdVhtWma9CIFhNdricitwMQrEKiLcXXOkizG+NtxBh0NsZ9QzQkR3trVdhffMqGbw3Ni01iIP
 5T9iGtjwrVCS4syT+qxmeYhFDAVBDk3jI2v12PWT/aImut8OGTfdqAE+GHyflQ7MysYGUxVoR
 /26TzcO2Dqfhdm4mehQDw7JI6fEvYqy6IldgfDTW0Joz57VVvxMm38gcHDPGHMcUrljg70+Hg
 21Ot0ZpwW/QL6eD5BsJvvRwUH8kFMUkGahgaFpO1f7osh/ykKrXjhY9svsRuGpQM6nP/E8Da1
 keyCm+a7Jd4csL+6K8V11GpLQ0hv9+y4RHUxJJJQpeGIk5GGk4lBe67vVFuilx
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181109010548.QND-Qw_3hkiJPzouyCI_h0aHyZFOxKI-HkNJAEDYn6M@z>



> On Nov 8, 2018, at 6:33 PM, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> 
> On 8 November 2018 at 23:55, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> The simd wrapper's skcipher request context structure consists
>> of a single subrequest whose size is taken from the subordinate
>> skcipher. However, in simd_skcipher_init(), the reqsize that is
>> retrieved is not from the subordinate skcipher but from the
>> cryptd request structure, whose size is completely unrelated to
>> the actual wrapped skcipher.
>> 
>> Reported-by: Qian Cai <cai@gmx.us>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>> crypto/simd.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/crypto/simd.c b/crypto/simd.c
>> index ea7240be3001..2f3d6e897afc 100644
>> --- a/crypto/simd.c
>> +++ b/crypto/simd.c
>> @@ -125,7 +125,7 @@ static int simd_skcipher_init(struct crypto_skcipher *tfm)
>>        ctx->cryptd_tfm = cryptd_tfm;
>> 
>>        reqsize = sizeof(struct skcipher_request);
>> -       reqsize += crypto_skcipher_reqsize(&cryptd_tfm->base);
>> +       reqsize += crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm));
>> 
> 
> This should be
> 
> reqsize += max(crypto_skcipher_reqsize(&cryptd_tfm->base);
>       crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm)));
> 
> since the cryptd path in simd still needs some space in the subreq for
> the completion.
Tested-by: Qian Cai <cai@gmx.us>
