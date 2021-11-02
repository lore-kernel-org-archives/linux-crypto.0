Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6C5C433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 16:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E4B86112E
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 16:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhKBQmP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 12:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234699AbhKBQmM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 12:42:12 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1F3C061714
        for <linux-crypto@vger.kernel.org>; Tue,  2 Nov 2021 09:05:56 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s24so17011393plp.0
        for <linux-crypto@vger.kernel.org>; Tue, 02 Nov 2021 09:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5B0niJFAo1yLajXmzI/5umMieXRxykE+f7gBMAitL9o=;
        b=Iw5Up6RHONQ29BqFjlltSOSNnScDVJl216dFmvRibW5KmOuLkvHI4DT06vmKyUv7/E
         wp79P+u7DSIY6KYclSQsNVPMutubWmEJlcCf7sBhDYsOwS5rZomieoealHfBJ/mVC1jR
         6rGhDXboSMu0RuH4A/bF0CWukrwkFtLyHYLa5ihg8ilvdv//emZ7pN4+0wVJWW50T4SP
         MA/J8te/VHCjudMrgh5bWfu9HLhyD8EO10R5/4txavkb0hJqUNL5qT132Hrv2HGX5Vg9
         fH5NZhvdpaq8nm9YLPKcvHSS6RGg45y3KHahyi9HpxZOORoZi2os2clRSu1Axxd+wIoL
         aEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5B0niJFAo1yLajXmzI/5umMieXRxykE+f7gBMAitL9o=;
        b=Ap58wIxj7ctmpp0mIaCostImvy6YxGqz/ahvt9JRxpSQWUhSZdysSVsdOdst6SIy3/
         8G+s62nfZ0/5e4AOhjsEiiPCvtVafO3j6NC6S6YYBpYmbKUM4DAtMRxdMFJiK23OMxVT
         de2YoOxmsX+67kgtQQ96rNP2nWee7RqU9+jtUubFVmsqovY7GR+ibCvbk7lNdwh/qGYe
         h1PBt8ZnC9NZ+NTWqJla6JE2mQZEGn0/nxQDC95VjNTSdItORAIwXw9uWLy03fNkzv2D
         Misv5UARLHaAZVRiWuuXk+hugreQqd5WxzanmTHOGLAidvp6hMjYWmALupaNIBXTKJ9D
         tJUA==
X-Gm-Message-State: AOAM5337wENR2ki4kWkrbinmjkTN5emlA9vKks2+t2aU+R783pZJca5N
        lUni5X4pgHkM+qzO4Z8H82VY6A==
X-Google-Smtp-Source: ABdhPJwRFVZqB/o9nUXVNlwNLZdudVoI5JAZf8giGWa6nGcBFS6nBP93XKgetD+wt5hRYP3Sm6vnQQ==
X-Received: by 2002:a17:902:e88f:b0:141:f982:777 with SMTP id w15-20020a170902e88f00b00141f9820777mr10055720plg.68.1635869155805;
        Tue, 02 Nov 2021 09:05:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o4sm2687173pfu.130.2021.11.02.09.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 09:05:55 -0700 (PDT)
Date:   Tue, 2 Nov 2021 16:05:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     thomas.lendacky@amd.com, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 0/4] Add SEV_INIT_EX support
Message-ID: <YYFh323otsIauvmH@google.com>
References: <20211102142331.3753798-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102142331.3753798-1-pgonda@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 02, 2021, Peter Gonda wrote:
> SEV_INIT requires users to unlock their SPI bus for the PSP's non
> volatile (NV) storage. Users may wish to lock their SPI bus for numerous
> reasons, to support this the PSP firmware supports SEV_INIT_EX. INIT_EX
> allows the firmware to use a region of memory for its NV storage leaving
> the kernel responsible for actually storing the data in a persistent
> way. This series adds a new module parameter to ccp allowing users to
> specify a path to a file for use as the PSP's NV storage. The ccp driver
> then reads the file into memory for the PSP to use and is responsible
> for writing the file whenever the PSP modifies the memory region.

What's changed between v1 and v3?  Also, please wait a few days between versions.
I know us KVM people are often slow to get to reviews, but posting a new version
every day is usually counter-productive as it increases the review cost (more
threads to find and read).
