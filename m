From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] nx-842: Endian swap ->count before handing over to the
 nx-842 compressor
Date: Mon, 2 Nov 2015 15:24:03 -0500
Message-ID: <CALZtONDeyNPJL=TDwwzLnLWaayxu+yqPcKuKy0WVOrLAWs06tw@mail.gmail.com>
References: <20151030224536.GB22549@ram.oc3035372033.ibm.com>
 <CALZtONDNpw=bpmrykQomZiFZZs+CaGxyPZRL5_aWg=vTSyTrJw@mail.gmail.com> <20151031183930.GB22547@ram.oc3035372033.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Haren Myneni <hbabu@us.ibm.com>
To: Ram Pai <linuxram@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35243 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbbKBUYn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Nov 2015 15:24:43 -0500
Received: by iofz202 with SMTP id z202so155918540iof.2
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2015 12:24:42 -0800 (PST)
In-Reply-To: <20151031183930.GB22547@ram.oc3035372033.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 31, 2015 at 2:39 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> On Sat, Oct 31, 2015 at 08:38:17AM -0400, Dan Streetman wrote:
>> On Fri, Oct 30, 2015 at 6:45 PM, Ram Pai <linuxram@us.ibm.com> wrote:
>> > The nx-842 compressor overshoots the output buffer corrupting memory. Verified
>> > that the following patch fixes the issue on a little-endian system.
>> >
>> > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
>> > ---
>> >  drivers/crypto/nx/nx-842-powernv.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
>> > index 3750e13..3b80ea7 100644
>> > --- a/drivers/crypto/nx/nx-842-powernv.c
>> > +++ b/drivers/crypto/nx/nx-842-powernv.c
>> > @@ -66,7 +66,7 @@ static void setup_indirect_dde(struct data_descriptor_entry *dde,
>> >                                unsigned int dde_count, unsigned int byte_count)
>> >  {
>> >         dde->flags = 0;
>> > -       dde->count = dde_count;
>> > +       dde->count = cpu_to_be32(dde_count);
>>
>> ->count is u8, I don't think this is correct...you could change
>> dde_count to a u8, but I'm skeptical that's required at all, are you
>> sure this is your problem?  The dde->length should restrict the coproc
>> from r/w past the output buffer anyway, even if the ->count is too
>> large...
>
> Dan, you are right. The problem does resurface even after the above change.
> There is something else going on. Please ignore this patch for now.
>
> I see corruption, when the output buffer is smaller than needed to hold
> the compressed data. I expect it to return -ENOSPC, but its not; instead
> overshoots and corrupts.

what are the in/out buffer sizes and alignment when it overruns the
output buffer?  and is it for compression or decompression?  does it
happen if you disable CRC (since Haren just enabled it recently)?


>
> RP
>
