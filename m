From: Loganaden Velvindron <logan@hackers.mu>
Subject: Re: [PATCH] crypto: ecc : Wipe memory for p on errors.
Date: Mon, 24 Apr 2017 10:05:17 +0400
Message-ID: <20170424060517.vdufjvbrxhtuwda6@hackers.mu>
References: <20170422113134.hzulmuvnveqg7sjq@hackers.mu>
 <1812636.Q25d83Qtbu@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from walmailout01.yourhostingaccount.com ([65.254.253.94]:48903 "EHLO
        walmailout01.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1165577AbdDXGfl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 02:35:41 -0400
Received: from mailscan02.yourhostingaccount.com ([10.1.15.2] helo=walmailscan02.yourhostingaccount.com)
        by walmailout01.yourhostingaccount.com with esmtp (Exim)
        id 1d2X7q-0007m6-Cz
        for linux-crypto@vger.kernel.org; Mon, 24 Apr 2017 02:05:30 -0400
Received: from [10.114.3.31] (helo=walimpout11)
        by walmailscan02.yourhostingaccount.com with esmtp (Exim)
        id 1d2X7q-0006EH-AS
        for linux-crypto@vger.kernel.org; Mon, 24 Apr 2017 02:05:30 -0400
Content-Disposition: inline
In-Reply-To: <1812636.Q25d83Qtbu@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 23, 2017 at 09:14:18PM +0200, Stephan Müller wrote:
> Am Samstag, 22. April 2017, 13:31:34 CEST schrieb Loganaden Velvindron:
> 
> Hi Loganaden,
> 
> > -	kfree(p);
> > +	kzfree(p);
> 
> Why do you think this is necessary? p is not filled in this function as this 
> function only allocates the memory.
On 2nd reading, p doesn't contain any sensitive information in this function,
and doesn't need to be zero'ed.

Thank you Stephan. Please disregard the patch.


> 
> Ciao
> Stephan
