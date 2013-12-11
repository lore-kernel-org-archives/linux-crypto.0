From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: crypto: ccp - CCP SHA crypto API support
Date: Wed, 11 Dec 2013 18:20:08 +0300
Message-ID: <20131211152008.GQ5443@mwanda>
References: <20131211105150.GA422@elgon.mountain>
 <7125615.uB987Qo2Ax@tlendack-t1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49980 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3LKPUh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Dec 2013 10:20:37 -0500
Content-Disposition: inline
In-Reply-To: <7125615.uB987Qo2Ax@tlendack-t1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 11, 2013 at 08:45:47AM -0600, Tom Lendacky wrote:
> 
> On Wednesday, December 11, 2013 01:51:50 PM Dan Carpenter wrote:
> > Hello Tom Lendacky,
> > 
> > The patch 0ab0a1d505ab: "crypto: ccp - CCP SHA crypto API support"
> > from Nov 12, 2013, leads to the following static checker warning:
> > 	drivers/crypto/ccp/ccp-crypto-sha.c:182 ccp_do_sha_update()
> > 	warn: should 'rctx->hash_cnt << 3' be a 64 bit type?
> > 
> > drivers/crypto/ccp/ccp-crypto-sha.c
> >    180                  sg_mark_end(sg);
> >    181
> >    182          rctx->msg_bits += (rctx->hash_cnt << 3);        /* Total in
> > bits */ ^^^^^^^^^^^^^^^^^^^
> > This operation wraps if the msg is over 500MB.  I'm not sure if that's
> > possible, but ->msg_bits is declared as a u64 here and in
> > rctx->cmd.u.sha.msg_bits as well.
> 
> I should probably cast hash_cnt to a u64 before doing the shift to be
> sure I don't lose any bits.  So that I can validate my fix, which static
> checker did you run?
> 

I haven't released the Smatch check for this...  I need to tweak it so
it has fewer false positives.

regards,
dan carpenter
