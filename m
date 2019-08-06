Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689FDC31E40
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 10:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D6AB20818
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 10:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NGNQ2izD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbfHFKnh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 06:43:37 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55254 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfHFKnh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 06:43:37 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so77656376wme.4
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 03:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W39mdygRmevkyJdX3phsZeuayUumsBZQtKvu/nZsbEo=;
        b=NGNQ2izDlK+401oSnhghSh/5gboxZvAjQhmvznjiGJWObAz1KHwuOCiajFVPd5mH6C
         F+VfXZ8Pbfo5gRhTlHJwDZC+nyVLmxrS9wl639C/lSN20/b9Wj9BytkM1HLVmtp7nXKq
         /CtXNe1eY2lDU2sAPKkCVXCJIq96hWBll+FM1DI173z/iphIhm8MHkYJeuKA3CqSihlH
         TF68vOVfCtCWys5dEEpqk+YngxRMzNWuun2wt/0UHi2BZ8Y4OSBm1Ym5SfvGP3TB9Dlx
         i9cPyjT8veO2GMBXAiaJWAptFs1Aj00LFS5supYmB0WnuKgUv0kaJbbgunxK78Z61+ni
         nqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W39mdygRmevkyJdX3phsZeuayUumsBZQtKvu/nZsbEo=;
        b=s+2d0dzLvtJCUxWeMNkBZ1xBP5NkFVIkuPw0pPfStCMP551cg//O84slTsbcLPu40t
         aXVpMb2nTYOhlFcI2n+W/p89l4CbUamuupNgHs+cxDFNItbzKZG8TLA1phBpamJkzHx/
         3h7ucW0MR2ew5CALIDhg9Edzx5n6nbcfhTjgqdxI+hx9ctCueI+zjbu6gM+DS6MrzmLQ
         slLPi1ryrwF5TuzTp4p5jXmVjVOKqE3kP4VSDUtnH7nR6M+u92k/4VcWcDzV4TuBEhgG
         QQgqcdfn/QDYimBarmfLzms8I1lIabMzZYARXySz1P4FAdRgHhmC839sOhKjVexgX1Dh
         U2lg==
X-Gm-Message-State: APjAAAWuNad2RaRn008YwabAD2bhC8cvU7EJkMcaOkYCGnDFqhCfJlOu
        TnFOmfiyKRUNT0Y7AuZHRp4=
X-Google-Smtp-Source: APXvYqybZlyyzNQJB5Mm/f8y4J3GBeKOWvL8vkkiPshrlDxObNTMCs8GsL1nIj+/mDHz+tyIhF1PQg==
X-Received: by 2002:a1c:dc46:: with SMTP id t67mr3790500wmg.159.1565088214709;
        Tue, 06 Aug 2019 03:43:34 -0700 (PDT)
Received: from [10.43.17.10] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y16sm185415950wrg.85.2019.08.06.03.43.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 03:43:34 -0700 (PDT)
Subject: Re: [RFC PATCH 2/2] md/dm-crypt - switch to AES library for EBOIV
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org, agk@redhat.com,
        snitzer@redhat.com, dm-devel@redhat.com
References: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
 <20190806080234.27998-3-ard.biesheuvel@linaro.org>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <22f5bfd5-7563-b85b-925e-6d46e7584966@gmail.com>
Date:   Tue, 6 Aug 2019 12:43:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190806080234.27998-3-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 06/08/2019 10:02, Ard Biesheuvel wrote:
> The EBOIV IV mode reuses the same AES encryption key that is used for
> encrypting the data, and uses it to perform a single block encryption
> of the byte offset to produce the IV.
> 
> Since table-based AES is known to be susceptible to known-plaintext
> attacks on the key, and given that the same key is used to encrypt
> the byte offset (which is known to an attacker), we should be
> careful not to permit arbitrary instantiations where the allocated
> AES cipher is provided by aes-generic or other table-based drivers
> that are known to be time variant and thus susceptible to this kind
> of attack.
> 
> Instead, let's switch to the new AES library, which has a D-cache
> footprint that is only 1/32th of the generic AES driver, and which
> contains some mitigations to reduce the timing variance even further.

NACK.

We discussed here that we will not limit combinations inside dm-crypt.
For generic crypto API, this policy should be different, but I really
do not want these IVs to be visible outside of dm-crypt.

Allowing arbitrary combinations of a cipher, mode, and IV is how dm-crypt
works since the beginning, and I really do not see the reason to change it.

This IV mode is intended to be used for accessing old BitLocker images,
so I do not care about performance much.

Thanks,
Milan
