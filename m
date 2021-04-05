Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F20C433B4
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Apr 2021 16:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BD3960FDB
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Apr 2021 16:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242394AbhDEQdO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Apr 2021 12:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238829AbhDEQdN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Apr 2021 12:33:13 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549F9C06178C
        for <linux-crypto@vger.kernel.org>; Mon,  5 Apr 2021 09:33:07 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so8095542pjb.4
        for <linux-crypto@vger.kernel.org>; Mon, 05 Apr 2021 09:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qFylozrlyKKCpuFovX6HAhcTBeCnPIKKmkJLUGerBIo=;
        b=P7OJP3yWJ32c95Ql6kBfLhVR4ZyxMoPCoYPGS3TPZmhhEje9aNWcjnT4VFuzpD/Som
         RTZ1PTZmHHDzit+q3mN6so/tOrFovHhdBcRqFxz9DcHeTl9G9XsDt25xq2iZPyuhEx/C
         BhmDoTXoJCNxoLJ9uhl3T5k6yoH48+oC7BThxzjARs2AcKUoIH+RAa4RdClIYtPrhlyD
         yj4hW7BMHPn4Ug3J6YwsfkZMxHosFZwH+i3+J1BvxXhpYET0W28pPlxYoYXEFMviQer7
         Kjx81OaLs3wDg/f05pRMc160V45mFZbMEkiXwTakXkqJxpqxw2laujVycQbqLldeuLHz
         Hx0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qFylozrlyKKCpuFovX6HAhcTBeCnPIKKmkJLUGerBIo=;
        b=Io8KIV87Xilefq7PHyZl9DBzGZBGhy/hqu/5Ww2URRNcIiZm9dqKm84zAhfOftSg0V
         M4brBR9MpwwWjtAHitVf6Vdu0TmK8OmDr6Pkk5Fsx8wPSODUjIysrJH4W4KbmsMfJdN+
         uw9NOxrnh3HPX5BSDyowjpbdY/zA0fqkvYBx42l5VBZfiS06EIsJXV4qFuNPz4bw80oN
         vLTQteuxemgfwJnEC0JzjcNeoSK+8ZPpITJ6JZw+7cB2uX7AexeVLKVR4ZDN591C3Egl
         Czmu773GFckV/qnk/iWWS+KqBdoOeN+/j1iMID5QQRrKkiJVje+L4Hrkat9wKbCt8WSw
         6CUQ==
X-Gm-Message-State: AOAM5313xLLLg4b+wA00NWtKhrt7mXUSSE36ULNbNQz0Ln51IFOed78s
        ds5hFjli5ZtS9xqHRIZg7uxBIg==
X-Google-Smtp-Source: ABdhPJyVqmt9XH5YGpvHjpubvqt/qVhOP3UrqTiRCe44LbhrbARmsVhpjt3fOrn0uLJLW1Yk1+SR2g==
X-Received: by 2002:a17:902:ff0b:b029:e8:eb46:1566 with SMTP id f11-20020a170902ff0bb02900e8eb461566mr8956141plj.24.1617640386562;
        Mon, 05 Apr 2021 09:33:06 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id r184sm16214515pfc.107.2021.04.05.09.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 09:33:06 -0700 (PDT)
Date:   Mon, 5 Apr 2021 16:33:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 2/5] crypto: ccp: Reject SEV commands with mismatching
 command buffer
Message-ID: <YGs7vioH8TVzyckx@google.com>
References: <20210402233702.3291792-1-seanjc@google.com>
 <20210402233702.3291792-3-seanjc@google.com>
 <bc82825c-03ff-1b3f-7166-f6e5671f0a4f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc82825c-03ff-1b3f-7166-f6e5671f0a4f@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 05, 2021, Tom Lendacky wrote:
> On 4/2/21 6:36 PM, Sean Christopherson wrote:
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > index 6556d220713b..4c513318f16a 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -141,6 +141,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
> >  	struct sev_device *sev;
> >  	unsigned int phys_lsb, phys_msb;
> >  	unsigned int reg, ret = 0;
> > +	int buf_len;
> >  
> >  	if (!psp || !psp->sev_data)
> >  		return -ENODEV;
> > @@ -150,7 +151,11 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
> >  
> >  	sev = psp->sev_data;
> >  
> > -	if (data && WARN_ON_ONCE(is_vmalloc_addr(data)))
> > +	buf_len = sev_cmd_buffer_len(cmd);
> > +	if (WARN_ON_ONCE(!!data != !!buf_len))
> 
> Seems a bit confusing to me.  Can this just be:
> 
> 	if (WARN_ON_ONCE(data && !buf_len))

Or as Christophe pointed out, "!data != !buf_len".

> Or is this also trying to catch the case where buf_len is non-zero but
> data is NULL?

Ya.  It's not necessary to detect "buf_len && !data", but it doesn't incur
additional cost.  Is there a reason _not_ to disallow that?

