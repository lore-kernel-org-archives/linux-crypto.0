Return-Path: <SRS0=efdq=UO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8821EC31E50
	for <linux-crypto@archiver.kernel.org>; Sat, 15 Jun 2019 18:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F00E21841
	for <linux-crypto@archiver.kernel.org>; Sat, 15 Jun 2019 18:19:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hgqO/z1b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbfFOST0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 15 Jun 2019 14:19:26 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56023 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbfFOST0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Jun 2019 14:19:26 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so5404191wmj.5
        for <linux-crypto@vger.kernel.org>; Sat, 15 Jun 2019 11:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NeSR6GnrdqlIjdqD3lSHhsRl+Jd7829fRlrkgMWMgPs=;
        b=hgqO/z1b4Hx6SULrkZJIDlpNnoYvvGGS7AWkh9SO2NGoLojVNruj2KGEH8h9PLfFjX
         VDFT5DrK8tM/FRLNhUHfZupm8TD7FfuL15GEACUbIdSJV3/jern+dSAxmnunMUql0Yx1
         g/1PlHr63lr12IM2YnYZAMRjKusNAWBXX47U1Rysw0MXOAUKvJX65LYi0V2cMyY89Qu1
         Z9QVya8+CDWwF+GhCtwztFUjQawWna/4EuNzTwSnGI1QLCbh26m5RtXimNGfjgCfS6lt
         xvWQwtLu5dw7ILrP0Wt4uiYHuXRQDjdT1EExm5bnTdp5VjwyGPEzpEddkgkvMBV/bBXG
         iaJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NeSR6GnrdqlIjdqD3lSHhsRl+Jd7829fRlrkgMWMgPs=;
        b=JVeLIrn9EYMCjjkYpyaWukZxF0XLPa9o4sfrcRti7AET2Yv5fjqQx5nrFe+EbMk89t
         1hkXqBJgLaYOZjpU8wH32kExxD0pSJ3cVhiuduP9Y6jWs9JUPG+TCTWbR+vq4+6EKIQ6
         RkVWs6onzEN6HARzyhehPsAhuWm8AfoyUpu1/Wc0MhJnWt22eDhZUEAJ3V7leROSE3j4
         pQDIjKcl2vcyWdutAcCOXFgEznJ0sIHwXDcqbx2dFZ6I1pnFhOtaK038oMC0/xat3jvk
         hROpU70bksxGudRRiRmcb+753b/OrshdC+NaGz678Fts4f6tE9lJSyQ59ri4pd5pk9po
         N60w==
X-Gm-Message-State: APjAAAVRLF9V4Th36KqU+7hXImoeDMp7QsE1ZmOE17yYxuSFEH7Fl7ym
        6YtUgPYYQPfeQZ4Rq0xdvHY=
X-Google-Smtp-Source: APXvYqw/K+cFbhCT0NWMIXD+LYK92nb5mpf/Ry2WAxMHuJb3dpuPdrfgG+0oXd/KUVmRuPPLBOK6/w==
X-Received: by 2002:a1c:a783:: with SMTP id q125mr12930224wme.94.1560622764575;
        Sat, 15 Jun 2019 11:19:24 -0700 (PDT)
Received: from [192.168.1.158] ([178.17.7.30])
        by smtp.gmail.com with ESMTPSA id s7sm3021728wmc.2.2019.06.15.11.19.23
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 11:19:24 -0700 (PDT)
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <9cd635ec-970b-bd1b-59f4-1a07395e69a0@gmail.com>
Date:   Sat, 15 Jun 2019 20:19:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 14/06/2019 10:34, Ard Biesheuvel wrote:
> This series is presented as an RFC for a couple of reasons:
> - it is only build tested
> - it is unclear whether this is the right way to move away from the use of
>   bare ciphers in non-crypto code
> - we haven't really discussed whether moving away from the use of bare ciphers
>   in non-crypto code is a goal we agree on
> 
> This series creates an ESSIV shash template that takes a (cipher,hash) tuple,
> where the digest size of the hash must be a valid key length for the cipher.
> The setkey() operation takes the hash of the input key, and sets into the
> cipher as the encryption key. Digest operations accept input up to the
> block size of the cipher, and perform a single block encryption operation to
> produce the ESSIV output.
> 
> This matches what both users of ESSIV in the kernel do, and so it is proposed
> as a replacement for those, in patches #2 and #3.
> 
> As for the discussion: the code is untested, so it is presented for discussion
> only. I'd like to understand whether we agree that phasing out the bare cipher
> interface from non-crypto code is a good idea, and whether this approach is
> suitable for fscrypt and dm-crypt.

If you want some discussion, it would be very helpful if you cc device-mapper list
to reach dm-crypt developers. Please add at least dm-devel list.

Just a few comments:

 - ESSIV is useful only for CBC mode. I wish we move to some better mode
in the future instead of cementing CBC use... But if it helps people
to actually use unpredictable IV for CBC, it is the right approach.
(yes, I know XTS has own problems as well... but IMO that should be the default
for sector/fs-block encryption these days :)

- I do not think there is a problem if ESSIV moves to crypto API,
but there it is presented as a hash... It is really just an IV generator.

> - wiring up some essiv(x,y) combinations into the testing framework. I wonder
>   if anything other than essiv(aes,sha256) makes sense.

In cryptsetup testsuite, we test serpent and twofish ciphers at least, but in
reality, essiv(aes,sha256) is the most used combination.
If it makes sense, I can run some tests with dm-crypt and this patchset.

Thanks,
Milan
