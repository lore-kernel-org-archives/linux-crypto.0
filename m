From: Pavel Roskin <proski@gnu.org>
Subject: Re: Converting mac80211 CCMP to packet-at-a-time processing
Date: Fri, 12 Mar 2010 22:42:58 -0500
Message-ID: <1268451778.9161.5.camel@mj>
References: <201003121149.55037.roberto.sassu@polito.it>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Roberto Sassu <roberto.sassu@polito.it>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7091 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab0CMDnO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Mar 2010 22:43:14 -0500
In-Reply-To: <201003121149.55037.roberto.sassu@polito.it>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2010-03-12 at 11:49 +0100, Roberto Sassu wrote:
> Hello
> 
> i'm not expert with cryptographic modules, but i played sometime with the 
> "authenc" module, which is AEAD, and i applied it to the filesystem "ecryptfs".
> In the forwarded message i added a brief description of what i do and i hope 
> this can be a useful example for you. 

Thank you!  That's indeed a useful example.

However, it's disappointing that the caller needs to deal explicitly
with completions.  The blkcipher API is much simpler.  I would have hard
time advocating a patch to CCMP that makes the code more complicated.

-- 
Regards,
Pavel Roskin
