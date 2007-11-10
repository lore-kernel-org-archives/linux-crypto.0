From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] geode: add fallback for unsupported modes,
	take 2
Date: Sat, 10 Nov 2007 22:28:06 +0100
Message-ID: <20071110212806.GE15150@Chamillionaire.breakpoint.cc>
References: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc> <1192788233-14968-5-git-send-email-linux-crypto@ml.breakpoint.cc> <20071021083158.GD9397@gondor.apana.org.au> <20071104205923.GB25799@Chamillionaire.breakpoint.cc> <20071110113130.GC5485@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, Jan Glauber <jang@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55197 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbXKJV2H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Nov 2007 16:28:07 -0500
Content-Disposition: inline
In-Reply-To: <20071110113130.GC5485@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-11-10 19:31:30 [+0800]:

>On Sun, Nov 04, 2007 at 09:59:23PM +0100, Sebastian Siewior wrote:
>> The Geode AES crypto engine supports only 128 bit long key. This
>> patch adds fallback for other key sizes which are required by the
>> AES standard.
>> 
>> Cc: Jordan Crouse <jordan.crouse@amd.com>
>> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
>
>Patch applied.  Thanks for fixing this.

Since you liked that one I make one for the s390 ppl as well.

Sebastian
