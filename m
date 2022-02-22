Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C3DC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Feb 2022 18:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbiBVSnw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Feb 2022 13:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbiBVSnw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Feb 2022 13:43:52 -0500
Received: from relay4.hostedemail.com (relay4.hostedemail.com [64.99.140.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D45E9E576;
        Tue, 22 Feb 2022 10:43:26 -0800 (PST)
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay11.hostedemail.com (Postfix) with ESMTP id 7E08A802C9;
        Tue, 22 Feb 2022 18:43:24 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf17.hostedemail.com (Postfix) with ESMTPA id 5571217;
        Tue, 22 Feb 2022 18:42:32 +0000 (UTC)
Message-ID: <603f9243bb9e1c4c50aaec83a527266b48ab9e20.camel@perches.com>
Subject: Re: [PATCHv3 04/10] linux/kernel: introduce lower_48_bits macro
From:   Joe Perches <joe@perches.com>
To:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk,
        martin.petersen@oracle.com, colyli@suse.de,
        Bart Van Assche <bvanassche@acm.org>
Date:   Tue, 22 Feb 2022 10:43:21 -0800
In-Reply-To: <20220222165613.GB1497257@dhcp-10-100-145-180.wdc.com>
References: <20220222163144.1782447-1-kbusch@kernel.org>
         <20220222163144.1782447-5-kbusch@kernel.org>
         <66a0c8210cf9e7dfcc3fa2d247de1eebd5a8acb7.camel@perches.com>
         <20220222165045.GA14168@lst.de>
         <20220222165613.GB1497257@dhcp-10-100-145-180.wdc.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nazzjjx87869o4w9oakhjiahqxjdbban
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: 5571217
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18aL9+BR2B9Ovzx+56lKMnaVrCxDabIdXo=
X-HE-Tag: 1645555352-996125
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2022-02-22 at 08:56 -0800, Keith Busch wrote:
> On Tue, Feb 22, 2022 at 05:50:45PM +0100, Christoph Hellwig wrote:
> > On Tue, Feb 22, 2022 at 08:45:53AM -0800, Joe Perches wrote:
> > > On Tue, 2022-02-22 at 08:31 -0800, Keith Busch wrote:
> > > > +/ *
> > > > + * lower_48_bits - return bits 0-47 of a number
> > > > + * @n: the number we're accessing
> > > > + */
> > > > +#define lower_48_bits(n) ((u64)((n) & 0xffffffffffffull))
> > > 
> > > why not make this a static inline function?
> > 
> > Agreed.
> 
> Sure, that sounds good to me. I only did it this way to match the
> existing local convention, but I personally prefer the inline function
> too. 

The existing convention is used there to allow the compiler to
avoid warnings and unnecessary conversions of a u32 to a u64 when
shifting by 32 or more bits.

If it's possible to be used with an architecture dependent typedef
like dma_addr_t, then perhaps it's reasonable to do something like:

#define lower_48_bits(val)					\
({								\
	typeof(val) high = lower_16_bits(upper_32_bits(val));	\
	typeof(val) low = lower_32_bits(val);			\
								\
	(high << 16 << 16) | low;				\
})

and have the compiler have the return value be an appropriate type.


