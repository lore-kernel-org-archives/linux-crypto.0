From: Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: [CRYPTO] obfuscating kernel pointers
Date: Fri, 12 Nov 2010 14:03:15 -0500
Message-ID: <1289588595.3090.331.camel@Dan>
References: <1289568721.3090.267.camel@Dan>
	 <20101112172727.GA26217@hmsreliant.think-freely.org>
	 <1289583581.2034.8.camel@dan>
	 <20101112185413.GB26217@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.vsecurity.com ([209.67.252.12]:61663 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab0KLTDU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Nov 2010 14:03:20 -0500
In-Reply-To: <20101112185413.GB26217@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> > 
> adding a consistent random value to a your void * pointers sounds like a fine
> solution to the problem, then.  As long as you use the same random value for the
> lifetime of the system, that will give you consistent values.  And you have to
> use the same random input consistently to have consistent output on multiple
> concatinations of the same file anyway.  This also has the advantage of not
> having to do a crypto operation for every print/seq_sprintf/etc that contains a
> %p.
> 

The problem with that is the ease with which one could infer that random
value makes the whole thing pretty pointless.

-Dan
