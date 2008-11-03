From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] crypto: add test vectors for skein256/512/1024
Date: Mon, 3 Nov 2008 09:38:25 +0100
Message-ID: <20081103083824.GA27169@Chamillionaire.breakpoint.cc>
References: <20081102161506.GA21940@havoc.gtf.org> <20081102201518.GA23620@Chamillionaire.breakpoint.cc> <490E5788.4080300@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42626 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482AbYKCIic (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Nov 2008 03:38:32 -0500
Content-Disposition: inline
In-Reply-To: <490E5788.4080300@garzik.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Jeff Garzik | 2008-11-02 20:44:40 [-0500]:

> Sebastian Andrzej Siewior wrote:
>> I grabed them from http://www.schneier.com/skein.html. The last test 
>> vector
>> (3) in every category is currently deactivated because it failed always.
>> It is unlikely that I made a type because I copy+pasted the tables + vim
>> magiced them. So maybe code may missbehave on requests lengths which are
>> not a multiple of 4 or the vectors can not be used due to some other
>> limitations that I've overseen.
>
> Another thought:  did you verify that the test vectors' output sizes 
> matched the Linux kernel's?
It should. All have something like:
| :Skein-512:   512-bit hash, msgLen =     8 bits
512 algo, 512 output. 

The third one has:
| :Skein-512:   512-bit hash, msgLen =  2040 bits. Tree: leaf=02, node=02, maxLevels=02
So it looks like the same except that it has the "Tree: leaf node"
attribes as well. So maybe this is something special maybe not. As I
browsed the .txt files for other vectors I did not find any where msglen
wasn't a multiple of 4 bytes (except some odd ones where msgles was 7
bits). Maybe I did not look close enough.

> 	Jeff

Sebastian
