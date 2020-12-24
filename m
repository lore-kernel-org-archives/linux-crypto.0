Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA04C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Dec 2020 09:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EF1B224B1
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Dec 2020 09:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgLXJeJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Dec 2020 04:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgLXJeI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Dec 2020 04:34:08 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F69BC06179C
        for <linux-crypto@vger.kernel.org>; Thu, 24 Dec 2020 01:33:28 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id q75so1171397wme.2
        for <linux-crypto@vger.kernel.org>; Thu, 24 Dec 2020 01:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4XfVxxDWXarYzvcm/E8/0oqF+lQgHrMQTnHY7kOdbxU=;
        b=axpvuOY9nFCk9VLhGK4sRl15qfMpZgnJgt0E1KA68xlu4peINsnUTnnatLWFrk4bEu
         9A/vZ7J1JKJWA88F0EOHwSu9IeZmTBkkhn0lHBi/jibKYm9pLr72Wy0BrbVrE0S8K3aM
         5OvPrn3vZFc/4I8ZTGdjEiJdDAZr2v4baEL0Yi7ZiUAvmPtNDc6Ny5cON1V12Z1V80G0
         /ggPI5g1OVp/boOyZaANdjKNd0W9ZMjFKN2q1Y2YRf9ou3v2J3KNuMpilDnOhOM/44ln
         wTa19Wa9atlf5BHqKf6mHRtz3Gnd9bIWhzIL92INFHvEEq/WPNJgyC2/eN+vaqIk0vDz
         8bTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4XfVxxDWXarYzvcm/E8/0oqF+lQgHrMQTnHY7kOdbxU=;
        b=tjzVnnr0c213epeXWWx3U9BPuyedlC032FKuDCDPvSWQa9CUrX53WOH96Irj1c7vzZ
         0eTkwpRhTbl5WclKk7+ZeliB4w3dQbMLoqlNMbJ3qBd13+pjQJ7/sz6jkmLmxCv4HJKE
         SN9MglgSYFCXiCVBJ2eVn5/Gy4pOCMoHYpn9jM19wMweIvxG6IKhE4fq7Ob/jkeMy9fz
         sTaP+Ga8khepgRFUdYF8R4Ciin5LkWTm0E4X7pW5p/w2yME/3aM44ga0THS5K6nz5aFS
         scuoGoKWsph1mydrXtNfBtLBMtgL5migqwKk3mzXLLTcEoYuuyk1XZyMjjCZgL7IUhdy
         qjng==
X-Gm-Message-State: AOAM533L3fHexsE8hYx+aXJfh1lUyRNn8l47LpW3jhJl9rdLwQ6WivzL
        Glr1Z3Y3OnFZ3pesdzjZPHU=
X-Google-Smtp-Source: ABdhPJw/j685Np+wpQh3jLyvME3Px5fOmP5hnCdjENEs90b/wPb1iw5PSrmNaSOdWcaI4p5yUr8o4Q==
X-Received: by 2002:a7b:c052:: with SMTP id u18mr2443719wmc.139.1608802406782;
        Thu, 24 Dec 2020 01:33:26 -0800 (PST)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id o17sm39463525wrg.32.2020.12.24.01.33.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Dec 2020 01:33:26 -0800 (PST)
Subject: Re: [RFC PATCH 00/10] crypto: x86 - remove XTS and CTR glue helper
 code
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <snitzer@redhat.com>
References: <20201223223841.11311-1-ardb@kernel.org>
From:   Milan Broz <gmazyland@gmail.com>
Message-ID: <dff974aa-4dcf-9f4a-83db-eb4883aa3376@gmail.com>
Date:   Thu, 24 Dec 2020 10:33:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201223223841.11311-1-ardb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/12/2020 23:38, Ard Biesheuvel wrote:
> After applying my performance fixes for AES-NI in XTS mode, the only
> remaining users of the x86 glue helper module are the niche algorithms
> camellia, cast6, serpent and twofish.
> 
> It is not clear from the history why all these different versions of these
> algorithms in XTS and CTR modes were added in the first place: the only
> in-kernel references that seem to exist are to cbc(serpent), cbc(camellia)
> and cbc(twofish) in the IPsec stack. The XTS spec only mentions AES, and
> CTR modes don't seem to be widely used either.

FYI: Serpent, Camellia and Twofish are used in TrueCrypt/VeraCrypt implementation;
cryptsetup and I perhaps even VeraCrypt itself tries to use native dm-crypt mapping.
(They also added Russian GOST Kuznyechik with XTS, but this is not in mainline,
but Debian packages it as gost-crypto-dkms).

Serpent and Twofish can be also used with LRW and CBC modes (for old containers only).

Cryptsetup uses crypto userspace API to decrypt the key from header, then it configures
dm-crypt mapping for data. We need both use and in-kernel API here.

For reference, see this table (my independent implementation of TrueCrypt/VeraCrypt modes,
it should be complete history though):
https://gitlab.com/cryptsetup/cryptsetup/-/blob/master/lib/tcrypt/tcrypt.c#L77

If the above still works (I would really like to have way to open old containers)
it is ok to do whatever you want to change here :-)

I have no info that CTR is used anywhere related to dm-crypt
(IIRC it can be tricked to be used there but it does not make any sense).

Thanks,
Milan
