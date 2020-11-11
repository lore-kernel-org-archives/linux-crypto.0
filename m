Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716B5C388F9
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Nov 2020 17:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E611206D9
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Nov 2020 17:36:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkwYBkP7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgKKRgP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Nov 2020 12:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgKKRgO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Nov 2020 12:36:14 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A2DC0613D1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2020 09:36:14 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id dk16so3837643ejb.12
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2020 09:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XnewkfxX+TMgqjvDNImFIiK33lQFNT7LVjTzzA+d1Rg=;
        b=HkwYBkP7/cUP7lQUXJORYuDoGE/KqKWBYgy4fB8WdDOKG8ofh7g4K5QNrvnzqe7UOR
         mJbe3CoNqXkZvItIryRJlopmLUMIEZ5mgemllG1nu4sOdxRGndYfhYAuKtWV8Crbe6qG
         UCF3UY2mSPpQ0IvNqDRrYBEL0TmI5GnPm3CB7WFB2mGrk3/t9vtJlgRuY8Gr+E4vw+PX
         fXUx4lXXI57aHcxh9Xo0XzlxajN9fUOIQxdqfjyhgzhBRy9ETfVU9qDp4HTgN+Dk85tF
         NEvnc+tfVaM4lfRSfaKlOSQtxrvq5lggWje0QhJupJjRpzzQ04UzYkQgbEbRAjQqzKwu
         JCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XnewkfxX+TMgqjvDNImFIiK33lQFNT7LVjTzzA+d1Rg=;
        b=byd68KmdmPgGeJFgGWTjQPcQuO4cctQR8gxugA1ub/9pG6pGxW0v/+Ixohe4Vv0seB
         KVugqVfIlNMOSyQYnvDzPiZEZnx9ilcx2eYJGPautdcJDbFsJHclTfz83mz37R7SaCQM
         8NNT5T8sxU3dzkQ4l0hj9nRc6lbcBsFXDo3Dc5Qty68s0ucqZhSg4m8L0NvE1qbjnjud
         gc3y6Kv5oldpsmeyj26qHfe6PlsYtbcYaTQgcQFC/EFFZ+rvn+2+O17pPGexjjvd3JIU
         T/kQImRGZCa7iYlMUmgjmyOzdkAgULDXGJu4th9x9pqI32BxTFKE1nNrAQBPqqcK6iS3
         ScrA==
X-Gm-Message-State: AOAM532rnpy6pEDaGK4Bbr+6Qam4o+zveCE3f1XeFd23SNJUosn07I4P
        2pJ/6UNAtpc3AIlnDNnn/jl0m4ZNvmvGfMNEiT0=
X-Google-Smtp-Source: ABdhPJxCz3JF+IvLAw+t/+i6B8wU3U2FAp7D5N1SQnilxrnkjQWMEZl+2hJZH8YDLJo4EMp5FKAeXUj3WOvAaEaGMTQ=
X-Received: by 2002:a17:906:2297:: with SMTP id p23mr25537162eja.60.1605116173256;
 Wed, 11 Nov 2020 09:36:13 -0800 (PST)
MIME-Version: 1.0
References: <20201110190444.10634-1-ardb@kernel.org> <20201110190444.10634-2-ardb@kernel.org>
In-Reply-To: <20201110190444.10634-2-ardb@kernel.org>
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Wed, 11 Nov 2020 18:36:02 +0100
Message-ID: <CAAUqJDtnb0k2YcM3h765fsBQ8FoEbu7hB8bDY6q7mni3utvGsQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] crypto: aegis128 - wipe plaintext and tag if
 decryption fails
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ut 10. 11. 2020 o 20:04 Ard Biesheuvel <ardb@kernel.org> nap=C3=ADsal(a):
> The AEGIS spec mentions explicitly that the security guarantees hold
> only if the resulting plaintext and tag of a failed decryption are
> not disclosed. So ensure that we abide by this.
>
> While at it, drop the unused struct aead_request *req parameter from
> crypto_aegis128_process_crypt().
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/aegis128-core.c | 32 ++++++++++++++++----
>  1 file changed, 26 insertions(+), 6 deletions(-)

Reviewed-by: Ondrej Mosnacek <omosnacek@gmail.com>
