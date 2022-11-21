Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D1CC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Nov 2022 09:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiKUJsQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Nov 2022 04:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiKUJrj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2022 04:47:39 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E8B1573D
        for <linux-crypto@vger.kernel.org>; Mon, 21 Nov 2022 01:47:31 -0800 (PST)
Received: from zn.tnic (p200300ea9733e725329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e725:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2D38B1EC0391;
        Mon, 21 Nov 2022 10:47:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669024050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Lvhf8ao6LFUPvplxDliDywV57iaqgHfLdAusJuf054Q=;
        b=NYXtMHwee+uzXyCasBc7hF4kUv+XP3etJTMtSNDhC3UW54PpTQoS4s/8ihw9mGnCG0f9Yz
        n8G6Ol0JzLaFwiSFyQ0zkbbk+HvOb5KWWXUWa4ifEjOS+GoQeqm0aQ/X9AnYeHewADZx0F
        HwLp2G1vipOvTHL2P/gZNZQEcak1KD4=
Date:   Mon, 21 Nov 2022 10:47:26 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi,
        ebiggers@kernel.org
Subject: Re: [PATCH v6 0/4] crypto: aria: implement aria-avx2 and aria-avx512
Message-ID: <Y3tJLp3UlXGmK7HB@zn.tnic>
References: <20221121003955.2214462-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221121003955.2214462-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 21, 2022 at 12:39:51AM +0000, Taehee Yoo wrote:
> This patchset is to implement aria-avx2 and aria-avx512.
> There are some differences between aria-avx, aria-avx2, and aria-avx512,
> but they are not core logic(s-box, diffusion layer).

From: Documentation/process/submitting-patches.rst

"Don't get discouraged - or impatient
------------------------------------

After you have submitted your change, be patient and wait.  Reviewers are
busy people and may not get to your patch right away.

Once upon a time, patches used to disappear into the void without comment,
but the development process works more smoothly than that now.  You should
receive comments within a week or so; if that does not happen, make sure
that you have sent your patches to the right place.  Wait for a minimum of
						     ^^^^^^^^^^^^^^^^^^^^^
one week before resubmitting or pinging reviewers - possibly longer during
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

busy times like merge windows."

IOW, pls stop spamming with your patchset.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
