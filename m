From: Mikko Herranen <mikko.herranen@cs.helsinki.fi>
Subject: GCM & CTR (fwd)
Date: Fri, 19 Oct 2007 23:03:27 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0710192300150.3619@antarct>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:46884 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758928AbXJSUD2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Oct 2007 16:03:28 -0400
Received: from hoasb-ff03dd00-82.dhcp.inet.fi (80.221.3.82) by pne-smtpout3-sn2.hy.skanova.net (7.2.075)
        id 46E521E000237133 for linux-crypto@vger.kernel.org; Fri, 19 Oct 2007 22:03:27 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

(Here's a copy of a message I posted yesterday on the 'wrong' crypto
list. Sorry for any inconvenience this may have caused to those who
were cc'd.)


Hello,

We've been wondering about a slight compatibility glitch between
CTR and GCM with Joy Latten. As CTR and GCM are very similar, the
way to go with GCM is obviously to implement it on top of CTR.
The problem is that CTR and GCM use different counter portion
values for the first encrypted plaintext block. (They both start
at 1 but GCM uses the first value for authentication.)

How to communicate the different value to CTR? The best way seems to be
to spawn CTR as ctr(alg,0,16) in GCM and pass the contents
of the entire counter block in the IV. But then the size of the
counter portion will be set to 0 in CTR. We could modify CTR to
set the size of the counter portion to blocksize whenever
ivsize == blocksize. Or we could introduce an additional template
parameter for specifying the counter portion size. The former is
the easiest way to go if embedding a bit of GCM-specific code
inside CTR module is not a problem. Any opinions on this?

-- 
Mikko Herranen
