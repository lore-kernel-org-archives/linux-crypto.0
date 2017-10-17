From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 2/8] crypto: scompress - use sgl_alloc() and sgl_free()
Date: Tue, 17 Oct 2017 08:07:20 +0200
Message-ID: <9e6d6115-8118-4e8d-aacb-849598becd19@suse.de>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
 <20171016224940.1332-3-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Bart Van Assche <bart.vanassche@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56667 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932536AbdJQGHX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2017 02:07:23 -0400
In-Reply-To: <20171016224940.1332-3-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/17/2017 12:49 AM, Bart Van Assche wrote:
> Use the sgl_alloc() and sgl_free() functions instead of open coding
> these functions.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/Kconfig     |  1 +
>  crypto/scompress.c | 51 ++-------------------------------------------------
>  2 files changed, 3 insertions(+), 49 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
