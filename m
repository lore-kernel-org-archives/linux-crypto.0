From: Tadeusz Struk <tstruk@gmail.com>
Subject: Re: akcipher use
Date: Sat, 27 Jun 2015 10:00:08 -0700
Message-ID: <558ED698.5080101@gmail.com>
References: <1708764.x5PFhLSanv@tauon.atsec.com> <558C5444.4000105@intel.com> <1934055.of3DnBQRik@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>,
	Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34219 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbbF0RAY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Jun 2015 13:00:24 -0400
Received: by pdbep18 with SMTP id ep18so70486682pdb.1
        for <linux-crypto@vger.kernel.org>; Sat, 27 Jun 2015 10:00:24 -0700 (PDT)
In-Reply-To: <1934055.of3DnBQRik@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,
On 06/27/2015 09:25 AM, Stephan Mueller wrote:
> Ok, in this case, it would mean that rsa would point to the software 
> implementation and oaep(rsa) would point to the hardware. Would I be correct?

All combinations are possible, and it is up to the implementation to decide.

>> Yes, that's the main use case for this. We want to be able to accelerate SSL
>> > handshakes.
> Are you currently working on an AF_ALG interface?

I'm currently working on adding rsa support to the qat driver. Once that will
be finished my plan was to add AF_ALG interface for it.
That will be in a few weeks time though since I'm on vacation next two weeks.
If you have already started on AF_ALG you are more than welcome to do it.
For me the most important thing will that it needs to be asynchronous.
Regards,
T
