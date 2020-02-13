Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0FA3C352A3
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 04:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A40D24671
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 04:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581566990;
	bh=ZvRdY2P4FEjO8XWiLdS71L6BPBX7L/QeoOjG/uO/vZc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=nwsqHQzBpANYJHamuKI1xdoXNZyH5QUn1PCL8zRtk+ISThLkyjV4jPU+3U1CRV3O9
	 /7sdMsSdKT8PwXqthKTeXg/m2gP+yFIPARO5ZyymG/3BbuOHivIBpMqvWQyARuHV7a
	 aaXh0VDtx2IwhnVRfivBzjh9Yw+8tYllY52j4jmY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbgBMEJr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 23:09:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729515AbgBMEJr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 23:09:47 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6791F2173E;
        Thu, 13 Feb 2020 04:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581566986;
        bh=ZvRdY2P4FEjO8XWiLdS71L6BPBX7L/QeoOjG/uO/vZc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nDzoygY531SKTNrWfICsg0TBZKNkYBlpr9yM0LsE4hAqoxhQSz2nT2XMCbyVEyWq9
         mMHBOPFnRn275yLdT3TqwgoU4IhlO2X69peYdHojBc1kzI2GhMWxRAp2Jwrdg7wT/r
         iz5JNAE8E2toEA/1D/dujHvoyO+DyEHTiHI+fka0=
Date:   Wed, 12 Feb 2020 20:09:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [net] net/tls: Fix to avoid gettig invalid tls record
Message-ID: <20200212200945.34460c3a@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200212071630.26650-1-rohitm@chelsio.com>
References: <20200212071630.26650-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 12 Feb 2020 12:46:30 +0530, Rohit Maheshwari wrote:
> Current code doesn't check if tcp sequence number is starting from (/after)
> 1st record's start sequnce number. It only checks if seq number is before
> 1st record's end sequnce number. This problem will always be a possibility
> in re-transmit case. If a record which belongs to a requested seq number is
> already deleted, tls_get_record will start looking into list and as per the
> check it will look if seq number is before the end seq of 1st record, which
> will always be true and will return 1st record always, it should in fact
> return NULL. 

I think I see your point, do you observe this problem in practice 
or did you find this through code review?

> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index cd91ad812291..2898517298bf 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -602,7 +602,8 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
>  		 */
>  		info = list_first_entry_or_null(&context->records_list,
>  						struct tls_record_info, list);
> -		if (!info)
> +		/* return NULL if seq number even before the 1st entry. */
> +		if (!info || before(seq, info->end_seq - info->len))

Is it not more appropriate to use between() in the actual comparison
below? I feel like with this patch we can get false negatives.

>  			return NULL;
>  		record_sn = context->unacked_record_sn;
>  	}

If you post a v2 please add a Fixes tag and CC maintainers of this code.
