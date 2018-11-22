Return-Path: <SRS0=unN5=OB=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39509 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406599AbeKWFjE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Nov 2018 00:39:04 -0500
Received: by mail-pf1-f195.google.com with SMTP id c72so2284697pfc.6
        for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2018 10:58:24 -0800 (PST)
Date: Thu, 22 Nov 2018 11:58:22 -0700
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Miller <davem@davemloft.net>
Cc: ganeshgr@chelsio.com, netdev@vger.kernel.org,
        nirranjan@chelsio.com, indranil@chelsio.com, dt@chelsio.com,
        linux-rdma@vger.kernel.org, swise@opengridcomputing.com,
        linux-crypto@vger.kernel.org, atul.gupta@chelsio.com,
        linux-scsi@vger.kernel.org, varun@chelsio.com, santosh@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: use new fw interface to get the VIN and
 smt index
Message-ID: <20181122185822.GB31486@ziepe.ca>
References: <1542787824-4731-1-git-send-email-ganeshgr@chelsio.com>
 <20181122024624.GA28494@ziepe.ca>
 <20181122.105349.1035544140286401266.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122.105349.1035544140286401266.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 22, 2018 at 10:53:49AM -0800, David Miller wrote:
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Date: Wed, 21 Nov 2018 19:46:24 -0700
> 
> > On Wed, Nov 21, 2018 at 01:40:24PM +0530, Ganesh Goudar wrote:
> >> From: Santosh Rastapur <santosh@chelsio.com>
> >> 
> >> If the fw supports returning VIN/VIVLD in FW_VI_CMD save it
> >> in port_info structure else retrieve these from viid and save
> >> them  in port_info structure. Do the same for smt_idx from
> >> FW_VI_MAC_CMD
> >> 
> >> Signed-off-by: Santosh Rastapur <santosh@chelsio.com>
> >> Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
> >>  drivers/crypto/chelsio/chtls/chtls_cm.c         |  3 +-
> >>  drivers/infiniband/hw/cxgb4/cm.c                |  6 +--
> >>  drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      | 12 ++++-
> >>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 58 ++++++++++++-------------
> >>  drivers/net/ethernet/chelsio/cxgb4/l2t.c        | 13 +++---
> >>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      | 46 ++++++++++++++++++--
> >>  drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h   | 20 +++++++++
> >>  drivers/scsi/cxgbi/cxgb4i/cxgb4i.c              |  3 +-
> >>  drivers/target/iscsi/cxgbit/cxgbit_cm.c         |  8 ++--
> >>  9 files changed, 114 insertions(+), 55 deletions(-)
> > 
> > Applied to for-next, but please try to write better commit messages in
> > future, explain what benifit your change is bringing.
> 
> The subject line indicates this is targetting my net-next tree, therefore
> why did you apply it to your's?

It is my mistake, it ended up in RDMA patchworks next to other RDMA
chelsio patches, and contained an IB component..

It is dropped from rdma.git now.

Thanks,
Jason
