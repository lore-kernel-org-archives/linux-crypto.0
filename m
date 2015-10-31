From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] nx-842: Endian swap ->count before handing over to the
 nx-842 compressor
Date: Sat, 31 Oct 2015 08:38:17 -0400
Message-ID: <CALZtONDNpw=bpmrykQomZiFZZs+CaGxyPZRL5_aWg=vTSyTrJw@mail.gmail.com>
References: <20151030224536.GB22549@ram.oc3035372033.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Haren Myneni <hbabu@us.ibm.com>
To: Ram Pai <linuxram@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33417 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbJaMi5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 31 Oct 2015 08:38:57 -0400
Received: by iodd200 with SMTP id d200so104697758iod.0
        for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2015 05:38:56 -0700 (PDT)
In-Reply-To: <20151030224536.GB22549@ram.oc3035372033.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 30, 2015 at 6:45 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> The nx-842 compressor overshoots the output buffer corrupting memory. Verified
> that the following patch fixes the issue on a little-endian system.
>
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> ---
>  drivers/crypto/nx/nx-842-powernv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
> index 3750e13..3b80ea7 100644
> --- a/drivers/crypto/nx/nx-842-powernv.c
> +++ b/drivers/crypto/nx/nx-842-powernv.c
> @@ -66,7 +66,7 @@ static void setup_indirect_dde(struct data_descriptor_entry *dde,
>                                unsigned int dde_count, unsigned int byte_count)
>  {
>         dde->flags = 0;
> -       dde->count = dde_count;
> +       dde->count = cpu_to_be32(dde_count);

->count is u8, I don't think this is correct...you could change
dde_count to a u8, but I'm skeptical that's required at all, are you
sure this is your problem?  The dde->length should restrict the coproc
from r/w past the output buffer anyway, even if the ->count is too
large...

>         dde->index = 0;
>         dde->length = cpu_to_be32(byte_count);
>         dde->address = cpu_to_be64(nx842_get_pa(ddl));
>
