Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A360C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 07:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343663AbhKZH5X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 02:57:23 -0500
Received: from verein.lst.de ([213.95.11.211]:45069 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344792AbhKZHzX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 02:55:23 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9736C68AFE; Fri, 26 Nov 2021 08:52:07 +0100 (CET)
Date:   Fri, 26 Nov 2021 08:52:07 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 09/12] nvmet: Parse fabrics commands on all queues
Message-ID: <20211126075207.GA23769@lst.de>
References: <20211123123801.73197-1-hare@suse.de> <20211123123801.73197-10-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123123801.73197-10-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 23, 2021 at 01:37:58PM +0100, Hannes Reinecke wrote:
> Fabrics commands might be sent to all queues, not just the admin one.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> ---
>  drivers/nvme/target/core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
> index 5119c687de68..a3abbf50f7e0 100644
> --- a/drivers/nvme/target/core.c
> +++ b/drivers/nvme/target/core.c
> @@ -943,6 +943,8 @@ bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
>  	if (unlikely(!req->sq->ctrl))
>  		/* will return an error for any non-connect command: */
>  		status = nvmet_parse_connect_cmd(req);
> +	else if (nvme_is_fabrics(req->cmd))
> +		status = nvmet_parse_fabrics_cmd(req);

This will allow all fabrics commands on the I/O queue, which is a bad
idea.  Please please nvmet_parse_fabrics_cmd into
nvmet_parse_admin_fabrics_cmd and nvmet_parse_io_fabrics_cmd
