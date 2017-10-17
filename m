From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/8] lib/scatterlist: Introduce sgl_alloc() and
 sgl_free()
Date: Tue, 17 Oct 2017 08:06:42 +0200
Message-ID: <b7975651-7f1e-9a61-f752-78eb8763dece@suse.de>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
 <20171016224940.1332-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20171016224940.1332-2-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/17/2017 12:49 AM, Bart Van Assche wrote:
> Many kernel drivers contain code that allocates and frees both a
> scatterlist and the pages that populate that scatterlist.
> Introduce functions in lib/scatterlist.c that perform these tasks
> instead of duplicating this functionality in multiple drivers.
> Only include these functions in the build if CONFIG_SGL_ALLOC=y
> to avoid that the kernel size increases if this functionality is
> not used.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> ---
>  include/linux/scatterlist.h |  10 +++++
>  lib/Kconfig                 |   4 ++
>  lib/scatterlist.c           | 105 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 119 insertions(+)
> 

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
