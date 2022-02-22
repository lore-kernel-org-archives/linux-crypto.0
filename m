Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C729C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Feb 2022 16:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbiBVQy3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Feb 2022 11:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiBVQy3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Feb 2022 11:54:29 -0500
X-Greylist: delayed 485 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Feb 2022 08:54:03 PST
Received: from relay4.hostedemail.com (relay4.hostedemail.com [64.99.140.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A565370D
        for <linux-crypto@vger.kernel.org>; Tue, 22 Feb 2022 08:54:03 -0800 (PST)
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay10.hostedemail.com (Postfix) with ESMTP id 784C8A5A;
        Tue, 22 Feb 2022 16:45:56 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf18.hostedemail.com (Postfix) with ESMTPA id 396B643;
        Tue, 22 Feb 2022 16:45:34 +0000 (UTC)
Message-ID: <66a0c8210cf9e7dfcc3fa2d247de1eebd5a8acb7.camel@perches.com>
Subject: Re: [PATCHv3 04/10] linux/kernel: introduce lower_48_bits macro
From:   Joe Perches <joe@perches.com>
To:     Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
        colyli@suse.de, Bart Van Assche <bvanassche@acm.org>
Date:   Tue, 22 Feb 2022 08:45:53 -0800
In-Reply-To: <20220222163144.1782447-5-kbusch@kernel.org>
References: <20220222163144.1782447-1-kbusch@kernel.org>
         <20220222163144.1782447-5-kbusch@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 396B643
X-Stat-Signature: yzf67mxeguumtukwkfw7sqsufuzga6du
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+NisYWVxViQyJRvI3jjilg5uVaEbHyZ28=
X-HE-Tag: 1645548334-553202
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2022-02-22 at 08:31 -0800, Keith Busch wrote:
> Recent data integrity field enhancements allow 48-bit reference tags.
> Introduce a helper macro since this will be a repeated operation.
[]
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
[]
> @@ -63,6 +63,12 @@
>  }					\
>  )
>  
> +/**
> + * lower_48_bits - return bits 0-47 of a number
> + * @n: the number we're accessing
> + */
> +#define lower_48_bits(n) ((u64)((n) & 0xffffffffffffull))

why not make this a static inline function?
And visually, it's difficult to quickly count a repeated character to 12.

Perhaps:

static inline u64 lower_48_bits(u64 val)
{
	return val & GENMASK_ULL(47, 0);
}


