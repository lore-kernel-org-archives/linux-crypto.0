From: Joy Latten <latten@austin.ibm.com>
Subject: Re: GCM & CTR (fwd)
Date: Fri, 19 Oct 2007 17:29:32 -0500
Message-ID: <1192832972.2477.413.camel@faith.austin.ibm.com>
References: <Pine.LNX.4.64.0710192300150.3619@antarct>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Mikko Herranen <mikko.herranen@cs.helsinki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:46971 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935257AbXJSWeI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Oct 2007 18:34:08 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9JMY2X7022866
	for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2007 18:34:02 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9JMY2Xt113992
	for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2007 16:34:02 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9JMY2CG002618
	for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2007 16:34:02 -0600
In-Reply-To: <Pine.LNX.4.64.0710192300150.3619@antarct>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2007-10-19 at 23:03 +0300, Mikko Herranen wrote:
> (Here's a copy of a message I posted yesterday on the 'wrong' crypto
> list. Sorry for any inconvenience this may have caused to those who
> were cc'd.)
> 
> 
> Hello,
> 
> We've been wondering about a slight compatibility glitch between
> CTR and GCM with Joy Latten. As CTR and GCM are very similar, the
> way to go with GCM is obviously to implement it on top of CTR.
> The problem is that CTR and GCM use different counter portion
> values for the first encrypted plaintext block. (They both start
> at 1 but GCM uses the first value for authentication.)
> 
> How to communicate the different value to CTR? The best way seems to be
> to spawn CTR as ctr(alg,0,16) in GCM and pass the contents
> of the entire counter block in the IV. But then the size of the
> counter portion will be set to 0 in CTR. We could modify CTR to
> set the size of the counter portion to blocksize whenever
> ivsize == blocksize. Or we could introduce an additional template
> parameter for specifying the counter portion size. The former is
> the easiest way to go if embedding a bit of GCM-specific code
> inside CTR module is not a problem. Any opinions on this?

I think the change to CTR would be simple.  
If noncesize + ivsize == blocksize, then use 
entire counterblock as counter and pass to  
ctr_inc_quad(). Currently, we just fail 
if noncesize + ivsize == blocksize.  

Let me know if this sounds ok, and I will 
code it. 

Regards,
Joy
