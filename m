From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: crypto: ccp - CCP SHA crypto API support
Date: Wed, 11 Dec 2013 08:45:47 -0600
Message-ID: <7125615.uB987Qo2Ax@tlendack-t1>
References: <20131211105150.GA422@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: <linux-crypto@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:24364
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809Ab3LKOpz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Dec 2013 09:45:55 -0500
In-Reply-To: <20131211105150.GA422@elgon.mountain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Wednesday, December 11, 2013 01:51:50 PM Dan Carpenter wrote:
> Hello Tom Lendacky,
> 
> The patch 0ab0a1d505ab: "crypto: ccp - CCP SHA crypto API support"
> from Nov 12, 2013, leads to the following static checker warning:
> 	drivers/crypto/ccp/ccp-crypto-sha.c:182 ccp_do_sha_update()
> 	warn: should 'rctx->hash_cnt << 3' be a 64 bit type?
> 
> drivers/crypto/ccp/ccp-crypto-sha.c
>    180                  sg_mark_end(sg);
>    181
>    182          rctx->msg_bits += (rctx->hash_cnt << 3);        /* Total in
> bits */ ^^^^^^^^^^^^^^^^^^^
> This operation wraps if the msg is over 500MB.  I'm not sure if that's
> possible, but ->msg_bits is declared as a u64 here and in
> rctx->cmd.u.sha.msg_bits as well.

I should probably cast hash_cnt to a u64 before doing the shift to be
sure I don't lose any bits.  So that I can validate my fix, which static
checker did you run?

Thanks,
Tom
 
> 
>    183
>    184          memset(&rctx->cmd, 0, sizeof(rctx->cmd));
> 
> 
> regards,
> dan carpenter
