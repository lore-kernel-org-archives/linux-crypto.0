Return-Path: <SRS0=Oq1A=OC=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:32898 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437213AbeKXF5C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Nov 2018 00:57:02 -0500
Date: Fri, 23 Nov 2018 11:11:27 -0800 (PST)
Message-Id: <20181123.111127.1107043881210783525.davem@davemloft.net>
To: ganeshgr@chelsio.com
Cc: netdev@vger.kernel.org, nirranjan@chelsio.com,
        indranil@chelsio.com, dt@chelsio.com, linux-rdma@vger.kernel.org,
        swise@opengridcomputing.com, linux-crypto@vger.kernel.org,
        atul.gupta@chelsio.com, linux-scsi@vger.kernel.org,
        varun@chelsio.com, santosh@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: use new fw interface to get the VIN
 and smt index
From: David Miller <davem@davemloft.net>
In-Reply-To: <1542787824-4731-1-git-send-email-ganeshgr@chelsio.com>
References: <1542787824-4731-1-git-send-email-ganeshgr@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ganesh Goudar <ganeshgr@chelsio.com>
Date: Wed, 21 Nov 2018 13:40:24 +0530

> From: Santosh Rastapur <santosh@chelsio.com>
> 
> If the fw supports returning VIN/VIVLD in FW_VI_CMD save it
> in port_info structure else retrieve these from viid and save
> them  in port_info structure. Do the same for smt_idx from
> FW_VI_MAC_CMD
> 
> Signed-off-by: Santosh Rastapur <santosh@chelsio.com>
> Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>

Applied to net-next.
