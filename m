Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_MED,USER_AGENT_MUTT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13F7C04AB1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 15:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707BB216C4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 15:38:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H5YrD2LA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfEIPig (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 May 2019 11:38:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34619 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfEIPig (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 May 2019 11:38:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id c13so1424069pgt.1
        for <linux-crypto@vger.kernel.org>; Thu, 09 May 2019 08:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5YwQ7pSduzStb02SylGKVrjZm5E2uXA+GvWIb5JRr7I=;
        b=H5YrD2LANg0XDBX7Y8dX3WkFbyNGuKqmc5AwTCh3L8XKM1fCfygAH6ZZiCtp9tqqlD
         RxH8VecF/mXAPPFyCplZvNSO/9v006AbuWT/n6pPPRhI4nrP96doRX6Xq1znHbO4VVQ/
         G3kcSqpeEXJBkxBuWZHB/O1+9AApxfAZUUs9ezP38DJDepTh3xANJ/OLFaHQBMLj9Wm5
         MuJG8j7w2G1sbeBewcHXyCRfwk4iMjYXN1tb8k0QAz9IxchlTla8nJbb1BQ7G/YzDMOO
         Y/KBoLfQw/G64pRnlHf18UE8WP4NpZegiPor/cUFu6kDqVkX1EEz1g1AITn6aA211vqv
         Dzpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5YwQ7pSduzStb02SylGKVrjZm5E2uXA+GvWIb5JRr7I=;
        b=UlS9IQQJKx+ACZlNETbqnNh+r2oFJ7dg3jt5UO7Bn02D8YrNlUAHNlyctA5EogWM/i
         1GNMJwFGOTyIWgkpEDS1EvLPw+UzK9sbCNVbxFoi35FgeHAUcVU7ndTUIKh8gca8s0Y/
         HiKrOeH0SrfC7UyqsA46tbllcmHwWCPM6SEehg3OtajH/dqKKNBEej+3r6YgU0+UmpT1
         zE2IkTVN3Rr3jsjM/RQXS83b6i41n7PulyFvV04D+SVDj/RSZoyzOb6o9/ssjFt59yRW
         xZS+JZrKGfg7hLnFCcbSo8zRiLglEbMH5focHYENH6OAQgXAIKpJHZtp2BQCqojDNLC6
         JKGA==
X-Gm-Message-State: APjAAAWUl4lROeFWlufSvZR9N2NDJC1gCETfP5n6sOtFp4YMyAA1EJE8
        Dofo19x44F9G7CrIjJXRgNdVEQ==
X-Google-Smtp-Source: APXvYqxqQ737rcyEeTeKDmNxTm839RB0ZfC55simHYlp8b5BDIhwUb8yXIjBmSqvxOC2ppuwaQgrnQ==
X-Received: by 2002:a62:2b43:: with SMTP id r64mr6112838pfr.210.1557416314921;
        Thu, 09 May 2019 08:38:34 -0700 (PDT)
Received: from google.com ([2620:15c:201:2:ce90:ab18:83b0:619])
        by smtp.gmail.com with ESMTPSA id i15sm5711248pfj.167.2019.05.09.08.38.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 09 May 2019 08:38:33 -0700 (PDT)
Date:   Thu, 9 May 2019 08:38:28 -0700
From:   Sami Tolvanen <samitolvanen@google.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Joao Moreira <jmoreira@suse.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Message-ID: <20190509153828.GA261205@google.com>
References: <20190507161321.34611-1-keescook@chromium.org>
 <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain>
 <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
 <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
 <20190509020439.GB693@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509020439.GB693@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 08, 2019 at 07:04:40PM -0700, Eric Biggers wrote:
> And I also asked whether indirect calls to asm code are even allowed
> with CFI. IIRC, the AOSP kernels have been patched to remove them from
> arm64

At least with clang, indirect calls to stand-alone assembly functions
trip CFI checks, which is why Android kernels use static inline stubs
to convert these to direct calls instead.

Sami
