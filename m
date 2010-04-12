From: Milan Broz <mbroz@redhat.com>
Subject: Re: aesni-intel slower than aes-x86_64
Date: Mon, 12 Apr 2010 14:41:46 +0200
Message-ID: <4BC3150A.1080905@redhat.com>
References: <693236.82640.qm@web45101.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: john terragon <terragonjohn@yahoo.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab0DLMls (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Apr 2010 08:41:48 -0400
In-Reply-To: <693236.82640.qm@web45101.mail.sp1.yahoo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/12/2010 12:52 AM, john terragon wrote:
> My system has a core i5 520M and supports AES-NI. I wanted to do a
> rude performance test and so I ran these commands on a small (4GB) partition and on the dm-crypt device backed by it:
> 
> 1) using the aesni-intel module: dd if=/dev/dev/mapper/vol of=/dev/null bs=4k
> 2) using only the generic aes-x86_64 module: dd if=/dev/dev/mapper/vol
> of=/dev/null bs=4k
> 3) dd if=/dev/sda4 of=/dev/null bs=4k 
> 
> What I got kind of surprised me:
> 1) ~ 67 MB/sec, with a low cpu load by kcryptd
> 2) ~ 79 MB/sec, with a higher cpu load by kcryptd
> 3) ~ 81 MB/sec

Just curious  - is it the same if you add iflag=direct? Also try larger block size bs=1M etc.

Milan
