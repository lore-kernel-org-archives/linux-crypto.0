Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268A6C48BE6
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Jun 2021 09:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E99F961241
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Jun 2021 09:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhFPJN4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Jun 2021 05:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbhFPJNz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jun 2021 05:13:55 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FFCC061574
        for <linux-crypto@vger.kernel.org>; Wed, 16 Jun 2021 02:11:49 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q15so1425927pgg.12
        for <linux-crypto@vger.kernel.org>; Wed, 16 Jun 2021 02:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=KtVdMb/6axa2rNnzxWBctbX/60Uc/ENo0T3/IaoLfho=;
        b=qcvIkQTtpPF0I+gN5iCvyP9ggl5XqSW4PJpsnIoGvVVckTmWiP5TV2ZMxiHaYXEX22
         UPbNzqeQ8J1M5ziNfdgDaxzmWJok/77O5B+CxV7rrkmd6YaWPQndrt1stBXAwytgPrHB
         4FWZYhZdYcoevju4mz/SKTFMGWcVuBvVFL/DCmGn0w0R7sOLtRttU4TPISiHduDUCKaB
         mbIwv+Y4DGyVx6ZZmiRvKCo1R5ELUk/MaOeqSg5c6FWffnYjM2sd7uqJQmHo9lGgX/ug
         oK0Czx1HPTR5BVGzl5c1VT0/f982B/zR+PfkeX5jrpSiCz4Pd4ZbxPi3hcO4pwSlmng6
         DeNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=KtVdMb/6axa2rNnzxWBctbX/60Uc/ENo0T3/IaoLfho=;
        b=jLyHUcP08gj3cqk8YF2bmJ/SG9TTfUSS7RD97PrY4T/k9xsBgw5bVtrchVmTukJ90f
         dqPvtBzXZ5rh/QaDaj759zLSV3zVwuLZpe9QOReAfGB7FA2M1m9yZVDWfrjS13+6qFpv
         FmcgPqVK+0DhsqgMp7hJXJKdnQPmF+qpcDV46M6MR/GXf+fmmuIFydxMStmwnQcSVc1r
         M6eluWXRjgzkIK9JyhpJXNnUtwUjTosNPR9WJuvIHESztAfgzReYZbBV6A64q7+NFjhL
         BtF0M3fpUehOPvCmT5BThcl5od0bKknefUIphiduXUDamhrgiR89mJJduQyJFLhMOg4n
         +yCA==
X-Gm-Message-State: AOAM533IsZoF5L2r4zBAKKefbpbjyHKtG++bFdYhiEiE5CzijC472mxl
        cgnHJycEPeIEDWAdc1SWvI8=
X-Google-Smtp-Source: ABdhPJwg5t3ZzDFtVfbDZtWpDp3zMSLvjEML2ObcV6lg8iOQ5MkRUg0XhWXkRP1aYI1548X+Gpo8og==
X-Received: by 2002:a63:6982:: with SMTP id e124mr3900515pgc.439.1623834708645;
        Wed, 16 Jun 2021 02:11:48 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id d12sm1576296pfo.113.2021.06.16.02.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 02:11:48 -0700 (PDT)
Date:   Wed, 16 Jun 2021 19:11:42 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 04/17] powerpc/vas: Add platform specific user window
 operations
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
        <c64fda6e9b684c175cedb3ec448cce7aaf0f4615.camel@linux.ibm.com>
        <1623636838.8tsdy9nisc.astroid@bobo.none>
        <e409750a3bd5f8410d7a8a290c69375486420b93.camel@linux.ibm.com>
In-Reply-To: <e409750a3bd5f8410d7a8a290c69375486420b93.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623834468.xkn6to1dom.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 15, 2021 4:37 pm:
> On Mon, 2021-06-14 at 12:24 +1000, Nicholas Piggin wrote:
>> Excerpts from Haren Myneni's message of June 13, 2021 8:57 pm:
>> > PowerNV uses registers to open/close VAS windows, and getting the
>> > paste address. Whereas the hypervisor calls are used on PowerVM.
>> >=20
>> > This patch adds the platform specific user space window operations
>> > and register with the common VAS user space interface.
>> >=20
>> > Signed-off-by: Haren Myneni <haren@linux.ibm.com>
>> > ---
>> >  arch/powerpc/include/asm/vas.h              | 14 +++++-
>> >  arch/powerpc/platforms/book3s/vas-api.c     | 53 +++++++++++++--
>> > ------
>> >  arch/powerpc/platforms/powernv/vas-window.c | 45 ++++++++++++++++-
>> >  3 files changed, 89 insertions(+), 23 deletions(-)
>> >=20
>> > diff --git a/arch/powerpc/include/asm/vas.h
>> > b/arch/powerpc/include/asm/vas.h
>> > index bab7891d43f5..85318d7446c7 100644
>> > --- a/arch/powerpc/include/asm/vas.h
>> > +++ b/arch/powerpc/include/asm/vas.h
>> > @@ -5,6 +5,7 @@
>> > =20
>> >  #ifndef _ASM_POWERPC_VAS_H
>> >  #define _ASM_POWERPC_VAS_H
>> > +#include <uapi/asm/vas-api.h>
>> > =20
>> >  struct vas_window;
>> > =20
>> > @@ -48,6 +49,16 @@ enum vas_cop_type {
>> >  	VAS_COP_TYPE_MAX,
>> >  };
>> > =20
>> > +/*
>> > + * User space window operations used for powernv and powerVM
>> > + */
>> > +struct vas_user_win_ops {
>> > +	struct vas_window * (*open_win)(struct vas_tx_win_open_attr *,
>> > +				enum vas_cop_type);
>> > +	u64 (*paste_addr)(struct vas_window *);
>> > +	int (*close_win)(struct vas_window *);
>> > +};
>>=20
>> This looks better, but rather than pull in uapi and the user API=20
>> structure here, could you just pass in vas_id and flags after the
>> common=20
>> code does the user copy and verifies the version and other details?
>>=20
>> I think it's generally good practice to limit the data that the usre
>> can influence as much as possible. Sorry for not picking up on that
>> earlier.
>=20
> The user space pass vas_tx_win_open_attr struct - use only vas_id and
> flags right now but it can be extended in future with reserve elements.
> So passing the same struct to platform specific API.
>=20
> do you prefer "struct vas_window * (*open_win)(vas_id, flags, cop)" and
> extend later when more elments are used?

Yes I think so. The reason being so you don't sending data under the
control of user very far into the kernel. Better safe than sorry.

Thanks,
Nick

