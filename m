From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v0] Add SHA-3 hash algorithm
Date: Wed, 03 Apr 2013 20:29:51 -0400
Message-ID: <515CC97F.5020200@pobox.com>
References: <20121003054542.GA2416@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:43225 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761013Ab3DDA3y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Apr 2013 20:29:54 -0400
In-Reply-To: <20121003054542.GA2416@havoc.gtf.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/03/2012 01:45 AM, Jeff Garzik wrote:
>
> Whee -- SHA-3 is out!   I wanted to explore the new toy a bit, and
> so, here is a blatantly untested rough draft of SHA-3 kernel support.
>
> Why rough draft?  Because answers to the questions below will inform a
> more polished version.

Just to update people...  this has been in a holding pattern, because 
apparently there are revisions to SHA-3 coming down the pipe.  They want 
to address preimage resistance, and make things faster in hardware.

Random quote from NIST, on the NIST hash-forum, which doesn't provide 
detail but does summarize general feeling: "As best we can tell, 
continuing to pay that performance penalty for all future uses of SHA3 
has no benefit.  (All this is a longwinded way of saying: we were wrong, 
but hopefully we got better.)"

	Jeff
