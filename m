From: Vincent Jardin <vincent.jardin@6wind.com>
Subject: Re: [ACRYPTO] New asynchronous crypto layer (acrypto) release.
Date: Fri, 29 Sep 2006 19:31:28 +0200
Message-ID: <451D5870.6020100@6wind.com>
References: <20060928120826.GA18063@2ka.mipt.ru> <87wt7nm0x5.fsf@willow.rfc1149.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp1-g19.free.fr ([212.27.42.27]:42913 "EHLO smtp1-g19.free.fr")
	by vger.kernel.org with ESMTP id S1161858AbWI2Rbe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Sep 2006 13:31:34 -0400
To: Samuel Tardieu <sam@rfc1149.net>
In-Reply-To: <87wt7nm0x5.fsf@willow.rfc1149.net>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

For the best synergy with OpenBSD guys, the OCF API should be considered:
   
http://www.usenix.org/events/usenix03/tech/full_papers/keromytis/keromytis_html/node8.html

then, whatever a HW driver is added, the same IOCTLs will be used by 
OpenSSL. The OCF patch for OpenSSL is already available.

Currently, it is not into the kernel git's repository so I think that 
your Via CPU won't get better performances with OpenSSL

Regards,
   Vincent

Samuel Tardieu wrote:

>Evgeniy> Hello.  I'm pleased to announce asynchronous crypto layer
>Evgeniy> (acrypto) [1] release for 2.6.18 kernel tree. Acrypto allows
>Evgeniy> to handle crypto requests asynchronously in hardware.
>
>Would userspace programs benefit from this patch? In particular, would
>OpenSSL get better performances on Via nehemiah CPUs or does it need
>to be patched?
>
>  Sam
>  
>

