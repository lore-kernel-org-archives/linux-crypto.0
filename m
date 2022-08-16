Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD18C25B0E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 21:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbiHPVZX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 17:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237604AbiHPVZW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 17:25:22 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D698C031
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 14:25:21 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gp7so10803609pjb.4
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 14:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc;
        bh=bFTgb0MyDNHElcHcfE66JD0U1t++ZcmngfUIUipRBa0=;
        b=MFZlty/T5ZlDBkujF13rtleo+pUP0+OugWJ730FEEFarjRnF5xN/XOBXKCOHb75VdU
         x/rr0MxCfay2pB1TGwQjiXGEdkeKO2OLgqG1TqHv7doagOgD6XmNBH0gxtC4gVzZvghO
         jYGJaDbm0HlgBVZNcZwtzHkFZF9V2+AQrWanZGdbnufTqqArATPdK/MH9VXqz5TdcSLH
         I4gNY/ch8oxNDY7vI4/0wyNgZlXLjWcGPCC0hi4b58Zd3OysmyUrGCOQlUEUcbArg4+e
         aVnKbrDGyshUl9Ma3MxAV8yO0KbWw0tgk/TLPCD89HuCk+dNrJRLHpikO10JxROTUyvP
         FHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc;
        bh=bFTgb0MyDNHElcHcfE66JD0U1t++ZcmngfUIUipRBa0=;
        b=kfGicJnJWkdSkUXx9wt/bAgCAcPGZELe1UAOpTghDkyAplAzMj9jpVJJ22xrPlUBMt
         xUp+7v/lWwfmDhkSXwEJ6cFBH+ZBxb62tuaJWhZ0af6jsLV0s0yPn2RDh1+1LMGwQpnM
         WN6XDPoghso1GVgSwkgMbdHRq/bVENHo+SFvdBsKvIoLzTeAh6BjYDlmndaZGbXiM9TF
         odTqO9SlASeAp1TVR+0kzL+ixkXp7zSvoA3YVwQ8GI/3StyZiJyt/KrQeDvIG/QGQhvc
         z4exDhtnP+j5PoNUUrcpBuuyLjZc1awe11CxxLTDXKN1ua5ERnp6zp70cmKu6PBpwdi1
         x5JQ==
X-Gm-Message-State: ACgBeo37loxTLJQTWPCXXTHTP/vXNlIHHl7N+7C3d3J7RM0gdvOh3Mpf
        pCgX7dQ0rs5BMsBe0oULQETlJw==
X-Google-Smtp-Source: AA6agR7e3Tte3sx6cv3dVpIoZdC2K6gncQgCVMsjYEmv+jkwyGumqBTSaYyZHjEUVcrKp1sFlH1aGg==
X-Received: by 2002:a17:90b:33ce:b0:1fa:81bb:aeba with SMTP id lk14-20020a17090b33ce00b001fa81bbaebamr464120pjb.205.1660685120939;
        Tue, 16 Aug 2022 14:25:20 -0700 (PDT)
Received: from [2620:15c:29:203:9a1b:5709:54ba:ae28] ([2620:15c:29:203:9a1b:5709:54ba:ae28])
        by smtp.gmail.com with ESMTPSA id a11-20020a170902eccb00b0016d785ef6d2sm9469653plh.223.2022.08.16.14.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:25:20 -0700 (PDT)
Date:   Tue, 16 Aug 2022 14:25:19 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
To:     Jacky Li <jackyli@google.com>
cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Orr <marcorr@google.com>, Alper Gun <alpergun@google.com>,
        Peter Gonda <pgonda@google.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 2/2] crypto: ccp - Fail the PSP initialization when
 writing psp data file failed
In-Reply-To: <20220816193209.4057566-3-jackyli@google.com>
Message-ID: <18f39270-87d3-3d3d-c60b-77465f81f3a0@google.com>
References: <20220816193209.4057566-1-jackyli@google.com> <20220816193209.4057566-3-jackyli@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 16 Aug 2022, Jacky Li wrote:

> Currently the OS continues the PSP initialization when there is a write
> failure to the init_ex_file. Therefore, the userspace would be told that
> SEV is properly INIT'd even though the psp data file is not updated.
> This is problematic because later when asked for the SEV data, the OS
> won't be able to provide it.
> 
> Fixes: 3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support")
> Reported-by: Peter Gonda <pgonda@google.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Jacky Li <jackyli@google.com>

Acked-by: David Rientjes <rientjes@google.com>
