Return-Path: <SRS0=EmbF=5Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1BDC2D0EA
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 15:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7233206F7
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 15:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586359881;
	bh=aW3ft5X9hZtu9qVkui3ULDsUUXgTBmC/IHq5RwHtdM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=KP3UgyL+YlueQDwgOAJMQRwG0QmD87vtKqt2SOKkUY3UGbDMIemluDY0aOYqdaCV3
	 H0vxiNC7hGMAYFZbbnRMfpjoQBzHN+jbzSrL/ZCiD7MMyOxC/kxoBZZU1/Hl6F2B49
	 z1MbY8LFRvz4fzZaTaypjGgXR0EE2xZPye3Eukr0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgDHPbU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:31:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43908 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgDHPbU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Apr 2020 11:31:20 -0400
Received: by mail-wr1-f66.google.com with SMTP id i10so1987013wrv.10;
        Wed, 08 Apr 2020 08:31:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7g2IDxoHI/17bb2lHkaR7jfy7fINZC4aLcy8p7mbFWU=;
        b=inLFqxRMp0YUXZfzwpNTxO2qdvdCGGFSPg2/eu5X6Ekj4gon+Ye99IflNCRTgsSzzT
         8qOf4l6Gv2wG7ik9Dm15p05SY25xKxuKwkyRcxJZUnkOpJ5Pk+ug/soR+ftYZCegFXUh
         2BaQIheb0nefo0Jcw9RnV05Qc2/pk8C4jxsK4wpBWGjZxmLsoGdHLZ9liMdXngOZh6O/
         OoUi6tBLTGAP1zgswOYshj1v6b+YcLl+Hja/jBlu9rMyEnlV3cFpYMptGoIwSvbwGbPh
         Q6TshNfaAsWRp3U5GLSFgYN4YEas2PhMnPzqj43VO1K0jIOEcmdLRQFp7AvkRULA55LD
         cABQ==
X-Gm-Message-State: AGi0PuaFSVhNWYjkKIrd6HiiK4hJnGKTAQd3RzOqnAtaPHTMQyV070+R
        aCrzq0dlPLcG6Uh53hbtYkM=
X-Google-Smtp-Source: APiQypJ9O8BdKURufjoODCWj6Vu45474Vg3xaJGe9sn6hp0NQRyhqjbMB9htMUc2OA9BeOF5icQonw==
X-Received: by 2002:adf:fe4b:: with SMTP id m11mr8866703wrs.20.1586359877175;
        Wed, 08 Apr 2020 08:31:17 -0700 (PDT)
Received: from localhost (ip-37-188-180-223.eurotel.cz. [37.188.180.223])
        by smtp.gmail.com with ESMTPSA id a7sm7201481wmj.12.2020.04.08.08.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 08:31:16 -0700 (PDT)
Date:   Wed, 8 Apr 2020 17:31:14 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Peter Xu <peterx@redhat.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+3be1a33f04dc782e9fd5@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, bgeffon@google.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org
Subject: Re: WARNING in af_alg_make_sg
Message-ID: <20200408153114.GB18914@dhcp22.suse.cz>
References: <000000000000f2bc9505a2c2b808@google.com>
 <20200408095849.15236-1-hdanton@sina.com>
 <20200408151213.GE66033@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408151213.GE66033@xz-x1>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed 08-04-20 11:12:13, Peter Xu wrote:
> >From 380003a56efc125565143c91ee6cefd7b3eba869 Mon Sep 17 00:00:00 2001
> From: Hillf Danton <hdanton@sina.com>
> Date: Wed, 8 Apr 2020 11:01:25 -0400
> Subject: [PATCH] mm/gup: Let __get_user_pages_locked() return -EINTR for fatal
>  signal
> 
> __get_user_pages_locked() will return 0 instead of -EINTR after commit
> 4426e945df588 which added extra code to allow gup detect fatal signal
> faster.  Restore that behavior.
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Hillf Danton <hdanton@sina.com>
> [peterx: write commit message]

Fixes: 4426e945df58 ("mm/gup: allow VM_FAULT_RETRY for multiple times")
> Signed-off-by: Peter Xu <peterx@redhat.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/gup.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index afce0bc47e70..6076df8e04a4 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1326,8 +1326,11 @@ static __always_inline long __get_user_pages_locked(struct task_struct *tsk,
>  		 * start trying again otherwise it can loop forever.
>  		 */
>  
> -		if (fatal_signal_pending(current))
> +		if (fatal_signal_pending(current)) {
> +			if (!pages_done)
> +				pages_done = -EINTR;
>  			break;
> +		}
>  
>  		ret = down_read_killable(&mm->mmap_sem);
>  		if (ret) {
> -- 
> 2.24.1
> 
> 
> -- 
> Peter Xu
> 

-- 
Michal Hocko
SUSE Labs
