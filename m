Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C315C4363D
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 13:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C8B2344C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 13:27:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nfSKHQCQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgIXN1o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Sep 2020 09:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbgIXN1n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Sep 2020 09:27:43 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD7AC0613CE;
        Thu, 24 Sep 2020 06:27:43 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so3811602wrx.7;
        Thu, 24 Sep 2020 06:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r3I1mnQai1mfPIplSYmD+NC34SGQg41LS6zGJe1bzqY=;
        b=nfSKHQCQVgjApwvRMzVFj3ikULKjIzhUqiRV475V6YcrXuN5JV+douN8stw3Aapq7p
         fozMiSMMtYIHryiD3is/iGYBq8v+HBQbvdSeTv4T6AwBv8iyiI1xjnn+61ZozaWd5Zyy
         ULoIoDv2AwFWPfJLBRRaJe1TZWAXfn5RzUq6+NlvvrPtXNvmm7vvGDkx1rD9NQF9Ymq2
         2VO+6vLHcABbhyKSrH3NBexpgNg2u/6GVsjhVeyB8ksBmX7oCWBu5Gjog3zB/zOP1ZjX
         ZJ/RZevSSYS3hXQkQJ/sU4iJQ8GQp0YPE7L9Kn8lbq1WhrT5lvX2sCgpMFBC3r/jYWbi
         RHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r3I1mnQai1mfPIplSYmD+NC34SGQg41LS6zGJe1bzqY=;
        b=cPWAG7X1tnS8VXPIS0dqmZ4UEKIfVgpIKQR7QWtt4x06nyvjaIfLgFlr8UmhN3kUuu
         CiqTvYchWEq53KlsS4pJ3pA6wpLHW67XAD+/1wkOdV/coQwCIkDl2A+210IeXOzijXSA
         NXmz55e0y7cMUusMD/6cMFkqIgyTmIlGNRXhWyHRxQoTf4M1LL9xQoBwKjJlJUgmWIgW
         qcK5evIGF3LKk4OAtwzdlLBG2ljxrm2JGA4Rtrd2+kCLpJ19GLOmNMghea/N6PKu08yP
         FnnKDJaz+eTJnLOkz0OgwFxOFDeAS0bYdYmg3wq2eCjGhoPvy8NxZHYpvezYTHyZXeoa
         0Xjw==
X-Gm-Message-State: AOAM533WDduSTf4l/1HWNaWZNXoLHZ9aMrtlgzeC3MCbvhtTnmby5mcP
        NQhF3t3BLcZvf8q29P8+y58=
X-Google-Smtp-Source: ABdhPJx9S4j4bPl7OFbUDbVSzOgef6QlHCjyMQskW1omVTbmskMTtFRy6SoHeZ7uPJf7AxCSt0OPwA==
X-Received: by 2002:a5d:4c4c:: with SMTP id n12mr5110273wrt.162.1600954061530;
        Thu, 24 Sep 2020 06:27:41 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id u126sm4351883wmu.9.2020.09.24.06.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 06:27:40 -0700 (PDT)
Date:   Thu, 24 Sep 2020 15:27:38 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [v2 PATCH] crypto: sun4i-ss - Fix sparse endianness markers
Message-ID: <20200924132738.GA24386@Red>
References: <202009061621.J89kO43Q%lkp@intel.com>
 <20200907062400.GA15841@gondor.apana.org.au>
 <20200907160029.GC11894@Red>
 <20200908050036.GA19817@gondor.apana.org.au>
 <20200910122248.GA22506@Red>
 <20200911041354.GA5275@gondor.apana.org.au>
 <20200914104058.GA14265@Red>
 <20200924030859.GA8223@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924030859.GA8223@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 24, 2020 at 01:08:59PM +1000, Herbert Xu wrote:
> On Mon, Sep 14, 2020 at 12:40:58PM +0200, Corentin Labbe wrote:
> >
> > I got this on next-20200910/multi_v7_defconfig BigEndian
> > [   12.137856] alg: hash: skipping comparison tests for md5-sun4i-ss because md5-generic is unavailable
> > md5-sun4i-ss md5 reqs=763
> > [   98.286632] alg: ahash: md5 test failed (wrong result) on test vector \"random: psize=65 ksize=0\", cfg=\"random: use_finup src_divs=[95.28%@+1052, <reimport>0.61%@+4046, 0.87%@+24, <reimport,nosimd>3.24%@+542] key_offset=54\"
> > 
> > So sun4i-ss is not involved.
> > Strangely /proc/crypto show:
> > name         : md5                                                                                  
> > driver       : md5-generic                                                                          
> > module       : md5                                                                                  
> > priority     : 0                                                                                    
> > refcnt       : 1                                                                                    
> > selftest     : passed                                                                               
> > internal     : no                                                                                   
> > type         : shash                                                                                
> > blocksize    : 64                                                                                   
> > digestsize   : 16
> > 
> > and I didnt see anything failed/unknow in /proc/crypto
> > 
> > Why the failed algorithm is not visible ?
> 
> Please include the complete /proc/crypto after you get the error.
> 

Hello

This is an example on next-20200923+BigEndian
alg: ahash: sha1 test failed (wrong result) on test vector \"random: psize=194 ksize=0\", cfg=\"random: inplace may_sleep use_finup src_divs=[98.25%@+1124, <flush>1.75%@+5] iv_offset=18\"

=== DUMP /proc/crypto ===
name         : ctr(sm4)
driver       : ctr(sm4-generic)
module       : ctr
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 16
max keysize  : 16
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : cbc(sm4)
driver       : cbc(sm4-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 16
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : ecb(sm4)
driver       : ecb(sm4-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 16
ivsize       : 0
chunksize    : 16
walksize     : 16
name         : sm4
driver       : sm4-generic
module       : sm4_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 16
name         : authenc(hmac(sha512),cbc(des3_ede))
driver       : authenc(hmac(sha512-generic),cbc(des3_ede-generic))
module       : authenc
priority     : 1100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 64
geniv        : <none>
name         : authenc(hmac(sha512),cbc(des3_ede))
driver       : authenc(hmac(sha512-generic),cbc-des3-sun4i-ss)
module       : authenc
priority     : 3100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 64
geniv        : <none>
name         : authenc(hmac(sha512),cbc(des))
driver       : authenc(hmac(sha512-generic),cbc(des-generic))
module       : authenc
priority     : 1100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 64
geniv        : <none>
name         : authenc(hmac(sha512),cbc(des))
driver       : authenc(hmac(sha512-generic),cbc-des-sun4i-ss)
module       : authenc
priority     : 3100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 64
geniv        : <none>
name         : authenc(hmac(sha384),cbc(des3_ede))
driver       : authenc(hmac(sha384-generic),cbc(des3_ede-generic))
module       : authenc
priority     : 1100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 48
geniv        : <none>
name         : authenc(hmac(sha384),cbc(des3_ede))
driver       : authenc(hmac(sha384-generic),cbc-des3-sun4i-ss)
module       : authenc
priority     : 3100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 48
geniv        : <none>
name         : authenc(hmac(sha384),cbc(des))
driver       : authenc(hmac(sha384-generic),cbc(des-generic))
module       : authenc
priority     : 1100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 48
geniv        : <none>
name         : authenc(hmac(sha384),cbc(des))
driver       : authenc(hmac(sha384-generic),cbc-des-sun4i-ss)
module       : authenc
priority     : 3100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 48
geniv        : <none>
name         : authenc(hmac(sha256),cbc(des3_ede))
driver       : authenc(hmac(sha256-generic),cbc(des3_ede-generic))
module       : authenc
priority     : 1100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 32
geniv        : <none>
name         : authenc(hmac(sha256),cbc(des3_ede))
driver       : authenc(hmac(sha256-generic),cbc-des3-sun4i-ss)
module       : authenc
priority     : 3100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 32
geniv        : <none>
name         : authenc(hmac(sha256),cbc(des))
driver       : authenc(hmac(sha256-generic),cbc(des-generic))
module       : authenc
priority     : 1100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 32
geniv        : <none>
name         : authenc(hmac(sha256),cbc(des))
driver       : authenc(hmac(sha256-generic),cbc-des-sun4i-ss)
module       : authenc
priority     : 3100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 32
geniv        : <none>
name         : authenc(hmac(sha224),cbc(des3_ede))
driver       : authenc(hmac(sha224-generic),cbc(des3_ede-generic))
module       : authenc
priority     : 1100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 28
geniv        : <none>
name         : authenc(hmac(sha224),cbc(des3_ede))
driver       : authenc(hmac(sha224-generic),cbc-des3-sun4i-ss)
module       : authenc
priority     : 3100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 28
geniv        : <none>
name         : authenc(hmac(sha224),cbc(des))
driver       : authenc(hmac(sha224-generic),cbc(des-generic))
module       : authenc
priority     : 1100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 28
geniv        : <none>
name         : authenc(hmac(sha224),cbc(des))
driver       : authenc(hmac(sha224-generic),cbc-des-sun4i-ss)
module       : authenc
priority     : 3100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 28
geniv        : <none>
name         : authenc(hmac(sha1),cbc(des3_ede))
driver       : authenc(hmac(sha1-generic),cbc(des3_ede-generic))
module       : authenc
priority     : 1100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 20
geniv        : <none>
name         : authenc(hmac(sha1),cbc(des3_ede))
driver       : authenc(hmac(sha1-generic),cbc-des3-sun4i-ss)
module       : authenc
priority     : 3100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 20
geniv        : <none>
name         : authenc(hmac(sha1),cbc(des))
driver       : authenc(hmac(sha1-generic),cbc(des-generic))
module       : authenc
priority     : 1100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 20
geniv        : <none>
name         : authenc(hmac(sha1),cbc(des))
driver       : authenc(hmac(sha1-generic),cbc-des-sun4i-ss)
module       : authenc
priority     : 3100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 8
ivsize       : 8
maxauthsize  : 20
geniv        : <none>
name         : authenc(hmac(sha1),ecb(cipher_null))
driver       : authenc(hmac(sha1-generic),ecb(cipher_null-generic))
module       : authenc
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 1
ivsize       : 0
maxauthsize  : 20
geniv        : <none>
name         : authenc(hmac(sha1),ecb(cipher_null))
driver       : authenc(hmac(sha1-generic),ecb-cipher_null)
module       : authenc
priority     : 1100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 1
ivsize       : 0
maxauthsize  : 20
geniv        : <none>
name         : authenc(hmac(md5),ecb(cipher_null))
driver       : authenc(hmac(md5-generic),ecb(cipher_null-generic))
module       : authenc
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 1
ivsize       : 0
maxauthsize  : 16
geniv        : <none>
name         : ecb(cipher_null)
driver       : ecb(cipher_null-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 0
max keysize  : 0
ivsize       : 0
chunksize    : 1
walksize     : 1
name         : authenc(hmac(md5),ecb(cipher_null))
driver       : authenc(hmac(md5-generic),ecb-cipher_null)
module       : authenc
priority     : 1000
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 1
ivsize       : 0
maxauthsize  : 16
geniv        : <none>
name         : authenc(hmac(sha1),cbc(aes))
driver       : authenc(hmac(sha1-generic),cbc(aes-generic))
module       : authenc
priority     : 1100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 16
ivsize       : 16
maxauthsize  : 20
geniv        : <none>
name         : authenc(hmac(sha1),cbc(aes))
driver       : authenc(hmac(sha1-generic),cbc-aes-sun4i-ss)
module       : authenc
priority     : 3100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 16
ivsize       : 16
maxauthsize  : 20
geniv        : <none>
name         : cmac(des3_ede)
driver       : cmac(des3_ede-generic)
module       : cmac
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 8
digestsize   : 8
name         : cmac(aes)
driver       : cmac(aes-generic)
module       : cmac
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 16
digestsize   : 16
name         : rfc4543(gcm(aes))
driver       : rfc4543(gcm_base(ctr(aes-generic),ghash-generic))
module       : gcm
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : <none>
name         : rfc4106(gcm(aes))
driver       : rfc4106(gcm_base(ctr(aes-generic),ghash-generic))
module       : gcm
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : <none>
name         : hmac(streebog512)
driver       : hmac(streebog512-generic)
module       : hmac
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 64
name         : hmac(streebog256)
driver       : hmac(streebog256-generic)
module       : hmac
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 32
name         : hmac(sha3-512)
driver       : hmac(sha3-512-generic)
module       : hmac
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 72
digestsize   : 64
name         : hmac(sha3-384)
driver       : hmac(sha3-384-generic)
module       : hmac
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 104
digestsize   : 48
name         : hmac(sha3-256)
driver       : hmac(sha3-256-generic)
module       : hmac
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 136
digestsize   : 32
name         : hmac(sha3-224)
driver       : hmac(sha3-224-generic)
module       : hmac
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 144
digestsize   : 28
name         : vmac64(aes)
driver       : vmac64(aes-generic)
module       : vmac
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 16
digestsize   : 8
name         : hmac(rmd160)
driver       : hmac(rmd160-generic)
module       : hmac
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 20
name         : hmac(rmd128)
driver       : hmac(rmd128-generic)
module       : hmac
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 16
name         : xcbc(aes)
driver       : xcbc(aes-generic)
module       : xcbc
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 16
digestsize   : 16
name         : hmac(sha224)
driver       : hmac(sha224-generic)
module       : hmac
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 28
name         : hmac(sha512)
driver       : hmac(sha512-generic)
module       : hmac
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 128
digestsize   : 64
name         : hmac(sha384)
driver       : hmac(sha384-generic)
module       : hmac
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 128
digestsize   : 48
name         : hmac(sha256)
driver       : hmac(sha256-generic)
module       : hmac
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 32
name         : hmac(sha1)
driver       : hmac(sha1-generic)
module       : hmac
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 20
name         : hmac(md5)
driver       : hmac(md5-generic)
module       : hmac
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 16
name         : streebog512
driver       : streebog512-generic
module       : streebog_generic
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 64
name         : streebog256
driver       : streebog256-generic
module       : streebog_generic
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 32
name         : sm3
driver       : sm3-generic
module       : sm3_generic
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 32
name         : sha3-512
driver       : sha3-512-generic
module       : sha3_generic
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 72
digestsize   : 64
name         : sha3-384
driver       : sha3-384-generic
module       : sha3_generic
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 104
digestsize   : 48
name         : sha3-256
driver       : sha3-256-generic
module       : sha3_generic
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 136
digestsize   : 32
name         : sha3-224
driver       : sha3-224-generic
module       : sha3_generic
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 144
digestsize   : 28
name         : crct10dif
driver       : crct10dif-generic
module       : crct10dif_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 1
digestsize   : 2
name         : rfc4309(ccm(aes))
driver       : rfc4309(ccm_base(ctr(aes-generic),cbcmac(aes-generic)))
module       : ccm
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 1
ivsize       : 8
maxauthsize  : 16
geniv        : <none>
name         : ecb(seed)
driver       : ecb(seed-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 16
ivsize       : 0
chunksize    : 16
walksize     : 16
name         : seed
driver       : seed-generic
module       : seed
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 16
name         : rmd320
driver       : rmd320-generic
module       : rmd320
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 40
name         : rmd256
driver       : rmd256-generic
module       : rmd256
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 32
name         : rmd160
driver       : rmd160-generic
module       : rmd160
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 20
name         : rmd128
driver       : rmd128-generic
module       : rmd128
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 16
name         : cts(cbc(aes))
driver       : cts(cbc(aes-generic))
module       : cts
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : cts(cbc(aes))
driver       : cts(cbc-aes-sun4i-ss)
module       : cts
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : ccm(aes)
driver       : ccm_base(ctr(aes-generic),cbcmac(aes-generic))
module       : ccm
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 1
ivsize       : 16
maxauthsize  : 16
geniv        : <none>
name         : cbcmac(aes)
driver       : cbcmac(aes-generic)
module       : ccm
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 1
digestsize   : 16
name         : lzo
driver       : lzo-scomp
module       : lzo
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : scomp
name         : lzo
driver       : lzo-generic
module       : lzo
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : compression
name         : gcm(aes)
driver       : gcm_base(ctr(aes-generic),ghash-generic)
module       : gcm
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : aead
async        : no
blocksize    : 1
ivsize       : 12
maxauthsize  : 16
geniv        : <none>
name         : ghash
driver       : ghash-generic
module       : ghash_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 16
digestsize   : 16
name         : salsa20
driver       : salsa20-generic
module       : salsa20_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 8
chunksize    : 64
walksize     : 64
name         : xts(camellia)
driver       : xts(ecb(camellia-generic))
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : lrw(camellia)
driver       : lrw(ecb(camellia-generic))
module       : lrw
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 48
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : ctr(camellia)
driver       : ctr(camellia-generic)
module       : ctr
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : cbc(camellia)
driver       : cbc(camellia-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : ecb(camellia)
driver       : ecb(camellia-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
chunksize    : 16
walksize     : 16
name         : camellia
driver       : camellia-generic
module       : camellia_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
name         : pcbc(fcrypt)
driver       : pcbc(fcrypt-generic)
module       : pcbc
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 8
chunksize    : 8
walksize     : 8
name         : fcrypt
driver       : fcrypt-generic
module       : fcrypt
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 8
min keysize  : 8
max keysize  : 8
name         : ecb(xeta)
driver       : ecb(xeta-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 16
max keysize  : 16
ivsize       : 0
chunksize    : 8
walksize     : 8
name         : tgr128
driver       : tgr128-generic
module       : tgr192
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 16
name         : tgr160
driver       : tgr160-generic
module       : tgr192
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 20
name         : tgr192
driver       : tgr192-generic
module       : tgr192
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 24
name         : cbc(anubis)
driver       : cbc(anubis-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 40
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : ecb(anubis)
driver       : ecb(anubis-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 40
ivsize       : 0
chunksize    : 16
walksize     : 16
name         : anubis
driver       : anubis-generic
module       : anubis
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 40
name         : ecb(tnepres)
driver       : ecb(tnepres-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 0
max keysize  : 32
ivsize       : 0
chunksize    : 16
walksize     : 16
name         : wp256
driver       : wp256-generic
module       : wp512
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 32
name         : wp384
driver       : wp384-generic
module       : wp512
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 48
name         : wp512
driver       : wp512-generic
module       : wp512
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 64
name         : ecb(khazad)
driver       : ecb(khazad-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 16
max keysize  : 16
ivsize       : 0
chunksize    : 8
walksize     : 8
name         : khazad
driver       : khazad-generic
module       : khazad
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16
name         : ecb(xtea)
driver       : ecb(xtea-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 16
max keysize  : 16
ivsize       : 0
chunksize    : 8
walksize     : 8
name         : ecb(tea)
driver       : ecb(tea-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 16
max keysize  : 16
ivsize       : 0
chunksize    : 8
walksize     : 8
name         : xeta
driver       : xeta-generic
module       : tea
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16
name         : xtea
driver       : xtea-generic
module       : tea
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16
name         : tea
driver       : tea-generic
module       : tea
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 8
min keysize  : 16
max keysize  : 16
name         : michael_mic
driver       : michael_mic-generic
module       : michael_mic
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 8
digestsize   : 8
name         : ecb(arc4)
driver       : ecb(arc4)-generic
module       : arc4
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 1
max keysize  : 256
ivsize       : 0
chunksize    : 1
walksize     : 1
name         : xts(cast6)
driver       : xts(ecb(cast6-generic))
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : lrw(cast6)
driver       : lrw(ecb(cast6-generic))
module       : lrw
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 48
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : ctr(cast6)
driver       : ctr(cast6-generic)
module       : ctr
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : cbc(cast6)
driver       : cbc(cast6-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : ecb(cast6)
driver       : ecb(cast6-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
chunksize    : 16
walksize     : 16
name         : cast6
driver       : cast6-generic
module       : cast6_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
name         : ctr(cast5)
driver       : ctr(cast5-generic)
module       : ctr
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 5
max keysize  : 16
ivsize       : 8
chunksize    : 8
walksize     : 8
name         : cbc(cast5)
driver       : cbc(cast5-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 5
max keysize  : 16
ivsize       : 8
chunksize    : 8
walksize     : 8
name         : ecb(cast5)
driver       : ecb(cast5-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 5
max keysize  : 16
ivsize       : 0
chunksize    : 8
walksize     : 8
name         : cast5
driver       : cast5-generic
module       : cast5_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 8
min keysize  : 5
max keysize  : 16
name         : zlib-deflate
driver       : zlib-deflate-scomp
module       : deflate
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : scomp
name         : deflate
driver       : deflate-scomp
module       : deflate
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : scomp
name         : deflate
driver       : deflate-generic
module       : deflate
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : compression
name         : sha384
driver       : sha384-generic
module       : sha512_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 128
digestsize   : 48
name         : sha512
driver       : sha512-generic
module       : sha512_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 128
digestsize   : 64
name         : cfb(aes)
driver       : cfb(aes-generic)
module       : cfb
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : ofb(aes)
driver       : ofb(aes-generic)
module       : ofb
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : rfc3686(ctr(aes))
driver       : rfc3686(ctr(aes-generic))
module       : ctr
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 20
max keysize  : 36
ivsize       : 8
chunksize    : 16
walksize     : 16
name         : ctr(aes)
driver       : ctr(aes-generic)
module       : ctr
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : xts(aes)
driver       : xts(ecb(aes-generic))
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : xts(aes)
driver       : xts(ecb-aes-sun4i-ss)
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : lrw(aes)
driver       : lrw(ecb(aes-generic))
module       : lrw
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 48
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : lrw(aes)
driver       : lrw(ecb-aes-sun4i-ss)
module       : lrw
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 48
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : xts(serpent)
driver       : xts(ecb(serpent-generic))
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 0
max keysize  : 64
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : lrw(serpent)
driver       : lrw(ecb(serpent-generic))
module       : lrw
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 48
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : ctr(serpent)
driver       : ctr(serpent-generic)
module       : ctr
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 0
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : cbc(serpent)
driver       : cbc(serpent-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 0
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : ecb(serpent)
driver       : ecb(serpent-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 0
max keysize  : 32
ivsize       : 0
chunksize    : 16
walksize     : 16
name         : tnepres
driver       : tnepres-generic
module       : serpent_generic
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 16
min keysize  : 0
max keysize  : 32
name         : serpent
driver       : serpent-generic
module       : serpent_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 16
min keysize  : 0
max keysize  : 32
name         : xts(twofish)
driver       : xts(ecb(twofish-generic))
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : lrw(twofish)
driver       : lrw(ecb(twofish-generic))
module       : lrw
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 48
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : ctr(twofish)
driver       : ctr(twofish-generic)
module       : ctr
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : cbc(twofish)
driver       : cbc(twofish-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : ecb(twofish)
driver       : ecb(twofish-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
chunksize    : 16
walksize     : 16
name         : twofish
driver       : twofish-generic
module       : twofish_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
name         : ctr(blowfish)
driver       : ctr(blowfish-generic)
module       : ctr
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 4
max keysize  : 56
ivsize       : 8
chunksize    : 8
walksize     : 8
name         : cbc(blowfish)
driver       : cbc(blowfish-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 4
max keysize  : 56
ivsize       : 8
chunksize    : 8
walksize     : 8
name         : ecb(blowfish)
driver       : ecb(blowfish-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 4
max keysize  : 56
ivsize       : 0
chunksize    : 8
walksize     : 8
name         : blowfish
driver       : blowfish-generic
module       : blowfish_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 8
min keysize  : 4
max keysize  : 56
name         : sha224
driver       : sha224-generic
module       : sha256_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 28
name         : sha256
driver       : sha256-generic
module       : sha256_generic
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 32
name         : md4
driver       : md4-generic
module       : md4
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 16
name         : ctr(des3_ede)
driver       : ctr(des3_ede-generic)
module       : ctr
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 24
max keysize  : 24
ivsize       : 8
chunksize    : 8
walksize     : 8
name         : ctr(des)
driver       : ctr(des-generic)
module       : ctr
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 8
max keysize  : 8
ivsize       : 8
chunksize    : 8
walksize     : 8
name         : stdrng
driver       : sun4i_ss_rng
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : rng
seedsize     : 24
name         : ecb(des3_ede)
driver       : ecb(des3_ede-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 24
max keysize  : 24
ivsize       : 0
chunksize    : 8
walksize     : 8
name         : ecb(des3_ede)
driver       : ecb-des3-sun4i-ss
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 24
max keysize  : 24
ivsize       : 0
chunksize    : 8
walksize     : 8
name         : cbc(des3_ede)
driver       : cbc(des3_ede-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 24
max keysize  : 24
ivsize       : 8
chunksize    : 8
walksize     : 8
name         : cbc(des3_ede)
driver       : cbc-des3-sun4i-ss
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 24
max keysize  : 24
ivsize       : 8
chunksize    : 8
walksize     : 8
name         : ecb(des)
driver       : ecb(des-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 0
chunksize    : 8
walksize     : 8
name         : ecb(des)
driver       : ecb-des-sun4i-ss
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 0
chunksize    : 8
walksize     : 8
name         : cbc(des)
driver       : cbc(des-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 8
chunksize    : 8
walksize     : 8
name         : cbc(des)
driver       : cbc-des-sun4i-ss
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 8
chunksize    : 8
walksize     : 8
name         : ecb(aes)
driver       : ecb(aes-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
chunksize    : 16
walksize     : 16
name         : ecb(aes)
driver       : ecb-aes-sun4i-ss
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
chunksize    : 16
walksize     : 16
name         : cbc(aes)
driver       : cbc(aes-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : cbc(aes)
driver       : cbc-aes-sun4i-ss
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
name         : sha1
driver       : sha1-sun4i-ss
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : no
blocksize    : 64
digestsize   : 20
name         : md5
driver       : md5-sun4i-ss
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : no
blocksize    : 64
digestsize   : 16
name         : stdrng
driver       : ansi_cprng
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : rng
seedsize     : 48
name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 1
digestsize   : 4
name         : aes
driver       : aes-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
name         : des3_ede
driver       : des3_ede-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 8
min keysize  : 24
max keysize  : 24
name         : des
driver       : des-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 8
min keysize  : 8
max keysize  : 8
name         : sha1
driver       : sha1-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 20
name         : md5
driver       : md5-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 16
name         : ecb(cipher_null)
driver       : ecb-cipher_null
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : no
blocksize    : 1
min keysize  : 0
max keysize  : 0
ivsize       : 0
chunksize    : 1
walksize     : 1
name         : digest_null
driver       : digest_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 1
digestsize   : 0
name         : compress_null
driver       : compress_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : compression
name         : cipher_null
driver       : cipher_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 1
min keysize  : 0
max keysize  : 0
=== END DUMP ===
