Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8675C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jun 2022 13:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiFNN3H (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jun 2022 09:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiFNN3H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jun 2022 09:29:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2567312742;
        Tue, 14 Jun 2022 06:29:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0174B81879;
        Tue, 14 Jun 2022 13:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331AEC3411B;
        Tue, 14 Jun 2022 13:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655213343;
        bh=YEx73vfnRAnHRBrz3PVeIi0/8rfDtL+oBfNabAeQlks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1j05TVhIBjoG+yVNALTqiebQc3iaVllOkF3KyI17HMtZRW0vM9CIkJAEPJqrW/sq1
         cIxXPaCYiJAElrrjwQyZfvFY7df7t/LnOG72Jx/8daQ5CLtNoqKv0RcXWms+WI5zmC
         azueH7QKGohSeoaA1D3eKgzY4b3KtGMGASp8Mj7I=
Date:   Tue, 14 Jun 2022 15:29:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "yekai(A)" <yekai13@huawei.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, zhangfei.gao@linaro.org,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v2 3/3] crypto: hisilicon/qm - defining the device
 isolation strategy
Message-ID: <YqiNHOfXHRtaQyZV@kroah.com>
References: <20220614122943.1406-1-yekai13@huawei.com>
 <20220614122943.1406-4-yekai13@huawei.com>
 <YqiCaTAaRoq7c0y0@kroah.com>
 <b597023a-5569-f4be-1e30-78d0d961dfdc@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b597023a-5569-f4be-1e30-78d0d961dfdc@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 14, 2022 at 09:24:08PM +0800, yekai(A) wrote:
> > >  struct hisi_qm {
> > >  	enum qm_hw_ver ver;
> > >  	enum qm_fun_type fun_type;
> > > @@ -335,6 +341,9 @@ struct hisi_qm {
> > >  	struct qm_shaper_factor *factor;
> > >  	u32 mb_qos;
> > >  	u32 type_rate;
> > > +	struct list_head uacce_hw_errs;
> > > +	atomic_t uacce_ref; /* reference of the uacce */
> > 
> > That is not how reference counts work, sorry.  Please use 'struct kref'
> > for a real reference count, never roll your own.
> > 
> > thanks,
> > 
> > greg k-h
> > .
> > 
> 
> this atomic_t reference is lightweight than 'struct kref',

It's the same size, why would it be "lighter"?  Why do you need it to be
lighter, what performance issue is there with a kref?

> this reference
> means whether the task is running. So would it be better to use atomic_t
> reference?

I do not know, as "running or not running" is a state, not a count or a
reference.  why does this have to be atomic at all?

thanks,

greg k-h
