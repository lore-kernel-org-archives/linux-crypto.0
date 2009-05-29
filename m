From: Jarod Wilson <jarod@redhat.com>
Subject: sha384 self-test failure oddity
Date: Fri, 29 May 2009 14:35:50 -0400
Message-ID: <200905291435.50237.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60119 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbZE2Sgi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2009 14:36:38 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4TIaes1023415
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2009 14:36:40 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4TIacio026893
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2009 14:36:39 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4TIabQM015559
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2009 14:36:37 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

While doing a bit of testing of some other crypto code, I've repeatedly
noticed a sha384 self-test failure. If you 'modprobe tcrypt', the
sha384 self-test fails, then immediately after it, sha384-generic
self-tests succeed. Something is awry w/sha384 initialization, as
can be more plainly seen by the following after a reboot:

# modprobe tcrypt mode=11 (run sha384 self-test)

dmesg
-----
alg: hash: Failed to load transform for sha384: -2


# modprobe tcrypt mode=12 (run sha512 self-test)

dmesg
-----
alg: self-tests for sha384-generic (sha384) passed
alg: self-tests for sha512-generic (sha512) passed
alg: self-tests for sha512 (sha512) passed


# modprobe tcrypt mode=11 (run sha384 self-test again)

dmesg
-----
alg: self-tests for sha384 (sha384) passed


Not sure offhand what's going awry, and don't have time to look deeper
right now, but will do so if nobody else gets around to it first...

-- 
Jarod Wilson
jarod@redhat.com
